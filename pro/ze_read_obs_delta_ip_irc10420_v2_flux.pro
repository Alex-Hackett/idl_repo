PRO ZE_READ_OBS_DELTA_TXT,file,rstar,np=np,ndelta1=ndelta1,nos=nos,p=p,delta1_vec=delta1_vec,obs_freq=obs_freq,ipdelta=ipdelta,lambda=lambda
C=299792000.
;OK, OBS_DELTA do not contain I(p,delta), contain the flux I(p,delta) * p^2 ! One has to read the new file IP_DELTA_DATA
openu,1,file
;reading header of the file, containing NP, NDELTA1, NOS , respectively
np=1. & ndelta1=np & nos=np
readf,1,np,ndelta1,nos
print,np,ndelta1,nos
nporig=np-1.
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

PRO ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData,circ_GridSpace_mas=circ_GridSpace_mas

;create a monocromatic vector of intensities (i.e. for one frequency from the OBS_DELTA vector) for a given lambda_val
intens2d_lambda=DBLARR(np*ndelta1)

near = Min(Abs(lambda - lambda_val), index)

for i=0.,(np*ndelta1)-1. do begin
intens2d_lambda[i]=ipdelta[index]
index=index+nos
endfor

;for each lambda, normalize the intensity by the maximum value for that particular lambda?
;screwing up to compute the spectrum; if normalizing does not work! JGH 2009 April 13 10pm
;intens2d_lambda=intens2d_lambda/max(intens2d_lambda)

;for each lambda, normalize the intensity by the maximum value overall?
;intens2d_lambda=intens2d_lambda/max(ipdelta)

;trying to correct for AG CAr (March 2 2009)
GRID_INPUT,x,y,intens2d_lambda,xsorted,ysorted,intens2d_lambdasorted
x2=xsorted
y2=ysorted
intens2d_lambda2=intens2d_lambdasorted

;interpolate the data. One has to use TOLERANCE in order to avoid co-linear points
;TOLERANCE=1e-10 for etacar , 1e-8 for AG Car
;TRIANGULATE, x, y, circtriangles, circboundaryPts,TOLERANCE=1e-10 ;working for r in rstar
;TRIANGULATE, x, y, circtriangles, circboundaryPts,TOLERANCE=1e-8
TRIANGULATE,x2,y2,circtriangles, circboundaryPts,TOLERANCE=1e-10
factor=0.15 ;40   ;factor to zoom out of the image              ;BEST for ETA Car image is factor=0.54 for p=p-21, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
;factor=3.7;                                                      ;BEST for ETA Car vis is factor=8.2 for p=p-21, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
pix=1027.
circ_gridSpace = [MAX(X2)/(pix-1)*2.*factor, MAX(Y2)/(pix-1)*2.*factor] ; space in x and y directions TESTING
;circ_griddedData = TRIGRID(x, y, intens2d_lambda, circtriangles, circ_gridSpace,[MIN(x), MIN(y), MAX(x), max(y)], XGrid=circxvector, YGrid=circyvector) ;TESTING

;circ_gridSpace = [MAX(X)/(pix-1)*2.*factor, MAX(Y)/(pix-1)*2.*factor] ; space in x and y directions [in rsun], it is the optimum value obtained from tests WPRKING
circ_griddedData = TRIGRID(x2, y2, intens2d_lambda2, circtriangles, circ_gridSpace,[MIN(x2)*factor, MIN(y2)*factor, MAX(x2)*factor, max(y2)*factor], XGrid=circxvector, YGrid=circyvector); WOKRING
;print,'Grid spacing in rstar',circ_gridSpace  ;grid spacing in rstar
;circ_gridSpace_meter=circ_gridSpace*(rstar*1e8)
;print,'Grid spacing in meters',circ_gridSpace_meter  ;grid spacing in meters
pixcut=0 ; number of pixels cut from each side, i.e. total nubmer of removed pixels is equal to pixcut*2. 
circ_griddedData=circ_griddedData[pixcut:(pix-1-pixcut),pixcut:(pix-1-pixcut)]
circxvector=circxvector[pixcut:(pix-1-pixcut)]
circyvector=circyvector[pixcut:(pix-1-pixcut)]

