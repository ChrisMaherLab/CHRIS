#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Mapping"
baseCommand: ["magicblast"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "quay.io/biocontainers/magicblast:1.6.0--hf1761c0_1"
    - class: InitialWorkDirRequirement
      listing: $(inputs.db)

arguments: [
 { valueFrom: "-infmt", position: 4},
 { valueFrom: "fastq", position: 5},
 { valueFrom: "-outfmt", position: 6},
 { valueFrom: "tabular", position: 7},
 { valueFrom: "-no_unaligned", position: 8},
 { valueFrom: "-out", position: 9},
 { valueFrom: non_rescued_long_reads_vs_$(inputs.sample_name)_magicblast_output.txt, position: 10},
 { valueFrom: "-db", position: 11},
 { valueFrom: "non_rescued_long_reads_db/non_rescued_long_reads", position: 12}
]


inputs:
    r1:
        type: File
        inputBinding:
            position: 1
            prefix: "-query"
    r2:
        type: File
        inputBinding:
            position: 2
            prefix: "-query_mate"
    db:
        type: Directory
    sample_name:
        type: string
           

outputs:
    out:
        type: File
        outputBinding:
            glob: non_rescued_long_reads_vs_$(inputs.sample_name)_magicblast_output.txt

