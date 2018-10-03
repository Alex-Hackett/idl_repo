LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

date_obs_all=['2007apr', '2008apr', '2008dec','2009jan','2009feb','2009apr']
date_obs=date_obs_all[0]

CASE date_obs of

;*********************************Apr 2007 ****************************************
 '2007apr': BEGIN

dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/CRIRES_DVD1/'
dir=dircriresrun+'270210/sci_proc/'
cal2070=dir+'CR_SEXT_270210_2007-04-19T05_30_35.800_DIT1_1090.4nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca,ptitle='2007 April, Integrated along the 11 arcsec slit at PA=325, on star'
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

cal2070=dir+'CR_SEXT_270210_2007-04-19T05_27_41.280_DIT1_1087.3nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

            END
            

;*********************************Apr 2008 ****************************************
 '2008apr': BEGIN

dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/381D-0262A_C01/'
dir=dircriresrun+'310723/sci_proc/'
cal2070=dir+'CR_SEXT_310723_2008-05-05T01:00:20.825_DIT1_1090.4nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca,ptitle='2008 April, Integrated along the 11 arcsec slit at PA=325, on star'
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

cal2070=dir+'CR_SEXT_310723_2008-05-05T00:46:21.211_DIT1_1087.3nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

            END
            
;*********************************DEC 2008 ****************************************
 '2008dec': BEGIN

dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/381D-0262B_C01_dec/'
dir=dircriresrun+'320086/sci_proc/'
cal2070=dir+'CR_SEXT_320086_2008-12-26T07_43_12.221_DIT1_1090.4nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca,ptitle='2008 December, Integrated along the 11 arcsec slit at PA=325, on star'
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

cal2070=dir+'CR_SEXT_320086_2008-12-26T07_05_44.119_DIT1_1087.3nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

            END
            
;*********************************JAN 2009 ****************************************

 '2009jan': BEGIN
 
dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/'
dir=dircriresrun+'200182818/sci_proc/'
cal2070=dir+'CR_SEXT_200182818_2009-01-08T07_20_38.529_DIT1_1090.4nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

cal2070=dir+'CR_SEXT_200182818_2009-01-08T06_42_37.035_DIT1_1087.3nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca,ptitle='2009 January, Integrated along the 11 arcsec slit at PA=325, on star'
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

            END
            
            
;*********************************FEB 2009 ****************************************
 '2009feb': BEGIN

dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043B_2009Feb09/'
dir=dircriresrun+'352647/sci_proc/'
cal2070=dir+'CR_SEXT_352647_2009-02-09T06_32_42.488_DIT1_1090.4nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca,ptitle='2009 February, Integrated along the 11 arcsec slit at PA=325, on star'
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

cal2070=dir+'CR_SEXT_352647_2009-02-09T06_12_38.858_DIT1_1087.3nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

            END
           

;*********************************APR 2009 ****************************************
 '2009apr': BEGIN

dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/383D-0240A_2009Apr03/'
dir=dircriresrun+'361944/sci_proc/'
cal2070=dir+'CR_SEXT_361944_2009-04-03T01_55_45.352_DIT1_1090.4nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca,ptitle='2009 April, Integrated along the 11 arcsec slit at PA=325, on star'
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

cal2070=dir+'CR_SEXT_361944_2009-04-03T01_27_00.321_DIT1_1087.3nm.fits'
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

lineplot,w1ca,f1ca
lineplot,w2ca,f2ca
lineplot,w3ca,f3ca
lineplot,w4ca,f4ca

            END
            
ENDCASE

END