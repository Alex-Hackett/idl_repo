;NAME:
;     function get_val(input, none)
;PURPOSE:
;     convert input string to a real number   
;INPUT:
;     input - string to convert
;OUTPUT:
;     none - indicates whether a value was retrieved
;     value - value retrieved from string, set to 0 if input string is null
function get_val, input, none

  none=0
  temp = input(0)
  if (strcompress(temp, /remove_all) GT 0) then begin
    temps = float(temp)
    value = temps(0)
  endif else begin
    value = 0.
    none = 1
  endelse

  return, value
  END
