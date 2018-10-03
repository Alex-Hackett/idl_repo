;PRO ZE_PLOT_SPECTRA_AGCAR_AMBER

LOADCT,13, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
dir='/Users/jgroh/espectros/agcar/'
ZE_READ_SPECTRA_COL_VEC,dir+'amber/AGCAR_AMBER_SPEC_2009-03-06T06_52_53.030.TAB',lobs1,fobs1
ZE_READ_SPECTRA_COL_VEC,dir+'amber/AGCAR_AMBER_SPEC_2009-03-06T07_02_20.997.TAB',lobs2,fobs2
ZE_READ_SPECTRA_COL_VEC,dir+'423_fineob_kband_vacn.txt',lmod,fmod
;ZE_READ_SPECTRA_COL_VEC,dir+'230_kband_vacn.txt',lmod,fmod

;converting observed wavelength scale to angstroms
lobs1=lobs1*10000.
lobs2=lobs2*10000.

;convolving the model spectrum to AMBER MR
lambda_val=21661.2
resolving_power=1500.
res=lambda_val/resolving_power
ZE_SPEC_CNVL,lmod,fmod,res,lambda_val,fluxcnvl=fmodcnvl

;scaling observed flux to 1
fobs1=fobs1/0.974


END