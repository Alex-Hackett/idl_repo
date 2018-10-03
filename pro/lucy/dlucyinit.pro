pro dlucyinit, raw_image,con_var,psf,fft_psf,lucy_image,weight
; lucy_image    current version of image (will be changed by iterations)
; raw_image     original image (usually will be smaller than lucy_image)
; adu           number of electrons per DN
; noise         readout noise
; con_var       readout noise, digitization, etc. = constant_noise^2/adu
;               if sky has been subtracted, this can be = sky + con_var
; psf           point spread function
; fft_psf       FFT of point spread function
; lucy_image    current version of image (will be changed by iterations)

COMMON chars,   log_unit
		  
COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter

    con_var = (noise^2)/adu

    m = where(psf eq max(psf))
    psf = shift(psf, -m[0])
    fft_psf = fft(psf, -1)
    fft_psf = fft_psf / float(fft_psf[0,0])

    lucy_image = replicate(total(raw_image*weight)/(total(weight)), $
       oxsize, oysize)

END
