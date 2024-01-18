
# CHRIS: Characterizing circRNA through Integrative Sequencing
##

Developed by the [Christopher Maher Lab](http://www.maherlab.com) at [Washington University in St. Louis](http://wustl.edu).

##

## Overview

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
| pipeline | Full CHRIS workflow, which relies on tools in /tools |
| tools | Individual steps in the workflow containing single commands or scripts |
| example_ymls | Contains example yml files to demonstrate input format |

## Inputs

CHRIS accepts a variety of inputs. Example input yml files have been provided in the example_ymls directory, which contain all required inputs and a brief description of expected values.

In addition to the examples found in the example_ymls directory, a comprehensive explanation of required inputs is provided below:

| Input Label | Description |
| --- | --- |
| short_fastq_r1 | List of fastq files containing R1 paired end reads. 1+ samples |
| short_fastq_r2 | List of fastq files containing R2 paried end reads. 1+ samples. Must be same order as short_fastq_r1 sampels |
| long_fastq | Long read fastq file(s). May be a single large file or multiple, smaller files. Larger files will significantly increase run time. Can either be all gzipped or all unzipped |
| reference | Reference genome fasta. Should have .fai (samtools index) and .amb/.ann/.bwt/.pac/.sa (bwa index) files in the same directory |
| circExplorer_gpf | GPF compatible with circExplorer tool |
| isocirc_gtf | GTF compatible with Isocirc tool |
| genomeDir | Directory containing STAR index output |
| is_long_read_pre_split | Boolean indicating if long_fastq is a single large sample (true) or multiple smaller files (false) |
| is_long_read_gzipped | Boolean indicating if file(s) in long_fastq are gzipped (true) or not (false) |
| star_fusion_index | Directory containing STAR fusion index. We recommend downloading from the [Broad Institute](https://data.broadinstitute.org/Trinity/CTAT_RESOURCE_LIB/) |
| out_sample_name | Optional. Sample name |

## Outputs


