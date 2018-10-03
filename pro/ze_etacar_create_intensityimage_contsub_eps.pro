PRO ZE_ETACAR_CREATE_INTENSITYIMAGE_CONTSUB_EPS,circ_griddedData_cont,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector,PIP=PIP,sqrt=sqrt,norm=norm


ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA_CONTSUB_V1,circ_griddedData_cont,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData,PIP=PIP

!X.THICK=15
!Y.THICK=15
!P.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=8
!Y.OMARGIN=[8,4]
!P.FONT=-1
;!P.CHARSIZE=3.5
;!X.CHARSIZE=3.5
;!Y.CHARSIZE=3.5

;convert lambda float to a string
ndlambda=1.
lambda_str=number_formatter(lambda_val,decimals=ndlambda)
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))

;circ_griddedData=alog10(circ_griddedData)

If KEYWORD_SET(SQRT) THEN circ_griddedData=SQRT(circ_griddedData)

a=min(circ_griddedData,/NAN)
a=0
;a=-7.0
;a=alog10(a)
b=max(circ_griddedData,/NAN)
b=1.66e-4
;b=24.0
;print,a,b
img=bytscl(circ_griddedData,MIN=a,MAX=b)
print,'TESTE',a,b
;i;mg=bytscl(circ_griddedData,MAX=max(circ_griddedData))
;MWRFITS, img,'/Users/jgroh/temp/intens_124.fits',/ISCALE, /CREATE
!P.Background = fsc_color('white')
LOADCT,0
xwindowsize=700.*1  ;window size in x
ywindowsize=700.*1  ; window size in y

;;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize ;original, working fine

LOADCT,13,/SILENT
tvimage,img,POSITION=[0,0,0.95,0.95]
;pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
wdelete,!d.window

xsize=700
ysize=700

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/img_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_'+lambda_val_str+'.eps',encapsulated=1,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches


!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
!Y.OMARGIN=[8,4]
ticklen = 15.
!x.ticklen = ticklen/ywindowsize
!y.ticklen = ticklen/xwindowsize
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

;print,lambda_val
near = Min(Abs(lambda - lambda_val), index)
;print,index
pa_str=strcompress(string(pa, format='(I03)'))

;use velocity labelling?
plot_vel=1.
;plot_vel=0.
;convert lambda_val to velocity and then to a string
IF plot_vel eq 1 THEN BEGIN
  ndvel=0.
  vel_val=ZE_LAMBDA_TO_VEL(lambda[index],lambda0)
  print,lambda[index],vel_val
  vel_val=FIX(vel_val)
  vel_str=number_formatter(vel_val,decimals=ndvel) 
 ; vel_str=strcompress(string(vel_val, format='(I03)'))
  print,vel_str
ENDIF
   
   
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF plot_vel eq 1 THEN BEGIN
title='Image at v ='+vel_str+' km/s, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Image at wavelength '+lambda_str+' Angstrom, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

if MAx(circxvector) LT 10.0 THEN format='(F8.1)' ELSE format='(I)'

plot, circxvector, circyvector, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT=format,XTICKFORMAT=format, $
xrange=[max(circxvector),-max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.24, 0.24, 0.96, 0.96];, title=title
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!

a=a/b
b=b/b
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar_ticknames_str=['0.0','0.2', '0.4', '0.6', '0.8', '1.0']
LOADCT,13,/SILENT
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, CHARSIZE=1.5,$
POSITION=[0.24, 0.04, 0.96, 0.07]
LOADCT, 13,/SILENT
tvimage,pic2, /Overplot

LOADCT,0,/SILENT
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=xc
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=yc,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

;xyouts,0.85,0.85,'c)',/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=12
xyouts,0.08,0.9687,title,/NORMAL,charsize=2.8,color=fsc_color('black')
xyouts,0.08,0.035,TEXTOIDL('I/I_{max}'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12


device,/close
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
set_plot,'x'


END