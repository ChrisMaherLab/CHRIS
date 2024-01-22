#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "makeblastdb"
baseCommand: ["makeblastdb"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "quay.io/biocontainers/magicblast:1.6.0--hf1761c0_1"

arguments: [
 { valueFrom: "-out", position: 2},
 { valueFrom: "non_rescued_long_reads_db/non_rescued_long_reads", position: 3},
 { valueFrom: "-parse_seqids", position: 4},
 { valueFrom: "-dbtype", position: 5},
 { valueFrom: "nucl", position: 6}
]


inputs:
    fasta:
        type: File
        inputBinding:
            position: 1
            prefix: "-in"
           

outputs:
    db:
        type: Directory
        outputBinding:
            glob: "non_rescued_long_reads_db"

