#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "CIRI-long"
baseCommand: ["CIRI-long", "call"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "sidizhao/ciri-long:v1.1.0"

arguments: [
    { valueFrom: "-o", position: 2},
    { valueFrom: $(runtime.outdir), position: 3 },
    { valueFrom: "-t", position: 7},
    { valueFrom: "16", position: 8},
    { valueFrom: "--debug", position: 9}
]


inputs:
    fasta:
        type: File
        inputBinding:
            position: 1
            prefix: "-i"
    reference:
        type: File
        secondaryFiles: [.fai, .amb, .ann, .bwt, .pac, .sa]
        inputBinding:
            position: 4
            prefix: "-r"
    sample_name:
        type: string
        inputBinding:
            position: 5
            prefix: "-p"
    annot:
        type: File
        inputBinding:
            position: 6
            prefix: "-a"

outputs:
    cand_circ:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).cand_circ.fa
    json:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).json
    log:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).log
    low_conf:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).low_confidence.fa

