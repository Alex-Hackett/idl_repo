PRO ZE_ETACAR_CRIRES_WAVECAL_N2O_V1,index,swmpa2,dataa2,f2canorm,row,grat_angle,det,minrow,numberrows,wn2o,fn2o
gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
ZE_READ_CRIRES_N2O_LINES,min(swmpa2[*,row])*10.,max(swmpa2[*,row])*10.,wn2o,fn2o
linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+gratdet+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_template.sav'
guess_lambda=swmpa2[*,row]*10
ZE_BUILD_TELURIC_LINELIST_V5,guess_lambda,f2canorm,wn2o,fn2o,grat_angle,det
ZE_CREATE_IDENT_PLOT_TELURIC,guess_lambda,f2canorm,grat_angle,det,linelist_file
ZE_WAVECAL_BUILD_TEMPLATE_V2,index,f2canorm,grat_angle,det,linelist_file
ZE_WAVECAL_CALIB_LAMBDA_SCI_v2,index,guess_lambda,dataa2,minrow,numberrows,grat_angle,det,linelist_file,template_file
ZE_WAVECAL_CALIB_LAMBDA_CAL,index,guess_lambda,f2canorm,1,1,grat_angle,det,linelist_file,template_file
END 