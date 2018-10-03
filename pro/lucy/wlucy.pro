function wlucy, rwin, pwin, lab  

COMMON chars,   log_unit

COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter

COMMON imstruct,  raw_image, rname, rxsize, rysize, raw_true, raw_hdr, $
		  psf, pname, pxsize, pysize, psf_true, $
		  model, mname, mxsize, mysize, model_true, $
		  mask, kname, kxsize, kysize, mask_true, $
		  weight, wname, wxsize, wysize, weight_true, $
		  background, bname, bxsize, bysize, background_true

  if (speed EQ 2) then init = 1 else init = 0

  image = MAKE_ARRAY(oxsize,oysize,value=0.,/FLOAT)
  psfim = MAKE_ARRAY(oxsize,oysize,value=0.,/FLOAT)
  nmask = MAKE_ARRAY(oxsize,oysize,value=0,/INT)
  nweight = MAKE_ARRAY(oxsize,oysize,value=0.0,/FLOAT)
  K = fltarr(oxsize,oysize)
  if (oxsize EQ rxsize) then begin
   fpx = 0
   lpx = rxsize - 1
   tfpx = 0
   tlpx = rxsize - 1
  endif else begin
   fpx = ((oxsize - rxsize)/2) > 0
   lpx = (fpx + rxsize - 1) < (oxsize - 1) 
   tfpx = ((rxsize - oxsize)/2) > 0
   tdelt = rxsize < oxsize 
   tlpx = tfpx + tdelt - 1
  endelse
  if (oysize EQ rysize) then begin
    fpy = 0
    lpy = rysize - 1
    tfpy = 0
    tlpy = rysize - 1
  endif else begin
   fpy = ((oysize - rysize)/2) > 0
   lpy = (fpy + rysize - 1) < (oysize - 1) 
   tfpy = ((rysize - oysize)/2) > 0
   tdelt = rysize < oysize 
   tlpy = tfpy + tdelt - 1 
  endelse
  image(fpx:lpx,fpy:lpy)=raw_image(tfpx:tlpx,tfpy:tlpy)
  if (mask_true EQ 1) then begin 
    if (kxsize ne rxsize) OR (kysize ne rysize) then begin
      print, 'ERROR in mask size, must match raw image'
      return, -1
    endif else nmask(fpx:lpx,fpy:lpy) = mask(tfpx:tlpx,tfpy:tlpy) 
  endif else nmask(fpx:lpx,fpy:lpy) = 1
  if (weight_true EQ 1) then begin 
    if (wxsize ne rxsize) OR (wysize ne rysize) then begin
      print, 'ERROR in weight image, size must match raw image'
      return, -1
    endif else nweight(fpx:lpx,fpy:lpy) = weight(tfpx:tlpx,tfpy:tlpy) 
  endif else nweight(fpx:lpx,fpy:lpy) = 1.
  if ((oxsize EQ pxsize) AND (oysize EQ pysize)) then begin
   psfim = psf
  endif else begin
   fpx = ((oxsize - pxsize)/2) > 0
   lpx = (fpx + pxsize - 1) < (oxsize - 1) 
   fpy = ((oysize - pysize)/2) > 0
   lpy = (fpy + pysize - 1) < (oysize - 1) 
   tfpx = ((pxsize - oxsize)/2) > 0
   tdelt = pxsize < oxsize 
   tlpx = tfpx + tdelt - 1
   tfpy = ((pysize - oysize)/2) > 0
   tdelt = pysize < oysize 
   tlpy = tfpy + tdelt - 1 
   psfim(fpx:lpx,fpy:lpy)=psf(tfpx:tlpx,tfpy:tlpy)
  endelse
  limit = -(noise^2)/adu 
  toolow = where(raw_image LT limit, count)
  if (count GT 0) then begin
    raw_image(toolow) = limit 
    nmask(toolow) = 0
  endif
  npix = total(nmask)
  nweight = nweight * nmask

  dlucyinit, image,con_var,psfim,fft_psf,lucy_image,nweight
   K = nweight * adu
   nweight = 0
   nmask = 0
   if (damp EQ 1) then begin
      if (model_true EQ 0) then damp_image=lucy_image else damp_image = model
      ddampiter, damp_image, image, K, con_var, fft_psf, npix, rwin, pwin, $
	      lab, init=init
      lucy_image = damp_image
   endif else begin
      if (model_true EQ 0) then iter_image=lucy_image else iter_image=model
      dlucyiter, iter_image, image, K, con_var, fft_psf, npix, rwin, pwin, $
	      lab, init=init 
      lucy_image = iter_image
   endelse
  return, lucy_image

END
