;PRO ZE_AGCAR_WORK_HARPS
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

ZE_READ_SPECTRA_FITS,'/Users/jgroh/data/eso_3d6m/harps/Advanced_Data_Products/agcar/ADP.HARPS.2008-02-17T05:15:03.863_03_S1D_A.fits',l08feb,f08feb,header08feb,nrec08feb
ZE_READ_SPECTRA_FITS,'/Users/jgroh/data/eso_3d6m/harps/Advanced_Data_Products/agcar/ADP.HARPS.2009-02-09T08:00:13.433_03_S1D_A.fits',l09feb,f09feb,header09feb,nrec09feb

lineplot,l08feb,f08feb
lineplot,l09feb,f09feb

END