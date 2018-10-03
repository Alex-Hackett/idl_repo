PRO ZE_LAMP_FIND_SHIFT_CENTROID_ALL_REFERENCE_LINES_AUTO,lampspec,lampspecorig,xcenorig,identify_pixwindow,centroid_fit_window,epsilon,shiftxcenvec

shiftxcenvec=dblarr(n_elements(xcenorig))
for i=0, n_elements(xcenorig)-1 DO BEGIN
 ZE_LAMP_FIND_SHIFT_CENTROID_INDIVIDUAL_REFERENCE_LINE_AUTO,i,lampspec,lampspecorig,xcenorig,identify_pixwindow,centroid_fit_window,epsilon,shiftxcen
 shiftxcenvec[i]=shiftxcen
ENDFOR


END