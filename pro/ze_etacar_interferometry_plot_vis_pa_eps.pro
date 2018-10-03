PRO ZE_ETACAR_INTERFEROMETRY_PLOT_VIS_PA_EPS,imgname,pa1,vis1,pa2,vis2,errorvis1,model2d,sufix

;plotting to PS file
aa=700
bb=700
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/'+imgname+'.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 25.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

c1=fsc_color('black')
c2=fsc_color('red')
plot, pa1, vis1, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F5.2)',XTICKFORMAT='(I)', $
;yrange=[0.62,0.74],$
yrange=[0.54,0.77],$ ;used in the letter
;yrange=[0.24,0.97],$
;yrange=[MIN(vis1)*1.05,MAX(vis1)*(1.05)],$
xrange=[36,139],xstyle=1,ystyle=1, xtitle='PA (degrees East of North)', $
ytitle='Visibility', /NODATA, Position=[0.24, 0.24, 0.96, 0.96], title=title
plots,pa1,vis1,color=c1,noclip=0,linestyle=0
oploterror,pa1,vis1,errorvis1,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('dark grey'),symsize=2
plots,pa1,vis1,color=c1,noclip=0,linestyle=0
plots,pa2,vis2,color=c2,noclip=0,linestyle=2,thick=25
xyouts,0.85,0.85,'d)',/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12

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
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
END