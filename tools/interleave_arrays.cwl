#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: ExpressionTool
label: "Combine two arrays of equal length, alternating items from each array"

requirements:
    - class: InlineJavascriptRequirement


inputs:
    array1:
        type: File[]
    array2:
        type: File[]

outputs:
    merged_array:
        type: File[]


expression: >
    ${
        var out_array = [];
        for (var i = 0; i < inputs.array1.length; i++) {
            out_array.push(inputs.array1[i]);
            out_array.push(inputs.array2[i]);
        }
        return { 'merged_array' : out_array }
    }
