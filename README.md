
# CHRIS: CHaracterizing CircRNAs by Integrative Sequencing
##

Developed by the [Christopher Maher Lab](http://www.maherlab.com) at [Washington University in St. Louis](http://wustl.edu).

For additional details, see publication: PLACEHOLDER_LINK.

##

## Overview

CHRIS (CHaracterizing CircRNAs by Integrative Sequencing) is an open-source [Common Work Flow](https://www.commonwl.org/) (CWL) pipeline leveraging both short-read and long-read (Oxford Nanopore or PacBio) RNA-seq data to identify novel, bona fide circRNA isoforms. In short, this two-pass rescue pipeline consolidates all novel circRNAs detected using long-read RNA-seq and identifies those that have ample support in matching short-read RNA-seq samples. In the first-pass analysis, splice sites in long-read circRNAs are used as a guiding annotation set to rescue circRNAs in the short-read samples. In the second-pass analysis, corresponding raw reads from long-read circRNAs not rescued by the previous step are converted into a Magic-BLAST reference database; all chimeric short reads are then mapped against the reference to further rescue long-read circRNAs.

![Workflow Schematic](images/workflow_schematic.png "Workflow Schematic")

## Quick Start

Download the repository with `git clone https://github.com/ChrisMaherLab/CHRIS.git`

A number of tools exist for running CWL pipelines. In our testing of the pipeline, we used the Cromwell CWL interpreter (v54), which can be downloaded [here](https://github.com/broadinstitute/cromwell/releases). For additional information about using CWL pipelines, we suggest the [CWL user guide](https://www.commonwl.org/) and Cromwell's [configuration file tutorial](https://cromwell.readthedocs.io/en/stable/tutorials/ConfigurationFiles/).

As CHRIS was designed for use in high performance computing environments (HPCs) and HPCs can be highly customizable and variable between different institutions, a comprehensive guide on how to configure different CWL interpreters for specific HPCs is not possible here. We highly recommend reviewing the above documentation (or the documentation for your preferred CWL interpreter) to ensure correct integration with your HPC.

After installation and configuration of Cromwell (if that is your preferred interpreter), CHRIS can be run using:

`java -Dconfig.file=<config.file> -jar <cromwell.jar> run -t cwl -i <input_yml> pipeline/CHRIS.cwl`

This assumes you have `java` in your `$PATH`. 

## Project Structure

This repository is organized as follows:
| Directory | Description |
| --- | --- |
| pipeline | Full CHRIS workflow, which relies on tools in /tools. |
| tools | Individual steps in the workflow containing single commands or scripts. |
| example_ymls | Contains example yml files to demonstrate input format. |

## Inputs

CHRIS accepts a variety of inputs. Example input yml files have been provided in the example_ymls directory, which contain all required inputs and a brief description of expected values.

In addition to the examples found in the example_ymls directory, a comprehensive explanation of required inputs is provided below:

| Input Label | Description |
| --- | --- |
| short_fastq_r1 | List of fastq files containing R1 paired end reads. 1+ samples. |
| short_fastq_r2 | List of fastq files containing R2 paried end reads. 1+ samples. Must be same order as short_fastq_r1 samples. |
| long_fastq | Long read fastq file(s). May be a single large file or multiple, smaller files. Larger files will significantly increase run time. Can either be all gzipped or all unzipped. Please use 1 sample at a time. |
| reference | Reference genome fasta. Should have .fai (samtools index) and .amb/.ann/.bwt/.pac/.sa (bwa index) files in the same directory. |
| circExplorer_gpf | GPF compatible with CIRCexplorer2 tool. For detailed instruction, see CIRCexplorer2's [setup page](https://circexplorer2.readthedocs.io/en/latest/tutorial/setup/). |
| isocirc_gtf | GTF compatible with isoCirc and CIRI-long tools. Please ensure the GTF contains exon IDs. We recommend using [UCSC Utilities](http://hgdownload.soe.ucsc.edu/admin/exe/) for proper conversion. |
| genomeDir | Directory containing STAR index output. |
| is_long_read_pre_split | Boolean indicating if long_fastq is a single large sample (true) or multiple smaller files (false). |
| is_long_read_gzipped | Boolean indicating if file(s) in long_fastq are gzipped (true) or not (false). |
| star_fusion_index | Directory containing STAR fusion index. We recommend downloading from the [Broad Institute](https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/). |
| out_sample_name | Optional. Sample name. |

## Outputs

CHRIS reports three categories of output files:
1. Short-read based circRNA detection results

| Output File Name | Description |
| --- | --- |
| circularRNA_known.txt | CIRCexplorer2 results for each short-read sample. For details please see CIRCexplorer2's [manual](https://circexplorer2.readthedocs.io/en/latest/modules/annotate). |

2. Long-read based circRNA detection results
One-base pair adjustments were made to all circRNAs detected by CIRI-long to keep splice site boundary formats consistent with isoCirc and CIRCexplorer2 results.

| Output File Name | Description |
| --- | --- |
| isocirc.merged.aggregate.txt | Aggregated isoCirc results for long-read sample. For details please see isoCirc's [manual](https://github.com/Xinglab/isoCirc). |
| ciri.long.merged.aggregate.txt | Aggregated CIRI-long results for long-read sample. For details please see CIRI-long's [manual](https://ciri-cookbook.readthedocs.io/en/latest/CIRI-long_2_usage.html#output-format). Note: Read counts are used to quantify each circRNA based on backsplice junctions (BSJ); percent spliced in (PSI) values are used to quantify each circular isoform, i.e. circRNAs that share BSJ but defer in internal structure. |

3. Integrative rescue analysis results
   
| Output File Name | Description |
| --- | --- |
| first_pass_rescued_circRNAs_out.txt | First-pass rescue analysis result including rescued short read counts of each long-read circRNA. |
| magicblast_output.txt | Magic-BLAST mapping results for each short-read sample in second-pass rescue analysis. For details please see Magic-BLAST's [manual](https://ncbi.github.io/magicblast/doc/output.html). |
| high_conf_ref_query_pair_read_ids.txt | All high-confidence long- vs. short-read pairs (format: short_read_ID\|long_read_ID) supporting long-read circRNAs in second-pass rescue analysis. |
| final_two_pass_rescue_results.txt | Aggregated first- and second-pass results. |

