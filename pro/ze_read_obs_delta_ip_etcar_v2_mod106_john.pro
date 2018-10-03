PRO ZE_READ_OBS_DELTA_TXT,file,rstar,np=np,ndelta1=ndelta1,nos=nos,p=p,delta1_vec=delta1_vec,obs_freq=obs_freq,ipdelta=ipdelta,lambda=lambda
C=299792000.
;OK, OBS_DELTA do not contain I(p,delta), contain the flux I(p,delta) * p^2 ! One has to read the new file IP_DELTA_DATA
openu,1,file
;reading header of the file, containing NP, NDELTA1, NOS , respectively
np=1. & ndelta1=np & nos=np
readf,1,np,ndelta1,nos
print,np,ndelta1,nos
nporig=np-1
np=np-1    ;selecting maximum value of p ( 26 FOR ETA CAR, DO NOT CHANGE!)
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

;add a gaussian
gauss = PSF_GAUSSIAN( Npixel=pix, FWHM=[7000,7000], CENTROID=[513,513],/NORMAL,/DOUBLE )
;gauss=gauss/max(gauss)
totalflux=dblarr(pix)
;first loop to compute flux spectrum from Ip values WORKING! DO NOT MULTIPLY BY P, since  we are doing the integral in P and delta (BH05 eq 12), F=1/d^2 *Int(0,2pi)Int(0,pmax)I(p,delta)dp ddelta
for j=0, pix-1 do totalflux[j]=int_tabulated(circxvector,circ_griddedData[j,*],/DOUBLE) ;using circxvector in 10^10cm
;compute flux spectrum from Ip values WORKING! DO NOT MULTIPLY BY P, since  we are doing the integral in P and delta (BH05 eq 12), F=1/d^2 *Int(0,2pi)Int(0,pmax)I(p,delta)dp ddelta
;first we do the integral in x inside the for LOOP above, and the the integral in y with the for loop below; units are Jy, and probably accurate within 1 %.
totalfluxfim=0.D0
totalfluxfim=int_tabulated(circyvector,totalflux[*],/DOUBLE) ;;using circxvector in 10^10cm      /(3.08568025E+21)^2.
print,'Finished Wind'
for j=0, pix-1 do totalflux[j]=int_tabulated(circxvector,gauss[j,*],/DOUBLE) ;using circxvector in 10^10cm
;compute flux spectrum from Ip values WORKING! DO NOT MULTIPLY BY P, since  we are doing the integral in P and delta (BH05 eq 12), F=1/d^2 *Int(0,2pi)Int(0,pmax)I(p,delta)dp ddelta
;first we do the integral in x inside the for LOOP above, and the the integral in y with the for loop below; units are Jy, and probably accurate within 1 %.
totalfluxfimgauss=0.D0
totalfluxfimgauss=int_tabulated(circyvector,totalflux[*],/DOUBLE) ;;using circxvector in 10^10cm      /(3.08568025E+21)^2.
print,'Finished gauss'

gauss_frac_wind=0.5 ;;fraction of gauss emission relative to the wind;

print,'Flux CMFGEN wind',totalfluxfim
print,'Flux gauss',totalfluxfimgauss
print,'mult factor', gauss_frac_wind*totalfluxfim/totalfluxfimgauss

;circ_griddedData=gauss
circ_griddedData=ROT(circ_griddedData,pa,/INTERP)
circ_griddedData=circ_griddedData + gauss_frac_wind*totalfluxfim/totalfluxfimgauss*(gauss)
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

PRO ZE_COMPUTE_IMAGE_FFT_I_P_DELTA_LAMBDA,rstar,dist,img,lambda_val,circ_GridSpace_mas,visamp=visamp,real=real,phase=phase,vis_circxvector=vis_circxvector,vis_circyvector=vis_circyvector,xcen=xcen,ycen=ycen

;near = Min(Abs(lambda - lambda_val), index)

nx = (size(img, /dim))[0]
ny = (size(img, /dim))[1]

; if (xcen,ycen) are specified, then shift the image by (-xcen,-ycen) pixels
; to have the pixel (xcen, ycen) at (0,0). This does not have any effect
; on the resulting visibility amplitude image, but it does change phase, 
; real, and imag.

xcen=fix(nx/2. - 0.5)
ycen=fix(ny/2. - 0.5)
  pix_sh = shift(img, -xcen, -ycen)

trans = fft(pix_sh)

; determine shift amount - even -> nx/2 - 1, odd -> (nx-1)/2
xshiftamount = fix(nx/2. - 0.5)
yshiftamount = fix(ny/2. - 0.5)

strans = shift(trans, xshiftamount, yshiftamount)

imag   = imaginary(strans)
real   = real_part(strans)
;print,real

visamp = abs(strans)
phase  = atan(strans, /phase)

;convert phases to degrees?
phase=phase*180./!PI

visamp=visamp/max(visamp)

ftxaxis=FINDGEN(nx)/(nx*0.001*circ_GridSpace_mas[0])
ftyaxis=FINDGEN(ny)/(ny*0.001*circ_GridSpace_mas[1])

;converting the u,v scale to meters; ONLY works if circxvector, circyvector  is in mas!
vis_circxvector=ftxaxis*206265.*lambda_val*1e-10
vis_circyvector=ftyaxis*206265.*lambda_val*1e-10


END
;--------------------------------------------------------------------------------------------------------------------------;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_PLOT_IMAGE_FFT_I_P_DELTA_LAMBDA,base_rect_coord,rstar,dist,img,circxvector,circyvector,pa,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,$
visamp,real,phase,vis_circxvector,vis_circyvector,xcen,ycen,circ_GridSpace_mas,VEL=vel

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

img=bytscl(visamp,MAX=max(visamp)); byte scaling the image for display purposes with tvimage
imginv=img
;plotting in window
xsize=900
ysize=760
window,13,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF KEYWORD_SET(vel) THEN BEGIN
title='Visibility at velocity '+vel_str+' km s!E-1!N, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Visibility at wavelength '+lambda_str+' Angstrom, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, vis_circxvector, vis_circyvector, charsize=2,ycharsize=1,xcharsize=1, YTICKFORMAT='(I)',XTICKFORMAT='(I)', $
xrange=[max(vis_circxvector),-max(vis_circxvector)], $
yrange=[-max(vis_circyvector),max(vis_circyvector)],xstyle=1,ystyle=1, xtitle='u [m]', $
ytitle='v [m]', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13, /SILENT
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0, /SILENT
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector),-max(vis_circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector),-max(vis_circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)]
;draws grid lines through 0,0
PLOTS,[max(vis_circxvector),-max(vis_circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector),max(vis_circyvector)],linestyle=1,color=fsc_color('white')

;Plotting baseline?
PLOTSYM,8,/FILL
for i=0, n_elements(base_rect_coord)/2 - 1 DO BEGIN
;PLOTS,base_rect_coord[0,i],base_rect_coord[1,i],psym=8,symsize=2,COLOR=fsc_color('white')
ENDFOR

