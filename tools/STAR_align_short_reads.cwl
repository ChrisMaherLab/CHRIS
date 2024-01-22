#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
label: "STAR: align reads"
baseCommand: ["STAR"]
requirements:
    - class: ShellCommandRequirement
    - class: ResourceRequirement
      ramMin: 64000
      coresMin: 12
    - class: DockerRequirement
      dockerPull: "mgibio/star:2.7.0f"


arguments: [
    "--chimSegmentMin", "18",
    "--chimOutType", "WithinBAM", "Junctions",
    "--outReadsUnmapped", "Fastx",
    "-runThreadN", "18",
    "--outSAMtype", "BAM", "SortedByCoordinate",
    "--quantMode", "GeneCounts",
    "--genomeLoad", "NoSharedMemory",
    "--outSJfilterOverhangMin", "15", "15", "15", "15",
    "--alignSJoverhangMin", "15",
    "--alignSJDBoverhangMin", "10",
    "--outFilterMultimapNmax", "20",
    "--outFilterScoreMin", "1",
    "--outFilterMismatchNmax", "999",
    "--outFilterMismatchNoverLmax", "0.05",
    "--outFilterMatchNminOverLread", "0.7",
    "--alignIntronMin", "20", 
    "--alignIntronMax", "1000000",
    "--alignMatesGapMax", "1000000",
    "--chimScoreMin", "15",
    "--chimScoreSeparation", "10",
    "--chimJunctionOverhangMin", "15",
    "--twopassMode", "Basic",
    "--alignSoftClipAtReferenceEnds", "No",
    "--outSAMattributes", "NH", "HI", "NM", "MD", "AS", "XS",
    "--outSAMstrandField", "intronMotif"
]


inputs:
    fastq_r1:
        type: File
        inputBinding:
            position: 4
            prefix: '--readFilesIn'
    fastq_r2:
        type: File
        inputBinding:
            position: 5
    genomeDir:
        type: Directory
        inputBinding:
            position: 6
            prefix: '--genomeDir'
    gtf:
        type: File
        inputBinding:
            position: 7
            prefix: '--sjdbGTFfile'


outputs:
    aligned_bam:
        type: File
        outputBinding:
            glob: "Aligned.sortedByCoord.out.bam"
    junction:
        type: File
        outputBinding:
            glob: "Chimeric.out.junction"
    
