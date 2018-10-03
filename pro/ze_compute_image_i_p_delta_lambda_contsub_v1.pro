PRO ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA_CONTSUB_V1,circ_griddedData_cont,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,circ_GridSpace_mas,intens2d_lambda=intens2d_lambda,$
circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData,PIP=PIP,norm=norm

;do continuum subtraction, uses as input a continuum image *array*, i.e not byscl (circ_griddedData_cont), computed with ZE_COMPUTE_IMAGE_I_P_DELTA_LAMBDA_V2

;create a monocromatic vector of intensities (i.e. for one frequency from the OBS_DELTA vector) for a given lambda_val
intens2d_lambda=DBLARR(np*ndelta1)

near = Min(Abs(lambda - lambda_val), index)

  for i=0.,(np*ndelta1)-1. do begin
    intens2d_lambda[i]=ipdelta[index]
    index=index+nos
  endfor


;for each lambda, normalize the intensity by the maximum value for that particular lambda?
;comment line below and screw up the computation of the spectrum; if normalizing does not work! JGH 2009 April 13 10pm
;IF KEYWORD_SET(NORM) THEN intens2d_lambda=intens2d_lambda/max(intens2d_lambda)

;for each lambda, normalize the intensity by the maximum value overall?
;IF KEYWORD_SET(NORM) THEN 
;intens2d_lambda=intens2d_lambda/1.6e-4

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

circ_gridSpace = [circ_GridSpace_mas[0]*mas_to_rstar,circ_GridSpace_mas[1]*mas_to_rstar] ; space in x and y directions TESTING
factor=circ_GridSpace_mas[0]*mas_to_rstar*(pix-1.)/(2.*max(X2))

circ_griddedData = TRIGRID(x2, y2, intens2d_lambda2, circtriangles, circ_gridSpace,[MIN(x2)*factor, MIN(y2)*factor, MAX(x2)*factor, max(y2)*factor], XGrid=circxvector, YGrid=circyvector); WOKRING
;print,'Grid spacing in rstar',circ_gridSpace  ;grid spacing in rstar
;circ_gridSpace_meter=circ_gridSpace*(rstar*1e8)
;print,'Grid spacing in meters',circ_gridSpace_meter  ;grid spacing in meters

;gauss = PSF_GAUSSIAN( Npixel=1027, FWHM=[20,20], CENTROID=[513,513],/NORMAL,/DOUBLE )
;gauss=gauss/max(gauss)
;
;circ_griddedData=circ_griddedData-gauss
;t=where(circ_griddedData lt 0)
;circ_griddedData[t]=0

pixcut=0 ; number of pixels cut from each side, i.e. total nubmer of removed pixels is equal to pixcut*2.

circ_griddedData=circ_griddedData[pixcut:(pix-1-pixcut),pixcut:(pix-1-pixcut)]

circxvector=circxvector[pixcut:(pix-1-pixcut)]
circyvector=circyvector[pixcut:(pix-1-pixcut)]

IF KEYWORD_SET(PIP) THEN BEGIN
for i=0, n_elements(circxvector) -1 DO BEGIN
 for j=0, n_elements(circyvector) -1 DO BEGIN
   circ_griddedData[i,j]=circ_griddedData[i,j]*sQRT(circxvector[i]^2+circyvector[j]^2)
ENDFOR
ENDFOR
ENDIF
;do continuum subtraction?
circ_griddedData=circ_griddedData-circ_griddedData_cont
;atv,circ_griddedData
;block the inner region
;circ_griddedData=circ_griddedData

;convert circgridxvector and circgridyvector from rstar to mas? NOTE THAT PREVIOUS 2 LINES SHOULD BE COMMENTED!!!!
circxvector=circxvector*(rstar/6.96)/(214.08*dist)
circyvector=circyvector*(rstar/6.96)/(214.08*dist)
;circ_GridSpace_mas=[circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]]
;print,'Grid spacing in mas',circxvector[2]-circxvector[1],circyvector[2]-circyvector[1]

END