;tvlaser,BARPOS='no',FILENAME='/aux/pc20072b/jgroh/temp/output_image_obs_delta_ip_lambda.ps',$
;/NoPrint,XDIM=xsize,YDIM=ysize,/COLORPS,/ENCAP

IF KEYWORD_SET(vel) THEN BEGIN
title='Phase at velocity '+vel_str+' km s!E-1!N, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Phase at wavelength '+lambda_str+' Angstrom, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

;plot phases
img=bytscl(phase,MIN=min(phase),MAX=max(phase)); byte scaling the image for display purposes with tvimage
imginv=img
;plotting in window
xsize=900
ysize=760
window,14,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0, /SILENT
;GETCOLOR is not working anymore...
;colors = GetColor(/Load) 
;!P.Background = colors.white
;!P.Color = colors.black
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, vis_circxvector, vis_circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(I)',XTICKFORMAT='(I)', $
xrange=[max(vis_circxvector),-max(vis_circxvector)], $
yrange=[-max(vis_circyvector),max(vis_circyvector)],xstyle=1,ystyle=1, xtitle='u [m]', $
ytitle='v[m]', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize],title=title
LOADCT, 13, /SILENT
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning

;format colorbarvalues to the maximum and minimum values found?
;colorbar_min=MIN(PHASE)
;colorbar_max=MAX(PHASE)

;format colorbarvalues to the -180 and +180 values found?
colorbar_min=-180.
colorbar_max=180.

colorbar_ticknames_str = [number_formatter(colorbar_min+(colorbar_max-colorbar_min)*0,decimals=2), $
number_formatter(colorbar_min+(colorbar_max-colorbar_min)*.25,decimals=2),$
number_formatter(0.00,decimals=2),$
number_formatter(colorbar_min+(colorbar_max-colorbar_min)*.75,decimals=2),$
number_formatter(colorbar_min+(colorbar_max-colorbar_min)*1.0,decimals=2)]


colorbar, COLOR=fsc_color('black'),DIVISIONS=4,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0, /SILENT
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector),-max(vis_circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector),-max(vis_circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)]
;draws grid lines through 0,0
PLOTS,[-max(vis_circxvector),max(vis_circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector),max(vis_circyvector)],linestyle=1,color=fsc_color('white')

for i=0, n_elements(base_rect_coord)/2 - 1 DO BEGIN
PLOTS,base_rect_coord[0,i],base_rect_coord[1,i],psym=8,symsize=2,COLOR=fsc_color('white')
ENDFOR

;PLOTS,40.1,40.1,psym=8,symsize=2,COLOR=fsc_color('white')
;tvlaser,BARPOS='no',FILENAME='/aux/pc20072b/jgroh/temp/output_image_obs_delta_ip_lambda.ps',$
;/NoPrint,XDIM=xsize,YDIM=ysize,/COLORPS,/ENCAP


END
;--------------------------------------------------------------------------------------------------------------------------;--------------------------------------------------------------------------------------------------------------------------


PRO ZE_PLOT_IMAGE_FFT_I_P_DELTA_LAMBDA_ORIG,base_rect_coord,rstar,dist,img,circxvector,circyvector,pa,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,$
intens2d_lambda=intens2d_lambda,visamp=visamp,real=real,phase=phase,vis_circxvector=vis_circxvector,vis_circyvector=vis_circyvector,xcen=xcen,ycen=ycen,circ_GridSpace_mas=circ_GridSpace_mas,VEL=vel

near = Min(Abs(lambda - lambda_val), index)

;convert PA float to a string
ndpa=0.
pa_str=number_formatter(pa,decimals=ndpa)

;convert lambda float to a string
ndlambda=1.
lambda_str=number_formatter(lambda_val,decimals=ndlambda)

;convert lambda_val to velocity and then to a string
IF KEYWORD_SET(vel) THEN BEGIN
  ndvel=0.
  vel_val=ZE_LAMBDA_TO_VEL(lambda[index],lambda0)
  vel_str=number_formatter(vel_val,decimals=ndvel) 
ENDIF

nx = (size(img, /dim))[0]
ny = (size(img, /dim))[1]

; if (xcen,ycen) are specified, then shift the image by (-xcen,-ycen) pixels
; to have the pixel (xcen, ycen) at (0,0). This does not have any effect
; on the resulting visibility amplitude image, but it does change phase, 
; real, and imag.

xcen=fix(nx/2. - 0.5)
ycen=fix(ny/2. - 0.5)
  pix_sh = shift(img, -xcen, -ycen)
print,xcen,ycen
trans = fft(pix_sh)

; determine shift amount - even -> nx/2 - 1, odd -> (nx-1)/2
xshiftamount = fix(nx/2. - 0.5)
yshiftamount = fix(ny/2. - 0.5)

strans = shift(trans, xshiftamount, yshiftamount)

imag   = imaginary(strans)
real   = real_part(strans)
;print,real

visamp = abs(strans)
phase  = atan(strans, /phase)

;convert phases to degrees?
phase=phase*180./!PI

visamp=visamp/max(visamp)

circ_GridSpace_mas=[circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]]
print,circ_GridSpace_mas
ftxaxis=FINDGEN(nx)/(nx*0.001*circ_GridSpace_mas[0])
ftyaxis=FINDGEN(ny)/(ny*0.001*circ_GridSpace_mas[1])

;converting the u,v scale to meters; ONLY works if circxvector, circyvector  is in mas!
vis_circxvector=ftxaxis*206265.*lambda_val*1e-10
vis_circyvector=ftyaxis*206265.*lambda_val*1e-10

img=bytscl(visamp,MAX=max(visamp)); byte scaling the image for display purposes with tvimage
imginv=img
;plotting in window
xsize=900
ysize=760
window,13,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
;GETCOLOR is not working anymore...
;colors = GetColor(/Load) 
;!P.Background = colors.white
;!P.Color = colors.black
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF KEYWORD_SET(vel) THEN BEGIN
title='Visibility at velocity '+vel_str+' km s!E-1!N, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Visibility at wavelength '+lambda_str+' Angstrom, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, vis_circxvector, vis_circyvector, charsize=2,ycharsize=1,xcharsize=1, YTICKFORMAT='(I)',XTICKFORMAT='(I)', $
xrange=[max(vis_circxvector),-max(vis_circxvector)], $
yrange=[-max(vis_circyvector),max(vis_circyvector)],xstyle=1,ystyle=1, xtitle='u [m]', $
ytitle='v [m]', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
colorbar_ticknames_str = [number_formatter(0.00,decimals=1), number_formatter(max(visamp)*.2,decimals=1),$
number_formatter(max(visamp)*.4,decimals=1),number_formatter(max(visamp)*.6,decimals=1), number_formatter(max(visamp)*.8,decimals=1),$
number_formatter(max(visamp),decimals=1)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector),-max(vis_circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector),-max(vis_circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)]
;draws grid lines through 0,0
PLOTS,[max(vis_circxvector),-max(vis_circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector),max(vis_circyvector)],linestyle=1,color=fsc_color('white')

