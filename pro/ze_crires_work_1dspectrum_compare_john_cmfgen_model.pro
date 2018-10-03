;PRO ZE_CRIRES_WORK_1DSPECTRUM_COMPARE_JOHN_CMFGEN_MODEL
restore,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_all.sav'

;ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/etacar/etacar_john_mod111_full_norm.txt',lmod,fmod
!P.Background = fsc_color('white')
;lineplot,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn
;selecting region for removal using linear interpolation, e.g. due to telluric lines residual.
;selecting region for normalization interactively
indexmay=indgen(n_elements(lallmay))*1.
undefine,rem_sect
IF n_elements(rem_sect) eq 0 THEN ZE_SELECT_NORM_SECTION_V2,indexmay,fallmayn,norm_sect=rem_sect
LINTERP,[rem_sect[0],rem_sect[1]], [fallmayn[rem_sect[0]],fallmayn[rem_sect[1]]],indexmay[rem_sect[0]:rem_sect[1]],yint
fallmayn[rem_sect[0]:rem_sect[1]]=yint

restore,FILENAME='/Users/jgroh/espectros/etacar/etacar_2008may_1087_2fos4.sav'
l08mayfos4=lambda_newcal_vac_hel[*,120+49]
f08mayfos4=spec_ext
line_norm,l08mayfos4,f08mayfos4,f08mayfos4n
restore,FILENAME='/Users/jgroh/espectros/etacar/etacar_2009feb09_1087_2fos4.sav'
l09febfos4=lambda_newcal_vac_hel[*,120+49]
f09febfos4=spec_ext
line_norm,l09febfos4,f09febfos4,f09febfos4n
save,/variables,FILENAME='/Users/jgroh/espectros/etacar/etacar_fos4_comp_08may_09feb.sav'


;lineplot,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn
lineplot,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn
;lineplot,ZE_LAMBDA_TO_VEL(l08mayfos4,10833.0)-185,f08mayfos4n+0.5
;lineplot,ZE_LAMBDA_TO_VEL(l09febfos4,10833.0)-185,f09febfos4n
END