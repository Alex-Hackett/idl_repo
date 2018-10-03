;PRO ZE_CMFGEN_EVOL_EXPORT_P060z14S0_GRID_SPECTRA_TO_HOMEPAGE
;routine to create a copy of spectra files to be input in the Geneva group homepage.


model_array_norot=['model001750_T043261_L0597948_logg3.907_f0d2',$
'model003000_T035749_L0680682_logg3.495_f0d2',$
'model003970_T025884_L0757148_logg2.875_f0d2',$
'model004050_T024443_L0759715_logg2.769_f0d2',$
'model004200_T021072_L0766547_logg2.497_f0d2',$
'model004730_T012130_L0835687_logg1.360',$
'model004731_T011444_L0836924_logg1.258',$
'model004732_T011141_L0837454_logg1.211',$
'model004734_T010594_L0838434_logg1.123',$
'model004737_T009664_L0839972_logg0.962',$
'model004738_T009317_L0840531_logg0.899',$
'model004739_T009038_L0840990_logg0.845',$
'model004741_T008373_L0841934_logg0.712',$
'model004744_T008011_L0842525_logg0.635',$
'model005215_T010827_L1027971_logg0.974',$
'model005328_T011606_L1005669_logg1.088',$
'model005344_T012182_L1001146_logg1.171_2',$
'model005375_T013648_L0989874_logg1.368',$
'model005425_T019166_L0964242_logg1.960',$
'model005460_T023678_L0954291_logg2.327',$
'model007027_T081012_L0835922_logg4.509',$
'model007577_T106349_L0717440_logg5.036',$
'model022251_T165881_L0355836_logg5.818',$
'model022271_T182276_L0390822_logg5.940',$
'model1000_T45796_L555083_logg_4d0519_Fe_OK_f0d2',$
'model10131_T125166_L584448_logg5d344',$
'model11201_T126228_L545449_logg5d63_4',$
'model12551_T133655_L507200_logg5d468',$
'model14951_T136008_L434538_logg5d51_hydro',$
'model18950_T140543_L350244_logg_5d580_hydro',$
'model21950_T151200_L332128_logg5d690_2',$
'model23950_T224855_L483178_logg6d211_vinf5000',$
'model2500_T39375_L645563_logg_3d6925_Fe_OK_f0d2',$
'model3500_T31088_L719179_logg_3d22_Fe_OK_f0d2',$
'model3800_T27864_L743098_logg3d01_Fe_OK_2_f0d2',$
'model4301_T18573_L772592_logg2d267',$
'model4379_T12105_L755429_logg1d491_with_lowion',$
'model4501_T19271_L741291_logg2d235',$
'model4701_T25875_L814798_logg2d684_2',$
'model4717_T20457_L818840_logg2d279',$
'model4723_T16164_L827077_logg1d863_3',$
'model4729_T12785_L834422_logg1d4519_with_lowion',$
'model500_T47031_L528310_logg_4d1278_Fe_OK_f0d2',$
'model5404_T15961_L976662_logg1d64',$
'model5500_T30783_L941860_logg_2d787',$
'model5601_T38708_L927046_logg3d19',$
'model57_T48386_L507016_logg_4d2015_Fe_OK_f0d2',$
'model5820_T45243_L916947_logg3d4654_Fe_OK_tauref10',$
'model6250_T56420_L897212_logg_2d913_tauref20',$
'model6551_T63351_L883519_logg_4d062',$
'model6870_T70075_L869169_logg4d24',$
'model7201_T92369_L791920_logg_4d756_expanded',$
'model8201_T122874_L682455_logg5d294']


dirmod='/Users/jgroh/ze_models/grid_P060z14S0/'
export_dir='/Users/jgroh/ze_models/grid_P060z14S0/export_to_geneva_homepage/'

LMIN=900.0
LMAX=50000.0

;for finding out stages automatically based on timestep number sort
timestep_str=strarr(n_elements(model_array_norot))
for i=0, n_elements(model_array_norot) -1 DO timestep_str[i]=string(strmid(model_array_norot[i],strpos(model_array_norot[i],'model')+5,6),format='(I05)')
stage_str=strarr(n_elements(model_array_norot))
for i=0, n_elements(sort(timestep_str)) -1 do stage_str[(sort(timestep_str))[i]]=i+1
stage_str=string(stage_str,format='(I02)')

for i=0, n_elements(model_array_norot) -1 DO BEGIN
     spawn, 'ls '+dirmod+model_array_norot[i]+'/obs/obs_fin*' ,obsfinfile,/sh
     spawn, 'ls '+dirmod+model_array_norot[i]+'/obs*con*/obs*' ,obscontfile,/sh
     ;WARNING if more than two obs_fin* files are found within dir, take first one
     if n_elements(obsfinfile) GT 1 THEN obsfinfile=obsfinfile[0]
     mass_str='060'
     met_str='14'
     norot_str='0'
    ; timestep_str=string(strmid(model_array_norot[i],strpos(model_array_norot[i],'model')+5,6),format='(I05)') ;DEPRECATED
     t_str=string(strmid(model_array_norot[i],strpos(model_array_norot[i],'_T')+2,6),format='(I06)')
     l_str=string(strmid(model_array_norot[i],strpos(model_array_norot[i],'_L')+2,7),format='(I07)')
     prefix='M'+mass_str+'Z'+met_str+'V'+norot_str+'_stage'+stage_str[i]+'_T'+t_str+'_L'+l_str
     print,prefix
     modsum_file=dirmod+'modsum/'+model_array_norot[i]+'/MOD_SUM'
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