;;Plotting baseline?
;PLOTSYM,8,/FILL
;for i=0, n_elements(base_rect_coord)/2 - 1 DO BEGIN
;PLOTS,base_rect_coord[0,i],base_rect_coord[1,i],psym=8,symsize=2,COLOR=fsc_color('white')
;ENDFOR

;tvlaser,BARPOS='no',FILENAME='/aux/pc20072b/jgroh/temp/output_image_obs_delta_ip_lambda.ps',$
;/NoPrint,XDIM=xsize,YDIM=ysize,/COLORPS,/ENCAP

IF KEYWORD_SET(vel) THEN BEGIN
title='Phase at velocity '+vel_str+' km s!E-1!N, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Phase at wavelength '+lambda_str+' Angstrom, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

;plot phases
img=bytscl(phase,MIN=min(phase),MAX=max(phase)); byte scaling the image for display purposes with tvimage
imginv=img
;plotting in window
xsize=900
ysize=760
window,14,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
;GETCOLOR is not working anymore...
;colors = GetColor(/Load) 
;!P.Background = colors.white
;!P.Color = colors.black
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, vis_circxvector, vis_circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(I)',XTICKFORMAT='(I)', $
xrange=[max(vis_circxvector),-max(vis_circxvector)], $
yrange=[-max(vis_circyvector),max(vis_circyvector)],xstyle=1,ystyle=1, xtitle='u [m]', $
ytitle='v[m]', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize],title=title
LOADCT, 13
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning

;format colorbarvalues to the maximum and minimum values found?
;colorbar_min=MIN(PHASE)
;colorbar_max=MAX(PHASE)

;format colorbarvalues to the -180 and +180 values found?
colorbar_min=-180.
colorbar_max=180.

colorbar_ticknames_str = [number_formatter(colorbar_min+(colorbar_max-colorbar_min)*0,decimals=2), $
number_formatter(colorbar_min+(colorbar_max-colorbar_min)*.25,decimals=2),$
number_formatter(0.00,decimals=2),$
number_formatter(colorbar_min+(colorbar_max-colorbar_min)*.75,decimals=2),$
number_formatter(colorbar_min+(colorbar_max-colorbar_min)*1.0,decimals=2)]


colorbar, COLOR=fsc_color('black'),DIVISIONS=4,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector),-max(vis_circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector),-max(vis_circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)]
;draws grid lines through 0,0
PLOTS,[-max(vis_circxvector),max(vis_circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector),max(vis_circyvector)],linestyle=1,color=fsc_color('white')

for i=0, n_elements(base_rect_coord)/2 - 1 DO BEGIN
;PLOTS,base_rect_coord[0,i],base_rect_coord[1,i],psym=8,symsize=2,COLOR=fsc_color('white')
ENDFOR

;PLOTS,40.1,40.1,psym=8,symsize=2,COLOR=fsc_color('white')
;tvlaser,BARPOS='no',FILENAME='/aux/pc20072b/jgroh/temp/output_image_obs_delta_ip_lambda.ps',$
;/NoPrint,XDIM=xsize,YDIM=ysize,/COLORPS,/ENCAP

END
;--------------------------------------------------------------------------------------------------------------------------

;plot visibility profile for a given PA? TESTING;plot image profile along a given PA, passing through the center; useful for plotting the visibility.; PA convention: 0=N, increase eastwards
PRO ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile,baseline_val=baseline_val

nx = (size(image, /dim))[0]
ny = (size(image, /dim))[1]

; if (xcen,ycen) are specified, then shift the image by (-xcen,-ycen) pixels
; to have the pixel (xcen, ycen) at (0,0). This does not have any effect
; on the resulting visibility amplitude image, but it does change phase, 
; real, and imag.

xcen=fix(nx/2. - 0.5)
ycen=fix(ny/2. - 0.5)

x1=xcen
y1=ycen

circ_GridSpace_mas=[circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]]
 
x2=xcen+(nx/2)*(-1.)*SIN(paprof*!PI/180.)
y2=ycen+(ny/2)*COS(paprof*!PI/180.)

nPoints = ABS(x2-x1+1) > ABS(y2-y1+1)
;Next, you must construct two vectors containing the X and Y locations, respectively, of these points. This is easily done in IDL, like this:

xloc = x1 + (x2 - x1) * Findgen(nPoints) / (nPoints - 1)
yloc = y1 + (y2 - y1) * Findgen(nPoints) / (nPoints - 1)
;Finally, the profile values are calculated by interpolating the image values at these locations along the line with the Interpolate command. (These will be bilinearly interpolated values, by default.) The code looks like this:
baseline_xloc=ABS(xloc-xcen)/(nx*0.001*circ_GridSpace_mas[0])*206265.*lambda_val*1e-10
baseline_yloc=ABS(yloc-ycen)/(ny*0.001*circ_GridSpace_mas[1])*206265.*lambda_val*1e-10

baseline_val=SQRT(baseline_xloc^2. + baseline_yloc^2)
   profile = Interpolate(image, xloc, yloc)
  ; window,1
  ; Plot, baseline_val,profile, xstyle=1, ystyle=1,YMARGIN=[5,5]

END
;--------------------------------------------------------------------------------------------------------------------------

;plot visibility profile for a given PA? TESTING;plot image profile along a given PA, passing through the center; useful for plotting the visibility.; PA convention: 0=N, increase eastwards
PRO ZE_PLOT_1DINTENSITY_PA_MAS, paprof,image,circxvector,circyvector,lambda_val,circ_GridSpace_mas,profile=profile,ang_radius=ang_radius

nx = (size(image, /dim))[0]
ny = (size(image, /dim))[1]

; if (xcen,ycen) are specified, then shift the image by (-xcen,-ycen) pixels
; to have the pixel (xcen, ycen) at (0,0). This does not have any effect
; on the resulting visibility amplitude image, but it does change phase, 
; real, and imag.

xcen=fix(nx/2. - 0.5)
ycen=fix(ny/2. - 0.5)

;intensity profile starting on the center? 
;x1=xcen
;y1=ycen

;intensity profile starting on the negative edge
x1=xcen-(nx/2)*(-1.)*SIN(paprof*!PI/180.)
y1=ycen-(ny/2)*COS(paprof*!PI/180.)
print,x1,y1

x2=xcen+(nx/2)*(-1.)*SIN(paprof*!PI/180.)
y2=ycen+(ny/2)*COS(paprof*!PI/180.)
print,x2,y2
nPoints = ABS(x2-x1+1) > ABS(y2-y1+1)

