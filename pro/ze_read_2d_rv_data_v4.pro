
PRO ZE_CREATE_POLARCOORD_XY_VECTOR_V2,pa,np,ndelta1,p,delta1_vec,polarcoord=polarcoord,x=x,y=y

;creating matrix of size (2,np*ndelta1) to store the pairs of (NP,DELTA1_VEC) for further conversion to x,y
polarcoord=dblarr(2,np*ndelta1)

;counters
l=0
r=1
m=0
s=1

;changing slightly the value 2pi of the last delta1_vec point in order to avoid duplicated points; might not be necessary.
;commenting line below for AG CAR; do not comment for Eta Car
;delta1_vec[ndelta1-1]=6.29

;converting PA to radians
pa_rad=pa*!PI/180.

for j=0., (np*ndelta1-1) do begin ;running through all the lines of the matrix
  if j ge (np*r) then begin
    l=l+1
    r=r+1
  endif
  polarcoord(0,j)=delta1_vec[l]+pa_rad    ;positions polarcoord(0,*)=values of beta, working!!! now including an arbitrary PA    
  polarcoord(1,j)=p[m]         ;positions polarcoord(1,*)=values of p, working!!!
  m=m+1
  if m gt (np-1) then begin
    m=0
  endif
endfor


;getting x,y coordinates, where 0,0 is center the center of the star.
rect_coord = CV_COORD(From_Polar=polarcoord, /To_Rect)
x=rect_coord(0,*)
y=rect_coord(1,*)
END

;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_COMPUTE_IMAGE_DENCON_X_Y,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,den,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData

;create a monocromatic vector of intensities (i.e. for one frequency from the OBS_DELTA vector) for a given lambda_val
intens2d_lambda=DBLARR(np*ndelta1)

near = Min(Abs(lambda - lambda_val), index)

;for i=0.,(np*ndelta1)-1. do begin
;intens2d_lambda[i]=ipdelta[index]  ;only density contrast
;index=index+nos
;endfor

r=1.
m=0
for i=0.,(np*ndelta1)-1. do begin
        if i eq np*r THEN BEGIN
        m=0
        r=r+1
        ENDIF
intens2d_lambda[i]=ipdelta[index]*den[m]  ;full density
index=index+nos
m=m+1
endfor



;for each lambda, normalize the intensity by the maximum value for that particular lambda?
;comment line below and screw up the computation of the spectrum; if normalizing does not work! JGH 2009 April 13 10pm
;intens2d_lambda=intens2d_lambda/max(intens2d_lambda)

;for each lambda, normalize the intensity by the maximum value overall?
;intens2d_lambda=intens2d_lambda/max(ipdelta)
;x=x+MAX(X)
;y=y+MAX(y)
;trying to correct for AG CAr (March 2 2009)
GRID_INPUT,x,y,intens2d_lambda,xsorted,ysorted,intens2d_lambdasorted
x2=xsorted
y2=ysorted
intens2d_lambda2=intens2d_lambdasorted

x=x2
y=y2
intens2d_lambda=intens2d_lambda2
;interpolate the data. One has to use TOLERANCE in order to avoid co-linear points
TRIANGULATE,x,y,circtriangles, circboundaryPts,TOLERANCE=1e-10

;changing implementantion of factor to always use the same scale in mas for different models or distances, and thus the same sampling in the visiiblity images
;for irc 10420, visibility computation:circ_GridSpace_mas=0.08.
;factor=0.06 ;best for image;40   ;factor to zoom out of the image              ;BEST for IRC 10420 image is factor=0.06 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
;factor=1.18;                                                      ;BEST for IRC 10420 vis is factor=1.18 for model 15 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
;factor=0.40;                                                      ;BEST for IRC 10420 vis is factor=0.40 for model 19 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
pix=1027.                                                          ; BEST 1027 
;mas_to_rstar=(214.08*dist)/(rstar/6.96)
mas_to_rstar=1.
print,circ_GridSpace_mas
circ_gridSpace = [circ_GridSpace_mas[0]*mas_to_rstar,circ_GridSpace_mas[1]*mas_to_rstar] ; space in x and y directions TESTING
factor=circ_GridSpace_mas[0]*mas_to_rstar*(pix-1.)/(2.*max(X2))
print,factor
circ_griddedData = TRIGRID(x, y, intens2d_lambda, circtriangles, circ_gridSpace,[MIN(x2)*factor, MIN(y2)*factor, MAX(x2)*factor, max(y2)*factor], XGrid=circxvector, YGrid=circyvector); WOKRING

END
;--------------------------------------------------------------------------------------------------------------------------;----------------------------------------------------------------------

PRO ZE_PLOT_IMAGE_DENCON_X_Y,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda,$
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

