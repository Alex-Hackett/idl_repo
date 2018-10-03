PRO ZE_INDIE_WRITE_DEN_TO_CHAEL,file,ND,Nangles,vec
close,1
openw,1,file     ; open file to write
printf,1,FORMAT='(F12.4)',ND
printf,1,FORMAT='(F12.4)',Nangles
for k=0., n_elements(vec)-1. do begin
printf,1,FORMAT='(E16.9)',vec[k]
endfor
close,1

END
;------