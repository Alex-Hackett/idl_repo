PRO ZE_WAVECAL_CALIB_LAMBDA_CAL_V2,index,guess_lambda,f2canorm,minrow,numberrows,gratdet,linelist_file,template_file
;v2 implements gratdet instead of grat_angle and det, in order to include the obsdate in the output filenames = crucial for not overwriting output of different dates.
C=299792.458

lambda=index
flux_cal=index
!MOUSE.BUTTON = 1

for j=minrow, minrow+numberrows-1 do begin
!MOUSE.BUTTON = 1
flux_cal=f2canorm
flux=flux_cal
restore,template_file
readcol,linelist_file,linelist
nlines=n_elements(linelist)
CH=''
START:

    if strupcase(ch) eq 'R' then BEGIN
    print,'Left-click to select the points which should be removed (press the right button when done) '
    nremoval=0
    indexremoval=0
    !MOUSE.BUTTON = 1
    wset,22
   
    AXIS,XAXIS=1,XRANGE=[min(guess_lambda),max(guess_lambda)],xstyle=1,XTICKFORMAT='(I6)'
    wshow,22

        CURSOR, xa, ya, /DATA, /DOWN
        print,xa,ya
        PLOTS, xa, ya, PSYM=1, SYMSIZE=1.5, COLOR=FSC_COLOR("RED", !D.TABLE_SIZE-0)
        near = Min(Abs(wc - xa), indexremoval)
        print,near,indexremoval,nremoval
        
        IF !MOUSE.BUTTON NE 4 THEN BEGIN 
          REMOVE,indexremoval,wc,linelist,wr,wl,xc
          nremoval=nremoval + 1
        ENDIF
         IF !MOUSE.BUTTON EQ 4 THEN GOTO,ENDLINE

    nlines=nlines-nremoval
    print,' '
    endif
  
window,20,xsize=1000,ysize=500 
  PLOT,lambda,10.*(flux/max(flux)),/NOERASE, xstyle=9,$
    POSITION=[0.1,0.1,0.9,0.9],psym=0,xtitle='Wavelength(A)'
  
FOR i=0, nlines -1 DO BEGIN
  wlt=wl[i] & wrt=wr[i] & ;xct=xc[i] ;& wct=wc[i]
  print,wlt,wrt
  ZE_zcentroid,lambda,flux,1,wlt,wrt,xct,wct,aa
  W0=(WRt+WLt)/2.
  wcl=((AA(1)/c)+1)*(w0)
  fl=((AA/c)+1)*(w0)
  ;print,wcl,wct,fl
  ;print,aa
  XYOUTS,wct,min(10.*(flux/max(flux)))/2.,strcompress(string(i, format='(I02)')),align=0.5
  wl[i]=wlt & wr[i]=wrt & xc[i]=xct & wc[i]=wct
ENDFOR


fit=0
yfit=poly_fit(wc,linelist,2,yfit=fit,yerror=stddev)
print,linelist-fit
RMS=SQRT(TOTAL((linelist-fit)^2))
vel_rms=(RMS/(min(guess_lambda)+(max(guess_lambda)-min(guess_lambda))/2.))*C
AXIS,XAXIS=1,XRANGE=[min(guess_lambda),max(guess_lambda)],xstyle=1,XTICKFORMAT='(I6)'

window,21
plot,wc,linelist,/ynozero,psym=1
oplot,wc,fit,color=fsc_color('red')

window,22
plot,wc,(linelist-fit),/ynozero,psym=1,xstyle=10
AXIS,XAXIS=1,XRANGE=[min(guess_lambda),max(guess_lambda)],xstyle=1,XTICKFORMAT='(I6)'

for i=0, n_elements(wc)-1 do xyouts,wc[i],(linelist[i]-fit[i])*4,strcompress(string(i, format='(I02)')),charsize=2,align=0.5
print,'RMS [angstrom]:  ', RMS
print,'RMS [km/s]    :  ', VEL_RMS

    IF !MOUSE.BUTTON EQ 1 THEN BEGIN
    CH='R'
    GOTO,START
    ENDIF

ENDLINE:
PRINT,'Finished for current 1D spectrum'
save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'
endfor


END