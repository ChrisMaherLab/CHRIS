#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Collect and clean results from first and second pass"
baseCommand: ["Rscript", "/usr/bin/first_and_second_pass_cleanup.R"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_r"


arguments: [
 { valueFrom: $(runtime.outdir), position: 6}
]

inputs:
    short_bed:
        type: File
        inputBinding:
            position: 1
    first_pass_result:
        type: File
        inputBinding:
            position: 2
    first_pass_rescued:
        type: File
        inputBinding:
            position: 3
    isocirc_result:
        type: File
        inputBinding:
            position: 4
    ciri_long_result:
        type: File
        inputBinding:
            position: 5


outputs:
    out:
        type: File
        outputBinding:
            glob: final_two_pass_rescue_results.txt
 

