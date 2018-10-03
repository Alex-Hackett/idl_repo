PRO ZE_WAVECAL_1D_SPEC_V6, index,swmpa2,dataa2,f2canorm,row,grat_angle,det,minrow,numberrows,lkpno,fkpno,READ_KPNO=read_kpno,build_tel_list=build_tel_list,create_ident_plot=create_ident_plot, $
                           build_templ=build_templ,build_calonly_templ=build_calonly_templ,calib_sci=calib_sci,calib_cal=calib_cal

;implements mouse cursor selection and separate sci and cal wavecal as procedures
;implements keywords to select which steps should be done

!EXCEPT = 0


swmpa2_air=swmpa2[*,row]*10
VACTOAIR,swmpa2_air
guess_lambda=swmpa2_air
print,guess_lambda

IF KEYWORD_SET(read_kpno) THEN ZE_READ_TELKPNO_AIR,lambdacut=lkpno,fluxcut=fkpno,min(swmpa2_air),max(swmpa2_air)
print,'lkpno wavecal',lkpno
IF KEYWORD_SET(build_tel_list) THEN ZE_BUILD_TELURIC_LINELIST_V5,guess_lambda,f2canorm,lkpno,fkpno,grat_angle,det

linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_template.sav'

IF KEYWORD_SET(create_ident_plot) THEN ZE_CREATE_IDENT_PLOT_TELURIC,guess_lambda,f2canorm,grat_angle,det,linelist_file
IF KEYWORD_SET(build_templ) THEN ZE_WAVECAL_BUILD_TEMPLATE_V2,index,dataa2[*,row],grat_angle,det,linelist_file
IF KEYWORD_SET(build_calonly_templ) THEN ZE_WAVECAL_BUILD_TEMPLATE_V2,index,f2canorm,grat_angle,det,linelist_file
IF KEYWORD_SET(calib_sci) THEN ZE_WAVECAL_CALIB_LAMBDA_SCI_v2,index,guess_lambda,dataa2,minrow,numberrows,grat_angle,det,linelist_file,template_file
IF KEYWORD_SET(calib_cal) THEN ZE_WAVECAL_CALIB_LAMBDA_CAL,index,guess_lambda,f2canorm,1,1,grat_angle,det,linelist_file,template_file

END