;Next, you must construct two vectors containing the X and Y locations, respectively, of these points. This is easily done in IDL, like this:
xloc = x1 + (x2 - x1) * Findgen(nPoints) / (nPoints - 1)
yloc = y1 + (y2 - y1) * Findgen(nPoints) / (nPoints - 1)
;Finally, the profile values are calculated by interpolating the image values at these locations along the line with the Interpolate command. (These will be bilinearly interpolated values, by default.) The code looks like this:
ang_radius_x=(xloc-xcen)*circ_GridSpace_mas[0]
ang_radius_y=(yloc-ycen)*circ_GridSpace_mas[1]
;print,ang_radius_x,ang_radius_y
ang_radius=SQRT(ang_radius_x^2. + ang_radius_y^2)
;help,ang_radius
for i=0,(n_elements(ang_radius)/2.)-1 DO ang_radius[i]=ang_radius[i]*(-1.)
profile = Interpolate(image, xloc, yloc)

END
;
;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_RETRIEVE_VISIBILITY_PHASE_CP_TRIPLET_WAVELENGTH,base_rect_coord,baseline_xloc_all,baseline_yloc_all,visamp,phase,vis_triplet=vis_triplet, phase_triple=phase_triplet, cp_triplet=cp_triplet
;finding location of the observed baseline coordinates in the model image, and retrieving visibilities and phase values corresponding to that baseline
nearx=dblarr(3) & neary=nearx & indexx = nearx & indexy=indexx & vis_triplet=indexx & phase_triplet=nearx
for i=0, 2 DO BEGIN
nearx1 = Min(Abs(baseline_xloc_all - base_rect_coord[0,i]), indexx1)
neary1 = Min(Abs(baseline_yloc_all - base_rect_coord[1,i]), indexy1)
nearx[i]=nearx1 & neary[i]=neary1 & indexx[i]=indexx1 & indexy[i]=indexy1
vis_triplet[i]=visamp[indexx[i],indexy[i]]
phase_triplet[i]=phase[indexx[i],indexy[i]]
ENDFOR

cp_triplet=TOTAL(phase_triplet)
;cp_triplet=phase_triplet[0]+phase_triplet[1]+phase_triplet[2]
if cp_triplet ge 180 then cp_triplet=cp_triplet-360
if cp_triplet le (-180) then cp_triplet=cp_triplet+360

;TESTING
;if cp_triplet le (-178) then cp_triplet=0
;if cp_triplet ge 178 then cp_triplet=0

END
;--------------------------------------------------------------------------------------------------------------------------
 
$MAIN CODE
;This version ve_mod106_john is adapted for mod106_john. My changes are in ZE_READ_OBS_DELTA_TXT where we change np=np-21 to np=np-0...this has to be done since mod106_john does not extend as fas as
; mod111_john, and rstar is different
CLOSE,/ALL
Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
filename_ipdata_txt_write='/Users/jgroh/temp/teste_IP.txt'
dir='/Users/jgroh/ze_models/2D_models/etacar/'
;model='mod111_john'
model='mod106_john'
;model2d='4314'
;model2d='5506'
;model2d='6737'
;model2d='7936'
;model2d='12617'
;model2d='16569'
;model2d='21029'
;model2d='35556'
;model2d='latidep'
model2d='c'
;model2d='cut_v4'
sufix=''
;model2d='tilted'
;sufix='d'
model2d='tilted_owocki'
sufix='00_45_brg'
;sufix='d'
;model='1'
filename_ipdata_txt=dir+model+'/'+model2d+'/'+sufix+'/IP_DELTA_DATA'             ;correct IP_DELTA
;screwing up to compute the spectrum
;filename_ipdata_txt=dir+model+'/OBS_DELTA_IP_DATA'             ;has the flux data (i.e. I(p)p^2),useful for computing line profiles
;filename_ipdata_txt='/Users/jgroh/temp/OBS_DELTA_IP_DATA'        ;OBS_DELTA
rstar=1670.4 ; in CMFGEN UNITS
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

;
;baseline info
PA_obs_etacar_2004dec26=[35,94,70] ;in degress
Base_obs_etacar_2004dec26=[43,59,89]

PA_obs_etacar_2005feb26=[84,152,132] ;in degress
Base_obs_etacar_2005feb26=[29,61,77]

PA_obs_etacar_2006apr12=[69.0,135,112] ;in degress
Base_obs_etacar_2006apr12=[36,62,83]

PA_obs_etacar_2006apr16=[37,96,72] ;in degress
Base_obs_etacar_2006apr16=[43,59,89]

PA_obs_etacar_2008apr6=[69.8,69.8,69.8] ;in degress
;PA_obs_etacar_2008apr6=[49.8,49.8,49.8] ;in degress
Base_obs_etacar_2008apr6=[15.8,31.7,47.5]

PA_obs_irc10420_ut=[36,76.5,60.6] ;in degress
;changing PAs because the IMAGE PA should be 60, not 0
;PA_obs_irc10420_ut=PA_obs_irc10420_ut-60.
Base_obs_irc10420_ut=[54.3,82.7,128.9]

PA_obs=[PA_obs_etacar_2004dec26,PA_obs_etacar_2006apr12,PA_obs_etacar_2006apr16]
Base_obs=[Base_obs_etacar_2004dec26,Base_obs_etacar_2006apr12,Base_obs_etacar_2006apr16]
PA_obs=PA_obs_etacar_2004dec26
Base_obs=Base_obs_etacar_2004dec26
;PA_obs=PA_obs_irc10420_ut
;Base_obs=Base_obs_irc10420_ut
base_polarcoord=dblarr(2,n_elements(base_obs))
base_polarcoord[0,*]=(90-Pa_obs)*!PI/180. ;converting PA to radians and to 0=N, increases eastwards
base_polarcoord[1,*]=Base_obs
base_rect_coord = CV_COORD(From_Polar=base_polarcoord, /To_Rect)

;lambda_val=20582.0     ; wavelength in Angstroms
;lambda0=20586.9    ;He I    ; VACUUM wavelength of the line transition of interest
lambda0=21661.2    ; Br gamma
;lambda0=4314.
;lambda_ini=4315.   ;initial lambda to do calculations 21610
;lambda_fin=21685    ;initial lambda to do calculations 21720
lambda_ini=21550.   ;initial lambda to do calculations 21610
lambda_fin=21720.    ;initial lambda to do calculations 21720
;lambda_ini=21040.

;lambda_ini=21510   ;initial lambda to do calculations 21610
;lambda_fin=21520.
lambda_sampling=5.6     ;sampling in Angstrom ; use 1

;CASE model2d of
;
;'4314': BEGIN
;lambda_ini=4315.
;lambda_fin=4317.
;lambda_sampling=0.8     ;sampling in Angstrom ; use 1
;END
;
;'5506': BEGIN
;lambda_ini=5506.
;lambda_fin=5516.
;lambda_sampling=2.8     ;sampling in Angstrom ; use 1
;END
;
;'6737': BEGIN
;lambda_ini=6737.
;lambda_fin=6748.
;lambda_sampling=2.8     ;sampling in Angstrom ; use 1
;END
;
;'7936': BEGIN
;lambda_ini=7938.
;lambda_fin=7959.
;lambda_sampling=5.8     ;sampling in Angstrom ; use 1
;END
;
;'12617': BEGIN
;lambda_ini=12620.
;lambda_fin=12680.
;lambda_sampling=10.8     ;sampling in Angstrom ; use 1
;END
;
;'16569': BEGIN
;lambda_ini=16570.
;lambda_fin=16620.
;lambda_sampling=7.8     ;sampling in Angstrom ; use 1
;END
;
;'21029': BEGIN
;lambda_ini=21040.
;lambda_fin=21060.
;lambda_sampling=4.8     ;sampling in Angstrom ; use 1
;END
;'35556': BEGIN
;lambda_ini=35560.
;lambda_fin=35610.
;lambda_sampling=5.8     ;sampling in Angstrom ; use 1
;END
;ENDCASE
;filterwidth=200 ;in Angstroms
;lambda_ini=lambda0-filterwidth/2
;lambda_fin=lambda0+filterwidth/2


