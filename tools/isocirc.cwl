#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Isocirc"
baseCommand: ["isocirc"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "sidizhao/sidizhao-wustl:v1.0.7_split"

arguments: [
    { valueFrom: "-t", position: 1},
    { valueFrom:  "16", position: 2},
    { valueFrom: $(runtime.outdir), position: 7 }
]


inputs:
    corrected_fasta:
        type: File
        inputBinding:
            position: 3
    reference:
        type: File
        inputBinding:
            position: 4
    annot:
        type: File
        inputBinding:
            position: 5
    short_read_annot:
        type: File
        inputBinding:
            position: 6

outputs:
    isocirc_bed:
        type: File
        outputBinding:
            glob: "isocirc.bed"
    isocirc_out:
        type: File
        outputBinding:
            glob: "isocirc.out"
