PRO ZE_ETACAR_CRIRES_WAVECAL_LAMP_V2,gratdet_orig,lampfile,index,spec_ext_array,center_ext,swmpa2,tharlinescut,next

linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+gratdet_orig+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet_orig+'_template.sav'

IF FILE_EXIST(template_file) eq 1. THEN READ,cont_fullcal,PROMPT='Template files and previous calibration found. Type 1 to skip full calibration.'
cont_fullcal=0.
IF cont_fullcal eq 1. THEN GOTO, SKIP_FULL_CALL
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

spec_ext=spec_ext_array[*,0]
ZE_READ_LAMPFILE,lampfile,min(swmpa2[*,center_ext])*10.,max(swmpa2[*,center_ext])*10.,tharlinescut
ZE_WRITE_COL,linelist_file,tharlinescut
ZE_CREATE_IDENT_PLOT_LAMP,swmpa2(*,center_ext)*10.,spec_ext,gratdet_orig,linelist_file
ZE_WAVECAL_BUILD_TEMPLATE_LAMP_V1,index,spec_ext,gratdet_orig,linelist_file
ZE_WAVECAL_CALIB_LAMBDA_LAMP_V1,index,swmpa2(*,center_ext)*10.,spec_ext,gratdet_orig+'pos00',linelist_file,template_file,1

GOTO,SKIP_FULL_CALL

SKIP_FULL_CALL:
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
IF next  gt 0 THEN BEGIN
    FOR i=0, next - 1 DO BEGIN
       spec_ext=spec_ext_array[*,i]
       ZE_WAVECAL_CALIB_LAMBDA_LAMP_V1,index,swmpa2(*,center_ext)*10.,spec_ext,gratdet_orig+'pos'+strcompress(string(i, format='(I02)')),linelist_file,template_file,1    
    ENDFOR


ENDIF
END 