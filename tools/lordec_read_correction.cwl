#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Lordec Correct"
baseCommand: ["/usr/local/bin/isoCirc/isoCirc_pipeline/bin/lordec-correct"]
requirements:
    - class: ShellCommandRequirement
    - class: DockerRequirement
      dockerPull: "sidizhao/sidizhao-wustl"

arguments: [
    "-k", "21",
    "-s", "3",
    "-o", { valueFrom: $(runtime.outdir)/corrected.fasta }
]


inputs:
    short_fastq:
        type: File[]
        inputBinding:
            position: 1
            prefix: "-2"
            itemSeparator: ","
    split_long_read:
        type: File
        inputBinding:
            position: 2
            prefix: "-i"

outputs:
    corrected_reads:
        type: File
        outputBinding:
            glob: "corrected.fasta"
