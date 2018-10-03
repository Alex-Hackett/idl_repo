PRO ZE_LAMP_FIND_SHIFT_CENTROID_INDIVIDUAL_REFERENCE_LINE_AUTO,i,lampspec,lampspecorig,xcenorig,identify_pixwindow,centroid_fit_window,epsilon,shiftxcen

index=FINDGEN(n_elements(lampspecorig))*1D0

xmin=xcenorig[i]-identify_pixwindow
xmax=xcenorig[i]+identify_pixwindow

minx_index=WHERE(xmin lt 0,countmin)
maxx_index=WHERE(xmax gt n_elements(index)-1,countmax)
IF countmin NE 0 THEN xmin(where(xmin lt 0))=0
IF COUNTMAX NE 0 THEN xmax(where(xmax gt n_elements(index)-1))=n_elements(index)-1

;first find peaks corresponding to spectral lines in the lamp and reference lamp spectra
peakso=ze_peaks(lampspecorig(xmin:xmax),3)
peaksn=ze_peaks(lampspec(xmin:xmax),3)

;then find centroids corresponding to the peaks
ZE_FIND_CENTROID_AUTO,peakso,index(xmin:xmax),lampspecorig(xmin:xmax),centroid_fit_window,xceno,yceno,chisqveco,sigmafitveco,centeringveco
ZE_FIND_CENTROID_AUTO,peaksn,index(xmin:xmax),lampspec(xmin:xmax),centroid_fit_window,xcenn,ycenb,chisqvecn,sigmafitvecn,centeringvecn

;compute the difference vectors -- remove the 0th elementh of both arrays as the correspond to the last element of the array which was shuffled to the first element
diffxceno=shift(xceno,1)-xceno
diffxcenn=shift(xcenn,1)-xcenn
remove,0,diffxceno,diffxcenn

;find the matches between the centroid values of the two spectra within epsilon
match,diffxceno,diffxcenn,subdiffxceno,subdiffxcenn,count=count,epsilon=epsilon

;compute the shift as the median of the difference between the centroid positions -- if count=0 (i.e. no match) then shiftxcen=-9999. is returned 

  IF count eq 0 THEN shiftxcen=-9999. ELSE shiftxcen=MEDIAN(xcenn(subdiffxcenn))-MEDIAN(xceno(subdiffxceno))

;fOR debugging: print values
;
;print,'xcenn'
;print,xcenn
;print,''
;print,'xceno'
;print,xceno
;print,''
;print,'diffxcenn'
;print,diffxcenn
;print,''
;print,'diffxceno'
;print,diffxceno
;print,''
;print,'count'
;print,count
;print,''
;print,'xcenn(subdiffxcenn)'
;IF count GT 0 THEN print,xcenn(subdiffxcenn) ELSE print,'no match'
;print,''
;print,'xceno(subdiffxceno)'
;IF count GT 0 THEN print,xceno(subdiffxceno) ELSE print,'no match'
;print,''
;print,'shiftxcen'
;print,shiftxcen
;print,''
END