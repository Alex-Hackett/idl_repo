PRO ZE_CCD_WAVECAL_CALIB_LAMBDA_V1,index,guess_lambda,f2canorm,gratdet,linelist
;v2 implements gratdet instead of grat_angle and det, in order to include the obsdate in the output filenames = crucial for not overwriting output of different dates.
;v3 implements higher quality plots and output to EPS files
C=299792.458
Angstrom = '!6!sA!r!u!9 %!6!n'
lambda=index
flux_cal=index

!MOUSE.BUTTON = 1
flux_cal=f2canorm
flux=flux_cal
wl=xcenmin
wr=xcenmax
wc=xcennew

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
plot,wc,linelist,/ynozero,psym=1,xtitle='Pixel',ytitle='Wavelength ('+Angstrom+')'
oplot,wc,fit,color=fsc_color('red')

window,22
plot,wc,(linelist-fit),/ynozero,psym=1,xstyle=10,xtitle='Pixel',ytitle='Residual ('+Angstrom+')'
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

;outputting PS files
aa=800.
bb=600.
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/wavecal_fit_'+gratdet+'.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

!X.THICK=5.5
!Y.THICK=5.5
!X.CHARSIZE=2
!Y.CHARSIZE=2
!P.CHARSIZE=2
!P.CHARTHICK=5.5
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot,wc,linelist,psym=2,xtitle='Pixel',ytitle='Wavelength ['+Angstrom+']',POSITION=[0.24,0.18,0.95,0.95],YTICKFORMAT='(I6)',symsize=2,thick=5,$
YRANGE=[min(linelist)-(max(linelist)-min(linelist))*0.1,max(linelist)+(max(linelist)-min(linelist))*0.1],ystyle=1
oplot,wc,fit,color=fsc_color('red'),thick=5
xyouts,0.4,0.25,TEXTOIDL('\lambda=')+number_formatter(yfit[0],decimals=2)+'+'+number_formatter(yfit[1],decimals=2)+'*pix'+''+number_formatter(yfit[2],decimals=2)+TEXTOIDL('*pix^2'),/NORMAL


device,/close_file

ps_filename='/Users/jgroh/temp/wavecal_resid_'+gratdet+'.eps'

device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
plot,wc,(linelist-fit),psym=1,xstyle=10,xtitle='Pixel',ytitle='Residual ['+Angstrom+']',POSITION=[0.23,0.18,0.95,0.92],/ynozero,symsize=2,thick=5 ;,YRANGE=[min(linelist-fit)*0.8,,max(linelist]
AXIS,XAXIS=1,XRANGE=[min(guess_lambda),max(guess_lambda)],xstyle=1,XTICKFORMAT='(I6)',xtickinterval=150.
xyouts,0.4,0.25,TEXTOIDL('RMS=')+number_formatter(vel_rms,decimals=2)+' km/s',/NORMAL,charsize=1.5
device,/close_file
set_plot,'x'
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
END