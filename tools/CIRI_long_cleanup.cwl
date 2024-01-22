#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Cleanup ciri long outputs"
baseCommand: ["Rscript", "/usr/bin/ciri_long_cleanup.R"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_r"


arguments: [
 { valueFrom: $(runtime.outdir), position: 2}
]

inputs:
    sample_name:
        type: string
        inputBinding:
            position: 1
    info_file:
        type: File
        inputBinding:
            position: 3
    isoforms_file:
        type: File
        inputBinding:
            position: 4
    reads_file:
        type: File
        inputBinding:
            position: 5


outputs:
    bed:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).ciri.long.merged.uniq.cleaned.bed
    aggregate:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).ciri.long.merged.aggregate.txt
    reads:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).ciri.long.circRNA.readIDs.txt 
 

