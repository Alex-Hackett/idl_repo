dir='/Users/jgroh/data/lna/camiv_spectra/dados/02nov03/'
hd50=dir+'hd50896_mze.txt'
agua=dir+'agua1d.txt'

filefits_orig='hd50896n.fits'
out_fits='/Users/jgroh/temp/hd50896_02nov04_ma.fits'
flux_orig=mrdfits(dir+filefits_orig,0,header)



ZE_READ_SPECTRA_COL_VEC,hd50,w50,f50
ZE_READ_SPECTRA_COL_VEC,agua,wa,fa

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;line_norm,wa,fa,fanorm,norm,xnodes,ynodes
t=ZE_SHIFT_SPECTRA_VEL(wa,fanorm,141.)
t2=((t-1.0)*1.0 +1.) 

window,0
plot,w50,f50/t2,yrange=[0,70000],xrange=[10700,11190]
plots,w50,f50/t2,color = fsc_color('red')


line_norm,w50,f50/t,f50norm,norm,xnodes,ynodes

window,1
plot,w50,f50norm,yrange=[0,5],xrange=[10700,11190]

mwrfits,f50/t2,out_fits,header

END