PRO ZE_SPECTRA_CROP_LAMBDA,l,f,lini,lfin,lcrop,fcrop
;crop spectrum from lini to lfin
lmin=findel(lini,l)
IF lmin lt 0 then lmin=0
lmax=findel(lfin,l)
IF lmax lt 0 then lmax=n_elements(l)-1
lcrop=l[lmin:lmax]
fcrop=f[lmin:lmax]



END