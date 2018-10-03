pro hwrite,h,filename
;+
;			hwrite
;
; procedure to print FITS header to a file
;
; CALLING SEQUENCE:
;	hwrite,h,filename
;
; INPUTS:
;	h - FITS header
;	filename - output file name
;
;-
	openw,unit,filename,/get_lun
	for i=0,n_elements(h)-1 do printf,unit,strtrim(h(i))
	free_lun,unit
return
end
