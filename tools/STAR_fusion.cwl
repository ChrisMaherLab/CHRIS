#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "STAR Fusion"
baseCommand: ["/usr/local/src/STAR-Fusion/STAR-Fusion"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "trinityctat/starfusion:latest"

arguments: [
    { valueFrom: "--output_dir", position: 4},
    { valueFrom: "$(inputs.sample_name)_output", position: 5 }
]


inputs:
    star_fusion_index:
        type: Directory
        inputBinding:
            position: 1
            prefix: "--genome_lib_dir"
    r1:
        type: File
        inputBinding:
            position: 2
            prefix: "--left_fq"
    r2:
        type: File
        inputBinding:
            position: 3
            prefix: "--right_fq"
    sample_name:
        type: string

outputs:
    predictions:
        type: File
        outputBinding:
            glob: $(inputs.sample_name)_output/star-fusion.fusion_predictions.tsv