gauss = PSF_GAUSSIAN( Npixel=1027, FWHM=[75,75], CENTROID=[690,330],/NORMAL,/DOUBLE )
gauss=gauss/max(gauss)
;
;circ_griddedData=circ_griddedData-gauss
;t=where(circ_griddedData lt 0)
;circ_griddedData[t]=0

;convert circgridxvector and circgridyvector from alog10(p/rstar 1e-6) back to linear coordinates in rstar?
;circxvector=(10^(circxvector)-(1e-6))*rstar
;circyvector=(10^(circyvector)-(1e-6))*rstar

;convert circgridxvector and circgridyvector from rstar back to linear coordinates, i.e. Rsun?
;circxvector=circxvector*rstar/6.96
;circyvector=circyvector*rstar/6.96

;convert circgridxvector and circgridyvector from rstar to mas? NOTE THAT PREVIOUS 2 LINES SHOULD BE COMMENTED!!!!
circxvector=circxvector*(rstar/6.96)/(214.08*dist)
circyvector=circyvector*(rstar/6.96)/(214.08*dist)
circ_GridSpace_mas=[circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]]
;print,'Grid spacing in mas',circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]

END
;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA,lsc,fsc,rstar,dist,pa,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda,$
circxvector,circyvector,circ_griddedData,imginv=imginv,VEL=vel

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
;GETCOLOR is not working anymore...
;colors = GetColor(/Load) 
;!P.Background = colors.white
;!P.Color = colors.black
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF KEYWORD_SET(vel) THEN BEGIN
title='Image at velocity '+vel_str+' km s!E-1!N, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Image at wavelength '+lambda_str+' Angstrom, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-max(circxvector)/2.,max(circxvector)/2.], $
yrange=[-max(circyvector)/2.,max(circyvector)/2.],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
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
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector)/2.,max(circxvector)/2.],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector)/2.,max(circyvector)/2.],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector)/2.,max(circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector)/2.,max(circyvector)/2.]
;draws grid lines through 0,0
PLOTS,[-max(circxvector)/2.,max(circxvector)/2.],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(circyvector)/2.,max(circyvector)/2.],linestyle=1,color=fsc_color('white')

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
xrange=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.], $
yrange=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],xstyle=1,ystyle=1, xtitle='u [m]', $
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
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector)/2.,-max(vis_circyvector)/2.],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.]
;draws grid lines through 0,0
PLOTS,[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],linestyle=1,color=fsc_color('white')

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
xrange=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.], $
yrange=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],xstyle=1,ystyle=1, xtitle='u [m]', $
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
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector)/2.,-max(vis_circyvector)/2.],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.]
;draws grid lines through 0,0
PLOTS,[-max(vis_circxvector)/2.,max(vis_circxvector)/2.],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],linestyle=1,color=fsc_color('white')

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
xrange=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.], $
yrange=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],xstyle=1,ystyle=1, xtitle='u [m]', $
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
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector)/2.,-max(vis_circyvector)/2.],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.]
;draws grid lines through 0,0
PLOTS,[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],linestyle=1,color=fsc_color('white')

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
xrange=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.], $
yrange=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],xstyle=1,ystyle=1, xtitle='u [m]', $
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
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector)/2.,-max(vis_circyvector)/2.],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.]
;draws grid lines through 0,0
PLOTS,[-max(vis_circxvector)/2.,max(vis_circxvector)/2.],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],linestyle=1,color=fsc_color('white')

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

CLOSE,/ALL

