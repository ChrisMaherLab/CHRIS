#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Split fastq (or fastq.gz) files into smaller files for use in parallel"
baseCommand: ["/bin/bash", "/usr/local/bin/optional_split.sh"]
requirements:
    - class: ShellCommandRequirement
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 6000
    - class: DockerRequirement
      dockerPull: "sidizhao/sidizhao-wustl:v3_split"

inputs:
    fastq:
        type: File[]
        inputBinding:
            position: 3
            itemSeparator: ","
    is_pre_split:
        type: boolean
        inputBinding:
            position: 1
            valueFrom : ${if (self) { return "1";} else { return "0";}}
    is_gzipped:
        type: boolean
        inputBinding:
            position: 2
            valueFrom: ${if (self) { return "1";} else { return "0";}}

outputs:
    split_fastq:
        type: File[]
        outputBinding:
            glob: "*.fastq"

