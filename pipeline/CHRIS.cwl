#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "circRNA analysis of long and short read data"
requirements:
    - class: SubworkflowFeatureRequirement
    - class: ScatterFeatureRequirement


inputs:
    short_fastq_r1:
        type: File[]
        doc: "List of R1 short read fastq files"
    short_fastq_r2:
        type: File[]
        doc: "List of R2 short read fastq files. Must be in same order as short_fastq_r1"
    long_fastq:
        type: File[]
        doc: "Long read fastq. May be a single large file or split into smaller files."
    reference:
        type: File
        secondaryFiles: [.fai, .amb, .ann, .bwt, .pac, .sa]
        doc: "Reference genome and samtools index/bwa index outputs"
    circExplorer_gpf:
        type: File
        doc: "GPF compatible with circExplorer"
    isocirc_gtf:
        type: File
        doc: "GTF compatible with Isocirc"
    genomeDir:
        type: Directory
        doc: "STAR index output directory. Likely the same as the reference genome directory"
    is_long_read_pre_split:
        type: boolean
        doc: "Is the long_fastq a single large file or multiple smaller ones?"
    is_long_read_gzipped:
        type: boolean
        doc: "Is/are the file(s) in long_fastq gzipped?"
    star_fusion_index:
        type: Directory
        doc: "Directory containing STAR fusion index"
    mean_read_filter:
        type: int?
        default: 0
        doc: "Filter for minimum mean read support value across samples"
    out_sample_name:
        type: string?
        default: "sample_name"
        doc: "Optional sample name"

outputs:
    circexplorer2_annotations:
        type: File[]
        outputSource: annotate_junctions/circRNA_annot
    isocirc_calls:
        type: File
        outputSource: isocirc_cleanup/aggregate
    first_pass_rescue:
        type: File
        outputSource: first_pass_cleanup/rescued
    magicblast_mapping_result:
        type: File[]
        outputSource: magicblast_mapping/out
    high_confidence_magicblast_hits:
        type: File
        outputSource: high_conf_hits/high_conf_ref_query_pair
    first_and_second_pass_result:
        type: File
        outputSource: first_and_second_pass_cleanup/out
    circ_annot_filter:
        type: File
        outputSource: circ_annotation_to_bed/circ_annot_bed_filter_result

