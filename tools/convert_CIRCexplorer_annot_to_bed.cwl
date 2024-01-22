#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "CIRCexplorer annotate"
baseCommand: ["Rscript", "/usr/bin/circularRNA_annot_to_bed.R"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_r"


inputs:
    sample_names:
        type: string[]
        inputBinding:
            position: 1
    annot:
        type: File[]
        inputBinding:
            position: 2


outputs:
    circRNA_annot_bed:
        type: stdout

stdout: "circularRNA_known.bed"

