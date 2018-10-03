PRO ZE_CMFGEN_COMPUTE_NUMBER_IONIZING_PHOTONS_FUNCTION_DEPTH_EDDFACTOR_FOR_TOM,EDDFACTOR_output,nphot_hyd,nphot_hei,nphot_he2,lum_hyd,lum_hei,lum_he2
;compute number of ionizing phtotons and luminosity below a certain depth from EDDFACTOR file  from output to .txt
;NOT SURE IT WORKS

ZE_READ_SPECTRA_COL_VEC,EDDFACTOR_output,lobs,fobs;,skip_lines=2
fobs=fobs*1e23 ;converts from erg/s/cm^2/Hz to Jy
obs='dummy'
print,lobs
;lobs has to be already in ascending order
ZE_CMFGEN_COMPUTE_NUMBER_H_IONIZING_PHOTONS,obs,nphot_hyd,nphot_hei,nphot_he2,lum_hyd,lum_hei,lum_he2,skip_obsread=1,lobs=lobs,fobs=fobs


END