steps:
    #Step 00
    extract_short_read_sample_names:
        run: ../tools/extract_sample_name_from_prefix.cwl
        scatter: [file_name]
        in:
            file_name: short_fastq_r1
        out:
            [sample_name]

    #Step 01 align short reads
    short_read_alignment:
        run: ../tools/STAR_align_short_reads.cwl
        scatter: [fastq_r1, fastq_r2]
        scatterMethod: "dotproduct"
        in:
            fastq_r1: short_fastq_r1
            fastq_r2: short_fastq_r2
            genomeDir: genomeDir
            gtf: isocirc_gtf
        out:
            [aligned_bam, junction]

    #Step 02 circexplorer parse
    parse_junctions:
        run: ../tools/CIRCexplorer_parse.cwl
        scatter: [junction]
        in:
            junction: short_read_alignment/junction
        out:
            [back_splice_junction]

    #Step 03a circexplorer annotate
    annotate_junctions:
        run: ../tools/CIRCexplorer_annotate.cwl
        scatter: [junction_bed]
        in:
            junction_bed: parse_junctions/back_splice_junction
            reference_fasta: reference
            gpf: circExplorer_gpf
        out:
            [circRNA_annot]

    #Step 03b
    annotate_junctions_add_header:
        run: ../tools/add_generic_header.cwl
        scatter: [infile]
        in:
            infile: annotate_junctions/circRNA_annot
            cols:
                default: 18
            out_name:
                default: "circularRNA_known.txt"
        out:
            [out]

    #Step 04 split long fastq
    optionally_split_fastq:
        run: ../tools/optional_fastq_split.cwl
        in:
            fastq: long_fastq
            is_pre_split: is_long_read_pre_split
            is_gzipped: is_long_read_gzipped
        out:
            [split_fastq]

    #Step 05a 
    combine_fastq_lists:
        run: ../tools/interleave_arrays.cwl
        in:
            array1: short_fastq_r1
            array2: short_fastq_r2
        out:
            [merged_array]

    #Step 05b lordec long read correction
    lordec_correction:
        run: ../tools/lordec_read_correction.cwl
        scatter: [split_long_read]
        in:
            short_fastq: combine_fastq_lists/merged_array
            split_long_read: optionally_split_fastq/split_fastq
        out:
            [corrected_reads]

    #Step 06 circexplorer to bed
    circ_annotation_to_bed:
        run: ../tools/convert_CIRCexplorer_annot_to_bed.cwl
        in:
            sample_names: extract_short_read_sample_names/sample_name
            annot: annotate_junctions_add_header/out
            mean_read_filter: mean_read_filter
        out:
            [circRNA_annot_bed, circ_annot_bed_filter_result]

    #Step 07 isocirc
    isocirc:
        run: ../tools/isocirc.cwl
        scatter: [corrected_fasta]
        in:
            corrected_fasta: lordec_correction/corrected_reads
            reference: reference
            annot: isocirc_gtf
            short_read_annot: circ_annotation_to_bed/circRNA_annot_bed
        out:
            [isocirc_bed, isocirc_out]


    #Step 10a
    isocirc_add_header1:
        run: ../tools/add_generic_header.cwl
        scatter: [infile]
        in:
            infile: isocirc/isocirc_bed
            cols: 
                default: 12
            out_name:
                default: "isocirc_bed"
        out:
            [out]

    #Step 10b
    isocirc_add_header2:
        run: ../tools/add_generic_header.cwl
        scatter: [infile]
        in:
            infile: isocirc/isocirc_out
            cols:
                default: 35
            out_name:
                default: "isocirc_out"
        out:
            [out]

    #Step 10-11 isorcirc cleanup
    isocirc_cleanup:
        run: ../tools/isocirc_cleanup.cwl
        in:
            beds: isocirc_add_header1/out
            iso_outs: isocirc_add_header2/out
            sample_name: out_sample_name
        out:
            [reads, aggregate, cleaned_bed]


    #Step 13
    pass_one_rescue_prep:
        run: ../tools/rescue_prep_one.cwl
        in:
            isocirc_bed: isocirc_cleanup/cleaned_bed
            #ciri_long_bed: ciri_long_cleanup/bed
            sample_name: out_sample_name
        out:
            [bed, gpf, circexplorer_gpf, gtf]

    #Step 14 short read rescue align
    short_read_rescue_alignment:
        run: ../tools/STAR_align_short_reads.cwl
        scatter: [fastq_r1, fastq_r2]
        scatterMethod: "dotproduct"
        in:
            fastq_r1: short_fastq_r1
            fastq_r2: short_fastq_r2
            genomeDir: genomeDir
            gtf: pass_one_rescue_prep/gtf
        out:
            [aligned_bam, junction]

    #Step 15 rescue parse
    parse_junctions2:
        run: ../tools/CIRCexplorer_parse.cwl
        scatter: [junction]
        in:
            junction: short_read_rescue_alignment/junction
        out:
            [back_splice_junction]

    #Step 16 resuce annotate
    annotate_junctions2:
        run: ../tools/CIRCexplorer_annotate.cwl
        scatter: [junction_bed]
        in:
            junction_bed: parse_junctions2/back_splice_junction
            reference_fasta: reference
            gpf: pass_one_rescue_prep/circexplorer_gpf
        out:
            [circRNA_annot]

    #Step 17a
    annotate_junctions2_add_header:
        run: ../tools/add_generic_header.cwl
        scatter: [infile]
        in:
            infile: annotate_junctions2/circRNA_annot
            cols:
                default: 18
            out_name:
                default: "circularRNA_known.txt"
        out:
            [out]

    #Step 17b
    circ_annot_add_header:
        run: ../tools/add_generic_header.cwl
        in:
            infile: circ_annotation_to_bed/circRNA_annot_bed
            cols:
                default: 12
            out_name:
                default: "circularRNA_known.bed"
        out:
            [out]

    #Step 17c
    pass_one_bed_add_header:
        run: ../tools/add_generic_header.cwl
        in:
            infile: pass_one_rescue_prep/bed
            cols: 
                default: 12
            out_name:
                default: "combined.tools.first.pass.rescue.bed"
        out:
            [out]

    #Step 17d
    first_pass_cleanup:
        run: ../tools/first_pass_cleanup.cwl
        in:
            short_read_bed: circ_annot_add_header/out
            long_read_bed: pass_one_bed_add_header/out
            short_read_circRNAs: annotate_junctions2_add_header/out
            sample_names: extract_short_read_sample_names/sample_name
        out:
            [rescued, non_rescued, long_read]

    #Step 18 read extraction
    read_extraction:
        run: ../tools/nonrescued_read_extraction.cwl
        in:
            nonrescued_circRNAs: first_pass_cleanup/non_rescued
            isocirc_out: isocirc_cleanup/aggregate
            corrected_reads: lordec_correction/corrected_reads
        out:
            [non_rescued_fasta]

    #Step 19 magicblast mkblastdb
    makeblastdb:
        run: ../tools/magicblast_makeblastdb.cwl
        in:
            fasta: read_extraction/non_rescued_fasta
        out:
            [db]

    #Step 20 magicblast mapping
    magicblast_mapping:
        run: ../tools/magicblast_mapping.cwl
        scatter: [r1, r2, sample_name]
        scatterMethod: "dotproduct"
        in:
            r1: short_fastq_r1
            r2: short_fastq_r2
            db: makeblastdb/db
            sample_name: extract_short_read_sample_names/sample_name
        out:
            [out]
   
    #Step 21 read extraction 
    chimeric_read_extraction:
        run: ../tools/second_pass_chimeric_read_extraction.cwl
        in:
            junctions: short_read_alignment/junction
        out:
            [merged, read_ids]

    #Step 22 star fusion
    star_fusion:
        run: ../tools/STAR_fusion.cwl
        scatter: [r1,r2,sample_name]
        scatterMethod: "dotproduct"
        in:
            r1: short_fastq_r1
            r2: short_fastq_r2
            star_fusion_index: star_fusion_index
            sample_name: extract_short_read_sample_names/sample_name
        out:
            [predictions]

    #Step 23a read extraction
    extract_star_reads:
        run: ../tools/second_pass_star_read_extraction.cwl
        in:
            star_out: star_fusion/predictions
        out:
            [read_ids]

    #Step 23b 
    chimeric_read_extraction_add_header:
        run: ../tools/add_generic_header.cwl
        in:
            infile: chimeric_read_extraction/merged
            cols: 
                default: 14
            out_name:
                default: "merged_chimeric_junctions.txt"
        out:
            [out]

    #Step 24a magicblast filter
    magicblast_read_filter:
        run: ../tools/second_pass_magicblast_read_filter.cwl
        scatter: [magicblast_out]
        in:
            chimeric_readIDs: chimeric_read_extraction/read_ids
            fusion_readIDs: extract_star_reads/read_ids
            magicblast_out: magicblast_mapping/out
        out:
            [filtered]

    #Step 24b
    magicblast_make_unique:
        run: ../tools/make_unique.cwl
        in:
            infiles: magicblast_read_filter/filtered
        out:
            [unique]

    #Step 24c
    magicblast_add_header:
        run: ../tools/add_generic_header.cwl
        in:
            infile: magicblast_make_unique/unique
            cols: 
                default: 25
            out_name:
                default: "unique.txt"
        out:
            [out]

    #Step 25
    high_conf_hits:
        run: ../tools/second_pass_magicblast_high_conf_hits.cwl
        in:
            magicblast: magicblast_add_header/out
            junctions: chimeric_read_extraction_add_header/out
        out:
            [high_conf_long_read_ids, high_conf_short_read_ids, high_conf_ref_query_pair, high_conf_magicblast_hits, long_read_ids, short_read_ids]

    #Step 26 Extract top hits
    high_conf_circRNA_extraction:
        run: ../tools/second_pass_high_conf_circRNA_extraction.cwl
        in:
            magicblast_reads: high_conf_hits/high_conf_long_read_ids
            isocirc_reads: isocirc_cleanup/aggregate
            long_read_ids: high_conf_hits/long_read_ids
        out:
            [isocirc, isocirc_chimeric_support]

    #Step 27 cleanup
    first_and_second_pass_cleanup:
        run: ../tools/first_and_second_pass_cleanup.cwl
        in:
            short_bed: circ_annot_add_header/out
            first_pass_result: first_pass_cleanup/long_read
            first_pass_rescued: first_pass_cleanup/rescued
            isocirc_result: high_conf_circRNA_extraction/isocirc
            iso_low_conf: high_conf_circRNA_extraction/isocirc_chimeric_support
        out:
            [out]

