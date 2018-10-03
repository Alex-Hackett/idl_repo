pro ze_hrs_merge,wave,flux,wout,fout

;
; determine number of spectra
;
    s = size(wave) & ndim = s(0) & ns = s(1) & nspec = s(2)

;
; Type of weighting
;
  weight_array = replicate(1.0,ns,nspec)
  sigma_weighting = 0
  case 1 of
      n_elements(weights) eq 0: 
      n_elements(weights) eq 1: begin
      if (weights ne 0) and (err_proc ne 0) then begin
        sigma_weighting = 1
        good = where(err gt 0,ngood)
        if ngood gt 0 then $
            weight_array(good) = 1/err(good)^2
        bad = where(err le 0,nbad)
        if nbad gt 0 then weight_array(bad) = 0
      end
      end
      n_elements(weights) eq nspec: begin
          for i=0,nspec-1 do weight_array(*,i) = weights(i) 
      end
      n_elements(weights) eq n_elements(flux): weight_array = weights
      else: begin
        print,'HRS_MERGE: Invalid array size for WEIGHTS keyword input'
    retall
    end
  endcase
;------------------------ NEAREST/INTERP ------------------------
;
; determine wavelength range for each spectrum and order of wavelength
; vectors
;
;
; determine order of wavelengths
;
  wmins = wave(0,*)
  print,wmins
  order = sort(wmins)
    wmaxs = wave(ns-1,*)
     print,'wmax'
    print,wmaxs
    nkeep = replicate(ns,nspec)
  wmaxs = wmaxs(order)
  nkeep = nkeep(order)
;
; find overlap points
;
  ipos = lonarr(nspec)  ;starting data point not in wavelength
        ;range of previous spectrum
                                ; - changed to max of all previous
                                ;   spectra  4/23/98 RSH
  for i = 1,nspec-1 do begin
    good = where(wave(*,order(i)) gt max(wmaxs(0:i-1)),ngood)
    if ngood gt 0 then ipos(i)=good(0) else ipos(i) = ns
  endfor
;
; create output arrays
;
;       arg clipped at 0 because arrays were too short if
;           wavelength range fluctuating at both ends  - 4/23/98 RSH

  nout = long(total((nkeep-ipos)>0))
  print,nout
  wout = dblarr(nout)
  fout = fltarr(nout)
  weight_sum = fltarr(nout)
  
  iout = 0L   ;current position in output array
;
; loop on spectra
;
;       print,'    ISPEC        IOUT        KPOS         NK        KSPEC'
  for ispec = 0,nspec-1 do begin
      kspec = order(ispec)  ;position of spectrum
      kpos = ipos(ispec)    ;first new wavelength position
      nk = nkeep(ispec)   ;number of points to keep
;
; insert new wavelengths into output array
;
;           print,ispec,iout,kpos,nk,kspec
      if kpos lt nk then begin
      weight = weight_array(kpos:nk-1,kspec)
    wout(iout) = wave(kpos:nk-1,kspec)
    fout(iout) = flux(kpos:nk-1,kspec)*weight
    weight_sum(iout) = weight
    iout = iout+nk-kpos
      endif
;
; add in overlap region
;
      if kpos gt 0 then begin
;
; extract overlap region
;
    fover = flux(0:kpos-1,kspec)
    wover = wave(0:kpos-1,kspec)
    weight = weight_array(0:kpos-1,kspec)
    kpos1 = kpos-1
; -------------------------------INTERP--------------------------------------
;
; find region to correct
;
        index = where((wout ge wover(0)) and $
          (wout lt wover(kpos-1)),n)
        if n gt 0 then begin
      ifirst = index(0)   ;region in wout to proc.
      ilast = index(n-1)
      pointer = 0L      ;pointer in wover, fover

      for i = long(ifirst),long(ilast) do begin

;
; find two data points in wover that wout(i) is between
;
          while (pointer lt kpos1)  and $
           (wout(i) gt wover(pointer+1)) do pointer=pointer+1 
;
; interpolate
;
          pointer1 = pointer+1

          frac1 = (wout(i) - wover(pointer))/ $
          (wover(pointer1)-wover(pointer))
          frac2 = 1.0 - frac1
          interp_flux = frac2 * fover(pointer) + $
                  frac1 * fover(pointer1)
          w1 = frac2 * weight(pointer) + $
             frac1 * weight(pointer1)
             
          fout(i) = fout(i) + interp_flux*w1
          weight_sum(i) = weight_sum(i) + w1
          print,weight_sum
 
skipit:
        end; for i
    end; if n gt 0
      end; if mtype eq 'N'
      end; if kpos gt 0
  end; for ispec = 0,nspec-1
  bad = where(weight_sum eq 0,nbad)
  if nbad gt 0 then weight_sum(bad) = 1.0
  fout = fout/weight_sum

print,'Merging done.'
end
