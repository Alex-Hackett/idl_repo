PRO ZE_WAVECAL_BUILD_TEMPLATE_V3,lambda,flux,gratdet,linelist_file
;v3 implements gratdet instead of grat_angle and det, in order to include the obsdate in the output filenames = crucial for not overwriting output of different dates.

!EXCEPT=0
readcol,linelist_file,linelist
nlines=n_elements(linelist)
wl=dblarr(nlines) & wr=wl & xc=wl & wc=wl & minx_vec=wl & centerx_vec=wl & maxx_vec=wl
wlt=0. & wrt=0. & xct=0. & wct=0.

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
window,xsize=1000,ysize=500 
  PLOT,lambda,flux,xstyle=1,ystyle=1,yrange=[min(flux),max(flux)],/NOERASE, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='ZE_WAVECAL_BUILD_TEMPLATE_V2'
;  OPLOT,guess_lambda,fluxtel*10.,linestyle=0,color=fsc_color('red')
;  OPLOT,lkpno,10.*(fkpno/max(fkpno))

   print,'Left-click to select lines which should be included for wavelength calibration; click as close as possible to line center '
    !MOUSE.BUTTON = 1

    for i=0, nlines -1 DO BEGIN
          CURSOR, xa, ya, /DATA, /DOWN
          PLOTS, xa, ya, PSYM=1, SYMSIZE=1.5, COLOR=FSC_COLOR("BLUE", !D.TABLE_SIZE-0)
          centerx_vec[i]=xa
          minx_vec[i]=xa-15
          maxx_vec[i]=xa+15         
    endfor   
       
minx_index=WHERE(minx_vec lt min(lambda),countmin)
maxx_index=WHERE(maxx_vec gt max(lambda),countmax)

IF countmin NE 0 THEN minx_vec(minx_index)=0
IF countmax NE 0 THEN maxx_vec(maxx_index)=max(lambda)      
       
window,20,xsize=1000,ysize=500 
FOR i=0, nlines -1 DO BEGIN
  ZE_zcentroid_v2,lambda,flux,0,minx_vec[i],maxx_vec[i],wlt,wrt,xct,wct
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct
ENDFOR


fit=0
;fit=poly_fit2(wc,linelist,1)
yfit=poly_fit(wc,linelist,2,yfit=fit)
print,linelist-fit
RMS=SQRT(TOTAL((linelist-fit)^2))

window,21
plot,wc,linelist,/ynozero,psym=1
oplot,wc,fit,color=fsc_color('red')

window,22
plot,wc,(linelist-fit),/ynozero,psym=1

for i=0, n_elements(wc)-1 do xyouts,wc[i],(linelist[i]-fit[i])*4,strcompress(string(i, format='(I02)')),charsize=2,align=0.5
print,'RMS [angstrom]:  ', RMS

save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_template.sav'
END