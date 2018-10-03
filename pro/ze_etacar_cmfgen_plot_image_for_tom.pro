PRO ZE_READ_OBS_DELTA_TXT,file,rstar,np=np,ndelta1=ndelta1,nos=nos,p=p,delta1_vec=delta1_vec,obs_freq=obs_freq,ipdelta=ipdelta,lambda=lambda
C=299792000.
;OK, OBS_DELTA do not contain I(p,delta), contain the flux I(p,delta) * p^2 ! One has to read the new file IP_DELTA_DATA
openu,1,file
;reading header of the file, containing NP, NDELTA1, NOS , respectively
np=1. & ndelta1=np & nos=np
readf,1,np,ndelta1,nos
print,np,ndelta1,nos
nporig=np-1
np=np-5    ;selecting maximum value of p ( 21 FOR ETA CAR, DO NOT CHANGE!)
nlines=1.+nporig+1+nos+ndelta1+(np*nos*ndelta1)
print,nlines
data=DBLARR(1, nlines)
p=dblarr(nporig)
delta1_vec=dblarr(ndelta1)
obs_freq=dblarr(nos)
ipdelta=dblarr(np*nos*ndelta1)
for i=0.,nporig-1 do begin
readf,1,p1
p[i]=p1/rstar ;working for ETA Car , do not change
;p[i]=alog10(p1/rstar +1e-6) ;in rstar for model 389
endfor
readf,1,scratchp; reading last value of p, which per definition has i(p)=0. therefore there's no ip output for this value
for i=0.,ndelta1-1 do begin
readf,1,delta1_vec1
delta1_vec[i]=delta1_vec1
endfor
for i=0.,nos-1 do begin
readf,1,obs_freq1
obs_freq[i]=obs_freq1
endfor
for i=0.,(np*nos*ndelta1)-1 do begin
readf,1,ipdelta1
ipdelta[i]=ipdelta1
endfor

;;if we want I(p,delta) * p....see coment above
;j=0.
;k=1.
;for i=0.,(np*nos*ndelta1)-1 do begin
;readf,1,ipdelta1
;ipdelta[i]=ipdelta1*p[j]
;if i ge (nos*ndelta1*k) then begin
;j=j+1.
;k=k+1.
;endif
;endfor

close,1

lambda=C/obs_freq*1E-05

END
;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_WRITE_IPDATA_TXT,data_bin,file_txt
OPENW,2,file_txt
PRINTF,2,data_bin
CLOSE,2
END
;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_CREATE_POLARCOORD_XY_VECTOR,rstar,pa,np,ndelta1,p,delta1_vec,polarcoord=polarcoord,x=x,y=y

;creating matrix of size (2,np*ndelta1) to store the pairs of (NP,DELTA1_VEC) for further conversion to x,y
polarcoord=dblarr(2,np*ndelta1)

;counters
l=0
r=1
m=0
s=1

;changing slightly the value 2pi of the last delta1_vec point in order to avoid duplicated points; might not be necessary.
;commenting line below for AG CAR; do not comment for Eta Car
delta1_vec[ndelta1-1]=6.29

;converting PA to radians
pa_rad=pa*!PI/180.

;computing the vector of polar coordinates. It is compatible with the OBS_DELTA_IP_DATA output from 2D MODELS, doing OK!
for j=0., (np*ndelta1-1) do begin ;running through all the lines of the matrix
  if j ge (ndelta1*r) then begin
    l=l+1
    r=r+1
  endif
  polarcoord(0,j)=delta1_vec[m]+pa_rad    ;positions polarcoord(0,*)=values of beta, working!!! now including an arbitrary PA    
  polarcoord(1,j)=p[l]         ;positions polarcoord(1,*)=values of p, working!!!
  m=m+1
  if m gt (ndelta1-1) then begin
    m=0
  endif
endfor

;getting x,y coordinates, where 0,0 is center the center of the star.
rect_coord = CV_COORD(From_Polar=polarcoord, /To_Rect)
x=rect_coord(0,*)
y=rect_coord(1,*)
END
;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData

;create a monocromatic vector of intensities (i.e. for one frequency from the OBS_DELTA vector) for a given lambda_val
intens2d_lambda=DBLARR(np*ndelta1)

near = Min(Abs(lambda - lambda_val), index)

for i=0.,(np*ndelta1)-1. do begin
intens2d_lambda[i]=ipdelta[index]
index=index+nos
endfor