nlambda= (lambda_fin-lambda_ini)/lambda_sampling         ;number of wavelengths to compute IMAGE, VIS, PHASE

ZE_CREATE_POLARCOORD_XY_VECTOR,rstar,pa,np,ndelta1,p,delta1_vec,polarcoord=polarcoord,x=x,y=y

!P.THICK=3
!X.THiCK=3
!Y.THICK=3
!P.CHARTHICK=1.5
!P.FONT=-1

vis_triplet_wavelength=dblarr(3,nlambda) & phase_triplet_wavelength=vis_triplet_wavelength & cp_triplet_wavelength=dblarr(nlambda) & lambda_vector=dblarr(nlambda)
;vis_image_wavelength=dblarr(1027,1027,nlambda) & phase_image_wavelength=vis_image_wavelength & intens_image_wavelength=vis_image_wavelength 
totalflux=dblarr(1027,nlambda)

;first loop computes the high spatial resolution images and the spectrum; cannot be used for computing visibilities and phases. 
circ_GridSpace_mas=[0.035,0.035];used for all Eta Car images before
circ_GridSpace_mas=[0.013,0.013];best
;circ_GridSpace_mas=[0.035*3.75,0.035*3.75];teset

for i=0., nlambda-1 do begin
lambda_val=lambda_ini + i*lambda_sampling
lambda_vector[i]=lambda_val
ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData
ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda, circxvector,circyvector,circ_griddedData,imginv=imginv,/VEL
;wset,8
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/img/etc_mod111john_2Db_brg_obl32_img'+strcompress(string(i, format='(I04)'), /remove)
;WRITE_PNG, '/Users/jgroh/temp/irc10420_'+model+model2d+sufix + STRING(i, FORMAT = "(I4.4)") + '.png', TVRD(True=1)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;wset,15
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/spec/etc_mod111john_2Db_brg_obl32_specloc'+strcompress(string(i, format='(I04)'), /remove)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;
;first loop to compute flux spectrum from Ip values WORKING! DO NOT MULTIPLY BY P, since  we are doing the integral in P and delta (BH05 eq 12), F=1/d^2 *Int(0,2pi)Int(0,pmax)I(p,delta)dp ddelta
for j=0, 1026. do totalflux[j,i]=int_tabulated(circxvector*(6.96*214.08*dist),circ_griddedData[j,*],/DOUBLE) ;using circxvector in 10^10cm
print,'Finished IMG for lambda:  ', lambda_val
endfor

;compute flux spectrum from Ip values WORKING! DO NOT MULTIPLY BY P, since  we are doing the integral in P and delta (BH05 eq 12), F=1/d^2 *Int(0,2pi)Int(0,pmax)I(p,delta)dp ddelta
;first we do the integral in x inside the for LOOP above, and the the integral in y with the for loop below; units are Jy, and probably accurate within 1 %.
totalfluxfim=dblarr(nlambda)
for i=0, nlambda-1 do totalfluxfim[i]=int_tabulated(circyvector*(6.96*214.08*dist),totalflux[*,i],/DOUBLE) ;;using circxvector in 10^10cm      /(3.08568025E+21)^2.
vel_vector=ZE_LAMBDA_TO_VEL(lambda_vector,lambda0)
print,'Finished SPEC'

;2nd loop computes the visibilities and phases; images are recomputed using a larger scale.
circ_GridSpace_mas_vis=[0.08,0.08]
for i=0., nlambda-1 do begin
lambda_val=lambda_ini + i*lambda_sampling
lambda_vector[i]=lambda_val
xrangevel=ZE_LAMBDA_TO_VEL([lambda_ini-lambda_sampling,lambda_fin+lambda_sampling],lambda0)
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
window,15
plot,lambda_vector,totalfluxfim,XRANGE=[lambda_ini-lambda_sampling,lambda_fin+lambda_sampling],xstyle=9,ystyle=1,charsize=2,charthick=1.7,XTICKFORMAT='(I6)',/NODATA,YRANGE=[0.95*min(totalfluxfim),1.05*max(totalfluxfim)]
plots,lambda_vector,totalfluxfim,thick=3,color=FSC_COLOR('black')
nearslambda = Min(Abs(lambda_vector - lambda_val), indexsl)
plots,lambda_vector[indexsl],totalfluxfim[indexsl],psym=1,symsize=4,color=FSC_COLOR('red')
AXIS,XAXIS=1,XTICKFORMAT='(I6)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='vel (km/s)',XRANGE=xrangevel,xcharsize=2,charthick=1.7
plots,[lambda_vector(indexsl),totalfluxfim(indexsl)],[0,5],color=FSC_COLOR('red'),linestyle=2
ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas_vis,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData
;ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda, circxvector,circyvector,circ_griddedData,imginv=imginv,/VEL
img=circ_griddedData
ZE_COMPUTE_IMAGE_FFT_I_P_DELTA_LAMBDA,rstar,dist,img,lambda_val,circ_GridSpace_mas_vis,visamp=visamp,real=real,phase=phase,vis_circxvector=vis_circxvector,vis_circyvector=vis_circyvector,xcen=xcen,ycen=ycen
;ZE_PLOT_IMAGE_FFT_I_P_DELTA_LAMBDA,base_rect_coord,rstar,dist,img,circxvector,circyvector,pa,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,$
;visamp,real,phase,vis_circxvector,vis_circyvector,xcen,ycen,circ_GridSpace_mas,/VEL
;
;;computing baseline values for each pixel of the full FT image; works for visibility and phase images
baseline_xloc_all= vis_circxvector[xcen] - vis_circxvector ;reversed since u increases to the left, to be compliant with the general convention
baseline_yloc_all=vis_circyvector - vis_circyvector[ycen]
ZE_RETRIEVE_VISIBILITY_PHASE_CP_TRIPLET_WAVELENGTH,base_rect_coord,baseline_xloc_all,baseline_yloc_all,visamp,phase,vis_triplet=vis_triplet, phase_triple=phase_triplet, cp_triplet=cp_triplet
vis_triplet_wavelength[*,i]=vis_triplet
phase_triplet_wavelength[*,i]=phase_triplet
cp_triplet_wavelength[i]=cp_triplet
;wset,13
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/vis/etc_mod111john_2Db_brg_obl32_vis'+strcompress(string(i, format='(I04)'), /remove)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;wset,14
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/phase/etc_mod111john_2Db_brg_obl32_phase'+strcompress(string(i, format='(I04)'), /remove)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
endfor

