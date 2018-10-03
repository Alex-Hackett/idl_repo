;PRO ZE_WORK_AMBER
dir='/Users/jgroh/data/eso/amber/lbvs_p85/'
file='AMBER.2010-04-25T00:26:30.752.fits'

ftab_help,dir+file
;mwrfits,im1,'/aux/pc244a/jgroh/temp/1.fits',hdr1
;mwrfits,im1,'/aux/pc244a/jgroh/temp/1.fits',hdr1
ftab_ext,dir+file,'Data2,Data3',data2,data3,EXTEN_NO=1



END