filename_ipdata_txt_write='/Users/jgroh/temp/teste_IP.txt'
dir='/Users/jgroh/ze_models/2D_models/irc10420/8/'
;dir='/Users/jgroh/ze_models/2D_models/agcar/200/'
;dir='/Users/jgroh/ze_models/2D_models/examples/WN5_T56000_T84400_M2.5E-05/'
;dir='/Users/jgroh/ze_models/2D_models/HD316/M1/'
;dir='/Users/jgroh/ze_models/2D_models/agcar/417/'
model='a'
;model='1'
filename_ipdata_txt=dir+model+'/IP_DELTA_DATA'             ;correct IP_DELTA
;screwing up to compute the spectrum
;filename_ipdata_txt=dir+model+'/OBS_DELTA_IP_DATA'             ;has the flux data (i.e. I(p)p^2),useful for computing line profiles
;filename_ipdata_txt='/Users/jgroh/temp/OBS_DELTA_IP_DATA'        ;OBS_DELTA
rstar=642. ; in CMFGEN UNITS
;rstar=1500.4
;rstar=785.
dist=2.3 ;in kpc
ZE_READ_OBS_DELTA_TXT,filename_ipdata_txt,rstar,np=np,ndelta1=ndelta1,nos=nos,p=p,delta1_vec=delta1_vec,obs_freq=obs_freq,ipdelta=ipdelta,lambda=lambda
;ZE_WRITE_IPDATA_TXT,ipdata_txt,filename_ipdata_txt_write
pa=61.          ;position angle in degrees; by definition PA=0 towards N, and increase eastwards. USE PA significantly different than 0 (e.g.50) for spherical models
;pa=227

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
Base_obs_irc10420_ut=[54.3,82.7,128.9]

PA_obs=[PA_obs_etacar_2004dec26,PA_obs_etacar_2006apr12,PA_obs_etacar_2006apr16]
Base_obs=[Base_obs_etacar_2004dec26,Base_obs_etacar_2006apr12,Base_obs_etacar_2006apr16]
PA_obs=PA_obs_irc10420_ut
Base_obs=Base_obs_irc10420_ut
base_polarcoord=dblarr(2,n_elements(base_obs))
base_polarcoord[0,*]=(90-Pa_obs)*!PI/180. ;converting PA to radians and to 0=N, increases eastwards
base_polarcoord[1,*]=Base_obs
base_rect_coord = CV_COORD(From_Polar=base_polarcoord, /To_Rect)

;observations INFO
vis_obs_irc10420_ut=[0.9,0.82,0.7] ;by eye

;lambda_val=20582.0     ; wavelength in Angstroms
;lambda0=20586.9    ;He I    ; VACUUM wavelength of the line transition of interest
lambda0=21661.2    ; Br gamma
lambda_ini=21648   ;initial lambda to do calculations 21610
lambda_fin=21680    ;initial lambda to do calculations 21720
;filterwidth=200 ;in Angstroms
;lambda_ini=lambda0-filterwidth/2
;lambda_fin=lambda0+filterwidth/2

lambda_sampling= 1.5     ;sampling in Angstrom ; use 1
nlambda= (lambda_fin-lambda_ini)/lambda_sampling         ;number of wavelengths to compute IMAGE, VIS, PHASE

ZE_CREATE_POLARCOORD_XY_VECTOR,rstar,pa,np,ndelta1,p,delta1_vec,polarcoord=polarcoord,x=x,y=y

specfile='/Users/jgroh/espectros/irc10420/irc10420_8_norm_vac.txt'
ZE_READ_SPECTRA_COL_VEC,specfile,ls,fs
nears = Min(Abs(ls - lambda_ini), indexs)
nears2= Min(Abs(ls - lambda_fin), indexs2)
lsc=ls[indexs:indexs2]
fsc=fs[indexs:indexs2]
vsc=ZE_LAMBDA_TO_VEL(lsc,lambda0)
;normalize flux?
fsc=fsc/fsc[0]
window,15,retain=0
!P.THICK=3
!X.THiCK=3
!Y.THICK=3
!P.CHARTHICK=1.5
!P.FONT=-1