;write fits files?
;MWRFITS, circ_griddedData,'/Users/jgroh/temp/intens_21615.fits',/ISCALE, /CREATE
;MWRFITS, visamp,'/Users/jgroh/temp/vis_21615.fits',/ISCALE, /CREATE
;MWRFITS, phase,'/Users/jgroh/temp/phase_21615.fits',/ISCALE, /CREATE
;

lambda_val=21520.2 ;ONLY for baseline calculations; actually uses the last visamp for computing values...
paprof=50. ; PA in degrees
image=visamp
window,29
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

;doing this to obtain number of baseline values
ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile50,baseline_val=baseline_val50

pamin=50.
pamax=130.
pastep=20.
npa=(pamax - pamin)/pastep +1.
pamin_str=strcompress(string(pamin, format='(I03)'))
pamax_str=strcompress(string(pamax, format='(I03)'))
pastep_str=strcompress(string(pastep, format='(I03)'))
nbas=n_elements(baseline_val50)
nbas=391.
pa_vec=dblarr(npa)
FOR i=0,npa-1 do pa_vec[i]=pamin+ i*pastep
vis_profile=dblarr(nbas,npa)
baseline_val=dblarr(nbas,npa)

FOR i=0, npa -1 do begin
ZE_PLOT_1DVISIBILITY_PA_BASELINE, pa_vec[i],image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profilet,baseline_val=baseline_valt
vis_profile[*,i]=profilet[0:390]
baseline_val[*,i]=baseline_valt[0:390]
ENDFOR

;write data to FILE
file='/Users/jgroh/temp/vis_baseline_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_PA'+pa_str+'_PAmin'+pamin_str+'_PAmax'+pamax_str+'_PAstep'+pastep_str+'.txt'
close,1
openw,1,file     ; open file to write

;for k=0, nbas-1 do begin
;printf,1,FORMAT='(F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6)',baseline_val50[k],profile50[k],baseline_val70[k],profile70[k],baseline_val90[k],profile90[k],baseline_val110[k],profile110[k],baseline_val130[k],profile130[k]
;endfor
;close,1


printf,1,nbas
printf,1,pamin
printf,1,npa
printf,1,vis_profile
printf,1,baseline_val
close,1
;for k=0, nbas-1 do begin
;printf,1,FORMAT='(F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6)',baseline_val50[k],profile50[k],baseline_val70[k],profile70[k],baseline_val90[k],profile90[k],baseline_val110[k],profile110[k],baseline_val130[k],profile130[k]
;endfor
;close,1

;ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile50,baseline_val=baseline_val50
;plot, baseline_val50,profile50, xstyle=1, ystyle=1,YMARGIN=[5,5],XRANGE=[0,150],psym=1,color=FSC_COLOR('orange')
;
;paprof=paprof+20. ; PA in degrees
;ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile70,baseline_val=baseline_val70
;plots, baseline_val70,profile70,color=FSC_COLOR('red'),noclip=0,psym=2
;paprof=paprof+20. ; PA in degrees
;ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile90,baseline_val=baseline_val90
;plots, baseline_val90,profile90,color=FSC_COLOR('blue'),noclip=0,psym=4
;paprof=paprof+20. ; PA in degrees
;ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile110,baseline_val=baseline_val110
;plots, baseline_val110,profile110,color=FSC_COLOR('green'),noclip=0,psym=5
;paprof=paprof+20. ; PA in degrees
;ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile130,baseline_val=baseline_val130
;plots, baseline_val130,profile130,color=FSC_COLOR('cyan'),noclip=0,psym=6
;
;;write data to FILE
;file='/Users/jgroh/temp/vis_baseline_PA_50_70_90_110_130'+model+'_'+model2d+'_'+sufix+'.txt'
;close,1
;openw,1,file     ; open file to write
;
;for k=0, n_elements(baseline_val50)-1 do begin
;printf,1,FORMAT='(F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6)',baseline_val50[k],profile50[k],baseline_val70[k],profile70[k],baseline_val90[k],profile90[k],baseline_val110[k],profile110[k],baseline_val130[k],profile130[k]
;endfor
;close,1


;read thomas files
filename='/Users/jgroh/espectros/irc10420/IRC10420_VIS12_BIN11_STEP1.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=vis12_ut
filename='/Users/jgroh/espectros/irc10420/IRC10420_VIS23_BIN11_STEP1.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=vis23_ut
filename='/Users/jgroh/espectros/irc10420/IRC10420_VIS31_BIN11_STEP1.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=vis31_ut

filename='/Users/jgroh/espectros/irc10420/IRC10420_DP12_JOSE.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=phase12_ut
filename='/Users/jgroh/espectros/irc10420/IRC10420_DP23_JOSE.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=phase23_ut
filename='/Users/jgroh/espectros/irc10420/IRC10420_DP31_JOSE.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=phase31_ut

filename='/Users/jgroh/espectros/irc10420/IRC10420_CP_JOSE.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=cp_ut

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/irc10420/IRC10420_SPEC.TAB',lobs,fobs

lobs=lobs*10000.
vis_triplet_wavelength_cnvl=vis_triplet_wavelength
phase_triplet_wavelength_cnvl=phase_triplet_wavelength
window,1
t=dblarr(nlambda)
lambda_val=lambda_ini
ra_obs=[19,26,48.00]
dec_obs=[11,21,16.7]
;date_obs=[2008,4,6,08]
;ZE_COMPUTE_HELIOCENTRIC_VEL,date_obs,ra_obs,dec_obs,vhelio=vhelio
vsys=0.          ;from humphreys et al. 2002
vhelio=0.       ;from ESO skycalc webpage
velshift=vsys-vhelio
print,'Heliocentric velocity: ',vhelio

ra_decimal=convang(ra_obs,/ra)
dec_decimal=convang(dec_obs)
HELIO2LSR, vhelio, vlsr,ra=ra_decimal, dec=dec_decimal
print,'LSR velocity: ',vlsr

resolving_power=12000.
res=lambda_val/resolving_power

;shifting the model spectrum by the systemic velocity
totalfluxfimsys=ZE_SHIfT_SPECTRA_VEL(lambda_vector,totalfluxfim,vsys)
ZE_SPEC_CNVL,lambda_vector,totalfluxfimsys,res,lambda_val,fluxcnvl=totalfluxfimsys_cnvl
line_norm,lambda_vector,totalfluxfimsys_cnvl,totalfluxfimsysn

;shifting the model visibilities by the systemic velocity
for i=0, 2 DO BEGIN 
t[*]=vis_triplet_wavelength[i,*]
;t=ZE_SHIfT_SPECTRA_VEL(lambda_vector,t,vsys)
ZE_SPEC_CNVL,lambda_vector,t,res,lambda_val,fluxcnvl=t2
vis_triplet_wavelength_cnvl[i,*]=t2
endfor

