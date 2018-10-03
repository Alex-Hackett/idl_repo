;PRO ZE_WAVECAL_1D_SPEC_v4, lambda,flux,wl=wl,wr=wr,xc=xc,wc=wc,linelist=linelist,fit=fit,yfit=yfit,RMS=RMS
;implements mouse cursor selection
C=299792.
!EXCEPT = 0

grat_angle=2076
det=2
swmpa2_air=swmpa2[*,row]
VACTOAIR,swmpa2_air
guess_lambda=swmpa2_air*10.
index=1.*indgen((size(dataa2))[1])

;ZE_READ_TELKPNO_AIR,lambdacut=lkpno,fluxcut=fkpno,min(swmpa2_air)*10.,max(swmpa2_air)*10.
;ZE_BUILD_TELURIC_LINELIST_V2, lkpno,fkpno,grat_angle,det
linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_template.sav'
;ZE_CREATE_IDENT_PLOT_TELURIC,guess_lambda,f2canorm,grat_angle,det,linelist_file
;ZE_WAVECAL_BUILD_TEMPLATE,index,dataa2[*,row],grat_angle,det,linelist_file

lambda=index
flux_cal=index
minrow=28
numberrows=1 ;
!MOUSE.BUTTON = 1

for j=minrow, minrow+numberrows-1 do begin
!MOUSE.BUTTON = 1
flux_cal[*]=dataa2[*,j]
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
;save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/espectros/etc_poly_wavecal_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_line_auto_'+strcompress(string(j, format='(I02)'))+'.sav'
save,yfit,wc,wl,wr,xc,linelist,fit,RMS,FILENAME='/Users/jgroh/espectros/etc_poly_wavecal_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_line_auto_tel.sav'

endfor


END