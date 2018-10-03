;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_COMPARE_CAVITY_BACKSIDE_PRIMARY_PERIASTRON
;compares model with and without cavity on the back side of the primary wind as predicted by 3D hydro sims. fossil cavity on the front side and newborn cavity are also included


close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

;new model spectra for periastron
dirperi='/Users/jgroh/ze_models/2D_models/etacar/mod43_groh_finer_rgrid/'
modelperi='cut_v4_vstream_innercav'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix001020='0_10_20'

;filename10='OBSFRAME2'
;filename20='OBSFRAME3'
sufixperibackcav='test4'
filename00peribackcav='OBSFRAME1'
filename49peribackcav='OBSFRAME2'
filename90peribackcav='OBSFRAME3'
ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperibackcav,filename00peribackcav,lm00peribackcav,fm00peribackcav,fn00peribackcav,inc00peribackcav,inc_str00peribackcav,/FLAM
ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperibackcav,filename49peribackcav,lm49peribackcav,fm49peribackcav,fn49peribackcav,inc49peribackcav,inc_str49peribackcav,/FLAM
ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperibackcav,filename90peribackcav,lm90peribackcav,fm90peribackcav,fn90peribackcav,inc90peribackcav,inc_str90peribackcav,/FLAM
;save,lm00peribackcav,fm00peribackcav,fn00peribackcav,lm49peribackcav,fm49peribackcav,fn49peribackcav,lm90peribackcav,fm90peribackcav,fn90peribackcav,filename='/Users/jgroh/temp/etc_mod43_groh_finer_rgrid_halpha_norm_00_49_90_test4_backcav.sav'

restore,'/Users/jgroh/temp/etc_mod43_groh_finer_rgrid_halpha_norm_00_49_90_test4_backcav.sav'
;sufixperinobackcav='test4'
;filename00perinobackcav='OBSFRAME1'
;filename49perinobackcav='OBSFRAME2'
;filename90perinobackcav='OBSFRAME3'
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperinobackcav,filename00perinobackcav,lm00perinobackcav,fm00perinobackcav,fn00perinobackcav,inc00perinobackcav,inc_str00perinobackcav,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperinobackcav,filename49perinobackcav,lm49perinobackcav,fm49perinobackcav,fn49perinobackcav,inc49perinobackcav,inc_str49perinobackcav,/FLAM
;ZE_BH05_READ_OBS2D_GET_INC_NORMALIZE,dirperi,modelperi,sufixperinobackcav,filename90perinobackcav,lm90perinobackcav,fm90perinobackcav,fn90perinobackcav,inc90perinobackcav,inc_str90perinobackcav,/FLAM
;save,lm00perinobackcav,fm00perinobackcav,fn00perinobackcav,lm49perinobackcav,fm49perinobackcav,fn49perinobackcav,lm90perinobackcav,fm90perinobackcav,fn90perinobackcav,filename='/Users/jgroh/temp/etc_mod43_groh_finer_rgrid_halpha_norm_00_49_90_test4_nobackcav.sav'


;restore,'/Users/jgroh/temp/etc_mod43_groh_finer_rgrid_halpha_norm_00_49_90.sav'
;lineplot,lm00peribackcav,fn00peribackcav,title='equator back cav'
;lineplot,lm49peribackcav,fn49peribackcav,title='star at 139deg back cav'
;lineplot,lm90peribackcav,fn90peribackcav,title='pole back cav'

restore,'/Users/jgroh/temp/etc_mod43_groh_finer_rgrid_halpha_norm_00_49_90_test4_nobackcav.sav'
;lineplot,lm00perinobackcav,fn00perinobackcav,title='equator no back cav'
;lineplot,lm49perinobackcav,fn49perinobackcav,title='star at 139deg no back cav'
;lineplot,lm90perinobackcav,fn90perinobackcav,title='pole no back cav'

lineplot,lm49peribackcav,fn49peribackcav,title='star at 139deg back cav'
lineplot,lm49perinobackcav,fn49perinobackcav,title='star at 139deg no back cav'

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
END