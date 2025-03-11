#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: ExpressionTool
label: "Gather outputs into a single directory"

requirements:
    - class: InlineJavascriptRequirement

inputs:
    circexplorer2_annotation:
        type: File[]
    isocirc_calls:
        type: File
    first_pass_rescue:
        type: File
    magicblast_mapping_result:
        type: File[]
    high_confidence_magicblast_hits:
        type: File
    first_and_second_pass_result:
        type: File
    circ_annot_filter:
        type: File


outputs:
    out:
        type: Directory

expression: >
    ${
        return {"out": {
            "class": "Directory",
            "basename": "OutputDirectory",
            "listing": [inputs.circexplorer2_annotation, inputs.isocirc_calls, inputs.first_pass_resuce, inputs.magicblast_mapping_result, inputs.high_confidence_magicblast_hits, inputs.first_and_second_pass_result, inputs.circ_annot_filter]
        } };
    }
