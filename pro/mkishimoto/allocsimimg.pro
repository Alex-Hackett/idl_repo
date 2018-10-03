function allocsimimg, nx

;nx=1024
ny=nx
pix = dblarr(nx,ny)
arr = replicate(!values.d_nan, nx)
imh = allocimh();  pix, /center)
pos = pixelpos(pix, imh)

img = { $
  nx:           nx, $
  ny:           ny, $

  xpixsize:	0., $
  ypixsize:	0., $
  xcen:		0., $
  ycen:		0., $
  wpsf:		0., $
  wnuc: 	0., $

  model:	'', $

  wdust:	0., $
  rdeff:	0., $
  rdin:		0., $
  rdout:	0., $

  gam:		0., $
  beta:		0., $

  nucfrac:	0., $

  pix:          pix, $
  imh:          imh, $

  posx:		pix, $
  posy:		pix, $
  rad:		pix, $
  temp:		pix, $

  psf:		pix, $
  nuc:          pix, $
  dust:         pix, $

  obs:		pix, $

  visobs:	pix, $
  vispsf:	pix, $
  vis:		pix, $
  phs:		pix, $
  phsdeg:	pix, $
  visreal: 	pix, $
  visimag:	pix, $
  imhvis:	imh, $

;  appix:	arr, $
  sfreq:	arr, $
  u:		arr, $
  baseline: 	arr, $
  vis1d:	arr, $
  phs1d:	arr, $
  phs1ddeg:	arr, $
  lam_um:	0. , $
  sfreq_to_bline: 0. $
    
}

return, img
end

