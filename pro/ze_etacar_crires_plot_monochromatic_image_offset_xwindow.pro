PRO ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_XWINDOW,img,a,b,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0

;for lambda0 in angstroms
vel_Val=ZE_LAMBDA_TO_VEL(lambda_val,lambda0*10^4)


window,19,xsize=aa,ysize=bb,retain=0,XPOS=30,YPOS=90
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=2
!Y.CHARSIZE=2
!P.CHARSIZE=0
!P.CHARTHICK=0
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], [min(offset_vector),max(offset_vector)],XTICKFORMAT='(F5.2)',xstyle=1,ystyle=1, xtitle='Spatial offset along slit (arcsec)', ytitle='Spatial offset perpendicular to slit (arcsec)',$
/NODATA, Position=[0.08, 0.18, 0.945, 0.86],XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086], YRANGE=[min(offset_vector),max(offset_vector)]
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 13
;LOADCT,0
tvimage,img, /Overplot
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
LOADCT,13
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,CHARSIZE=1.3,$
POSITION=[0.95, 0.18, 0.97, 0.86]

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Spatial offset along slit (arcsec)',XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)',xcharsize=0

AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[min(offset_vector),max(offset_vector)]
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[min(offset_vector),max(offset_vector)],ytickv=4,YTICKFORMAT='(A2)'
xyouts,0.95,0.90,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')
;xyouts,0.25,0.75,'Pos'+strcompress(STRING(FIX(pos)))+', '+number_formatter(cumoffsetx_plot*0.085,decimals=2)+' '+direction+' '+TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=8
xyouts,0.25,0.75,'v='+number_formatter(vel_val,decimals=0),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=2.4

END