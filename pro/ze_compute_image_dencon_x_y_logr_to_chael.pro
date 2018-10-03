;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_COMPUTE_IMAGE_DENCON_X_Y_LOGR_TO_CHAEL,pa,rstar,dist,lambda_val,lambda0,lambda,np,ndelta1,nos,ipdelta,p,delta1_vec,x,y,den,circ_GridSpace_mas,intens2d_lambda,$
circxvector,circyvector,circ_griddedData

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

x=alog10(x2)
y=alog10(y2)
intens2d_lambda=intens2d_lambda2
;interpolate the data. One has to use TOLERANCE in order to avoid co-linear points
TRIANGULATE,x,y,circtriangles, circboundaryPts,TOLERANCE=1e-10

;changing implementantion of factor to always use the same scale in mas for different models or distances, and thus the same sampling in the visiiblity images
;for irc 10420, visibility computation:circ_GridSpace_mas=0.08.
;factor=0.06 ;best for image;40   ;factor to zoom out of the image              ;BEST for IRC 10420 image is factor=0.06 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
;factor=1.18;                                                      ;BEST for IRC 10420 vis is factor=1.18 for model 15 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
;factor=0.40;                                                      ;BEST for IRC 10420 vis is factor=0.40 for model 19 for p=p-1, pix=1027 (DO NOT CHANGE THAT! INTENSIVE TESTS WERE MADE!)
pix=1024.                                                          ; BEST 1027 
;mas_to_rstar=(214.08*dist)/(rstar/6.96)
mas_to_rstar=1.
print,circ_GridSpace_mas
circ_gridSpace = [circ_GridSpace_mas[0]*mas_to_rstar,circ_GridSpace_mas[1]*mas_to_rstar] ; space in x and y directions TESTING
factor=circ_GridSpace_mas[0]*mas_to_rstar*(pix-1.)/(2.*max(X2))
print,factor
circ_griddedData = TRIGRID(x, y, intens2d_lambda, circtriangles, alog10(circ_gridSpace),[MIN(x2)*factor, MIN(y2)*factor, MAX(x2)*factor, max(y2)*factor], XGrid=circxvector, YGrid=circyvector); WOKRING
help,circ_griddedData
i1=REVERSE(TRANSPOSE(circ_griddedData))
i2=TRANSPOSE(circ_griddedData)
circ_GriddedData=ROT([i1[0:pix/2 -1,*],i2[1:pix/2,*]],90,/INTERP)

END
;--------------------------------------------------------------------------------------------------------------------------;----------------------------------------------------------------------
