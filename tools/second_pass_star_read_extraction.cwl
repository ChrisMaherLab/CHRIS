#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Get read IDs from STAR fusion predictions"
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
            samples=$1

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              cat $f
             done
            done <<< "$samples" | cut -f11 | sed 's/,/\n/g' | grep -v "JunctionReads" | sort | uniq > merged_fusion_readIDs.txt




inputs:
    star_out:
        type: File[]
        inputBinding:
            position: 1
            itemSeparator: ","


outputs:
    read_ids:
        type: File
        outputBinding:
            glob: "merged_fusion_readIDs.txt"

