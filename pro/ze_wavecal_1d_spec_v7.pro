PRO ZE_WAVECAL_1D_SPEC_V7, index,swmpa2,dataa2,f2canorm,row,gratdet,minrow,numberrows,lkpno,fkpno,READ_KPNO=read_kpno,build_tel_list=build_tel_list,create_ident_plot=create_ident_plot, $
                           build_templ=build_templ,build_calonly_templ=build_calonly_templ,calib_sci=calib_sci,calib_cal=calib_cal

;implements mouse cursor selection and separate sci and cal wavecal as procedures
;implements keywords to select which steps should be done
;v7 implements gratdet instead of grat_angle and det, in order to include the obsdate in the output filenames = crucial for not overwriting output of different dates.
!EXCEPT = 0


swmpa2_air=swmpa2[*,row]*10
VACTOAIR,swmpa2_air
guess_lambda=swmpa2_air
print,guess_lambda

IF KEYWORD_SET(read_kpno) THEN ZE_READ_TELKPNO_AIR,lambdacut=lkpno,fluxcut=fkpno,min(swmpa2_air),max(swmpa2_air)

IF KEYWORD_SET(build_tel_list) THEN ZE_BUILD_TELURIC_LINELIST_V6,guess_lambda,f2canorm,lkpno,fkpno,gratdet

linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+gratdet+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_template.sav'

IF KEYWORD_SET(create_ident_plot) THEN ZE_CREATE_IDENT_PLOT_TELURIC_V2,guess_lambda,f2canorm,gratdet,linelist_file
IF KEYWORD_SET(build_templ) THEN ZE_WAVECAL_BUILD_TEMPLATE_V3,index,dataa2[*,row],gratdet,linelist_file
IF KEYWORD_SET(build_calonly_templ) THEN ZE_WAVECAL_BUILD_TEMPLATE_V3,index,f2canorm,gratdet,linelist_file
IF KEYWORD_SET(calib_sci) THEN ZE_WAVECAL_CALIB_LAMBDA_SCI_V3,index,guess_lambda,dataa2,minrow,numberrows,gratdet,linelist_file,template_file
IF KEYWORD_SET(calib_cal) THEN ZE_WAVECAL_CALIB_LAMBDA_CAL_V2,index,guess_lambda,f2canorm,1,1,gratdet,linelist_file,template_file

END