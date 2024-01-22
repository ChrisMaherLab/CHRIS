#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: ExpressionTool
label: "Get the base name of a given file"

requirements:
    - class: InlineJavascriptRequirement


inputs:
    file_name:
        type: File

outputs:
    sample_name:
        type: string


expression: >
    ${
        var out_name = "";
        out_name = inputs.file_name.path.split(/[\\/]/).pop().replace(/\.[^/.]+$/, "")
        return { 'sample_name' : out_name }
    }
