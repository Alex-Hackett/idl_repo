PRO ZE_FIND_CENTROID_AUTO,peaks,index,flux,centroid_fit_window,xcen,ycen,chisqvec,sigmafitvec,centeringvec,keep,chisq_threshold=chisq_threshold,sigmafit_threshold=sigmafit_threshold,centering_threshold=centering_threshold
;finds the centroid for a list of peaks in a spectrum -- needs lambda(or index) and flux as input, as well as the size of the centroid fit window aroud the peak (in pix).
;found centroids have to satisfy the 3 thresholds to keep a certain centroid value : LT chisq_threshold AND LT sigmafit_threshold AND LT centering_threshold 

  ;determines the size of the spectral region around the line that is to be used for finding the centroid
  ;done to be user proof -- can handle lines very close to edge of the detector, or the user setting a node out of the detector range

  xcen=dblarr(N_elements(peaks))
  ycen=dblarr(N_elements(peaks))
  chisqvec=dblarr(N_elements(peaks))
  sigmafitvec=dblarr(N_elements(peaks))
  centeringvec=dblarr(N_elements(peaks))  
  
  xcenmin=peaks - centroid_fit_window
  xcenmax=peaks + centroid_fit_window
  minx_index=WHERE(xcenmin lt 0,countmin)
  maxx_index=WHERE(xcenmax gt n_elements(index)-1,countmax)
  IF countmin NE 0 THEN xcenmin(where(xcenmin lt 0))=0
  IF COUNTMAX NE 0 THEN xcenmax(where(xcenmax gt n_elements(index)-1))=n_elements(index)-1

  for i=0, n_elements(peaks) -1 DO BEGIN
  fit=gaussfit(index[xcenmin[i]:xcenmax[i]],flux[xcenmin[i]:xcenmax[i]],A,chisq=chisqt,sigma=sigmafit)
  xcen[i]=A[1]
  ycen[i]=A[0] 
  chisqvec[i]=chisqt
  sigmafitvec[i]=sigmafit[1]
  centeringvec[i]=xcen[i]-peaks[i]
  ENDFOR
  
  IF KEYWORD_SET(chisq_threshold) THEN BEGIN
   keep=where((chisqvec lt chisq_threshold*MEDIAN(chisqvec)) AND  (sigmafitvec LT sigmafit_threshold) AND (abs(centeringvec) LT centering_threshold))
   xcen=(temporary(xcen))(keep)
   ycen=(temporary(ycen))(keep)
  ENDIF
  
END