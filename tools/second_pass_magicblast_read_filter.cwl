#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Filter magicblast output to include chimeric reads and exclude fusion reads"
baseCommand: ["python", "/usr/bin/filter_magicblast_output.py"]
requirements:
    - class: ShellCommandRequirement
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_p"


inputs:
    #merged_chimeric_readIDs.txt from step 21
    chimeric_readIDs:
        type: File
        inputBinding:
            position: 1
    #merged_fusion_readIDs. from step 23
    fusion_readIDs:
        type: File
        inputBinding:
            position: 2
    magicblast_out:
        type: File
        inputBinding:
            position: 3


outputs:
    filtered:
        type: stdout

stdout: "non_rescued_long_magicblast_output_filtered.txt"