print,SYSTIME()
vis_triplet_wavelength=dblarr(3,nlambda) & phase_triplet_wavelength=vis_triplet_wavelength & cp_triplet_wavelength=dblarr(nlambda) & lambda_vector=dblarr(nlambda)
;vis_image_wavelength=dblarr(1027,1027,nlambda) & phase_image_wavelength=vis_image_wavelength & intens_image_wavelength=vis_image_wavelength 
totalflux=dblarr(1027,nlambda)
for i=0., nlambda-1 do begin
lambda_val=lambda_ini + i*lambda_sampling
lambda_vector[i]=lambda_val
xrangevel=ZE_LAMBDA_TO_VEL([lambda_ini-lambda_sampling,lambda_fin+lambda_sampling],lambda0)
window,15
plot,lsc,fsc,XRANGE=[lambda_ini-lambda_sampling,lambda_fin+lambda_sampling],xstyle=9,ystyle=1,charsize=2,charthick=1.7,XTICKFORMAT='(I6)',/NODATA,YRANGE=[0,5]
plots,lsc,fsc,thick=3,color=FSC_COLOR('black')
nearslambda = Min(Abs(lsc - lambda_val), indexsl)
plots,lsc[indexsl],fsc[indexsl],psym=1,symsize=4,color=FSC_COLOR('red')
AXIS,XAXIS=1,XTICKFORMAT='(I6)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='vel (km/s)',XRANGE=xrangevel,xcharsize=2,charthick=1.7
plots,[lsc(indexsl),lsc(indexsl)],[0,5],color=FSC_COLOR('red'),linestyle=2
ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData,circ_GridSpace_mas=circ_GridSpace_mas
ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA,lsc,fsc,rstar,dist,pa,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda, circxvector,circyvector,circ_griddedData,imginv=imginv,/VEL

;factor=0.01
;circ_griddedData=(circ_griddedData+factor)/(1+factor)
img=circ_griddedData
ZE_COMPUTE_IMAGE_FFT_I_P_DELTA_LAMBDA,rstar,dist,img,lambda_val,circ_GridSpace_mas,visamp=visamp,real=real,phase=phase,vis_circxvector=vis_circxvector,vis_circyvector=vis_circyvector,xcen=xcen,ycen=ycen
;ZE_PLOT_IMAGE_FFT_I_P_DELTA_LAMBDA,base_rect_coord,rstar,dist,img,circxvector,circyvector,pa,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,$
;visamp,real,phase,vis_circxvector,vis_circyvector,xcen,ycen,circ_GridSpace_mas,/VEL

;;computing baseline values for each pixel of the full FT image; works for visibility and phase images
baseline_xloc_all= vis_circxvector[xcen] - vis_circxvector ;reversed since u increases to the left, to be compliant with the general convention
baseline_yloc_all=vis_circyvector - vis_circyvector[ycen]
ZE_RETRIEVE_VISIBILITY_PHASE_CP_TRIPLET_WAVELENGTH,base_rect_coord,baseline_xloc_all,baseline_yloc_all,visamp,phase,vis_triplet=vis_triplet, phase_triple=phase_triplet, cp_triplet=cp_triplet
vis_triplet_wavelength[*,i]=vis_triplet
phase_triplet_wavelength[*,i]=phase_triplet
cp_triplet_wavelength[i]=cp_triplet
;wset,8
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/img/etc_mod111john_2Db_brg_obl32_img'+strcompress(string(i, format='(I04)'), /remove)
;WRITE_PNG, '/Users/jgroh/temp/irc10420_8c_frame_' + STRING(i, FORMAT = "(I4.4)") + '.png', TVRD(True=1)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;wset,13
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/vis/etc_mod111john_2Db_brg_obl32_vis'+strcompress(string(i, format='(I04)'), /remove)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;wset,14
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/phase/etc_mod111john_2Db_brg_obl32_phase'+strcompress(string(i, format='(I04)'), /remove)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)

;wset,15
;file_output='/Users/jgroh/anim_gif/etacar/mod111_john/b/brgamma/spec/etc_mod111john_2Db_brg_obl32_specloc'+strcompress(string(i, format='(I04)'), /remove)
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)

;trying to compute flux spectrum from Ip values
for j=0, 1026. do totalflux[j,i]=int_tabulated(circxvector+min(circxvector),circ_griddedData[j,*])

print,'Finished VIS for lambda:  ', lambda_val
endfor

totalfluxfim=dblarr(nlambda)
for i=0, nlambda-1 do totalfluxfim[i]=int_tabulated(circyvector+min(circyvector),totalflux[*,i])

vel_vector=ZE_LAMBDA_TO_VEL(lambda_vector,lambda0)



