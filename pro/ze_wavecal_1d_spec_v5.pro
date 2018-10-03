PRO ZE_WAVECAL_1D_SPEC_V5,index,swmpa2,dataa2,f2canorm,row,grat_angle,det,minrow,numberrows
;implements mouse cursor selection and separate sci and cal wavecal as procedures

!EXCEPT = 0

swmpa2_air=swmpa2[*,row]
VACTOAIR,swmpa2_air
guess_lambda=swmpa2_air*10.
index=1.*indgen((size(dataa2))[1])

ZE_READ_TELKPNO_AIR,lambdacut=lkpno,fluxcut=fkpno,min(swmpa2_air)*10.,max(swmpa2_air)*10.
ZE_BUILD_TELURIC_LINELIST_V2, lkpno,fkpno,grat_angle,det
linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_template.sav'
ZE_CREATE_IDENT_PLOT_TELURIC,guess_lambda,f2canorm,grat_angle,det,linelist_file
ZE_WAVECAL_BUILD_TEMPLATE,index,dataa2[*,row],grat_angle,det,linelist_file
ZE_WAVECAL_CALIB_LAMBDA_SCI,index,guess_lambda,dataa2,minrow,numberrows,grat_angle,det,linelist_file,template_file
ZE_WAVECAL_CALIB_LAMBDA_CAL,index,guess_lambda,f2canorm,1,1,grat_angle,det,linelist_file,template_file

END