;for each lambda, normalize the intensity by the maximum value for that particular lambda?
;comment line below and screw up the computation of the spectrum; if normalizing does not work! JGH 2009 April 13 10pm
;intens2d_lambda=intens2d_lambda/max(intens2d_lambda)

;for each lambda, normalize the intensity by the maximum value overall?
;intens2d_lambda=intens2d_lambda/max(ipdelta)

;trying to correct for AG CAr (March 2 2009)
GRID_INPUT,x,y,intens2d_lambda,xsorted,ysorted,intens2d_lambdasorted
x2=xsorted
y2=ysorted
intens2d_lambda2=intens2d_lambdasorted


;adat

;interpolate the data. One has to use TOLERANCE in order to avoid co-linear points
TRIANGULATE,x2,y2,circtriangles, circboundaryPts,TOLERANCE=1e-10

;changing implementantion of factor to always use the same scale in mas for different models or distances, and thus the same sampling in the visiiblity images
;for irc 10420, visibility computation:circ_GridSpace_mas=0.08.
;factor=0.06 ;best for image;40   ;factor to zoom out of the image              ;BEST for IRC 10420 image is factor=0.06 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
;factor=1.18;                                                      ;BEST for IRC 10420 vis is factor=1.18 for model 15 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
;factor=0.40;                                                      ;BEST for IRC 10420 vis is factor=0.40 for model 19 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
pix=1027.                                                          ; BEST 1027 
mas_to_rstar=(214.08*dist)/(rstar/6.96)
print,circ_GridSpace_mas
circ_gridSpace = [circ_GridSpace_mas[0]*mas_to_rstar,circ_GridSpace_mas[1]*mas_to_rstar] ; space in x and y directions TESTING
factor=circ_GridSpace_mas[0]*mas_to_rstar*(pix-1.)/(2.*max(X2))
print,factor
circ_griddedData = TRIGRID(x2, y2, intens2d_lambda2, circtriangles, circ_gridSpace,[MIN(x2)*factor, MIN(y2)*factor, MAX(x2)*factor, max(y2)*factor], XGrid=circxvector, YGrid=circyvector); WOKRING
;print,'Grid spacing in rstar',circ_gridSpace  ;grid spacing in rstar
;circ_gridSpace_meter=circ_gridSpace*(rstar*1e8)
;print,'Grid spacing in meters',circ_gridSpace_meter  ;grid spacing in meters
pixcut=0 ; number of pixels cut from each side, i.e. total nubmer of removed pixels is equal to pixcut*2. 
circ_griddedData=circ_griddedData[pixcut:(pix-1-pixcut),pixcut:(pix-1-pixcut)]
circxvector=circxvector[pixcut:(pix-1-pixcut)]
circyvector=circyvector[pixcut:(pix-1-pixcut)]

;gauss = PSF_GAUSSIAN( Npixel=1027, FWHM=[30,30], CENTROID=[603,480],/NORMAL,/DOUBLE )
;gauss=gauss/max(gauss)

circ_griddedData=ROT(circ_griddedData,pa,/INTERP)
;circ_griddedData=circ_griddedData-gauss
;t=where(circ_griddedData lt 0)
;circ_griddedData[t]=0

;circ_griddedData[0:1000,200:512]=0.

;best fit for model 15a for scal0.06
;circ_griddedData[0:1000,000:495]=0.

;best fit for model 19a for scal0.06
;circ_griddedData[0:1000,000:485]=0.

;best fit for model 15a for scale=1.18
;circ_griddedData[0:1000,000:512]=0.

;testing
;circ_griddedData[0:1000,000:509]=0.

;best fit for model 19a for scale0.40
;circ_griddedData[0:1000,000:509]=0.


;best fit for model 19b for scale0.40
;circ_griddedData[0:1000,513:1000]=0.


circ_griddedData=ROT(circ_griddedData,-(pa),/INTERP)
;best fit for model 17a
;circ_griddedData[0:1000,0:485]=0.
;circ_griddedData=0

;for PA=60
;circ_griddedData[530:1000,530:1000]=0.
;circ_griddedData[512:1000,0:490]=0.

;convert circgridxvector and circgridyvector from alog10(p/rstar 1e-6) back to linear coordinates in rstar?
;circxvector=(10^(circxvector)-(1e-6))*rstar
;circyvector=(10^(circyvector)-(1e-6))*rstar

;convert circgridxvector and circgridyvector from rstar back to linear coordinates, i.e. Rsun?
;circxvector=circxvector*rstar/6.96
;circyvector=circyvector*rstar/6.96

