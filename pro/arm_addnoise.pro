;+
; NAME: arm_addnoise
;       
; CATEGORY: astronomy
;
; PURPOSE: degrade spectrum to desired signal-to-noise ratio
;
; CALLING SEQUENCE: arm_addnoise, s, n, snr_new, [snr=, signal_new=, noise_new=]
;
; INPUTS:
;   s       - array of signal values (eg, flux array)
;   n       - array of noise values  (eg, error array)
;   snr_new - array of desired signal-to-noise ratio values;
;             alternatively a single value will ceiling the
;             signal-to-noise ratio values 
;       
; OPTIONAL INPUTS:
;   snr - array of current signal-to-noise values (default=S/N)
;
; KEYWORDS:
;
; OUTPUTS:
; 
; OPTIONAL OUTPUTS:
;   signal_new - degraded version of S
;   noise_new  - degraded version of N
;
; EXAMPLE:
;
; PROCEDURES USED:
;
; COMMENTS: This routine ONLY degrades spectra.  Values of SNR_NEW which
;           exceed the original values will be ignored.  The option to
;           supply the original signal-to-noise values (SNR) in lieu
;           of just using S divided by N exists because the user may
;           have a better estimation (eg, a continuum fit divided by
;           an error array which has been interpolated over absorption
;           features).
;
; MODIFICATION HISTORY:
;    written by A.R.Marble, Steward Obs., 2004 March 17
;    tolerates zeroes in input noise array, A.R.Marble, 2004 Sep 23 
;    !values.f_nan changed to !values.f_infinity, ARM 2006 Oct 19 
;-

pro arm_addnoise, s, n, snr=snr, snr_new, signal_new=signal_new, noise_new=noise_new

    num = n_elements(s)

; defaults

    if n_elements(snr_new) eq 1L then snr_new = fltarr(num)+snr_new $
    else snr_new = snr_new * 1.0

    if n_elements(n) ne num then $
      message, 'N array has incompatible dimensions'
    n = n > 0
    zero = WHERE(n eq 0.0, nzero, complement=pos, ncomplement=npos)
    if n_elements(snr) eq 0L then begin
        snr_old = s * 0
        if nzero gt 0L then snr_old[zero] = !values.f_infinity
        if npos gt 0L then snr_old[pos] = s[pos] * 1.0 / n[pos]
    endif else snr_old = snr

; error-checking

    if n_elements(snr_new) ne num or n_elements(snr_old) ne num then $
      message, 'SNR arrays have incompatible dimensions'

; determine pixels to degrade

    degrade = where(snr_old gt snr_new, ndegrade)
    if ndegrade gt 0L then snratio = snr_new[degrade] / snr_old[degrade]

; initialize new signal and noise arrays

    signal_new = s
    noise_new = n

    if ndegrade gt 0L then begin

; determine necessary noise, allowing for originally noiseless pixels

       factor = s[degrade] / snr_new[degrade]
       noisy = where(n[degrade] gt 0, nnoisy)
       if nnoisy gt 0 then factor[noisy] = $
         sqrt((snratio[noisy])^(-2)-1) * n[degrade[noisy]]
       noise = randomn(seed, ndegrade) * factor

; degrade signal and noise arrays

       signal_new[degrade] = signal_new[degrade] + noise
       noise_new[degrade] = sqrt(noise_new[degrade]^2 + factor^2)

    endif
    
end
