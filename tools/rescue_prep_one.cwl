#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "CIRI-long"
baseCommand: ["/bin/bash", "helper.sh"]
requirements:
    - class: ShellCommandRequirement
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "genomicpariscentre/kentutils"
    - class: InitialWorkDirRequirement
      listing:
      - entryname: "helper.sh"
        entry: |
            isocirc_bed=$1
            ciri_long_bed=$2
            sample_name=$3

            cat $isocirc_bed $ciri_long_bed | sort | uniq > ${sample_name}.combined.tools.first.pass.rescue.bed

            bedToGenePred ${sample_name}.combined.tools.first.pass.rescue.bed ${sample_name}.combined.tools.first.pass.rescue.gpf

            awk 'BEGIN {OFS="\t"}; {$1=$1 OFS $1} 1' ${sample_name}.combined.tools.first.pass.rescue.gpf > ${sample_name}.combined.tools.first.pass.rescue.circexplorer.gpf

            genePredToGtf "file" ${sample_name}.combined.tools.first.pass.rescue.gpf ${sample_name}.combined.tools.first.pass.rescue.gtf



inputs:
    isocirc_bed:
        type: File
        inputBinding:
            position: 1
    ciri_long_bed:
        type: File
        inputBinding:
            position: 2
    sample_name:
        type: string
        inputBinding:
            position: 3


outputs:
    bed:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).combined.tools.first.pass.rescue.bed
    gpf:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).combined.tools.first.pass.rescue.gpf
    circexplorer_gpf:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).combined.tools.first.pass.rescue.circexplorer.gpf
    gtf:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).combined.tools.first.pass.rescue.gtf

