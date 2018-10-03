PRO ZE_CCD_WAVECAL_BUILD_TEMPLATE_LAMP,lambda,flux,lambda_split_regions,xl,xu,index,angle,lampfilelna,wcall
;optimzed for LNA ccd and camiv reductoin
;do not read linelist from file -- use output form ZE_CCD_READ_LAMPFILE
;split interactive line identification in 3 wavelength regions for better identification
!EXCEPT=0

ZE_CCD_READ_LAMPFILE,lampfilelna,xl[0],xu[2],tharlinescut
nlines=n_elements(linelist)
wcall=1D0

FOR J=0, lambda_split_regions -1 Do BEGIN

ZE_CCD_READ_LAMPFILE,lampfilelna,xl[j],xu[j],tharlinescut
print,tharlinescut
nlinescut=n_elements(tharlinescut)
wl=dblarr(nlinescut) & wr=wl & xc=wl & wc=wl & minx_vec=wl & centerx_vec=wl & maxx_vec=wl
wlt=0. & wrt=0. & xct=0. & wct=0.

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
window,xsize=1400,ysize=900 
  PLOT,index,flux,xstyle=1,ystyle=1,xrange=[FINDEL(xl[j],lambda),FINDEL(xu[j],lambda)],/NOERASE, $
    xmargin=[12,6],ymargin=[4,15],psym=0,xtitle='Wavelength(A)', $
  title='ZE_WAVECAL_BUILD_TEMPLATE_V2'
;  OPLOT,guess_lambda,fluxtel*10.,linestyle=0,color=fsc_color('red')
;  OPLOT,lkpno,10.*(fkpno/max(fkpno))

   print,'Left-click to select lines which should be included for wavelength calibration; click as close as possible to line center '
    !MOUSE.BUTTON = 1

    for i=0, nlinescut -1 DO BEGIN
          CURSOR, xa, ya, /DATA, /DOWN
          PLOTS, xa, ya, PSYM=1, SYMSIZE=1.5, COLOR=FSC_COLOR("BLUE", !D.TABLE_SIZE-0)
          centerx_vec[i]=xa
          minx_vec[i]=xa-15
          maxx_vec[i]=xa+15         
    endfor   

minx_index=WHERE(minx_vec lt min(index),countmin)
maxx_index=WHERE(maxx_vec gt max(index),countmax)

IF countmin NE 0 THEN minx_vec(minx_index)=0
IF countmax NE 0 THEN maxx_vec(maxx_index)=max(index)
print,'minxvex, maxxvec'
print,minx_vec,maxx_vec       
print,'end minxx maxx '
window,20,xsize=1000,ysize=500 

;if keyword set do it interactively
IF KEYWORD_SET(INTERACTIVE) THEN BEGIN
FOR i=0, nlinescut -1 DO BEGIN
  ZE_zcentroid_v2,index,flux,0,minx_vec[i],maxx_vec[i],wlt,wrt,xct,wct
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct  
ENDFOR
ENDIF ELSE BEGIN
;default is automatic -- does not work because spectrum is being not subsampled around a line, thus it is currently fitting a gaussian to the whole spectrum!
  FOR i=0, nlinescut -1 DO BEGIN
  fit=gaussfit(index,flux,A)
  wc[i]=A[1]  
  ENDFOR
ENDELSE
temp=0
wcall=[wcall,wc]
ENDFOR
print,wcall
remove,0,wcall


fit=0
;fit=poly_fit2(wc,linelist,1)
yfit=poly_fit(wcall,linelist,2,yfit=fit)
print,linelist-fit
RMS=SQRT(TOTAL((linelist-fit)^2))

window,21
plot,wcall,linelist,/ynozero,psym=1
oplot,wcall,fit,color=fsc_color('red')

window,22
plot,wcall,(linelist-fit),/ynozero,psym=1

for i=0, n_elements(wc)-1 do xyouts,wcall[i],(linelist[i]-fit[i])*4,strcompress(string(i, format='(I02)')),charsize=2,align=0.5
print,'RMS [angstrom]:  ', RMS

;save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/temp/wavecal_'+gratdet+'_template.sav'
END