;MWRFITS, circ_griddedData,'/Users/jgroh/temp/intens_21615.fits',/ISCALE, /CREATE
;MWRFITS, visamp,'/Users/jgroh/temp/vis_21615.fits',/ISCALE, /CREATE
;MWRFITS, phase,'/Users/jgroh/temp/phase_21615.fits',/ISCALE, /CREATE
;
lambda_val=21661.2
paprof=45. ; PA in degrees
image=visamp
window,2
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile0,baseline_val=baseline_val0
plot, baseline_val0,profile0, xstyle=1, ystyle=1,YMARGIN=[5,5],XRANGE=[0,150]
paprof=paprof+45. ; PA in degrees
ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile45,baseline_val=baseline_val45
plots, baseline_val45,profile45,color=FSC_COLOR('red'),noclip=0
paprof=paprof+45. ; PA in degrees
ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile90,baseline_val=baseline_val90
plots, baseline_val90,profile90,color=FSC_COLOR('blue'),noclip=0
paprof=paprof+45. ; PA in degrees
ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile135,baseline_val=baseline_val135
plots, baseline_val135,profile135,color=FSC_COLOR('green'),noclip=0
paprof=paprof+45. ; PA in degrees
ZE_PLOT_1DVISIBILITY_PA_BASELINE, paprof,image,vis_circxvector,vis_circyvector,circxvector,circyvector,lambda_val,profile=profile180,baseline_val=baseline_val180
plots, baseline_val180,profile180,color=FSC_COLOR('dark green'),noclip=0
plots,base_obs_irc10420_ut[0],vis_obs_irc10420_ut[0],psym=1,symsize=2,color=FSC_COLOR('red')
plots,base_obs_irc10420_ut[1],vis_obs_irc10420_ut[1],psym=1,symsize=2,color=FSC_COLOR('red')
plots,base_obs_irc10420_ut[2],vis_obs_irc10420_ut[2],psym=1,symsize=2,color=FSC_COLOR('red')
;window,4
;plot,lambda_vector,cp_triplet_wavelength,yrange=[-190,190]
resolving_power=15000
res=lambda_val/resolving_power
;
;ZE_SPEC_CNVL,lambda_vector,cp_triplet_wavelength,res,lambda_val,fluxcnvl=cpcnvl
;plots,lambda_vector,cpcnvl,color=FSC_COLOR('red')
;
;filename='/Users/jgroh/espectros/irc10420/IRC10420_VIS12_JOSE.TAB'
;ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=cp2004dec26
;plots,cp2004dec26.field01[2,*]*10000.,cp2004dec26.field01[3,*],color=FSC_COLOR('green')
;
;filename='/Users/jgroh/data/amber/Etacar_P74/BRG/AVG/EtaCar.MR.04-12.BrG.AVG.DP.BL12'
;ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=dp12_2004dec26
;
;filename='/Users/jgroh/data/amber/Etacar_P74/BRG/AVG/EtaCar.MR.04-12.BrG.AVG.DP.BL23'
;ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=dp23_2004dec26
;
;filename='/Users/jgroh/data/amber/Etacar_P74/BRG/AVG/EtaCar.MR.04-12.BrG.AVG.DP.BL31'
;ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=dp31_2004dec26
;
filename='/Users/jgroh/espectros/irc10420/IRC10420_VIS12_BIN11_STEP1.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=vis12_ut
filename='/Users/jgroh/espectros/irc10420/IRC10420_VIS23_BIN11_STEP1.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=vis23_ut
filename='/Users/jgroh/espectros/irc10420/IRC10420_VIS31_BIN11_STEP1.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename,data=vis31_ut

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/irc10420/IRC10420_SPEC.TAB',lobs,fobs
lobs=lobs*10000.
vis_triplet_wavelength_cnvl=vis_triplet_wavelength
window,1
t=dblarr(nlambda)
vsys=73.          ;from humphreys et al. 2002
vhelio=-25.2       ;from ESO skycalc webpage
velshift=vsys-vhelio
fobshelsys=ZE_SHIfT_SPECTRA_VEL(lobs,fobs,-velshift)
vobshelsys=ZE_LAMBDA_TO_VEL(lobs,21661.2)
;velshift=0
for i=0, 2 DO BEGIN 
t[*]=vis_triplet_wavelength[i,*]
t=ZE_SHIfT_SPECTRA_VEL(lambda_vector,t,velshift)
ZE_SPEC_CNVL,lambda_vector,t,res,lambda_val,fluxcnvl=t2
vis_triplet_wavelength_cnvl[i,*]=t2
endfor
;ZE_SPEC_CNVL,lambda_vector,vis_triplet_wavelength[1,*],res,lambda_val,vis_triplet_wavelength_cnvl[1,*]
;ZE_SPEC_CNVL,lambda_vector,vis_triplet_wavelength[2,*],res,lambda_val,vis_triplet_wavelength_cnvl[2,*]
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],noclip=0,yrange=[0,1.1]
plots,lambda_vector,vis_triplet_wavelength_cnvl[1,*],noclip=0
plots,lambda_vector,vis_triplet_wavelength_cnvl[2,*],noclip=0
plots,vis12_ut.field1[2,*]*10000.,vis12_ut.field1[3,*],color=FSC_COLOR('red'),noclip=0
plots,vis23_ut.field1[2,*]*10000.,vis23_ut.field1[3,*],color=FSC_COLOR('green'),noclip=0
plots,vis31_ut.field1[2,*]*10000.,vis31_ut.field1[3,*],color=FSC_COLOR('blue'),noclip=0
vel=55
;vis12_ut_shift=ZE_SHIFT_SPECTRA_VEL(vis12_ut.field1[2,*]*10000.,vis12_ut.field1[3,*],vel)

