#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Identify high confidence hits from filtered magicblast output"
baseCommand: ["Rscript", "/usr/bin/second_pass_magicblast_high_conf_hits.R"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_r"


arguments: [
 { valueFrom: $(runtime.outdir), position: 3}
]

inputs:
    magicblast:
        type: File
        inputBinding:
            position: 1
    junctions:
        type: File
        inputBinding:
            position: 2


outputs:
    high_conf_long_read_ids:
        type: File
        outputBinding:
            glob: high_conf_long_read_ids.txt
    high_conf_short_read_ids:
        type: File
        outputBinding:
            glob: high_conf_short_read_ids.txt
    high_conf_ref_query_pair:
        type: File
        outputBinding:
            glob: high_conf_ref_query_pair_read_ids.txt
    high_conf_magicblast_hits:
        type: File
        outputBinding:
            glob: high_conf_ref_magicblast_output_filtered.txt
    long_read_ids:
        type: File
        outputBinding:
            glob: long_read_ids.txt
    short_read_ids:
        type: File
        outputBinding:
            glob: short_read_ids.txt
 

