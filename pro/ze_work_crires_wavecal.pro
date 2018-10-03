dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/381D-0262A_C01/GEN_CALIB/gen/' ; for all
linesthar=dircal+'lines_thar.fits'

ftab_ext,linesthar,'Wavelength,Emission',wthar,fthar,EXTEN_NO=1
a=1500
b=3600

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
lineplot,wthar[a:b],fthar[a:b]

END