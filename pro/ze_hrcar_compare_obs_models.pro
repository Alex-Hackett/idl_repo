;PRO ZE_HRCAR_COMPARE_OBS_MODELS
LOADCT,13, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
dir='/Users/jgroh/espectros/'
restore,dir+'hrcar/hrcar_norm_val.sav'
dir='/Users/jgroh/espectros/'
dirhrcmod='/Users/jgroh/ze_models/hrcar/'
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrcar_gamen_casleo_2009jan13n.txt',l09jan13,f09jan13
;ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_1_optn.txt',l1,f1,nrec1
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_2_optn.txt',l2,f2,nrec2
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_3_optn.txt',l3,f3,nrec3
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_4_optn.txt',l4,f4,nrec4
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'5'+'/obsopt/obs_fin',dirhrcmod+'5'+'/obscont/obs_fin',l5,f5,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'6'+'/obsopt/obs_fin',dirhrcmod+'6'+'/obscont/obs_fin',l6,f6,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'7'+'/obsopt/obs_fin',dirhrcmod+'7'+'/obscont/obs_fin',l7,f7,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'8'+'/obsopt/obs_fin',dirhrcmod+'8'+'/obscont/obs_fin',l8,f8,/AIR


;lineplot,lhrc,fhrcn
fhrcns=ZE_SHIfT_SPECTRA_VEL(lhrc,fhrcn,113.)
;lineplot,ZE_LAMBDA_TO_VEL(lhrc,4088.862),fhrcns
;lineplot,ZE_LAMBDA_TO_VEL(l09jan13,4088.862),f09jan13


;lineplot,ZE_LAMBDA_TO_VEL(l2,4088.862)-vsys,f2
;lineplot,ZE_LAMBDA_TO_VEL(l2,4088.862)-vsys,((f2-1.)*1.8)+1
scl=1.82
;lineplot,ZE_LAMBDA_TO_VEL(l4,4088.862)-vsys,((f4-1.)*scl)+1

vsys=-10. ;consistent with Weis et al. 1997
f2sys=ZE_SHIFT_SPECTRA_VEL(l2,f2,-vsys)
f3sys=ZE_SHIFT_SPECTRA_VEL(l3,f3,-vsys)
f4sys=ZE_SHIFT_SPECTRA_VEL(l4,f4,-vsys)
f5sys=ZE_SHIFT_SPECTRA_VEL(l5,f5,-vsys)
f6sys=ZE_SHIFT_SPECTRA_VEL(l6,f6,-vsys)
f7sys=ZE_SHIFT_SPECTRA_VEL(l7,f7,-vsys)
f8sys=ZE_SHIFT_SPECTRA_VEL(l8,f8,-vsys)
;lineplot,lhrc,fhrcns
;lineplot,l09jan13,f09jan13
;ZE_SPEC_CNVL,l4,f4sys,0.5,4088.8,fluxcnvl=f4syscnvl
;lineplot,l4,f4syscnvl

;lineplot,l3,f3sys
;lineplot,l4,f4sys


;
;v_4088=(ZE_LAMBDA_TO_VEL(lhrc,4088.862))[18677:18897]
;f_4088=fhrcns[18677:18897]
;f_4088_shift=SHIFT(f_4088,-n_elements(f_4088)/2.)
;fft_4088=abs(fft(f_4088_shift))
END





