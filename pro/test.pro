asas_cut='/aux/pc20072b/jgroh/espectros/agcar_V_photometry_asas_new_cut2.txt'
ze_read_asas_photometry_cut,asas_cut,data

;note on ASAS apertures: mag0=2pix, max1=3 pix, 4 pix, 5 pix, and mag4=6pix. Plate scale is 15 arcsec/pix.
;ASAS magnitude should be used only for V>7.
;best aperture for AG car is 6pix = 90 arcsec 

;select only grade A data
nrec=(size(data.grade))[1]
t=fltarr(nrec)
for i=0, nrec-1 do begin
if data.grade[i] ne 'A' then begin
t[i]=i
endif else begin
;t[i]=0
endelse
endfor
t=where(t ne 0)

hjd_sela=data.hjd
mag4_sela=data.mag4
mag3_sela=data.mag3

remove,t,hjd_sela
remove,t,mag3_sela
remove,t,mag4_sela

END
