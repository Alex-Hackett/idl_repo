pro setparsimimg, img

; need default settings for the following
;
; nucfrac ... flux fraction of nucleus
; lam_um  ... obs wavelength in micron
;             used in calc of baseline in calcvis1d and in torus model
;
; model   ... model name
;  gaussian, ring, ringcut, ud: rdeff
;                                   gaussian:    FWHM     = rdeff *2
;                                   ring:        diameter = rdeff *2
;                                   ringcut:     diameter = rdeff *2, 
;                                                empty at r < rdeff
;                                   ud:          diameter = rdeff *2 *1.5
;
;  torus                      : rin ... inner boundary radius
;                             : beta... radial density profile index

; set parameters
img.xpixsize = 0.03    ; mas
img.ypixsize = img.xpixsize

img.xcen = fix( (img.nx - 1.)/2. ) ; to get the same peak pixel position as
img.ycen = fix( (img.ny - 1.)/2. ) ; that in Fourier image

img.wpsf = 1000.  ; mas FWHM; only for psf, which isn't used for visibilty calc
img.wnuc = 0.06   ; mas FWHM

; for model = 'ring' / 'ringcut', FWHM of the ring width
img.wdust = img.rdeff /5.

; for model = 'torus'
img.rdout = img.rdin *1000.
img.gam   = 1.6 ; absorption efficiency index

; setup imh
img.imh = allocimh(img.pix, /idl)  ; first, imh in units of pixels
img.imh = conv_imh(img.imh, $      ; then have (xcen,ycen) at (0,0) in imh
          newxcen=img.xcen, newycen=img.ycen, $
          xpixsize=img.xpixsize, $ ; and also, imh in units of mas
          ypixsize=img.ypixsize)      
img.imh.xname='x offset (mas)'
img.imh.yname='y offset (mas)'


; construct positional images
pos = pixelpos(img.pix, img.imh)
img.posx = pos.x
img.posy = pos.y
img.rad  = sqrt(pos.x^2 + pos.y^2)  ; in mas

return
end

