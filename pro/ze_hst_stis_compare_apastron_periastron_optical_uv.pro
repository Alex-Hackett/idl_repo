;PRO ZE_HST_STIS_COMPARE_APASTRON_PERIASTRON_OPTICAL_UV


Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
restore,'/Users/jgroh/temp/etc_stis_optical_obs_periastron_norm.sav'
;filename_19mar98='/Users/jgroh/data/hst/stis/etacar_from_john/star_19mar98'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_19mar98,lambda_19mar98,flux_19mar98,mask_19mar98
;
;;normalize observations?
;line_norm,lambda_19mar98,flux_19mar98,flux_19mar98n,norm19mar98,xnodes19mar98,ynodes19mar98

restore,'/Users/jgroh/espectros/etacar/etc_hst_stis_17apr01_1700_10400_norm.sav' 

filename_17apr01='/Users/jgroh/data/hst/stis/etacar_from_john/star_17apr01'
ZE_READ_STIS_DATA_FROM_JOHN,filename_17apr01,lambda_17apr01,flux_17apr01,mask_17apr01


lineplot,lambda_19mar98,flux_19mar98n
lineplot,lambda_17apr01,flux_17apr01n






END