;shifting the model phases by the systemic velocity
for i=0, 2 DO BEGIN 
t[*]=phase_triplet_wavelength[i,*]
;t=ZE_SHIfT_SPECTRA_VEL(lambda_vector,t,vsys)
ZE_SPEC_CNVL,lambda_vector,t,res,lambda_val,fluxcnvl=t2
phase_triplet_wavelength_cnvl[i,*]=t2
endfor

;shifting the model closure phase by the systemic velocity
cp_triplet_wavelength_sys=ZE_SHIfT_SPECTRA_VEL(lambda_vector,cp_triplet_wavelength,vsys)
ZE_SPEC_CNVL,lambda_vector,cp_triplet_wavelength_sys,res,lambda_val,fluxcnvl=cp_triplet_wavelength_cnvl_sys

;shifting the observed spectrum by the heliocentric correction velocity ; only has to be done if the files sent by thomas were not corrected by vhelio!
;looks like thomas' spectrum (i.e. lamb,flux) was not corrected by vhelio; the velocity scale in fig 3 was corrected for vhelio and vsys though.
fobshel=ZE_SHIfT_SPECTRA_VEL(lobs,fobs,vhelio)
line_norm,lobs,fobshel,fobsheln 
vobs=ZE_LAMBDA_TO_VEL(lobs,21661.2)

;;shifting the observed visibilities by the heliocentric correction velocity ; only has to be done if the files sent by thomas were not corrected by vhelio!
t3=dblarr(n_elements(vis12_ut.field1[2,*]))
lambdat=t3
t3[*]=vis12_ut.field1[3,*]
lambdat[*]=vis12_ut.field1[2,*]*10000.
t3=ZE_SHIfT_SPECTRA_VEL(lambdat,t3,vhelio)
vis12_ut.field1[3,*]=t3
;
t3=dblarr(n_elements(vis23_ut.field1[2,*]))
lambdat=t3
t3[*]=vis23_ut.field1[3,*]
lambdat[*]=vis23_ut.field1[2,*]*10000.
t3=ZE_SHIfT_SPECTRA_VEL(lambdat,t3,vhelio)
vis23_ut.field1[3,*]=t3

t3=dblarr(n_elements(vis31_ut.field1[2,*]))
lambdat=t3
t3[*]=vis31_ut.field1[3,*]
lambdat[*]=vis31_ut.field1[2,*]*10000.
t3=ZE_SHIfT_SPECTRA_VEL(lambdat,t3,vhelio)
vis31_ut.field1[3,*]=t3

;;shifting the observed phases by the heliocentric correction velocity ; only has to be done if the files sent by thomas were not corrected by vhelio!
t3=dblarr(n_elements(vis12_ut.field1[2,*]))
lambdat=t3
t3[*]=phase12_ut.field1[3,*]
lambdat[*]=phase12_ut.field1[2,*]*10000.
t3=ZE_SHIfT_SPECTRA_VEL(lambdat,t3,vhelio)
phase12_ut.field1[3,*]=t3
;
t3=dblarr(n_elements(phase23_ut.field1[2,*]))
lambdat=t3
t3[*]=phase23_ut.field1[3,*]
lambdat[*]=phase23_ut.field1[2,*]*10000.
t3=ZE_SHIfT_SPECTRA_VEL(lambdat,t3,vhelio)
phase23_ut.field1[3,*]=t3

t3=dblarr(n_elements(phase31_ut.field1[2,*]))
lambdat=t3
t3[*]=phase31_ut.field1[3,*]
lambdat[*]=phase31_ut.field1[2,*]*10000.
t3=ZE_SHIfT_SPECTRA_VEL(lambdat,t3,vhelio)
phase31_ut.field1[3,*]=t3

;shifting the observed closure phase by the heliocentric correction velocity ; only has to be done if the files sent by thomas were not corrected by vhelio!
t3=dblarr(n_elements(cp_ut.field1[2,*]))
lambdat=t3
t3[*]=cp_ut.field1[3,*]
lambdat[*]=cp_ut.field1[2,*]*10000.
t3=ZE_SHIfT_SPECTRA_VEL(lambdat,t3,vhelio)
cp_ut.field1[3,*]=t3

;plotting visibilities to window
window
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],noclip=0,yrange=[0,1.1]
plots,lambda_vector,vis_triplet_wavelength_cnvl[1,*],noclip=0
plots,lambda_vector,vis_triplet_wavelength_cnvl[2,*],noclip=0
plots,vis12_ut.field1[2,*]*10000.,vis12_ut.field1[3,*],color=FSC_COLOR('red'),noclip=0
plots,vis23_ut.field1[2,*]*10000.,vis23_ut.field1[3,*],color=FSC_COLOR('green'),noclip=0
plots,vis31_ut.field1[2,*]*10000.,vis31_ut.field1[3,*],color=FSC_COLOR('blue'),noclip=0

window,3
;plotting phases
plot, lambda_vector,phase_triplet_wavelength[0,*],yrange=[-80,80],ystyle=1,/NODATA
plots,phase12_ut.field1[2,*]*10000.,phase12_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,phase23_ut.field1[2,*]*10000.,phase23_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,phase31_ut.field1[2,*]*10000.,phase31_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
;;plots,dp12_2004dec26.field1[2,*]*10000.,dp12_2004dec26.field1[3,*],color=FSC_COLOR('red'),noclip=0
;;plots,dp23_2004dec26.field1[2,*]*10000.,dp23_2004dec26.field1[3,*],color=FSC_COLOR('green'),noclip=0
;;plots,dp31_2004dec26.field1[2,*]*10000.,dp31_2004dec26.field1[3,*],color=FSC_COLOR('blue'),noclip=0
plots, lambda_vector,phase_triplet_wavelength_cnvl[0,*],noclip=0,color=FSC_COLOR('red')
plots, lambda_vector,phase_triplet_wavelength_cnvl[1,*],noclip=0,color=FSC_COLOR('green')
plots, lambda_vector,phase_triplet_wavelength_cnvl[2,*],noclip=0,color=FSC_COLOR('blue')

;plotting closure phases
window,4
plot,lambda_vector,cp_triplet_wavelength,yrange=[-190,190],/NODATA
plots,cp_ut.field1[2,*]*10000.,cp_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,lambda_vector,cp_triplet_wavelength_cnvl_sys,color=FSC_COLOR('red')

;write CPs to FILE
file='/Users/jgroh/temp/cp_lambda_'+model+'_'+model2d+'_'+sufix+'_d'+dstr+'_PA'+pa_str+'_i'+inc_str+'.txt'
close,1
openw,1,file     ; open file to write

;for k=0, nbas-1 do begin
;printf,1,FORMAT='(F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6)',baseline_val50[k],profile50[k],baseline_val70[k],profile70[k],baseline_val90[k],profile90[k],baseline_val110[k],profile110[k],baseline_val130[k],profile130[k]
;endfor
;close,1


