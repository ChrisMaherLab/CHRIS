#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Add a header to a file"
baseCommand: ["/bin/bash", "/usr/bin/add_generic_header.sh"]
requirements:
    - class: ShellCommandRequirement
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_p"

inputs:
    infile:
        type: File
        inputBinding:
            position: 1
    cols:
        type: int
        inputBinding:
            position: 2
    out_name:
        type: string
        inputBinding:
            position: 3


outputs:
    out:
        type: File
        outputBinding:
            glob: $(inputs.out_name)

