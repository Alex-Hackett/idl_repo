pro setvalsimimg, img

; constant
conv = 2.*sqrt(2.*alog(2.)) ; conversion factor from FWHM to sigma in Gaussian

; construct each component
r = img.rad

img.psf  = exp(- r^2.       /(2.*(img.wpsf /conv)^2) )
img.nuc  = exp(- r^2.       /(2.*(img.wnuc /conv)^2) )


case img.model of 

 'ring': begin
   img.dust = exp(-(r-img.rdeff)^2 /(2.*(img.wdust/conv)^2) )
   end

 'ringcut': begin
   img.dust = exp(-(r-img.rdeff)^2 /(2.*(img.wdust/conv)^2) )
   img.dust[where(r lt img.rdeff)]=0
   end

 'gaussian': begin
   img.dust = exp(- r^2. / (2.*(img.rdeff*2./conv)^2))
   end

 'ud': begin
   img.dust[where(r le img.rdeff*1.5)] = 1
   end

 'torus': begin
   nu_hz = !phc.c /(img.lam_um *1d-4)
   tsub = 1500.d
   rin = img.rdin

   used = where(r ge rin)

   temp = tsub * (r[used] /rin)^(-2./(4 + img.gam))
   img.temp[used] = temp

   lam0_um = 2.2
   nu0_hz  = !phc.c /(lam0_um *1d-4)

   img.dust[used] = (img.lam_um /lam0_um)^(-img.gam) $
                  * (planck_nu(nu_hz, temp) /planck_nu(nu0_hz, tsub)) $
                  * (r[used] /rin)^(1-img.beta)

   ob = where(r gt img.rdout, count)
   if count ne 0 then img.dust[ob] = 0.
   end

;inc = 30.
;r_inc = sqrt( pos.x^2 + pos.y^2 *(1.+(tan(inc/!radeg))^2.) )
;img.dust = exp(-(r_inc-rdust)^2 /(2.*(wdust/conv)^2) )

endcase


img.nuc = img.nuc  /total(img.nuc)  *img.nucfrac
img.dust= img.dust /total(img.dust) *(1 - img.nucfrac)

; construct 'real' image, and observed image
img.pix = img.nuc + img.dust
img.obs = convolve(img.pix, img.psf)

return
end