printf,1,FIX(nlambda)
printf,1,lambda_vector
printf,1,cp_triplet_wavelength_cnvl_sys
close,1

xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
set_plot,'ps'
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=2.0
device,/close
device,filename='/Users/jgroh/temp/vis_wavelength'+model+model2d+sufix+'_d'+dstr+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.09, 0.85, 0.78*xwindowsize/ywindowsize]
plots,lambda_vector,vis_triplet_wavelength_cnvl[0,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector,vis_triplet_wavelength_cnvl[1,*],noclip=0,color=FSC_COLOR('green'),linestyle=2
plots,lambda_vector,vis_triplet_wavelength_cnvl[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=2
plots,vis12_ut.field1[2,*]*10000.,vis12_ut.field1[3,*],color=FSC_COLOR('red'),noclip=0
plots,vis23_ut.field1[2,*]*10000.,vis23_ut.field1[3,*],color=FSC_COLOR('green'),noclip=0
plots,vis31_ut.field1[2,*]*10000.,vis31_ut.field1[3,*],color=FSC_COLOR('blue'),noclip=0
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]

device,/close

device,filename='/Users/jgroh/temp/spec_wavelength'+model+model2d+sufix+'_d'+dstr+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,totalfluxfimsysn,yrange=[0,5.0],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='F/Fc',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.09, 0.85, 0.78*xwindowsize/ywindowsize]
plots,lambda_vector,totalfluxfimsysn,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lobs,fobsheln,color=FSC_COLOR('black'),noclip=0
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]

device,/close

set_plot,'x'
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

paprof=PA_Obs[0] ; PA in degrees
paprof_str=strcompress(string(paprof, format='(I02)'))

lambda_val=lambda_ini
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))
ZE_IRC10420_CREATE_INTENSITYIMAGE_EPS,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector
image=circ_griddedData
ZE_PLOT_1DINTENSITY_PA_MAS, paprof,image,circxvector,circyvector,lambda_val,circ_GridSpace_mas,profile=profile12,ang_radius=ang_radius12
ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_'+model+model2d+sufix+'_d'+dstr+'_PA'+pa_str+'_'+'_PAprof_'+paprof_str+'_'+lambda_val_str+'.txt',ang_radius12,profile12/max(profile12)

lambda_val=21520.
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))
ZE_IRC10420_CREATE_INTENSITYIMAGE_EPS_V2,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector
image=circ_griddedData
ZE_PLOT_1DINTENSITY_PA_MAS, paprof,image,circxvector,circyvector,lambda_val,circ_GridSpace_mas,profile=profile12,ang_radius=ang_radius12
ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/irc10420_intens_mas_'+model+model2d+sufix+'_d'+dstr+'_PA'+pa_str+'_'+'_PAprof'+paprof_str+lambda_val_str+'.txt',ang_radius12,profile12/max(profile12)

lambda_val=21633.2
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))
ZE_IRC10420_CREATE_INTENSITYIMAGE_EPS,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector
image=circ_griddedData
ZE_PLOT_1DINTENSITY_PA_MAS, paprof,image,circxvector,circyvector,lambda_val,circ_GridSpace_mas,profile=profile23,ang_radius=ang_radius23

lambda_val=21661.2
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))
ZE_IRC10420_CREATE_INTENSITYIMAGE_EPS,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector
image=circ_griddedData
ZE_PLOT_1DINTENSITY_PA_MAS, paprof,image,circxvector,circyvector,lambda_val,circ_GridSpace_mas,profile=profile31,ang_radius=ang_radius31
ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/irc10420_intens_mas_'+model+model2d+sufix+'_d'+dstr+'_PA'+pa_str+'_'+'_PAprof'+paprof_str+lambda_val_str+'.txt',ang_radius31,profile31/max(profile31)

lambda_val=21684.2
lambda_val_str=strcompress(string(lambda_val*10., format='(I06)'))
ZE_IRC10420_CREATE_INTENSITYIMAGE_EPS,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,model,model2d,sufix,dstr,inc_str,circ_GridSpace_mas,$
circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector



set_plot,'x'

!P.Background = fsc_color('white')
LOADCT,13
xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
;;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize
img=bytscl(visamp,MAX=max(visamp))
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
wdelete,!d.window

set_plot,'ps'
device,/close
device,filename='/Users/jgroh/temp/vis_truecolor'+model+model2d+sufix+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
   
LOADCT, 13

xsize=900
ysize=760

near = Min(Abs(lambda - lambda_val), index)

;convert lambda float to a string
ndlambda=1.
lambda_str=number_formatter(lambda_val,decimals=ndlambda)

;convert lambda_val to velocity and then to a string
IF KEYWORD_SET(vel) THEN BEGIN
  ndvel=0.
  vel_val=ZE_LAMBDA_TO_VEL(lambda[index],lambda0)
  vel_str=number_formatter(vel_val,decimals=ndvel) 
ENDIF

img=bytscl(visamp,MAX=max(visamp)); byte scaling the image for display purposes with tvimage
imginv=img
;plotting in window
xsize=900
ysize=760

LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF KEYWORD_SET(vel) THEN BEGIN
title='Visibility at velocity '+vel_str+' km s!E-1!N, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Visibility at wavelength '+lambda_str+' Angstrom, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, vis_circxvector, vis_circyvector, charsize=2,ycharsize=1,xcharsize=1, YTICKFORMAT='(I)',XTICKFORMAT='(I)', $
xrange=[max(vis_circxvector),-max(vis_circxvector)], $
yrange=[-max(vis_circyvector),max(vis_circyvector)],xstyle=1,ystyle=1, xtitle='u [m]', $
ytitle='v [m]', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13, /SILENT
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
colorbar_ticknames_str = [number_formatter(0.00,decimals=1), number_formatter(max(visamp)*.2,decimals=1),$
number_formatter(max(visamp)*.4,decimals=1),number_formatter(max(visamp)*.6,decimals=1), number_formatter(max(visamp)*.8,decimals=1),$
number_formatter(max(visamp),decimals=1)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0, /SILENT
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector),-max(vis_circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector),-max(vis_circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector),max(vis_circyvector)]
;draws grid lines through 0,0
PLOTS,[max(vis_circxvector),-max(vis_circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector),max(vis_circyvector)],linestyle=1,color=fsc_color('white')

device,/close

!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0

set_plot,'x'
LOADCT,13, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;undefine,img,imginv,pic2,visamp,phase,image,ipdelta,intens2d_lambda
;undefine,circ_GriddedData,real,lmod17,fmod17,lmod15,fmod15,fmod15sys,fmod17sys
;save,/variables,FILENAME='/Users/jgroh/espectros/irc10420/irc10420_2d_variables_'+model+model2d+sufix+'_d'+dstr+'pa'+pa_str+'.sav'   
;save,lobs,fobsheln,lambda_vector,vel_vector,totalfluxfimsysn,FILENAME='/Users/jgroh/espectros/irc10420/irc10420_variables_spec_'+model+model2d+sufix+'_d'+dstr+'.sav'
END
