;PRO ZE_HALPHA_PAPER_WORK_PERIASTRON_UV

close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model.sav'

dir='/Users/jgroh/ze_models/2D_models/etacar/mod111_john/'

modelphi0d5='cut_v4_vstream' 
sufixphi0d5='phi0d5_posx'
filenamephi0d5='OBSFRAME1'
extra_labelphi0d5i90=TEXTOIDL(',i=90^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d5,dir+modelphi0d5+'/'+sufixphi0d5+'/',lmphi0d5i90,fmphi0d5i90,nmfmphi0d5i90,/FLAM

modelphi0d5='cut_v4_vstream' 
sufixphi0d5='phi0d5_posx'
filenamephi0d5='OBSFRAME2'
extra_labelphi0d5i41=TEXTOIDL(',i=41^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d5,dir+modelphi0d5+'/'+sufixphi0d5+'/',lmphi0d5i41,fmphi0d5i41,nmfmphi0d5i41,/FLAM

modelphi0d5='cut_v4_vstream' 
sufixphi0d5='phi0d5_posx'
filenamephi0d5='OBSFRAME3'
extra_labelphi0d5i00=TEXTOIDL(',i=00^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d5,dir+modelphi0d5+'/'+sufixphi0d5+'/',lmphi0d5i00,fmphi0d5i00,nmfmphi0d5i00,/FLAM


;lineplot,lmphi0d5i90,fmphi0d5i90,title=sufixphi0d5+extra_labelphi0d5i90
;lineplot,lmphi0d5i41,fmphi0d5i41,title=extra_labelphi0d5i41
lineplot,lmphi0d5i00,fmphi0d5i00,title=sufixphi0d5+extra_labelphi0d5i00

modelphi0d02='cut_v4_vstream' 
sufixphi0d02='phi0d02_minusy'
filenamephi0d02='OBSFRAME1'
extra_labelphi0d02i90=TEXTOIDL(',i=90^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d02,dir+modelphi0d02+'/'+sufixphi0d02+'/',lmphi0d02i90,fmphi0d02i90,nmfmphi0d02i90,/FLAM

modelphi0d02='cut_v4_vstream' 
sufixphi0d02='phi0d02_minusy'
filenamephi0d02='OBSFRAME2'
extra_labelphi0d02i41=TEXTOIDL(',i=41^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d02,dir+modelphi0d02+'/'+sufixphi0d02+'/',lmphi0d02i41,fmphi0d02i41,nmfmphi0d02i41,/FLAM

modelphi0d02='cut_v4_vstream' 
sufixphi0d02='phi0d02_minusy'
filenamephi0d02='OBSFRAME3'
extra_labelphi0d02i00=TEXTOIDL(',i=00^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d02,dir+modelphi0d02+'/'+sufixphi0d02+'/',lmphi0d02i00,fmphi0d02i00,nmfmphi0d02i00,/FLAM


;lineplot,lmphi0d02i90,fmphi0d02i90,title=sufixphi0d02+extra_labelphi0d02i90
;lineplot,lmphi0d02i41,fmphi0d02i41,title=extra_labelphi0d02i41
;lineplot,lmphi0d02i00,fmphi0d02i00,title=extra_labelphi0d02i00

modelphi0d05='cut_v4_vstream' 
sufixphi0d05='phi0d05_minusy'
filenamephi0d05='OBSFRAME1'
extra_labelphi0d05i90=TEXTOIDL(',i=90^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d05,dir+modelphi0d05+'/'+sufixphi0d05+'/',lmphi0d05i90,fmphi0d05i90,nmfmphi0d05i90,/FLAM

modelphi0d05='cut_v4_vstream' 
sufixphi0d05='phi0d05_minusy'
filenamephi0d05='OBSFRAME2'
extra_labelphi0d05i41=TEXTOIDL(',i=41^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d05,dir+modelphi0d05+'/'+sufixphi0d05+'/',lmphi0d05i41,fmphi0d05i41,nmfmphi0d05i41,/FLAM

modelphi0d05='cut_v4_vstream' 
sufixphi0d05='phi0d05_minusy'
filenamephi0d05='OBSFRAME3'
extra_labelphi0d05i00=TEXTOIDL(',i=00^\circ')
ZE_CMFGEN_READ_OBS_2D,filenamephi0d05,dir+modelphi0d05+'/'+sufixphi0d05+'/',lmphi0d05i00,fmphi0d05i00,nmfmphi0d05i00,/FLAM


;lineplot,lmphi0d05i90,fmphi0d05i90,title=sufixphi0d05+extra_labelphi0d05i90
lineplot,lmphi0d05i41,fmphi0d05i41,title=extra_labelphi0d05i41
;lineplot,lmphi0d05i00,fmphi0d05i00,title=extra_labelphi0d05i00

;reads in companion spectrum
modelc='/Users/jgroh/ze_models/etacar/eta_companion_r5/obs/obs_fin'
ZE_CMFGEN_READ_OBS,modelc,lc1,fc1,num_rec1,/FLAM



END