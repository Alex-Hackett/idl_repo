!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

dir='/Users/jgroh/data/eso/amber/lbvs_p85/28may10/28may10_PRODUCT/'
file='AMBER.2010-05-28T04:05:18.197_-13:51.011_OIDATA_AVG__DIV__AMBER.2010-05-28T03:42:50.770_-8:40.978_OIDATA_AVG.fits'
;file='AMBER.2010-05-28T03:42:50.770_-8:40.978_OIDATA_AVG.fits'
ftab_help,dir+file


Result = MRDFITS(dir+file,6)
;lineplot,result[2].vis2data
lineplot,result[0].t3phi

END