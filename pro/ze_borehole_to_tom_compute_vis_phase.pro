PRO ZE_BOREHOLE_TO_TOM_COMPUTE_VIS_PHASE,res_array,minx,maxx

ppmfile='/Users/jgroh/Desktop/splash_linear.ppm'
ppmfile2='/Users/jgroh/Desktop/splash_linear_gray.ppm'
fits='/Users/jgroh/Desktop/splash_linear2.fits'
READ_PPM,ppmfile,image
;
;image=READ_BINARY(ppmfile2)

values=0.30D*2^image[0,*,*]+0.59D*2^image[1,*,*]+0.11D*2^image[2,*,*]
values=REFORM(values)


Result = MRDFITS( fits)
minval=1.68
maxval=2.31e4
res_array=minval+result*(maxval-minval)/255.

minx=-2.31e+14 ;cm
maxx=2.31e+14 ; cm

END