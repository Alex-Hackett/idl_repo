PRO ZE_INDIE_WRITE_R_TO_CHAEL,file,vec
close,1
openw,1,file     ; open file to write

for k=0., n_elements(vec)-1. do begin
printf,1,FORMAT='(E16.9)',vec[k]
endfor
close,1

END
;------