;PRO ZE_WAVECAL_1D_SPEC_v2, lambda,flux,wl=wl,wr=wr,xc=xc,wc=wc,linelist=linelist,fit=fit,yfit=yfit,RMS=RMS
C=299792.
lambda_cal=1.*indgen((size(dataa2))[1])
lambda=lambda_cal
flux_cal=lambda_cal
minrow=13
numberrows=1 ;
for j=minrow, minrow+numberrows-1 do begin
flux_cal[*]=dataa2[*,j]
flux_cal[*]=f2canorm
flux=flux_cal
linelist_file='/Users/jgroh/espectros/telluriclines_air_list_2070_2_sel.txt'
restore,'/Users/jgroh/espectros/etc_poly_wavecal_2070_det2_template.sav'
readcol,linelist_file,linelist
nlines=18
;wl=dblarr(nlines) & wr=wl & xc=wl & wc=wl
;wlt=wl[i] & wrt=r[i]. & xct=0. & wct=0.
CH=''
START:

;    print,'Hit R to remove points  '
;    read,CH,PROMPT='Hit R to remove points '
;    print,' '
    if strupcase(ch) eq 'R' then BEGIN
    print,'Type the number(s) of points which should be removed  '
    read,nremoval,PROMPT='Type the number(s) of points which should be removed'
    print,' '
    indexremoval=fltarr(nremoval)
    print,'Type the index(es) of points which should be removed  '
    indexremovalt=1.
    for i=0, nremoval -1 DO BEGIN
    read,indexremovalt,PROMPT='Type the index(es) of points which should be removed'
    indexremoval[i]=indexremovalt
    ENDFOR
    REMOVE,indexremoval,wc,linelist,wr,wl,xc
    nlines=nlines-nremoval
    print,' '
    endif
  
window,20,xsize=1000,ysize=500 
  PLOT,lambda,10.*(flux/max(flux)),xstyle=1,/NOERASE, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='FP_MERGE ( using CENTROID option)'
  
FOR i=0, nlines -1 DO BEGIN
  wlt=wl[i] & wrt=wr[i] & ;xct=xc[i] ;& wct=wc[i]
  print,wlt,wrt
  ZE_zcentroid,lambda,flux,1,wlt,wrt,xct,wct,aa
  W0=(WRt+WLt)/2.
  wcl=((AA(1)/c)+1)*(w0)
  fl=((AA/c)+1)*(w0)
  print,wcl,wct,fl
  ;print,aa
  XYOUTS,wct,min(10.*(flux/max(flux)))/2.,strcompress(string(i, format='(I02)')),align=0.5
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct
ENDFOR


fit=0
;fit=poly_fit2(wc,linelist,1)
yfit=poly_fit(wc,linelist,2,yfit=fit,yerror=stddev)
print,linelist-fit
RMS=TOTAL((linelist-fit)^2)

window,21
plot,wc,linelist,/ynozero,psym=1
oplot,wc,fit,color=fsc_color('red')

window,22
plot,wc,(linelist-fit),/ynozero,psym=1

for i=0, n_elements(wc)-1 do xyouts,wc[i],(linelist[i]-fit[i])*4,strcompress(string(i, format='(I02)')),charsize=2,align=0.5
print,'RMS [angstrom]:  ', RMS

    CH=''
    print,' '
    read,CH,PROMPT='  C)ontinue   R)emove point(s) and redo fit'
    print,' '
    if strupcase(ch) eq 'R' then GOTO,START
    

;save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/espectros/etc_poly_wavecal_2070_det2_line_auto_'+strcompress(string(j, format='(I02)'))+'.sav'
save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/espectros/etc_poly_wavecal_2070_det2_line_auto_tel.sav'

endfor
END