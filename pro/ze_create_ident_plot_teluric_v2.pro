PRO ZE_CREATE_IDENT_PLOT_TELURIC_V2,ltel,ftel,gratdet,linelist_file
;v2 implements gratdet instead of grat_angle and det, in order to include the obsdate in the output filenames = crucial for not overwriting output of different dates.


cs=1.7
ct=2.5

!P.CHARSIZE=cs
!P.CHARTHICK=ct

!X.CHARSIZE=0
!X.THICK=ct

!Y.CHARSIZE=0
!Y.THICK=ct

readcol,linelist_file,linelist
print,linelist
print,[min(ltel),max(ltel)]
;DEVICE, SET_FONT='Courier Bold Italic', /TT_FONT, $ 
;   SET_CHARACTER_SIZE=[70,90] 
   
window,22,xsize=1000,ysize=500
  PLOT,ftel,xstyle=1,ystyle=1,POSITION=[0.1,0.1,0.95,0.5],$
  psym=0,xtitle='Pixel',ytitle='F/Fc',yrange=[min(ftel),max(ftel)]
XYOUTS,0.5,0.9,'Telluric line identification for grating '+gratdet,align=0.5,charsize=3,/NORMAL
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=5,COLOR=fsc_color('black'),XTITLE='',XRANGE=[min(ltel),max(ltel)],/SAVE

FOR I=0, n_elements(linelist) -1  DO BEGIN
PLOTS,[linelist[i],linelist[i]],[min(ftel),max(ftel)],linestyle=1,thick=1
XYOUTS,linelist[i],1.03,'|'
XYOUTS,linelist[i]+0.5*cs,1.05,strcompress(string(i, format='(I02)'))+' = ' + strcompress(string(linelist[i], format='(F10.4)')),align=0.0,orientation=90
END
WRITE_PNG, '/Users/jgroh/espectros/telluriclines_air_list_'+gratdet+'.png', TVRD(True=1)
!P.CHARSIZE=0
!P.CHARTHICK=0

END