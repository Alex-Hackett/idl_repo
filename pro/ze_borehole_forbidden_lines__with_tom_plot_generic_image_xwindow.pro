PRO ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_PLOT_GENERIC_IMAGE_XWINDOW,img,a,b,xvalues,yvalues,aa,bb,ct,nointerp

window,18,xsize=aa,ysize=bb,retain=0,XPOS=30,YPOS=90
!X.THICK=5
!Y.THICK=5
!X.CHARSIZE=2
!Y.CHARSIZE=2
!P.CHARSIZE=0
!P.CHARTHICK=4
!P.THICk=5
!P.FONT=1
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, [min(xvalues),max(xvalues)], [min(yvalues),max(yvalues)],XTICKFORMAT='(F5.1)',xstyle=1,ystyle=1, xtitle='Offset (arcsec)', ytitle= 'Offset (arcsec)',$
/NODATA, Position=[0.1, 0.1, 0.9, 0.9],XRANGE=[min(xvalues),max(xvalues)], YRANGE=[min(yvalues),max(yvalues)]
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, ct
;LOADCT,0
tvimage,img, /Overplot,nointerpolation=nointerp
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
LOADCT,ct
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,CHARSIZE=1.3,$
POSITION=[0.92, 0.1, 0.94, 0.86]

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=1,XTICKFORMAT='(F5.1)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Spatial offset along slit (arcsec)',XRANGE=[min(xvalues),max(xvalues)],ytickv=4
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(xvalues),max(xvalues)],ytickv=4,YTICKFORMAT='(A2)',xcharsize=0
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(xvalues),max(xvalues)],ytickv=4,YTICKFORMAT='(A2)'
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[min(yvalues),max(yvalues)]
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[min(yvalues),max(yvalues)],ytickv=4,YTICKFORMAT='(A2)'
xyouts,0.95,0.90,TEXTOIDL('Flux'),/NORMAL,color=fsc_color('black'),charsize=2.0
;xyouts,0.25,0.75,'Pos'+strcompress(STRING(FIX(pos)))+', '+number_formatter(cumoffsetx_plot*0.085,decimals=2)+' '+direction+' '+TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=8

END