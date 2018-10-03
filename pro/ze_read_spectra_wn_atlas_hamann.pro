PRO ZE_READ_SPECTRA_WN_ATLAS_HAMANN,file,l,f
;read spectra from WN ATLAS from Hamann+ 1996
dir='/Users/jgroh/espectros/wnatlas_hamann/'

readcol,dir+file,l1,f1,l2,f2,l3,f3,skipline=3
l=dblarr(n_elements(l1)*3)
f=l
j=0
for i=0,n_elements(l1) -1 DO BEGIN
  l[j]=l1[i]
  l[j+1]=l2[i]
  l[j+2]=l3[i] 
  f[j]=f1[i]
  f[j+1]=f2[i]
  f[j+2]=f3[i]
j=j+3   
endfor  
END