#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "cat all input files and keep unique rows"
baseCommand: ["/bin/bash", "helper.sh"]
requirements:
    - class: ShellCommandRequirement
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "ubuntu:xenial"
    - class: InitialWorkDirRequirement
      listing:
      - entryname: "helper.sh"
        entry: |
            infiles=$1

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              cat $f 
             done
            done <<< "$infiles" | sort | uniq > unique.txt



inputs:
    infiles:
        type: File[]
        inputBinding:
            position: 1
            itemSeparator: ","


outputs:
    unique:
        type: File
        outputBinding:
            glob: unique.txt

