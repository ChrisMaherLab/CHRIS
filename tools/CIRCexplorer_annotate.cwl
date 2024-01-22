#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "CIRCexplorer annotate"
baseCommand: ["/opt/conda/bin/CIRCexplorer2", "annotate"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "bwhbioinformaticshub/circexplorer2"


inputs:
    gpf:
        type: File
        inputBinding:
            position: 1
            prefix: "-r"
    reference_fasta:
        type: File
        inputBinding:
            position: 2
            prefix: "-g"
    junction_bed:
        type: File
        inputBinding:
            position: 3
            prefix: "-b"


outputs:
    circRNA_annot:
        type: File
        outputBinding:
            glob: "circularRNA_known.txt"

