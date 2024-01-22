#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Get junctions and read IDs from alignment data"
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
            chimeric_junctions=$1

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              cat $f 
             done
            done <<< "$chimeric_junctions" | sort | uniq > merged_chimeric_junctions.txt

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              cat $f
             done
            done <<< "$chimeric_junctions" | cut -f10 | sort | uniq > merged_chimeric_readIDs.txt



inputs:
    junctions:
        type: File[]
        inputBinding:
            position: 1
            itemSeparator: ","


outputs:
    merged:
        type: File
        outputBinding:
            glob: merged_chimeric_junctions.txt
    read_ids:
        type: File
        outputBinding:
            glob: merged_chimeric_readIDs.txt

