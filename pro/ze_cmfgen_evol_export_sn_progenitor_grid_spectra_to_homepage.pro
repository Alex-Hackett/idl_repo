;PRO ZE_CMFGEN_EVOL_EXPORT_SN_PROGENITOR_GRID_SPECTRA_TO_HOMEPAGE
;routine to create a copy of spectra files to be input in the Geneva group homepage.

model_array_rot=['P020z14S4_model049869_T020358_L0191044_logg2.200','P025z14S4_model042063_T024625_L0318560_logg2.439',$
'P028z14S4_model060885_T028898_L0349513_logg2.725','P032z14S4_model075198_T181508_L0337150_logg5.904','P040z14S4_model085774_T211679_L0438412_logg6.142',$
'P060z14S4_model054963_T247137_L0784953_logg6.322','P085z14S4_model045758_T266698_L1310829_logg6.399','P120z14S4_model064569_T252831_L0856258_logg6.349']  

model_array_norot=['P025z14S0_model030888_T027115_L0239316_logg2.663','P032z14S0_model029922_T045794_L0367647_logg3.507',$
'P040z14S0_model106339_T048183_L0482467_logg3.576','P050z14S0_model025417_T235060_L0743448_logg6.222','P060z14S0_model23950_T224855_L483178_logg6d211_vinf5000',$
'P085z14S0_model024500_T236325_L0899663_logg6.201','P120z14S0_model025926_T167648_L1784201_logg5.527']

dirmod='/Users/jgroh/ze_models/SN_progenitor_grid/'
export_dir='/Users/jgroh/ze_models/SN_progenitor_grid/export_to_geneva_homepage/'

LMIN=900.0
LMAX=50000.0

for i=0, n_elements(model_array_rot) -1 DO BEGIN
     spawn, 'ls '+dirmod+model_array_rot[i]+'/obs/obs_fin*' ,obsfinfile,/sh
     spawn, 'ls '+dirmod+model_array_rot[i]+'/obs*con*/obs*' ,obscontfile,/sh
     mass_str=strmid(model_array_rot[i],1,strpos(model_array_rot[i],'model')-7)
     met_str=strmid(model_array_rot[i],5,strpos(model_array_rot[i],'model')-8)
     rot_str=strmid(model_array_rot[i],8,strpos(model_array_rot[i],'model')-9)
     timestep_str=strmid(model_array_rot[i],strpos(model_array_rot[i],'model')+5,6)
     t_str=strmid(model_array_rot[i],strpos(model_array_rot[i],'_T')+2,6)
     l_str=strmid(model_array_rot[i],strpos(model_array_rot[i],'_L')+2,7)
     prefix='M'+mass_str+'Z'+met_str+'V'+rot_str+'_0'+timestep_str+'_T'+t_str+'_L'+l_str
     print,prefix
     modsum_file=dirmod+model_array_rot[i]+'/MOD_SUM'
     ZE_CMFGEN_EVOL_CREATE_HEADER_FOR_OBS_FILES,modsum_file,header
     ZE_CMFGEN_READ_OBS,obsfinfile,lfin,ffin,num_rec,/flam
     ZE_WRITE_SPECTRA_COL_VEC,export_dir+prefix+'_spec.dat',lfin,ffin,header=header
   ;  ZE_CMFGEN_READ_OBS,obscontfile,lcont,fcont,num_rec   ;not exporting continuum files
  ;   ZE_WRITE_SPECTRA_COL_VEC,export_dir+prefix+'_spec.dat',lcont,fcont
     ZE_CMFGEN_EVOL_CREATE_HEADER_FOR_OBS_FILES,modsum_file,headernorm,/norm
     ZE_CMFGEN_CREATE_OBSNORM,obsfinfile,obscontfile,lnorm,fnorm,LMIN=lmin,LMAX=lmax
     ZE_WRITE_SPECTRA_COL_VEC,export_dir+prefix+'_spec_norm.dat',lnorm,fnorm,header=headernorm  
endfor

for i=0, n_elements(model_array_norot) -1 DO BEGIN
     spawn, 'ls '+dirmod+model_array_norot[i]+'/obs/obs_fin*' ,obsfinfile,/sh
     spawn, 'ls '+dirmod+model_array_norot[i]+'/obs*con*/obs*' ,obscontfile,/sh
     ;WARNING if more than two obs_fin* files are found within dir, take first one
     if n_elements(obsfinfile) GT 1 THEN obsfinfile=obsfinfile[0]
     mass_str=strmid(model_array_norot[i],1,strpos(model_array_norot[i],'model')-7)
     met_str=strmid(model_array_norot[i],5,strpos(model_array_norot[i],'model')-8)
     norot_str=strmid(model_array_norot[i],8,strpos(model_array_norot[i],'model')-9)
     timestep_str=strmid(model_array_norot[i],strpos(model_array_norot[i],'model')+5,6)
     t_str=strmid(model_array_norot[i],strpos(model_array_norot[i],'_T')+2,6)
     l_str=strmid(model_array_norot[i],strpos(model_array_norot[i],'_L')+2,7)
     prefix='M'+mass_str+'Z'+met_str+'V'+norot_str+'_0'+timestep_str+'_T'+t_str+'_L'+l_str
     print,prefix
     modsum_file=dirmod+model_array_norot[i]+'/MOD_SUM'
     ZE_CMFGEN_EVOL_CREATE_HEADER_FOR_OBS_FILES,modsum_file,header
     ZE_CMFGEN_READ_OBS,obsfinfile,lfin,ffin,num_rec,/flam
     ZE_WRITE_SPECTRA_COL_VEC,export_dir+prefix+'_spec.dat',lfin,ffin,header=header
   ;  ZE_CMFGEN_READ_OBS,obscontfile,lcont,fcont,num_rec   ;not exporting continuum files
  ;   ZE_WRITE_SPECTRA_COL_VEC,export_dir+prefix+'_spec.dat',lcont,fcont
     ZE_CMFGEN_EVOL_CREATE_HEADER_FOR_OBS_FILES,modsum_file,headernorm,/norm
     ZE_CMFGEN_CREATE_OBSNORM,obsfinfile,obscontfile,lnorm,fnorm,LMIN=lmin,LMAX=lmax
     ZE_WRITE_SPECTRA_COL_VEC,export_dir+prefix+'_spec_norm.dat',lnorm,fnorm,header=headernorm  
endfor

END