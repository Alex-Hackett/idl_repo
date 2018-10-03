;PRO ZE_WAVECAL_1D_SPEC, lambda,flux,wl=wl,wr=wr,xc=xc,wc=wc,linelist=linelist,fit=fit,yfit=yfit,RMS=RMS
lambda=index
flux_cal=index
flux_cal[*]=dataa2[*,14]
flux=flux_cal
linelist_file='/Users/jgroh/espectros/telluriclines_air_list_2070_1_sel.txt'

readcol,linelist_file,linelist
nlines=n_elements(linelist)
wl=dblarr(nlines) & wr=wl & xc=wl & wc=wl
wlt=0. & wrt=0. & xct=0. & wct=0.
window,20,xsize=1000,ysize=500 
FOR i=0, nlines -1 DO BEGIN
  ZE_zcentroid,lambda,flux,0,wlt,wrt,xct,wct
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct
ENDFOR


fit=0
;fit=poly_fit2(wc,linelist,1)
yfit=poly_fit(wc,linelist,2,yfit=fit)
print,linelist-fit
RMS=TOTAL((linelist-fit)^2)

window,21
plot,wc,linelist,/ynozero,psym=1
oplot,wc,fit,color=fsc_color('red')

window,22
plot,wc,(linelist-fit),/ynozero,psym=1

for i=0, n_elements(wc)-1 do xyouts,wc[i],(linelist[i]-fit[i])*4,strcompress(string(i, format='(I02)')),charsize=2,align=0.5
print,'RMS [angstrom]:  ', RMS

;save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/espectros/etc_poly_wavecal_2070_det1_line10.sav'
END