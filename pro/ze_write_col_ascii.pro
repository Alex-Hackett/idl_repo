PRO ZE_WRITE_COL_ASCII,file,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10
;right now works only for 3 vectors
;print,file
;print,v1
;print,v2
close,1
openw,1,file     ; open file to write

if n_elements(v3) LT 1 THEN BEGIN
  for k=0., n_elements(v1)-1 do begin
  printf,1,FORMAT='(F15.9,3x,F15.9)',v1[k],v2[k]
  endfor
ENDIF ELSE BEGIN
  if n_elements(v3) GT 1 THEN BEGIN
   for k=0., n_elements(v1)-1 do begin
   printf,1,FORMAT='(F15.9,3x,F15.9,3x,F15.9)',v1[k],v2[k],v3[k]
   endfor
  ENDIF
ENDELSE  
;
;for k=0., n_elements(v1)-1 do begin
;printf,1,FORMAT='(F15.9,3x,F15.9,3x,F15.9,3x,F15.9,3x,F15.9,3x,F15.9,3x,F15.9,3x,F15.9,3x,F15.9,3x,F15.9)',v1[k],v2[k],v3[k],v4[k],v5[k],v6[k],v7[k],v8[k],v9[k],v10[k]
;endfor



close,1
print,'Written file :',file
END
;--------------------------------------------------------------------------------------------------------------------------