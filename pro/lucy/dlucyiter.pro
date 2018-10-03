pro dlucyiter, lucy_image, raw_image, K, con_var, fft_psf, npix, $
     rwin, pwin, lab, init=init 
; DLUCYITER.PRO
;
; Execute multiple iterations of Lucy's method.  This version solves
; for the model (lucy_image) on an oversampled grid.  It also is modified
; to include the constant readout noise in the iteration ala Snyder.
; This version speeds convergence using a conjugate-gradient approach.
;
; lucy_image    current version of image (will be changed by iterations)
;               (at least B * raw image size)
; B             oversampling factor
; raw_image     original image
; K             number of electrons per DN (7.5 for WF/PC)
; con_var       readout noise, digitization, etc. = constant_noise^2*K
;               (about 30-50 for WFPC, 2-8 for WFPC2.)
;               If sky has been subtracted, this can be = sky + con_var
; fft_psf       FFT of point spread function (same size as lucy_image)
; niter         number of iterations to do
; chimin        minimum value of chi-square (0 by default, i.e. just do niter
;               iterations.  I rarely stop at chisq=1.)
; speedup       Speedup method to use:
;                  speedup <= 0 -> no speedup (standard Lucy iteration)
;                  speedup  = 1 -> line-search (Hook & Lucy acceleration)
;                  speedup >= 2 -> conjugate gradient (Turbo Lucy)
;               Default is speedup = 1.
; init          Set to non-zero value if this is first call.  Performs
;               extra initialization when speedup=2.
;

COMMON chars,   log_unit
		  
COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter

    speedup = speed
    CASE speedup OF

    0:  message,'Lucy iteration, no acceleration',/inform
    1:  message,'Accelerated Lucy iteration',/inform
    2:  message,'Turbo Lucy iteration',/inform

    ENDCASE
;
; special initialization for Turbo speedup -- first 5 steps don't use
; CG acceleration
;
        if keyword_set(init) then begin
            cglucy_restart, -4
            message,'Starting with 5 accelerated (non-turbo) steps',/inform
        endif

    temp=size(raw_image)
    if temp(0) NE 2 then message,'raw_image must be 2-D'
    x_raw=temp(1)
    y_raw=temp(2)
    nz = npix

    temp=size(lucy_image)
    if temp(0) NE 2 then message,'lucy_image must be 2-D'
    x_size=temp(1)
    y_size=temp(2)
    if x_size LT B*x_raw OR y_size LT B*y_raw then $
        message,'lucy_image must be at least B times bigger than raw_image'

    temp = size(fft_psf)
    if temp(0) NE 2 then message,'fft_psf must be 2-D'
    if temp(1) NE x_size OR temp(2) NE y_size then $
        message,'fft_psf must be same size as lucy_image'

    ratio=fltarr(x_size,y_size)

; get normalization factor
    ratio(0:B*x_raw-1,0:B*y_raw-1) = K
    norm = float( fft( fft(ratio,-1) * conj(fft_psf), +1))
    zero=where(norm lt 1.e-3*max(norm), count)
    if(count gt 0) then begin
        norm(zero) = 1.0
; Zero lucy_image where norm is zero -- those pixels don't affect
; the image anyway, and this will help speedup get a fast start.
        lucy_image(zero) = 0.0
    endif

; blur initial guess and calculate chi-square
    fft_conv = fft_psf*fft(lucy_image,-1)
    lucy_conv = B^2*rebin((float(fft(fft_conv,+1)))(0:B*x_raw-1,0:B*y_raw-1), $
        x_raw,y_raw) 
    fft_conv = 0    ; free storage
    chiarr = MAKE_ARRAY(niter+1, /FLOAT, VALUE=0.0)
    chisq = total(K*(lucy_conv - raw_image)^2/(lucy_conv + con_var))/(nz-1)
    chiarr(0) = FLOAT(chisq)
    str = 'Initial chi-squared per degree freedom=' + $
	  STRING(chisq,format='(f15.8)')
    WIDGET_CONTROL, lab, SET_VALUE=str
    print, str
    printf, log_unit, str

    for i=1,niter do begin
	piter = i
;
; embed the ratio in a bigger array (same size as lucy_image) with zero padding
; expand ratio by pixel replication back to oversampled size
;
        ratio(0:B*x_raw-1,0:B*y_raw-1) = rebin( $
            K*(raw_image+con_var)/(lucy_conv+con_var), $
            B*x_raw,B*y_raw,/sample) 
        fft_srat = fft(ratio,-1) * conj(fft_psf)
        if speedup EQ 0 then begin
;
; no speedup
;
            lucy_image = lucy_image * float(fft(fft_srat,+1))/norm
            fft_srat = 0    ; free storage
            fft_conv = fft_psf*fft(lucy_image,-1)
; bin in BxB blocks to get convolved model on same grid as data
            lucy_conv = B^2*rebin( $
                (float(fft(fft_conv,+1)))(0:B*x_raw-1,0:B*y_raw-1), $
                x_raw,y_raw) 
            fft_conv = 0    ; free storage
        endif else begin
;
; Call speedit to accelerate convergence
;
            new_lucy = lucy_image * float(fft(fft_srat,+1))/norm
            fft_srat = 0    ; free storage
            ;
            ; update lucy_image and lucy_conv
            ;
            speedit,lucy_image,new_lucy,lucy_conv,fft_psf,raw_image, $
                K, con_var, log_unit, speedup
            new_lucy = 0    ; free storage
        endelse
	ltv, lucy_image, rwin, imscale
;
; calculate chi-square
;
        chisq = total(K*(lucy_conv - raw_image)^2/(lucy_conv + con_var))/(nz-1)
	chiarr(i) = FLOAT(chisq)
        str = 'Iteration' + string(i,format='(i4)') + ' of'+ $
            string(niter,format='(i4)') + ' Chi-squared=' + $
	    string(chisq,format='(f15.8)')
        WIDGET_CONTROL, lab, SET_VALUE=str
	print, str
	printf, log_unit, str
        WSET, pwin
	if (i EQ 1) $
         then PLOT, chiarr, /YLOG, MIN_VALUE=0.0, YRANGE=[chimin,chiarr(0)], $
		  XTITLE='Iteration', YTITLE='LOG Chi-Squared' $
         else OPLOT, chiarr, MIN_VALUE=0.0
        if(chisq LE chimin) then begin
            print,'chi-sq <= ',chimin,', converged'
            return
        endif
    endfor
end
