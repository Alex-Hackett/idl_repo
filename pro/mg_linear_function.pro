;+
; Create a function which maps in_range to out_range with a linear function.
;
; @returns 2-element array of type of in_range and out_range
; @param in_range {in}{required}{type=2-element numeric array} input range
; @param out_range {in}{required}{type=2-element numeric array} output range
;-
function mg_linear_function, in_range, out_range
    compile_opt strictarr
    
    slope = (out_range[1] - out_range[0]) / (in_range[1] - in_range[0])
    return, [out_range[0] - slope * in_range[0], slope]
end