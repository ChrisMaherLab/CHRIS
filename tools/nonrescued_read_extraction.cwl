#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "Nonrescued read extraction"
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
            nonrescued_circRNAs=$1
            isocirc_out=$2
            ciri_long_out=$3
            long_read_fastas=$4

            #Extract compatible IDs
            cut -f13 $nonrescued_circRNAs > non_rescued_isoCirc_coords.txt
            cut -f14 $nonrescued_circRNAs > non_rescued_CIRI_long_coords.txt

            grep -f non_rescued_isoCirc_coords.txt $isocirc_output > non_rescued_isoCirc_out.txt
            grep -f non_rescued_CIRI_long_coords.txt $ciri_long_out > non_rescued_CIRI_long_out.txt

            cut -f24 non_rescued_isoCirc_out.txt | sed 's/,/\n/g' > non_rescued_isoCirc_readIDs.txt
            cut -f17 non_rescued_CIRI_long_out.txt | sed 's/,/\n/g' > non_rescued_CIRI_long_readIDs.txt

            cat non_rescued_isoCirc_readIDs.txt non_rescued_CIRI_long_readIDs.txt | grep -v "read" | sort | uniq > non_rescued_readIDs.txt

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              grep -A1 -f non_rescued_readIDs.txt $f | sed '/^--$/d' >> non_rescued_long_reads.fasta
             done 
            done <<< "$long_read_fastas"
            
           



inputs:
    nonrescued_circRNAs:
        type: File
        inputBinding:
            position: 1
    isocirc_out:
        type: File
        inputBinding:
            position: 2
    ciri_long_out:
        type: File
        inputBinding:
            position: 3
    corrected_reads:
        type: File[]
        inputBinding:
            position: 4
            itemSeparator: ","           


outputs:
    non_rescued_fasta:
        type: File
        outputBinding:
            glob: non_rescued_long_reads.fasta