;
;
window,3
;plot,dp12_2004dec26.field1[2,*]*10000.,dp12_2004dec26.field1[3,*],yrange=[-80,80],ystyle=1,/NODATA
plot, lambda_vector,phase_triplet_wavelength[0,*],yrange=[-80,80],ystyle=1,/NODATA
;;plots,dp12_2004dec26.field1[2,*]*10000.,dp12_2004dec26.field1[3,*],color=FSC_COLOR('red'),noclip=0
;;plots,dp23_2004dec26.field1[2,*]*10000.,dp23_2004dec26.field1[3,*],color=FSC_COLOR('green'),noclip=0
;;plots,dp31_2004dec26.field1[2,*]*10000.,dp31_2004dec26.field1[3,*],color=FSC_COLOR('blue'),noclip=0
plots, lambda_vector,phase_triplet_wavelength[0,*],noclip=0
plots, lambda_vector,phase_triplet_wavelength[1,*],noclip=0
plots, lambda_vector,phase_triplet_wavelength[2,*],noclip=0

xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
set_plot,'ps'
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=2.0
device,/close
device,filename='/Users/jgroh/temp/vis_wavelength.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=[0.16, 0.09, 0.85, 0.78*xwindowsize/ywindowsize]
plots,lambda_vector,vis_triplet_wavelength_cnvl[0,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector,vis_triplet_wavelength_cnvl[1,*],noclip=0,color=FSC_COLOR('green'),linestyle=2
plots,lambda_vector,vis_triplet_wavelength_cnvl[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=2
plots,vis12_ut.field1[2,*]*10000.,vis12_ut.field1[3,*],color=FSC_COLOR('red'),noclip=0
plots,vis23_ut.field1[2,*]*10000.,vis23_ut.field1[3,*],color=FSC_COLOR('green'),noclip=0
plots,vis31_ut.field1[2,*]*10000.,vis31_ut.field1[3,*],color=FSC_COLOR('blue'),noclip=0
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0),ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)]

device,/close

set_plot,'x'


;t2=cp2004dec26.field01[3,*]
;t=dp12_2004dec26.field1[3,*]+dp23_2004dec26.field1[3,*]-dp31_2004dec26.field1[3,*]


;pastring=string(pa,format='(I03)')
;file='/Users/jgroh/temp/cp_model_'+model+pastring+'_2004dec26'
;ext='.txt'


