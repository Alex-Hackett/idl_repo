;PRO ZE_WORK_HD152408
spec_dir='/Users/jgroh/espectros/hd152408/'
filenameobs=spec_dir+'WR79a_AMBER.2009-06-12T03:23:25.222_OIDATA_RAW_K_SPECTRUM.txt'
ZE_READ_AMBER_SPEC_FROM_MILLOUR,filenameobs,lobs,fobs,lambda_err

model2=spec_dir+'hd152408_2_nar.txt'
model4=spec_dir+'hd152408_5_nar.txt'
if n_elements(f2) eq 0 THEN ZE_READ_SPECTRA_COL_VEC,model2,l2,f2
if n_elements(f5) eq 0 THEN ZE_READ_SPECTRA_COL_VEC,model4,l5,f5
!P.Background = fsc_color('white')
if n_elements(fobsn) eq 0. THEN line_norm,lobs,fobs,fobsn,obs_norm,xnodes_obs,ynodes_obs

;convolving model spectra to AMBER MR-K
res=1500.   ;resolving power
lambda_val=21649.2
resang=lambda_val/res ;resolution in angstroms
ZE_SPEC_CNVL,l2,f2,resang,lambda_val,fluxcnvl=f2cnvl
ZE_SPEC_CNVL,l5,f5,resang,lambda_val,fluxcnvl=f5cnvl

lineplot,lobs,fobsn,title='WR 79a obs'
lineplot,l2,f2cnvl, title='model 2'
lineplot,l5,f5cnvl,  title='model 5'  
;save,/variables,FILENAME='/Users/jgroh/espectros/hd152408_work.sav' 
END