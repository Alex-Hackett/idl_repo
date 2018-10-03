;PRO ZE_WORK_ASTROMETRY_UVES
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
dataa2=MRDFITS('/Users/jgroh/Downloads/uF12_0020.fits',1,header1)
dataa2=MRDFITS('/Users/jgroh/Downloads/uD51_0100.fits',1,header1)
crval1=fxpar(header1,'CRVAL1')
cdelt1=fxpar(header1,'CDELT1')
sizelam=(size(dataa2))[1]
sizespat=(size(dataa2))[2]


lambda=dblarr(sizelam)
for k=0., sizelam-1 do lambda[k]=crval1 + (k*cdelt1)


;cropping dataa2 between index1 and index2?
index1=38000.
index2=46000.
index1=47000.
index2=57500.
index1=12000.
index2=27000.
;index1=2000.
;index2=7000.
dataa2=dataa2[index1:index2,*]
lambda=lambda[index1:index2,*]


;shifting each column in the spatial direction 
  ;1st finding centroids using gaussians
  l=(size(dataa2))[1]
  s=(size(dataa2))[2]
  y=findgen(s)
  center=dblarr(l)
  fwhm_spat=dblarr(l) 
  ;
  ;xgaussfit,y,dataa2[row,*]
  for i=0., l-1 do begin
  fit=gaussfit(y,dataa2[i,*],A)
  center[i]=A[1]
  fwhm_spat[i]=2*SQRT(2*ALOG(2))*A[2]*0.085
  endfor

  ;2nd sigma clipping centroids around mean value in order to remove spikes DON'T DO THAT IF INTERESTED IN SPECTROASTROMETRY! OR SET SIGMA_VAL TO A VERY HIGH numBER
  meanclip,center,mean_val,sigma_val
  print,sigma_val
  sigma_val=10.0
  for i=0., l-1 do begin
  if center[i] lt (mean_val - 3*sigma_val) then begin
  center[i]=mean_val
  endif
  if center[i] gt (mean_val + 3*sigma_val) then begin
  center[i]=mean_val
  endif
  endfor
  
  ;3rd manually replacing the first 7 pixels by crude linear interpolation in order to remove the influence of the teluric line
        ;
  for i=0, 6 do begin
  center[i]=center[7]+ ((7-i)*(center[8]-center[7]))
  endfor
  
  ; 3rd fitting centroids
  x=indgen(l)
  yfit2 = poly_fit2(x, center, 2)  ;LINEAR FIT
  line_norm,x,center,centernorm,centervals,xnodescen,ynodescen ;SPLINE FIT INTERACTIVE, BETTER CHOICE
        
  ; 4th finding offsets which can be relative to a given  line (arbitrary) 410 (i.e. 411) or to the mean centroid value
  ;
  image_center=fix((size(dataa2))[2]/2.)
  spatoffset=centervals-image_center
 
  ;
  ;plotting line centroid for debugging
  LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
  window,8
  plot,center , yrange=[image_center-2,image_center+8]
  oplot,yfit2,color=fsc_color('blue'),noclip=0,linestyle=1,thick=1.9 
  oplot,centervals,color=fsc_color('green')

  ;shifting each column by the offset (i.e. shifting in spatial direction)  ; shifting also the lambda IMAGE for consistency (JHG 09 April 09, 12 21 pm)
  prel=dblarr((size(dataa2))[2])  
  prel2=prel
  prel3=prel
  for i=0, (size(dataa2))[1] - 1 do begin
  prel[*]=dataa2[i,*]
  prel=shiftf(prel,-1.*spatoffset[i])
  dataa2[i,*]=prel
  endfor
lineplot,lambda,(center-centervals)*0.18
lineplot,lambda,dataa2[*,32]/166.
END