#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "First pass cleanup"
baseCommand: ["Rscript", "/usr/bin/first_pass_results_cleanup.R"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_r"


arguments: [
 { valueFrom: $(runtime.outdir), position: 5}
]

inputs:
    short_read_bed:
        type: File
        inputBinding:
            position: 1
    long_read_bed:
        type: File
        inputBinding:
            position: 2
    sample_names:
        type: string[]
        inputBinding:
            position: 3
            itemSeparator: ","
    short_read_circRNAs:
        type: File[]
        inputBinding:
            position: 4
            itemSeparator: ","


outputs:
    rescued:
        type: File
        outputBinding:
            glob: first_pass_rescued_circRNAs_out.txt
    non_rescued:
        type: File
        outputBinding:
            glob: first_pass_nonrescued_long_read_circRNAs.txt
 

