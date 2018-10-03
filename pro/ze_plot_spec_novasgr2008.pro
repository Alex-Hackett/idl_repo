Angstrom = '!6!sA!r!u!9 %!6!n'
close,/all

;defining observations (FITS)
obs08may08='/aux/pc244a/jgroh/espectros/nova_sgr_2008/nsgr2008_08may08ncoxa_hel.fits'
obs08may09='/aux/pc244a/jgroh/espectros/nova_sgr_2008/nsgr2008_08may09ncoxa_hel.fits'

;ZE_READ_SPECTRA_FITS, obs08may08,lambda08may08,flux08may08,header08may08,npix08may08
;ZE_READ_SPECTRA_FITS, obs08may09,lambda08may09,flux08may09,header08may09,npix08may09
ZE_PRINT_SPECTRA_EPS_OPT_NOVASGR2008,lambda08may08,flux08may08,lambda08may09,flux08may09


END
