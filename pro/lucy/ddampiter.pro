pro ddampiter,damp_image,raw_image,K,con_var,fft_psf, $
    npix, rwin, pwin, lab, init=init 
; DDAMPITER.PRO
;
; Execute multiple iterations of Damped Lucy's method.  This version solves
; for the model (damp_image) on an oversampled grid.  It also is modified
; to include the constant readout noise in the iteration ala Snyder.
; This version speeds convergence using a conjugate-gradient approach.
;
; damp_image    current version of image (will be changed by iterations)
;               (at least B * raw image size)
; B             oversampling factor
; raw_image     original image
; K             number of electrons per DN (7.5 for WFPC)
; con_var       readout noise, digitization, etc. = constant_noise^2/K
;               (about 30-50 for WFPC -- I tend to use numbers closer
;               to 50.) If sky has been subtracted, this can be = sky + con_var
; fft_psf       FFT of point spread function (same size as damp_image)
; niter         number of iterations to do
; chimin        minimum value of chi-square (0 by default, i.e. just do niter
;               iterations.  I rarely stop at chisq=1.)
; npix          total number of non-masked pixels
; rwin          window for displaying result
; pwin          window for displaying chi-squared (log,log)
; lab           WIDGET location for printing Chi-Squared
; imscale       scale result image linearly or logarithmically
; threshold     threshold for damping.  Roughly corresponds to square of
;               difference in sigma where damping turns on.  Default value
;               is 9 = 3 sigma ^ 2.  threshold=0 gives standard Lucy method.
; speedup       Speedup method to use:
;                  speedup  = 0 -> no speedup (standard Lucy iteration)
;                  speedup  = 1 -> line-search (Hook & Lucy acceleration)
;                  speedup  = 2 -> conjugate gradient (Turbo Lucy)
;               Default is speedup = 1.
; init          Set to non-zero value if this is first call.  Performs
;               extra initialization when speedup=2.
;
; A parameter that probably will not have to be changed:
;
; ndamp         Determines how sharply damping sets in.  Larger numbers
;               produce flatter likelihood function (more damping).
;               Default is ndamp=10.
;

COMMON chars,  log_unit
		  
COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter

    speedup = speed
    print, 'Damping= ', ndamp, 'Threshold= ', threshold

    if (ndamp LE 1) AND (threshold NE 0) then begin
        message,'Warning: damping is ignored for NDAMP='+string(ndamp)
        threshold = 0.0
        ndamp = 1
    endif

    CASE speedup OF

    0:  if (ndamp GT 0) $
        then message,'Damped Lucy iteration, no acceleration',/inform $
        else message,'Lucy iteration, no acceleration',/inform
      
    1:	if (ndamp GT 0) $
        then message,'Accelerated Damped Lucy iteration',/inform $
        else message,'Accelerated Lucy iteration',/inform

    2:  if (ndamp GT 0) $
        then message,'Turbo Damped Lucy iteration',/inform $
        else message,'Turbo Lucy iteration',/inform

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

    temp=size(damp_image)
    if temp(0) NE 2 then message,'damp_image must be 2-D'
    x_size=temp(1)
    y_size=temp(2)
    if x_size LT B*x_raw OR y_size LT B*y_raw then $
        message,'damp_image must be at least B times bigger than raw_image'

    temp = size(fft_psf)
    if temp(0) NE 2 then message,'fft_psf must be 2-D'
    if temp(1) NE x_size OR temp(2) NE y_size then $
        message,'fft_psf must be same size as damp_image'

    chiarr = MAKE_ARRAY(niter+1, /FLOAT, VALUE=0.0)
    ratio=fltarr(x_size,y_size)

; get normalization factor
    ratio(0:B*x_raw-1,0:B*y_raw-1) = K
    norm = float( fft( fft(ratio,-1) * conj(fft_psf), +1))
    zero=where(norm lt 1.e-3*max(norm))
    if(zero(0) ge 0) then begin
        norm(zero) = 1.0
; Zero damp_image where norm is zero -- those pixels don't affect
; the image anyway, and this will help speedup get a fast start.
        damp_image(zero) = 0.0
    endif

; blur initial guess and calculate chi-square
    fft_conv = fft_psf*fft(damp_image,-1)
    damp_conv = B^2*rebin((float(fft(fft_conv,+1)))(0:B*x_raw-1,0:B*y_raw-1), $
        x_raw,y_raw)
    fft_conv = 0    ; free storage
    chisq = total(K*(damp_conv - raw_image)^2/(damp_conv + con_var))/(nz-1)
    chiarr(0) = FLOAT(chisq)
    str = 'Initial chi-squared per degree freedom=' + $
	  STRING(chisq,format='(f15.8)')
    WIDGET_CONTROL, lab, SET_VALUE=str
    print, str
    printf, log_unit, str

    for i=1,niter do begin
	piter = i
;
; embed the ratio in a bigger array (same size as damp_image) with zero padding
; expand ratio by pixel replication back to oversampled size
;
        if threshold eq 0 then begin
            lnl = 1.0
        endif else begin
	    temp_damp = damp_conv+con_var > 0.0000001
	    temp_raw = raw_image + con_var > 0.0000001
            lnl = (- (2.0 / threshold) * K * (raw_image - damp_conv + $
                (raw_image+con_var)*alog((temp_damp)/ $
		(temp_raw)))) < 1 > 0
	endelse
        ratio(0:B*x_raw-1,0:B*y_raw-1) = rebin( K*(1 + $
            lnl^(ndamp-1) * (ndamp - (ndamp-1)*lnl) * $
            (raw_image-damp_conv) / (damp_conv+con_var) ), $
            B*x_raw,B*y_raw,/sample)
        fft_srat = fft(ratio,-1) * conj(fft_psf)
        if speedup eq 0 then begin
;
; no speedup
;
            damp_image = damp_image * float(fft(fft_srat,+1))/norm
            fft_srat = 0    ; free storage
            fft_conv = fft_psf*fft(damp_image,-1)
; bin in BxB blocks to get convolved model on same grid as data
            damp_conv = B^2*rebin( $
                (float(fft(fft_conv,+1)))(0:B*x_raw-1,0:B*y_raw-1), $
                x_raw,y_raw)
            fft_conv = 0    ; free storage
        endif else begin
;
; Call speedit to accelerate convergence
;
            new_damp = damp_image * float(fft(fft_srat,+1))/norm
            fft_srat = 0    ; free storage
            ;
            ; update damp_image and damp_conv
            ;
            dampspeedit,damp_image,new_damp,damp_conv,fft_psf,raw_image, $
                K,con_var,speedup
            new_damp = 0    ; free storage
        endelse
        ltv,damp_image(0:B*x_raw-1,0:B*y_raw-1)*B^2, rwin, imscale
;
; calculate chi-square
;
        chisq = total(K*(damp_conv - raw_image)^2/(damp_conv + con_var))/(nz-1)
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