;convert circgridxvector and circgridyvector from rstar to mas? NOTE THAT PREVIOUS 2 LINES SHOULD BE COMMENTED!!!!
circxvector=circxvector*(rstar/6.96)/(214.08*dist)
circyvector=circyvector*(rstar/6.96)/(214.08*dist)
;circ_GridSpace_mas=[circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]]
;print,'Grid spacing in mas',circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]

END
;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda,$
circxvector,circyvector,circ_griddedData,imginv=imginv,VEL=vel

near = Min(Abs(lambda - lambda_val), index)

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


;circ_griddedDAta=alog10(circ_griddedData)
a=min(circ_griddedData,/NAN)
b=max(circ_griddedData,/NAN)
img=bytscl(circ_griddedData,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
;img=bytscl(circ_griddedData,MAX=1.0); byte scaling the image for display purposes with tvimage
;log
;img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img

;plotting in window
xsize=900
ysize=760
window,8,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
;GETCOLOR is not working anymore...
;colors = GetColor(/Load) 
;!P.Background = colors.white
;!P.Color = colors.black
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF KEYWORD_SET(vel) THEN BEGIN
title='Image at velocity '+vel_str+' km s!E-1!N, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Image at wavelength '+lambda_str+' Angstrom, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[max(circxvector),-max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]
;draws grid lines through 0,0
PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

END
;--------------------------------------------------------------------------------------------------------------------------;--------------------------------------------------------------------------------------------------------------------------
PRO ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA_VPAPER,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda,$
circxvector,circyvector,circ_griddedData,imginv=imginv,VEL=vel
;optimized for multi-panel EPS plots, Figs. 8 and 9 from Driebe  et al. 2009

!P.THICK=9
!X.THiCK=9
!Y.THICK=9
!P.CHARTHICK=1.5
!P.FONT=-1
!P.CHARSIZE=2.5

near = Min(Abs(lambda - lambda_val), index)

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

img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;img=bytscl(circ_griddedData,MAX=1.0); byte scaling the image for display purposes with tvimage
;log
;img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img

;plotting in window
xsize=900
ysize=760
window,8,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF KEYWORD_SET(vel) THEN BEGIN
title='Image at velocity '+vel_str+' km s!E-1!N, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Image at wavelength '+lambda_str+' Angstrom, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[max(circxvector),-max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
nd=2
colorbar_ticknames_str = [number_formatter(0.00,decimals=nd), number_formatter(max(circ_griddedData)*.2,decimals=nd), number_formatter(max(circ_griddedData)*.4,decimals=nd),$
number_formatter(max(circ_griddedData)*.6,decimals=nd), number_formatter(max(circ_griddedData)*.8,decimals=nd),number_formatter(max(circ_griddedData),decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize],CHARSIZE=1.
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]
;draws grid lines through 0,0
PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

END
;--------------------------------------------------------------------------------------------------------------------------;--------------------------------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------------------------------
;for Groh et al. cavity full paper ; based on ze_read_obs_delta_ip_etacar_v2.pro, but not doing interferometry; more interested in I(p, delta) images and spectrum
$MAIN CODE

CLOSE,/ALL
Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
filename_ipdata_txt_write='/Users/jgroh/temp/teste_IP.txt'
dir='/Users/jgroh/ze_models/2D_models/etacar/'
model='mod111_john'

;model2d='cut_v4'
;sufix='m13'
;model2d='tilted_owocki'
;sufix='55_60_halpha'
;model2d='tilted_owocki_grid2'
;sufix='99_45_noscale'
sufix=''
model2d='4314'
filename_ipdata_txt=dir+model+'/'+model2d+'/'+sufix+'/IP_DELTA_DATA'             ;correct IP_DELTA
;screwing up to compute the spectrum
;filename_ipdata_txt=dir+model+'/OBS_DELTA_IP_DATA'             ;has the flux data (i.e. I(p)p^2),useful for computing line profiles
;filename_ipdata_txt='/Users/jgroh/temp/OBS_DELTA_IP_DATA'        ;OBS_DELTA

CASE model2d of

'4314': BEGIN
lambda_ini=4315.
lambda_fin=4317.
lambda_sampling=0.8     ;sampling in Angstrom ; use 1
END

'5506': BEGIN
lambda_ini=5506.
lambda_fin=5516.
lambda_sampling=2.8     ;sampling in Angstrom ; use 1
END

'6737': BEGIN
lambda_ini=6737.
lambda_fin=6748.
lambda_sampling=2.8     ;sampling in Angstrom ; use 1
END

'7936': BEGIN
lambda_ini=7938.
lambda_fin=7959.
lambda_sampling=5.8     ;sampling in Angstrom ; use 1
END

'12617': BEGIN
lambda_ini=12620.
lambda_fin=12680.
lambda_sampling=10.8     ;sampling in Angstrom ; use 1
END

'16569': BEGIN
lambda_ini=16570.
lambda_fin=16620.
lambda_sampling=7.8     ;sampling in Angstrom ; use 1
END

'21029': BEGIN
lambda_ini=21040.
lambda_fin=21060.
lambda_sampling=4.8     ;sampling in Angstrom ; use 1
END
'35556': BEGIN
lambda_ini=35560.
lambda_fin=35610.
lambda_sampling=5.8     ;sampling in Angstrom ; use 1
END
ENDCASE





rstar=417. ; in CMFGEN UNITS
;rstar=1500.4
;rstar=785.
factor_scale_b=1.33
factor_scale_c=1.22
factor_scale_d=1.3
factor_scale_h=1.0
dist=2.30*factor_scale_h ;in kpc
dstr=strcompress(string(dist*10., format='(I03)'))
ZE_READ_OBS_DELTA_TXT,filename_ipdata_txt,rstar,np=np,ndelta1=ndelta1,nos=nos,p=p,delta1_vec=delta1_vec,obs_freq=obs_freq,ipdelta=ipdelta,lambda=lambda
print,delta1_vec
;ZE_WRITE_IPDATA_TXT,ipdata_txt,filename_ipdata_txt_write
pa=130.          ;position angle in degrees; by definition PA=0 towards N, and increase eastwards. USE PA significantly different than 0 (e.g.50) for spherical models
;pa=220.
;pa=0.
pa_str=strcompress(string(pa, format='(I03)'))

;grep inclination angle info from OBS_INP
spawn,'grep ANG1 '+dir+model+'/'+model2d+'/'+sufix+'/OBS_INP' ,result,/sh
inc_str=strcompress(string(result, format='(I02)'))



;;lambda_val=20582.0     ; wavelength in Angstroms
;;lambda0=20586.9    ;He I    ; VACUUM wavelength of the line transition of interest
;lambda0=21661.2    ; Br gamma
;;lambda0=4314.
;lambda0=6562.8
;;lambda_ini=4315.   ;initial lambda to do calculations 21610
;;lambda_fin=21685    ;initial lambda to do calculations 21720
;;lambda_ini=21610.   ;initial lambda to do calculations 21610
;;lambda_fin=21640.    ;initial lambda to do calculations 21720
;;lambda_ini=21040.
;
;lambda_ini=21510   ;initial lambda to do calculations 21610
;lambda_fin=21520.
;lambda_sampling=2.6     ;sampling in Angstrom ; use 1
;
;lambda_ini=6547.   ;initial lambda to do calculations 21610
;lambda_fin=6578.
;lambda_sampling=5.6     ;sampling in Angstrom ; use 1



nlambda= (lambda_fin-lambda_ini)/lambda_sampling         ;number of wavelengths to compute IMAGE, VIS, PHASE

ZE_CREATE_POLARCOORD_XY_VECTOR,rstar,pa,np,ndelta1,p,delta1_vec,polarcoord=polarcoord,x=x,y=y

!P.THICK=3
!X.THiCK=3
!Y.THICK=3
!P.CHARTHICK=1.5
!P.FONT=-1

lambda_vector=dblarr(nlambda)
totalflux=dblarr(1027,nlambda)

;first loop computes the high spatial resolution images and the spectrum; cannot be used for computing visibilities and phases. 
;circ_GridSpace_mas=[0.035,0.035];used for all Eta Car images before
circ_GridSpace_mas=[0.013,0.013];best
;circ_GridSpace_mas=[0.035*1.4,0.035*1.4];teset

for i=0., nlambda-1 do begin
lambda_val=lambda_ini + i*lambda_sampling
lambda_vector[i]=lambda_val
ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData
;ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda, circxvector,circyvector,circ_griddedData,imginv=imginv,/VEL
; for j=0, 1026. do totalflux[j,i]=int_tabulated(circxvector*(6.96*214.08*dist),circ_griddedData[j,*],/DOUBLE) ;using circxvector in 10^10cm
 print,'Finished IMG for lambda:  ', lambda_val
endfor

;compute flux spectrum from Ip values WORKING! DO NOT MULTIPLY BY P, since  we are doing the integral in P and delta (BH05 eq 12), F=1/d^2 *Int(0,2pi)Int(0,pmax)I(p,delta)dp ddelta
;first we do the integral in x inside the for LOOP above, and the the integral in y with the for loop below; units are Jy, and probably accurate within 1 %.
totalfluxfim=dblarr(nlambda)
for i=0, nlambda-1 do totalfluxfim[i]=int_tabulated(circyvector*(6.96*214.08*dist),totalflux[*,i],/DOUBLE) ;;using circxvector in 10^10cm      /(3.08568025E+21)^2.
vel_vector=ZE_LAMBDA_TO_VEL(lambda_vector,lambda0)
print,'Finished SPEC'

vsys=-8.0
resolving_power=10000.
res=lambda_val/resolving_power
;
;;shifting the model spectrum by the systemic velocity
totalfluxfimsys=ZE_SHIfT_SPECTRA_VEL(lambda_vector,totalfluxfim,vsys)
ZE_SPEC_CNVL,lambda_vector,totalfluxfimsys,res,lambda_val,fluxcnvl=totalfluxfimsys_cnvl
line_norm,lambda_vector,totalfluxfimsys_cnvl,totalfluxfimsysn

xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y

set_plot,'ps'
device,filename='/Users/jgroh/temp/spec_wavelength'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,totalfluxfimsysn,yrange=[0,max(totalfluxfimsysn)*1.03],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='F/Fc',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.09, 0.85, 0.78*xwindowsize/ywindowsize]
plots,lambda_vector,totalfluxfimsysn,noclip=0,color=FSC_COLOR('red'),linestyle=2
;plots,lobs,fobsheln,color=FSC_COLOR('black'),noclip=0
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]

