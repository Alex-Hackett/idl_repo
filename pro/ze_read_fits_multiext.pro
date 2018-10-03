file='/aux/pc244a/jgroh/data/eso_vlt/crires/Cepheids_nardetto/302509/sci_proc/CR_SEXT_302509_2008-01-03T05:15:59.148_DIT15_2150.0nm.fits'
;rdfits_struct, file, st
;help,/struct,st

ftab_help,file
;mwrfits,im1,'/aux/pc244a/jgroh/temp/1.fits',hdr1
;mwrfits,im1,'/aux/pc244a/jgroh/temp/1.fits',hdr1
ftab_ext,file,'Wavelength,Extracted_RECT',w,f,EXTEN_NO=4
plot,w,f/3450.
END
