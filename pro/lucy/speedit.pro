pro speedit,psi0,psi1,phi0,fft_psf,data,K,con_var,log_unit,speedup
; accelerate lucy iteration
; if speedup<=1 use line search (default)
; if speedup>1 use conjugate gradient approach in conjunction with line search

;
; last search direction is saved in common
;
common cglscom, cgcount, dpsi, dphi

COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter

    temp=size(data)
    x_raw=long(temp(1))
    y_raw=long(temp(2))

    temp=size(psi0)
    x_size=long(temp(1))
    y_size=long(temp(2))

;
; select type of acceleration
;
    if speedup LE 1 then begin
        turbo = 0
        cgcount = 0
    endif else begin
        turbo = 1
;
        if n_elements(cgcount) LE 0 then begin
; cgcount undefined
            cglucy_restart
            turbo = 0
        endif else if n_elements(dpsi) NE n_elements(psi0) OR $
          cgcount LE 0 then begin
; cgcount<=0 means take non-turbo step
            turbo = 0
        endif
    endelse
;
    if NOT turbo then begin
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
        gamma = -total(K*dphi*gconv*(data+con_var)/(phi0+con_var)^2) / $
                 total(K*dphi^2    *(data+con_var)/(phi0+con_var)^2)
        ;
        ; update directions for both model, blurred model
        ;
        dpsi = psi1 - psi0 + gamma*dpsi
        dphi =    gconv    + gamma*dphi
    endelse
    cgcount = cgcount+1

; maximum & minimum values for c is determined by requirement that new psi1>0
    neg=where(dpsi lt 0)
    if (neg(0) ne -1) then begin
        cmax=min(-psi0(neg)/dpsi(neg))
    endif else begin
        cmax=100.
    endelse
    neg = 0
;
; if cmax < 1 then turbo step is not effective, just take standard step
;
    if turbo AND (cmax LT 1) then begin

        dpsi = psi1 - psi0
        dphi = gconv
        cgcount = 1
        turbo = 0

        neg=where(dpsi lt 0)
        if (neg(0) ne -1) then begin
            cmax=min(-psi0(neg)/dpsi(neg))
        endif else begin
            cmax=100.
        endelse
        neg = 0

    endif
;
    gconv = 0   ; free storage
;
    if NOT turbo then begin
        cmin = 1.0
    endif else begin
        pos=where(dpsi gt 0)
        if (pos(0) ne -1) then begin
            cmin=max(-psi0(pos)/dpsi(pos))
        endif else begin
            cmin=-100.
        endelse
        pos = 0
    endelse
;
; initial guess for c
    c = 1.0

; modified Newton's method to find maximum likelihood
; do at most 20 iterations
    for i=1,20 do begin
        model=phi0+con_var+c*dphi
        f=total(K*dphi*((data+con_var)/model-1))
        dfdc=-total(K*(data+con_var)*(dphi/model)^2)
        dc=-f/dfdc
; go to binary division of interval between c,cmax if we're overshooting
; the maximum or between c,cmin if we're overshooting cmin
        if (c+dc ge cmax) then begin
            dc=(cmax-c)/2.
        endif else if(c+dc le cmin) then begin
            dc=(cmin-c)/2.
        endif
        c=c+dc
;        print,'i=',i,'c=',c
        if(abs(dc) le 1.e-2) then begin
            psi0=psi0+c*dpsi
            phi0=phi0+c*dphi
            if NOT turbo then begin
                print,'accel    cmin,cmax,c ',cmin,cmax,c,format='(a,f,f,f)'
                printf, log_unit,'accel    cmin,cmax,c ',cmin,cmax,c,$
		   format='(a,f,f,f)'
            endif else begin
                print,'turbo',cgcount,' cmin,cmax,c ',cmin,cmax,c,$
		      format='(a,i3,a,f,f,f)'
                printf, log_unit,'turbo',cgcount,' cmin,cmax,c ',cmin,cmax,c,$
		      format='(a,i3,a,f,f,f)'
            endelse
            return
        endif
    endfor
    print,'did not converge'
    psi0=psi0+c*dpsi
    phi0=phi0+c*dphi
    return
end
