PRO ZE_WRITE_SPECTRA_COL_VEC,file,lambda,flux,flux2,header=header
close,1
openw,1,file     ; open file to write

IF KEYWORD_SET(header) THEN BEGIN
 printf,1,header
 printf,1,'#'
ENDIF

for k=0., n_elements(lambda)-1. do begin
  if n_elements(flux2) GT 0 THEN printf,1,FORMAT='(E15.6,2x,E15.6,2x,E15.6)',lambda[k],flux[k],flux2[k] ELSE printf,1,FORMAT='(E15.6,2x,E15.6)',lambda[k],flux[k]
endfor
close,1

END
;--------------------------------------------------------------------------------------------------------------------------