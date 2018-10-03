PRO ZE_PLOT_IMAGE_GEN_omega_inc_EPS,label,values,img,a,b,c,imgname,circxvector,circyvector,aa,bb,title,quantity_str,VEL=vel,INV=inv,CONT=cont
title=''
set_plot,'x'

;capturing TRUE COLOR image of the 2D spectrum to pic2
window,retain=2,xsize=aa,ysize=bb
LOADCT,c,/SILENT
IF KEYWORD_SET(INV) THEN img=255B-img
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
wdelete,!d.window

;plotting to PS file

ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/'+imgname+'.eps'
print,ps_filename
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')



inc_str=''
pa_str=''
vel_Str=''
lambda_str=''

plot, circxvector, circyvector,YTICKFORMAT='(I)',XTICKFORMAT='(F4.2)', $
xrange=[min(circxvector),max(circxvector)], $
yrange=[max(circyvector),min(circyvector)],xstyle=1,ystyle=1, xtitle='W=vrot/vcrit', $
ytitle='i (degrees)', /NODATA, Position=[0.20, 0.24, 0.95, 0.96], title=title,charsize=2.7,ycharsize=1.3,xcharsize=1.3,xtickinterval=0.05
LOADCT, c,/SILENT
tvimage,pic2, /Overplot

;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
;colorbar_ticknames_str = [number_formatter(0.00,decimals=nd), number_formatter(max(circ_griddedData)*.2,decimals=nd), number_formatter(max(circ_griddedData)*.4,decimals=nd),$
;number_formatter(max(circ_griddedData)*.6,decimals=nd), number_formatter(max(circ_griddedData)*.8,decimals=nd),number_formatter(max(circ_griddedData),decimals=nd)]
LOADCT,c,/SILENT
IF KEYWORD_SET(INV) THEN inv_val=1 ELSE inv_val=0
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, CHARSIZE=1.5,  /RIGHT,INVERTCOLORS=inv_val,$
POSITION=[0.20, 0.04, 0.95, 0.07]
LOADCT,0,/SILENT
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='',XRANGE=[min(circxvector),max(circxvector)],xcharsize=2.,xtickinterval=0.05
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('black'),XRANGE=[min(circxvector),max(circxvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('black'),YRANGE=[max(circyvector),min(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('black'),YRANGE=[max(circyvector),min(circyvector)],xtickinterval=0.05
IF KEYWORD_SET(CONT) THEN CONTOUR,values,circxvector, circyvector,LEVELS=[2.0],C_CHARTHICK=2,C_CHARSIZE=3,C_COLOR=[fsc_color('white')],C_THICK=8.,/CLOSED,/OVERPLOT,xrange=[min(circxvector),max(circxvector)], $
yrange=[max(circyvector),min(circyvector)],xstyle=1,ystyle=1
;draws grid lines through 0,y
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')
;xyouts,0.95,0.90,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')
;xyouts,0.25,0.75,'Pos'+strcompress(STRING(FIX(pos)))+', '+number_formatter(cumoffsetx_plot*0.085,decimals=2)+' '+direction+' '+TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=8
xyouts,0.85,0.85,label,/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=12

CASE quantity_str OF

'reff': BEGIN
xyouts,0.045,0.07,TEXTOIDL('Reff'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
xyouts,0.015,0.015,TEXTOIDL('[Rsun]'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
        END

'teff': BEGIN
xyouts,0.045,0.07,TEXTOIDL('Teff'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
xyouts,0.015,0.015,TEXTOIDL('[K]'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
        END
        
'tstar': BEGIN
xyouts,0.045,0.07,TEXTOIDL('Tstar'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
xyouts,0.015,0.015,TEXTOIDL('[K]'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
        END      
ENDCASE



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