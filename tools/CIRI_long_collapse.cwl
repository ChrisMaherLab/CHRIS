#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "CIRI-long"
baseCommand: ["/bin/bash", "helper.sh"]
requirements:
    - class: ShellCommandRequirement
    - class: InlineJavascriptRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 16
    - class: DockerRequirement
      dockerPull: "sidizhao/ciri-long:v1.1.0"
    - class: InitialWorkDirRequirement
      listing:
      - entryname: "helper.sh"
        entry: |
            in_fastas=$1
            out_name=$2
            sample_name=$3
            ref=$4
            annot=$5
            circ_bed=$6
            low_conf=$7

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              cat $f >> ${sample_name}.cand_circ.fa
             done
            done <<< "$in_fastas"

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              cat $f >> ${sample_name}.low_confidence.fa
             done
            done <<< "$low_conf"

            echo -e "${sample_name}\t${sample_name}.cand_circ.fa" > collapse.${sample_name}.lst

            mkdir $out_name

            CIRI-long collapse -i collapse.${sample_name}.lst -o ${out_name} -p ${sample_name} -r ${ref} -a ${annot} -c ${circ_bed}



arguments: [
#    { valueFrom: "-o", position: 2},
    { valueFrom: "collapse_output", position: 3 }
]


inputs:
    cand_circ_fasta:
        type: File[]
        inputBinding:
            position: 1
#            prefix: "-i"
            itemSeparator: ","
    reference:
        type: File
        secondaryFiles: [.fai, .amb, .ann, .bwt, .pac, .sa]
        inputBinding:
            position: 5
#            prefix: "-r"
    sample_name:
        type: string
        inputBinding:
            position: 4
#            prefix: "-p"
    annot:
        type: File
        inputBinding:
            position: 6
#            prefix: "-a"
    known_circ_bed:
        type: File
        inputBinding:
            position: 7
#            prefix: "-c"
    low_conf:
        type: File[]
        inputBinding:
            position: 8
            itemSeparator: ","


outputs:
    expression:
        type: File
        outputBinding:
            glob: collapse_output/$(inputs.sample_name).expression
    info:
        type: File
        outputBinding:
            glob: collapse_output/$(inputs.sample_name).info
    isoforms:
        type: File
        outputBinding:
            glob: collapse_output/$(inputs.sample_name).isoforms
    log:
        type: File
        outputBinding:
            glob: collapse_output/$(inputs.sample_name).log
    reads:
        type: File
        outputBinding:
            glob: collapse_output/$(inputs.sample_name).reads