device,/close

set_plot,'x'
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

;write figure latex code
lambda_ini_str=strcompress(string(lambda_ini*10., format='(I06)'))
lambda_fin_str=strcompress(string(lambda_fin*10., format='(I06)'))
file='/Users/jgroh/temp/latex_figure_img_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_'+lambda_ini_str+'_'+lambda_fin_str+'.tex'
caption=model+'\_'+model2d+'\_'+sufix+'\_d'+dstr+'\_'+lambda_ini_str+'\_'+lambda_fin_str
close,1
openw,1,file  
printf,1,'\documentclass[12pt]{article}'
printf,1,'\usepackage{geometry,epsfig} % see geometry.pdf on how to lay out the page. Theres lots.'
printf,1,'\geometry{a4paper} % or letter or a5paper or ... etc'
printf,1,'% \geometry{landscape} % rotated page geometry'

printf,1,'% See the ``Article customise'' template for come common customisations'

printf,1,'\title{Eta Car cavity models}'
printf,1,'\author{Jose Groh}'
printf,1,'%\date{} % delete this line to display the current date
printf,1,'\begin{document}'
printf,1,' \begin{verbatim} Model '+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_'+lambda_ini_str+'_'+lambda_fin_str+' \end{verbatim}'
printf,1,'\begin{figure}'
ncol=3
nrow=6
j=1

