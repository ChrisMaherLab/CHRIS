#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "CIRCexplorer parse"
baseCommand: ["/opt/conda/bin/CIRCexplorer2", "parse", "-t", "STAR"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "bwhbioinformaticshub/circexplorer2"


inputs:
    junction:
        type: File
        inputBinding:
            position: 1
           

outputs:
    back_splice_junction:
        type: File
        outputBinding:
            glob: "back_spliced_junction.bed"

