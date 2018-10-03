PRO ZE_WRITE_COL,file,vec
close,1
openw,1,file     ; open file to write

for k=0, n_elements(vec)-1 do begin
printf,1,FORMAT='(F12.6,3x)',vec[k]
endfor
close,1

END
;--------------------------------------------------------------------------------------------------------------------------