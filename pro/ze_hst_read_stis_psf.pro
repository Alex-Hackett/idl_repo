PRO ZE_HST_READ_STIS_PSF,dir_file_stis_psf,spec_line,psf_image,psfsize_x,psfsize_y,psf_pixscale
;dir_file_stis_psf='/Users/jgroh/tinytim/stis_spec/5756/result00.fits'
psf_image=MRDFITS(dir_file_stis_psf,0,header)
psf_pixscale=fxpar(header,'PIXSCALE')
psfsize_x=fxpar(header,'NAXIS1')
psfsize_y=fxpar(header,'NAXIS2')

END