PRO ZE_IRC10420_CREATE_INTENSITYIMAGE_EPS,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector

ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData

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
lambda_val_str=strcompress(string(lambda_val*10., format='(I10)'))

circ_griddedData=alog10(circ_griddedData)

a=min(circ_griddedData,/NAN)
;a=-7.0
;a=alog10(a)
b=max(circ_griddedData,/NAN)
;b=24.0
;print,a,b
img=bytscl(circ_griddedData,MIN=a,MAX=b)
print,'TESTE',a,b
;i;mg=bytscl(circ_griddedData,MAX=max(circ_griddedData))
;MWRFITS, img,'/Users/jgroh/temp/intens_124.fits',/ISCALE, /CREATE
!P.Background = fsc_color('white')
LOADCT,0
xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
;;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize
LOADCT,13
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
;pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize)
wdelete,!d.window

xsize=900
ysize=760

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/img_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_'+lambda_val_str+'.eps',encapsulated=1,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches

   LOADCT, 0
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
title='Image at velocity '+vel_str+' km/s, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Image at wavelength '+lambda_str+' Angstrom, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, circxvector, circyvector, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[max(circxvector),-max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.22, 0.17, 0.82,  0.77*xsize/ysize], title=title
LOADCT, 13
tvimage,pic2, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
nd=2
;colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
;number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar_ticknames_str=['0.0','0.2', '0.4', '0.6', '0.8', '1.0']
LOADCT,13
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.85, 0.17, 0.87, 0.77*xsize/ysize],YCHARSIZE=1.,XCHARSIZE=1.
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=xc
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=yc,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]
;draws grid lines through 0,0
PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

device,/close
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
set_plot,'x'

END