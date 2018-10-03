PRO ZE_CCD_TRACE_IMAGE_RECTIFIFY, image, star_center,specastrom,centervals,xnodescen,ynodescen, image_rect,no_trace_auto=no_trace_auto
;interactively trace and rectify a 2D spectrum for posterior 1D extraction
;includes option for automatic rectification in non-interactive mode, e.g. for lamp spectrum -- in that case no trace is done.
;this procedure actually takes a relatively good fraction of the total reduction time -- is it possible to make it more efficient?

spatindex=(size(image))[1]
specindex=(size(image))[2]
image_Rect=dblarr(spatindex,specindex)
;shifting each column in the spatial direction 

IF KEYWORD_SET(no_trace_auto) THEN BEGIN 
  spatoffset=centervals-star_center ;centervals and star_center have to be entered as input, and previously computed with this routine with no_trace_auto=0 for the science target
ENDIF ELSE BEGIN 

  ;1st finding centroids using gaussians
  ;image=ROTATE(image,4)

  y=findgen(spatindex)
  center=dblarr(specindex)
  fwhm_spat=dblarr(specindex) 

  for i=0., specindex-1 do begin
  fit=gaussfit(y,image[*,i],A,nterms=5)
  center[i]=A[1]
  fwhm_spat[i]=2*SQRT(2*ALOG(2))*A[2]*0.16
  endfor

  ;2nd sigma clipping centroids around mean value in order to remove spikes
  meanclip,center,mean_val,sigma_val
;  print,sigma_val
  for i=0., specindex-1 do begin
  if center[i] lt (mean_val - 3*sigma_val) then begin
  center[i]=mean_val
  endif
  if center[i] gt (mean_val + 3*sigma_val) then begin
  center[i]=mean_val
  endif
  endfor
  

  ; 3rd fitting centroids
  x=indgen(specindex)
  nnodes=8.
  xnodescen=indgen(nnodes)*(specindex-300.)/(nnodes-1.) +150.
  ynodescen=xnodescen
  for i=0, nnodes -1 do ynodescen[i]=MEDIAN(center[xnodescen[i]-30:xnodescen[i]+30])
  ;for i=0, nnodes -1 do xnodescen[i]=      ;[500,1000,1500,2000,2500,3000,3500,4000,4500] 
  line_norm,x,center,centernorm,centervals,xnodescen,ynodescen ;SPLINE FIT INTERACTIVE, BETTER CHOICE
  ;centernorm is the NORMALIZED result! if we are interested in spectro-astrometry, we need to comput center - centervals
  specastrom=center-centervals 
        ;

  ;convolve with a gaussian with a fwhm in the spectral direction?
  ;fwhm=2.35*1.1
  fwhm_spatval=30.
  ;center2=cnvlgauss(center,fwhm=fwhmspatval)
        
  ; 4th finding offsets which can be relative to a given  line (arbitrary) 410 (i.e. 411) or to the mean centroid value
  ;
  spatoffset=centervals-star_center
ENDELSE
  ;
;  ;plotting routines for debugging
;  LOADCT,0
;  window,8
;  plot,center 
;  oplot,yfit2,color=fsc_color('blue'),noclip=0,linestyle=1,thick=1.9 
;  ;oplot,center2,color=fsc_color('red')
;  oplot,centervals,color=fsc_color('green')

;shifting each column by the offset (i.e. shifting in spatial direction) 
prel=dblarr(specindex)  
for i=0, spatindex - 1 do begin
  prel[*]=image[i,*]
  prel=shiftf(prel,-1.*spatoffset[i])
  image_rect[i,*]=prel
endfor

END