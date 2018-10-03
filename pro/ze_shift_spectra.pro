function ze_shift_spectra, spec, x0
;+
; NAME: SHIFT_SUB
; PURPOSE:
;     Shift an image with subpixel accuracies
; CALLING SEQUENCE:
;      Result = shift_sub(image, x0, y0)
;-

 
if fix(x0)-x0 eq 0. then return, shift(spec, x0)

s =size(spec)
x=findgen(s(1))
x1= (x-x0)>0<(s(1)-1.)  
return, interpolate(spec, x1)
end 