;ZE_WRITE_SPECTRA_COL_VEC,file+ext,lambda_vector,cp_triplet_wavelength
;ZE_WRITE_SPECTRA_COL_VEC,file+'_R1500'+ext,lambda_vector,cpcnvl

;lambda0=21661.2    ; Br gamma
;lambda0=2371.2 
;;lambda_ini=21610    ;initial lambda to do calculations
;;lambda_fin=21720    ;initial lambda to do calculations
;filterwidth=2 ;in Angstroms
;lambda_ini=lambda0-filterwidth/2
;lambda_fin=lambda0+filterwidth/2
;lambda_sampling=0.5     ;sampling in Angstrom
;nlambda2= (lambda_fin-lambda_ini)/lambda_sampling         ;number of wavelengths to compute IMAGE, VIS, PHASE
;lambda_vector2=dblarr(nlambda2)
;intens_broadbandimage=dblarr(1027,1027)
;intens_broadbandimage[*,*]=0
;for i=0., nlambda2-1 do begin
;lambda_val=lambda_ini + i*lambda_sampling
;lambda_vector2[i]=lambda_val
;ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda=intens2d_lambda,$
;circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData,circ_GridSpace_mas=circ_GridSpace_mas
;ZE_PLOT_IMAGE_I_P_DELTA_LAMBDA,rstar,dist,pa,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda, circxvector,circyvector,circ_griddedData,imginv=imginv
;
;print,'Finished VIS for lambda:  ', lambda_val
;;intens_broadbandimage=intens_broadbandimage+circ_griddedData
;endfor
;print,SYSTIME()
;;MWRFITS, cont_124,'/Users/jgroh/temp/intens_124.fits',/ISCALE, /CREATE
;;MWRFITS, visamp,'/Users/jgroh/temp/vis_21615.fits',/ISCALE, /CREATE
;;MWRFITS, phase,'/Users/jgroh/temp/phase_21615.fits',/ISCALE, /CREATE
;
!P.Background = fsc_color('white')
LOADCT,13
xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
;;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize
tvimage,imginv,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
;wdelete,!d.window
;wset,8
;pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)


xsize=900
ysize=760

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/img_true.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
   LOADCT, 13
 
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
   
   
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF KEYWORD_SET(vel) THEN BEGIN
title='Image at velocity '+vel_str+' km s!E-1!N, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Image at wavelength '+lambda_str+' Angstrom, i=90!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-max(circxvector)/2.,max(circxvector)/2.], $
yrange=[-max(circyvector)/2.,max(circyvector)/2.],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13
tvimage,pic2, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
nd=2
colorbar_ticknames_str = [number_formatter(0.00,decimals=nd), number_formatter(max(circ_griddedData)*.2,decimals=nd), number_formatter(max(circ_griddedData)*.4,decimals=nd),$
number_formatter(max(circ_griddedData)*.6,decimals=nd), number_formatter(max(circ_griddedData)*.8,decimals=nd),number_formatter(max(circ_griddedData),decimals=nd)]
LOADCT,13
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector)/2.,max(circxvector)/2.],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector)/2.,max(circyvector)/2.],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector)/2.,max(circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector)/2.,max(circyvector)/2.]
;draws grid lines through 0,0
PLOTS,[-max(circxvector)/2.,max(circxvector)/2.],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(circyvector)/2.,max(circyvector)/2.],linestyle=1,color=fsc_color('white')

device,/close

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
;wset,8
;pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)


set_plot,'ps'
device,/close
device,filename='/Users/jgroh/temp/vis_truecolor.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
   
   LOADCT, 13

xsize=900
ysize=760

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
xrange=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.], $
yrange=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],xstyle=1,ystyle=1, xtitle='u [m]', $
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
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[max(vis_circyvector)/2.,-max(vis_circyvector)/2.],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(vis_circyvector)/2.,max(vis_circyvector)/2.]
;draws grid lines through 0,0
PLOTS,[max(vis_circxvector)/2.,-max(vis_circxvector)/2.],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(vis_circyvector)/2.,max(vis_circyvector)/2.],linestyle=1,color=fsc_color('white')

device,/close

!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0

set_plot,'x'
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
END
