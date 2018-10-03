PRO ZE_ETACAR_CREATE_INTENSITYIMAGE_EPS_V3,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector,log=log,vel=vel
;v3 uses a non-normalized colorbar, wiht I values given in erg/s/cm^2/sr


ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData

;convert lambda float to a string
ndlambda=1.
lambda_str=number_formatter(lambda_val,decimals=ndlambda)
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))

pa_str=strcompress(string(pa, format='(I03)'))
omega_Str=strmid(sufix,0,2)
;convert to w
w_str=number_formatter(SQRT(float(omega_str)/100.0),decimals=2)

IF KEYWORD_SET(log) THEN temp=alog10(circ_griddedData) ELSE temp=circ_griddedData
;print,omega_str
a=min(temp,/NAN)
;a=-7.0
;a=alog10(a)
b=max(temp,/NAN)
;b=24.0


;using fixed a,b to properly compare cavity and 1d models
;for 5506
;a=1.4467646e-07   
;b=0.00012977057

;for 21029
;a= 1.2109923e-07  
;b= 3.1908905e-05

;for 1384
;a=1.6155140e-07  
;b= 0.00014398566

print,'a, b, ', a,b
img=bytscl(temp,MIN=a,MAX=b)

;i;mg=bytscl(circ_griddedData,MAX=max(circ_griddedData))
;MWRFITS, img,'/Users/jgroh/temp/intens_124.fits',/ISCALE, /CREATE
!P.Background = fsc_color('white')
LOADCT,0,/SILENT

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

device,filename='/Users/jgroh/temp/img_etc_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_'+'_PA'+pa_str+'_i'+inc_str+'_'+lambda_val_str+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches

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


;use velocity labelling?
plot_vel=1.
;plot_vel=0.
;convert lambda_val to velocity and then to a string
IF plot_vel eq 1 THEN BEGIN
  ndvel=0.
  vel_val=ZE_LAMBDA_TO_VEL(lambda[index],lambda0)
 ; print,lambda[index],vel_val
  vel_val=FIX(vel_val)
  vel_str=number_formatter(vel_val,decimals=ndvel) 
 ; vel_str=strcompress(string(vel_val, format='(I03)'))
 ; print,vel_str
ENDIF
   
   
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

title=''


plot, circxvector, circyvector, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[max(circxvector),-max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.24, 0.24, 0.96, 0.96], title=title
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!

a=a/1e-4
b=b/1e-4
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
;colorbar_ticknames_str=['0.0','0.2', '0.4', '0.6', '0.8', '1.0']
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
xyouts,0.08,0.970,'1384 Angs image, '+TEXTOIDL('W=')+w_str+', i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo ',/NORMAL,charsize=3.0,color=fsc_color('black')
;xyouts,0.85,0.85,'c)',/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=12

xyouts,0.08,0.035,TEXTOIDL('I/I_{max}'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12

device,/close
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
set_plot,'x'

END