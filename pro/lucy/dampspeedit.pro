pro dampspeedit,psi0,psi1,phi0,fft_psf,data,K,con_var,speedup
; accelerate damped lucy iteration
; if speedup<=1 use line search (default)
; if speedup>1 use conjugate gradient approach in conjunction with line search

;
; last search direction is saved in common
;
common cglscom, cgcount, dpsi, dphi

COMMON chars,  log_unit
		  
COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter

    temp=size(data)
    x_raw=long(temp(1))
    y_raw=long(temp(2))

    temp=size(psi0)
    x_size=long(temp(1))
    y_size=long(temp(2))

    if speedup LE 1 then begin
;
; just use Lucy step to give direction for line search
;
        dpsi = psi1-psi0
;
; convolve delta model with PSF to get delta (blurred model)
;
        dphi = float(fft(fft_psf*fft(dpsi,-1),+1))
        if B EQ 1 then begin
            dphi = dphi(0:x_raw-1,0:y_raw-1)
        endif else begin
            dphi = B^2*rebin(dphi(0:B*x_raw-1,0:B*y_raw-1), x_raw, y_raw)
        endelse

    endif else begin
;
; compute conjugate direction for line search using Lucy direction and
; previous direction
;
; restart every 3 steps
		if n_elements(cgcount) LE 0 then cglucy_restart
        if cgcount GE 3 then cglucy_restart
;
; take regular step if cgcount <= 0
;
        if n_elements(dpsi) NE n_elements(psi0) OR cgcount LE 0 then begin
            ;
            ; initial dpsi = direction of Lucy step
            ; (this version does not use g)
            ;
            dpsi = psi1-psi0
            ;
            ; convolve delta model with PSF to get delta (blurred model)
            ;
            dphi = float(fft(fft_psf*fft(dpsi,-1),+1))
            if B EQ 1 then begin
                dphi = dphi(0:x_raw-1,0:y_raw-1)
            endif else begin
                dphi = B^2*rebin(dphi(0:B*x_raw-1,0:B*y_raw-1), x_raw, y_raw)
            endelse
        endif else begin
            ;
            ; after first step use direction of last step to modify
            ; search direction.  This forces the directions of current
            ; and previous searches to be conjugate.
            ;
            ; dphi is blurred version of dpsi from last step
            ;
            gconv = float(fft(fft_psf*fft(psi1-psi0,-1),+1))
            if B EQ 1 then begin
                gconv = gconv(0:x_raw-1,0:y_raw-1)
            endif else begin
                gconv = B^2*rebin(gconv(0:B*x_raw-1,0:B*y_raw-1), x_raw, y_raw)
            endelse
            if threshold eq 0 then begin
;
; no damping -- use regular formula for conjugate gradients
;
               gamma = -total(K*dphi*gconv*(data+con_var)/(phi0+con_var)^2) / $
                        total(K*dphi^2    *(data+con_var)/(phi0+con_var)^2)
            endif else begin
;
; include damping in conjugate gradient formula
;
               lnl = ( - ( 2.0 / threshold )  * K * ( $
                   data - phi0 + (data+con_var) * float( alog( $
                   1.d0+(phi0-data)/(data+con_var) ) ) ) ) < 1.0 > 0.0
               ddd = K * lnl^(ndamp-2) / (phi0+con_var)^2 * ( $
                   (ndamp*(ndamp-1)*2./threshold) * K*(1-lnl)*(data-phi0)^2 + $
                   (data+con_var) * lnl * (ndamp-(ndamp-1)*lnl) )
               gamma = - total(ddd*dphi*gconv) / total(ddd*dphi^2)
               ddd = 0   ; free storage
               lnl = 0   ; free storage
            endelse
            ;
            ; update direction for both model and blurred model
            ;
            dpsi = psi1 - psi0 + gamma*dpsi
            dphi =    gconv    + gamma*dphi
            gconv = 0   ; free storage
        endelse
        cgcount = cgcount+1
    endelse

; maximum & minimum values for c is determined by requirement that new psi1>0
    neg=where(dpsi lt 0, count)
    if (count ge 1) then begin
	temp_dpsi = dpsi
	zero = where(dpsi(neg) eq 0., count)
	if (count ge 1) then temp_dpsi(zero) = 0.0000001
        cmax=min(-psi0(neg)/temp_dpsi(neg))
;        cmax=min(-psi0(neg)/dpsi(neg))
    endif else begin
        cmax=100.
    endelse
    neg = 0
;
    if speedup LE 1 then begin
        cmin = 1.0
    endif else begin
        pos=where(dpsi gt 0, count)
        if (count ge 1) then begin
            cmin=max(-psi0(pos)/dpsi(pos))
        endif else begin
            cmin=-100.
        endelse
        pos = 0
    endelse
;
    if speedup LE 1 then begin
        print,'cmin,cmax',cmin,cmax
    endif else begin
        print,'cgcount',cgcount,' cmin,cmax',cmin,cmax
    endelse

; initial guess for c is 1 if in range (cmin,cmax), otherwise is mean
; of cmin,cmax
    c=1<cmax>cmin
    if c NE 1 then c=(cmin+cmax)/2

; modified Newton's method to find maximum likelihood
; do at most 20 iterations
    for i=1,20 do begin
        if threshold eq 0 then begin
            f=total(K*dphi*((data-phi0-c*dphi)/(phi0+c*dphi+con_var)))
            dfdc=-total(K*(data+con_var)*(dphi/(phi0+c*dphi+con_var))^2)
        endif else begin
	    temp_dat = (data+con_var) > 0.0000001
	    temp_d2 = (1.d0 + (phi0-data+c*dphi)/(temp_dat)) > 0.0000001
            lnl = ( - ( 2.0 / threshold )  * K * ( data - phi0 - c*dphi + $
                 (data+con_var) * float(alog(temp_d2)))) < 1.0 > 0.0 
            ddd = lnl^(ndamp-1)*(ndamp-(ndamp-1)*lnl)
            f=total(K*ddd*dphi*((data-phi0-c*dphi)/(phi0+c*dphi+con_var)))
            dfdc=-total( K*(dphi/(phi0+c*dphi+con_var))^2 * ( $
                ddd*(data+con_var) + $
                (ndamp*(ndamp-1)*2/threshold) * K * $
                lnl^(ndamp-2) * (1-lnl) * (data-phi0-c*dphi)^2 ) )
        endelse
        dc=-f/dfdc
; go to binary division of interval between c,cmax if we're overshooting
; the maximum or between c,cmin if we're overshooting cmin
        if (c+dc ge cmax) then begin
            dc=(cmax-c)/2.
        endif else if(c+dc le cmin) then begin
            dc=(cmin-c)/2.
        endif
        c=c+dc
        if(abs(dc) le 1.e-2) then begin
            psi0=psi0+c*dpsi
            phi0=phi0+c*dphi
            if speedup LE 1 then begin
                print,'cmin, cmax, c ',cmin,cmax,c
                printf, log_unit,'cmin, cmax, c ',cmin,cmax,c
            endif 
            return
        endif
    endfor
    print,'did not converge'
    psi0=psi0+c*dpsi
    phi0=phi0+c*dphi
    return
end

