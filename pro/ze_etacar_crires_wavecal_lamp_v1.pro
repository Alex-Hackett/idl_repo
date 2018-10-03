PRO ZE_ETACAR_CRIRES_WAVECAL_LAMP_V1,gratdet,lampfile,index,spec_ext,center_ext,swmpa2,tharlinescut

ZE_READ_LAMPFILE,lampfile,min(swmpa2[*,center_ext])*10.,max(swmpa2[*,center_ext])*10.,tharlinescut
linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+gratdet+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_template.sav'
ZE_WRITE_COL,linelist_file,tharlinescut
ZE_CREATE_IDENT_PLOT_LAMP,swmpa2(*,center_ext)*10.,spec_ext,gratdet,linelist_file
ZE_WAVECAL_BUILD_TEMPLATE_LAMP_V1,index,spec_ext,gratdet,linelist_file
ZE_WAVECAL_CALIB_LAMBDA_LAMP_V1,index,swmpa2(*,center_ext)*10.,spec_ext,gratdet,linelist_file,template_file,1

END 