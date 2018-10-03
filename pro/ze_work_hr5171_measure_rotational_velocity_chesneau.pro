;PRO ZE_WORK_HR5171_MEASURE_ROTATIONAL_VELOCITY_CHESNEAU
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/chesneau_hr5171A_YHG/Spectrum_1992.dat',l,f
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/hr5171a/hr5171_com_G8.txt',l,f
l_ini=6660.0
l_fin=6667.0
l0=6662.431
;l_ini=6100.0
;l_fin=6104.0
;l0=6102.0
;l_ini=6063.0
;l_fin=6066.3
;l0=6064.53
;l_ini=6216.8
;l_fin=6219.95
;l0=6218.4765
;l_ini=6188.95
;l_fin=6192.45
;l0=6190.7
l_ini=6659.0
l_fin=6665.0
l0=6662.431
!P.background=fsc_color('white')
indexini=findel(l_ini,l)
indexfin=findel(l_fin,l)
lcut=l[indexini:indexfin]
fcut=f[indexini:indexfin]
fcutinvnorm=(1-fcut)/max(1-fcut)

;lineplot,l[indexini:indexfin],f[indexini:indexfin]
;lineplot,lcut,fcutinvnorm

v=ZE_LAMBDA_TO_VEL(l,l0)
vcut=ZE_LAMBDA_TO_VEL(lcut,l0)

fcuti=rebin(fcut,n_elements(fcut)*10)

FT=abs(fft(fcutinvnorm))
fti=rebin(ft,n_elements(ft)*10)
ftxaxis=1/vcut
ftxaxisi=rebin(ftxaxis,n_elements(vcut)*10)

;from cg diaz
eps=0.6 ;limb darkening coefficient
k1 = 0.60975 + 0.0639*eps + 0.0205*eps^2 + 0.021*eps^3
sigma1=15.8*1e-3
vsini=k1 /sigma1 ;sigma here in v space
print,vsini


;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/papers_in_preparation_groh/chesneau_hr5171A_YHG/Spectrum_1992_ed.dat',l,f,f2

;for theta car as a sanity check; vsini =108 km/s, lefever+ 2010
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/02mar17_feros/tetaCar_1.fits',lttc,fttc
restore,'/Users/jgroh/temp/fttcnorm.sav'
l_ini=4562.0
l_fin=4570.0
l0=4566.6

l_ini=4465.0
l_fin=4475.0
l0=4469.9

indexini=findel(l_ini,lttc)
indexfin=findel(l_fin,lttc)
lttccut=lttc[indexini:indexfin]
fttccut=fttcnorm[indexini:indexfin]
fttccutinvnorm=(1-fttccut)/max(1-fttccut)

;lineplot,l[indexini:indexfin],f[indexini:indexfin]
;lineplot,lcut,fcutinvnorm

vttc=ZE_LAMBDA_TO_VEL(lttc,l0)
vttccut=ZE_LAMBDA_TO_VEL(lttccut,l0)

fttccuti=rebin(fttccut,n_elements(fttccut)*10)

FTttc=abs(fft(fttccutinvnorm))
ftttci=rebin(ftttc,n_elements(ftttc)*10)
ftxaxisttc=1/vttccut
ftxaxisttci=rebin(ftxaxisttc,n_elements(vttccut)*10)

;;from simon-diaz and herrero
;lambda0=l0
;sigma1=0.09
;vsini=0.660D0*299792.258/(lambda0*sigma1)
;print,vsini
 
;from cg diaz
eps=0.6 ;limb darkening coefficient
k1 = 0.60975 + 0.0639*eps + 0.0205*eps^2 + 0.021*eps^3
sigma1=3.0*1e-3
vsini=k1 /sigma1 ;sigma here in v space
print,vsini
END