#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Extract high confidence reads from isocirc/ciri output based on magicblast output"
baseCommand: ["python", "/usr/bin/extract_high_conf_circRNAs.py"]
requirements:
    - class: ShellCommandRequirement
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_p"


inputs:
    magicblast_reads:
        type: File
        inputBinding:
            position: 1
    isocirc_reads:
        type: File
        inputBinding:
            position: 2
    ciri_reads:
        type: File
        inputBinding:
            position: 3


outputs:
    isocirc:
        type: File
        outputBinding:
            glob: isocirc.second.pass.only.txt
    ciri:
        type: File
        outputBinding:
            glob: ciri.long.second.pass.only.txt


