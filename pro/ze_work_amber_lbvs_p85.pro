;PRO ZE_WORK_AMBER_LBVS_P85
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
dir='/Users/jgroh/data/eso/amber/lbvs_p85/lbvs_amber_ascii/'
file='SCIENCE_wray1796_AMBER.2010-06-27T03:08:54.832-AMBER.2010-06-27T03:14:37.961_K_AVG__DIV__CALIB_hd163197_AMBER.2010-06-27T03:30:44.719-AMBER.2010-06-27T03:54:06.935_K_AVG.fits.ascii'
file='SCIENCE_hrcar_AMBER.2010-04-25T00:26:30.752-AMBER.2010-04-25T00:40:29.857_K_AVG__DIV__CALIB_hd94987_AMBER.2010-04-25T00:01:40.493-AMBER.2010-04-25T00:08:21.872_K_AVG.fits.ascii'
file='SCIENCE_wray1796_AMBER.2010-08-25T01:26:29.573-AMBER.2010-08-25T01:32:40.582_K_AVG__DIV__CALIB_hd163197_AMBER.2010-08-25T01:54:21.699-AMBER.2010-08-25T02:00:05.132_K_AVG.fits.ascii'
;file='SCIENCE_hde316285_AMBER.2011-03-26T08:48:49.863-AMBER.2011-03-26T08:56:44.341_K_AVG__DIV__CALIB_hd156992_AMBER.2011-03-26T08:25:58.018-AMBER.2011-03-26T08:34:07.497_K_AVG.fits.ascii'
ZE_AMBER_READ_3T_ASCII_FROM_ALEX_KREPLIN,dir+file,data_wra1796cal,header
fileraw='SCIENCE_wray1796_AMBER.2010-08-25T01:26:29.573-AMBER.2010-08-25T01:32:40.582_K_AVG.fits.ascii'
ZE_AMBER_READ_3T_ASCII_FROM_ALEX_KREPLIN,dir+fileraw,data_wra1796raw,header


;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[1,*])
;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[3,*])
;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[5,*])

;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[7,*])
;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[9,*])
;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[11,*])

;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[15,*])
;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[17,*])
;lineplot,REFORM(data_wra1796[0,*]),REFORM(data_wra1796[19,*])

lineplot,REFORM(data_wra1796raw[0,*]),REFORM(data_wra1796raw[15,*])
;lineplot,REFORM(data_wra1796raw[0,*]),REFORM(data_wra1796raw[17,*])
;lineplot,REFORM(data_wra1796raw[0,*]),REFORM(data_wra1796raw[19,*])


;line_norm,REFORM(data_wra1796cal[0,*]),REFORM(data_wra1796cal[19,*]),fobsn_wra1796
;lobs_wra1796=REFORM(data_wra1796[0,*]*10000.)
;save,lobs_wra1796,fobsn_wra1796,filename='/Users/jgroh/espectros/amber/wra1796_25aug10.sav'

END