for lambda_val=lambda_ini, lambda_fin, lambda_sampling DO BEGIN
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))
ZE_IRC10420_CREATE_INTENSITYIMAGE_EPS,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector
IF j mod ncol eq 0 THEN BEGIN 
  PRINTF,1,'\resizebox{0.325\columnwidth}{!}{\includegraphics{/Users/jgroh/temp/img_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_'+lambda_val_str+'.eps}}\\'
ENDIF ELSE BEGIN
  PRINTF,1,'\resizebox{0.325\columnwidth}{!}{\includegraphics{/Users/jgroh/temp/img_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_'+lambda_val_str+'.eps}}' 
ENDELSE
IF j mod (nrow*ncol) eq 0 THEN BEGIN 
    printf,1,'\end{figure}'
    printf,1,'\begin{figure}'
ENDIF 

j=j+1
endfor

printf,1,'\end{figure}'
printf,1,'\end{document}'
close,1

set_plot,'x'

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT,13

!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0


;undefine,img,imginv,pic2,visamp,phase,image,ipdelta,intens2d_lambda
;undefine,circ_GriddedData,real,lmod17,fmod17,lmod15,fmod15,fmod15sys,fmod17sys
;save,/variables,FILENAME='/Users/jgroh/espectros/irc10420/irc10420_2d_variables_'+model+model2d+sufix+'_d'+dstr+'pa'+pa_str+'.sav'   
;save,lobs,fobsheln,lambda_vector,vel_vector,totalfluxfimsysn,FILENAME='/Users/jgroh/espectros/irc10420/irc10420_variables_spec_'+model+model2d+sufix+'_d'+dstr+'.sav'
END