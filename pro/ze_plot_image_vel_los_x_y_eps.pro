PRO ZE_PLOT_IMAGE_VEL_LOS_X_Y_EPS,img,a,b,imgname,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda,$
circxvector,circyvector,aa,bb,title,VEL=vel,ct

if n_elements(ct) LT 1 THEN ct=5
;PRO ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_EPS,img,a,b,imgname,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0

set_plot,'x'

;capturing TRUE COLOR image of the 2D spectrum to pic2
window,retain=2,xsize=aa,ysize=bb
LOADCT,ct
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
wdelete,!d.window

;plotting to PS file

ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/'+imgname+'.eps'
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


;convert PA float to a string
pa_str=strcompress(string(pa, format='(I02)'))

;convert lambda float to a string
ndlambda=1.
lambda_str=number_formatter(lambda_val,decimals=ndlambda)

;convert lambda_val to velocity and then to a string
IF KEYWORD_SET(vel) THEN BEGIN
  ndvel=0.
  vel_val=ZE_LAMBDA_TO_VEL(lambda[index],lambda0)
  vel_str=number_formatter(vel_val,decimals=ndvel) 
ENDIF

inc_str=''
pa_str=''
vel_Str=''
lambda_str=''

;circxvector=circxvector/1000.
;circyvector=circyvector/1000.

plot, circxvector, circyvector,YTICKFORMAT='(I)',XTICKFORMAT='(I)', $
xrange=[-max(circxvector),max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='X ['+TEXTOIDL('AU')+']', $
ytitle='Z ['+TEXTOIDL('AU')+']', /NODATA, Position=[0.23, 0.24, 0.95, 0.96], title=title,charsize=2.7,ycharsize=1.4,xcharsize=1.4

LOADCT, ct
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
LOADCT,ct
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, CHARSIZE=1.5,  /RIGHT,$
POSITION=[0.26, 0.04, 0.95, 0.07]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')
;xyouts,0.95,0.90,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')
;xyouts,0.85,0.85,'a)',/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=12

;xyouts,0.03,0.07,TEXTOIDL('log \rho'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
;xyouts,0.015,0.015,TEXTOIDL('[g/cm^3]'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12

xyouts,0.03,0.07,TEXTOIDL('v los'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12
xyouts,0.015,0.015,TEXTOIDL('[km/s]'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12

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