#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Add a header to a file
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
            infile=$1
            cols=$2
            outfile=$3

            h=""

            for i in $(seq 1 $cols); do
                if [[ $i -eq 1 ]];
                then
                    s+="V${i}"
                else
                    s+="\tV${i}"
                fi
            done
            echo -e $s > outfile
            #Remove header with # comment line, if there is one
            grep -v "#" $infile >> outfile



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

