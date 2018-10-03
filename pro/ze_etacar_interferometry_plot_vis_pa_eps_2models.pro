PRO ZE_ETACAR_INTERFEROMETRY_PLOT_VIS_PA_EPS_2MODELS,imgname,pa1,vis1,pa2,vis2,model2d,sufix,pa3,vis3,model2d3,sufix3

;plotting to PS file
aa=900
bb=760
ps_ysize=5.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/'+imgname+'.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=8
!X.THICK=8
!Y.THICK=8
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=8
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
c3=fsc_color('blue')
plot, pa1, vis1,YTICKFORMAT='(F5.2)',XTICKFORMAT='(I)', $
;yrange=[0.62,0.74],$
yrange=[0.58,0.74],$
xrange=[40,130],xstyle=1,ystyle=1, xtitle='PA (degrees East of North)', $
ytitle='Visibility at 24 m', /NODATA, Position=[0.24, 0.24, 0.94, 0.96], title=title
plots,pa1,vis1,color=c1,noclip=0
plots,pa2,vis2,color=c2,noclip=0,linestyle=2
plots,pa3,vis3,color=c3,noclip=0,linestyle=3

;draws axes, white tick marks
;AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
;AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('black'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('black'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
;AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('black'),YRANGE=[-max(circyvector),max(circyvector)]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')
;xyouts,0.95,0.90,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')
;xyouts,0.25,0.75,'Pos'+strcompress(STRING(FIX(pos)))+', '+number_formatter(cumoffsetx_plot*0.085,decimals=2)+' '+direction+' '+TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=8



device,/close_file
set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
END