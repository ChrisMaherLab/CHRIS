#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "isoCirc merge and cleanup"
baseCommand: ["/bin/bash", "cleanup.sh"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "jbwebster/sidi_r"
    - class: InitialWorkDirRequirement
      listing:
      - entryname: "cleanup.sh"
        entry: |
            in_beds=$1
            iso_outs=$2
            sample_name=$3
            dir=$4

            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              cat $f | awk 'BEGIN {OFS="\t"}{print $1,$2,$3,"circRNA_ID",$5,$6,$7,$8,$9,$10,$11,$12}'
             done
            done <<< "$in_beds" | sort | uniq | grep -v "#" > ${sample_name}.isocirc.merged.uniq.bed

            is_first=1
            while IFS=',' read -ra ARR; do
             for f in "${ARR[@]}"; do
              if [[ $is_first -eq 1 ]]
              then
                head -n 2 $f
                is_first=0
              fi
              tail -n +3 -q $f 
             done
            done <<< "$iso_outs" > ${sample_name}.isocirc.merged.out.txt

            Rscript /usr/bin/cleanup_isocirc.R ${sample_name}.isocirc.merged.uniq.bed ${sample_name}.isocirc.merged.out.txt ${sample_name} ${dir}

arguments: [
 { valueFrom: $(runtime.outdir), position: 4}
]

inputs:
    beds:
        type: File[]
        inputBinding:
            position: 1
            itemSeparator: ","
    iso_outs:
        type: File[]
        inputBinding:
            position: 2
            itemSeparator: ","
    sample_name:
        type: string
        inputBinding:
            position: 3


outputs:
    reads:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).isocirc.circRNA.readIDs.txt
    aggregate:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).isocirc.merged.aggregate.txt
    cleaned_bed:
        type: File
        outputBinding:
            glob: $(inputs.sample_name).isocirc.merged.uniq.cleaned.bed


