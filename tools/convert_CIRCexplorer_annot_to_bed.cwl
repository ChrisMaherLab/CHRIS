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

arguments: [
 { valueFrom: $(runtime.outdir), position: 1}
]

inputs:
    mean_read_filter:
        type: int
        inputBinding:
            position: 2
    sample_names:
        type: string[]
        inputBinding:
            position: 3
    annot:
        type: File[]
        inputBinding:
            position: 4


outputs:
    circRNA_annot_bed:
        type: File
        outputBinding:
            glob: circularRNA_known.bed
    circ_annot_bed_filter_result:
        type: File
        outputBinding:
            glob: circularRNA_known.filter_info.bed