circ_griddedData=alog10(circ_griddedData)
a=min(circ_griddedData,/NAN)
b=max(circ_griddedData,/NAN)
a=-21
b=-13
print,a,b
img=bytscl(circ_griddedData,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
;img=bytscl(circ_griddedData,MAX=1.0); byte scaling the image for display purposes with tvimage
;log
;img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img

;plotting in window
ysize=500
xsize=1000
window,8,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
;GETCOLOR is not working anymore...
;colors = GetColor(/Load) 
;!P.Background = colors.white
;!P.Color = colors.black
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
inc_str=''
pa_str=''
vel_Str=''
lambda_str=''
IF KEYWORD_SET(vel) THEN BEGIN
title='Image at velocity '+vel_str+' km s!E-1!N, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDIF ELSE BEGIN
title='Image at wavelength '+lambda_str+' Angstrom, i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo '
ENDELSE

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-max(circxvector),max(circxvector)], $
yrange=[min(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='X (AU)', $
ytitle='Z (AU)', /NODATA, Position=[0.16, 0.15, 0.85, 0.84], title='Density [g/cm^3]'
LOADCT, 5
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
;colorbar_ticknames_str = [number_formatter(0.00,decimals=nd), number_formatter(max(circ_griddedData)*.2,decimals=nd), number_formatter(max(circ_griddedData)*.4,decimals=nd),$
;number_formatter(max(circ_griddedData)*.6,decimals=nd), number_formatter(max(circ_griddedData)*.8,decimals=nd),number_formatter(max(circ_griddedData),decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.15, 0.92, 0.84]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[min(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[min(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[min(circyvector),max(circyvector)]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

END
;--------------------------------------------------------------------------------------------------------------------------;----------------------------------------------------------------------

$MAIN CODE
;
;PRO ZE_READ_2D_RV_DATA_V4
;trying to make it work for any generic value of ND and beta
close,/all

;OK, working and reading well RV_DATA!

;defines file RV_DATA
;rv_data='/Users/jgroh/ze_models/2D_models/takion/hd45166/106_copy/6/RV_DATA'
rv_data='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/cut_v3/h/RV_DATA'
openR,lun,rv_data,/GET_LUN     ; open file without writing

;set text string variables (scratch)
desc1=''
desc2=''

;find the values of ND and beta
readf,lun,FORMAT='(1x,I,10x,A23)',ND,desc1
readf,lun,FORMAT='(1x,I,10x,A22)',beta,desc2
N=ND*beta

;set vector sizes as ND
r1=dblarr(ND) & betaang=dblarr(beta) & radvel=dblarr(ND*beta) & azivel=radvel & betvel=radvel & dencon=radvel
denconbeta=dblarr(beta) & betadeg=betaang & denconrbeta=dblarr(ND,beta) & denconr=dblarr(ND)

;As long as the values of ND and beta are known, we can read out the rest of the file.
;Current format only valid for ND=40 and beta=11, will have to adjust the way to read RV_DATA
;        for other values of ND and beta.

readf,lun,FORMAT='(A23)',desc1 ;those lines are reading blank or text values
readf,lun,FORMAT='(A23)',desc1

;read values of r

READF,lun,r1

readf,lun,FORMAT='(A23)',desc1 ;those lines are reading blank or text values
readf,lun,FORMAT='(A23)',desc1 ;those lines are reading blank or text values

;read values of beta (i.e. angles)
READF,lun,betaang

readf,lun,FORMAT='(A23)',desc1
readf,lun,FORMAT='(A23)',desc1

;read values of the radial velocity as a function of r and beta
READF,lun,radvel

readf,lun,FORMAT='(A23)',desc1
readf,lun,FORMAT='(A23)',desc1

;read values of the azimuthal velocity as a function of r and beta
READF,lun,azivel

readf,lun,FORMAT='(A23)',desc1
readf,lun,FORMAT='(A23)',desc1

;read values of the beta velocity as a function of r and beta
READF,lun,betvel

readf,lun,FORMAT='(A23)',desc1
readf,lun,FORMAT='(A23)',desc1

;read values of the density contrast (in comparison with the spherical wind) as a function of r and beta
READF,lun,dencon

;Release the logical unit number and close the fortran file.  
FREE_LUN, lun  

;in the end of the reading we have r1, betaang, radvel, azivel, betvel and dencon with the quantities.

;compute density contrast as a function of betaang
i=0
for j=0,beta-1 do begin
denconbeta[j]=dencon[i]
i=i+40
endfor

;compute density contrast as a function of r
i=0
for j=0,ND-1 do begin
denconr[j]=dencon[j]
i=i+11
endfor


;convert betaang to degrees, which is then stored in betadeg
betadeg=180*betaang/3.141593

rvtj='/Users/jgroh/ze_models/etacar_john/mod_111/RVTJ'
ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,chiross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
    completion_of_model,program_date,was_t_fixed,species_name_con

;taking clumping into account:
denclump=den*clump

;artificially dividing by 4 to match the assumed value of the SPH simulations
den=denclump/4.

r1=r1/(6.96*204.8)

rstar=r1[ND-1]
lambda0=6560.
lambda_val=6555
lambda=[6560,6566]
dist=2.
nos=1.
circ_GridSpace_mas=[0.3,0.3]
circ_GridSpace_mas=circ_GridSpace_mas
pa=0.
ZE_CREATE_POLARCOORD_XY_VECTOR_V2,pa,ND,beta,r1,betaang,polarcoord=polarcoord,x=x,y=y
;x=
ZE_COMPUTE_IMAGE_DENCON_X_Y,pa,rstar,dist,lambda_val,lambda0,lambda,ND,beta,nos,dencon,r1,betaang,x,y,den,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData
ZE_PLOT_IMAGE_DENCON_X_Y,rstar,dist,pa,inc_str,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,intens2d_lambda, circxvector,circyvector,circ_griddedData,imginv=imginv,/VEL


end
