FUNCTION READ_IPDATA_BIN,file,arrsize
data=DBLARR(1, arrsize)
OPENR, lun, file, /GET_LUN
READU, lun, data
RETURN,data
CLOSE,lun
END
;--------------------------------------------------------------------------------------------------------------------------

PRO WRITE_IPDATA_TXT,data_bin,file_txt
OPENW,2,file_txt
PRINTF,2,data_bin
CLOSE,2
END
;--------------------------------------------------------------------------------------------------------------------------

filename_ipdata_txt='/aux/pc244a/jgroh/temp/teste_read_fits.txt'
file='/aux/pc244a/jgroh/temp/2agc0.imh'
;file='/aux/pc244a/jgroh/temp/1.fits'
;rdfits_struct, file, st
;help,/struct,st
;flux=mrdfits(file,0,header)
;fits_open,file,fcb
fits_read, file, data, header
mwrfits,data,'/aux/pc244a/jgroh/temp/6.fits',header
;ftab_help,file
;mwrfits,im1,'/aux/pc244a/jgroh/temp/1.fits',hdr1
;mwrfits,im1,'/aux/pc244a/jgroh/temp/1.fits',hdr1
;ftab_ext,file,'Wavelength,Extracted_RECT',w,f,EXTEN_NO=4
;plot,w,f/3450.

arrsize=400.
ipdata_txt=READ_IPDATA_BIN(file,arrsize)
WRITE_IPDATA_TXT,ipdata_txt,filename_ipdata_txt

END
