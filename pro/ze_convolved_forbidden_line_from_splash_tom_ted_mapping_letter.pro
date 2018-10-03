;PRO ZE_CONVOLVED_FORBIDDEN_LINE_FROM_SPLASH_TOM_TED_MAPPING_LETTER

;Modified by Jose Groh on 2010 Oct 07 13:47
dir='/Users/jgroh/papers_in_preparation_groh/ted_mapping_letter/'
dir_stis_psf='/Users/jgroh/tinytim/stis_spec/5756_sub10/'
dir_stis_psf='/Users/jgroh/tinytim/stis_spec/4659_sub10/'
file_stis_psf='result00.fits'
ZE_HST_READ_STIS_PSF,dir_stis_psf+file_stis_psf,spec_line,psf_image,psfsize_x,psfsize_y,psf_pixscale

;CONSTANTS
cm_to_au=(1/1.496e+13); conversion factor to AU
cm_to_mas=(1/1.496e+13)/(2300.0); conversion factor to arcsec, assuming d=2.3 kpc

;;reading the file the first time to get minx,maxx,miny,maxy values and to set the x and y vectors
;ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,dir+'phase0d163_blue.dat',image,minx,maxx,miny,maxy,header
;ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,dir+'phase0d163_red.dat',image,minx,maxx,miny,maxy,header
;ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,dir+'phase0d323_blue.dat',image,minx,maxx,miny,maxy,header
ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,dir+'phase0d323_red.dat',image,minx,maxx,miny,maxy,header

nx0=(size(image))[1]
ny0=(size(image))[2]

xvalues0=indgen(nx0)*1.0D
yvalues0=indgen(ny0)*1.0D

FOR i=0., nx0-1 do xvalues0[i]=minx + ((maxx-minx)/nx0)*i
print,min(xvalues0),max(xvalues0)
FOR i=0., ny0-1 do yvalues0[i]=miny + ((maxy-miny)/ny0)*i
print,min(yvalues0),max(yvalues0)

;xvalues=xvalues*cm_to_au
xvalues0_cm=xvalues0
yvalues0_cm=yvalues0
xvalues0=xvalues0*cm_to_mas
yvalues0=yvalues0*cm_to_mas
model_pixscale=xvalues0[nx0-1]-xvalues0[nx0-2] ;in arcsec if above lines are not commented out
print,'arcsec ', min(xvalues0), max(xvalues0)

p=dblarr(nx0,ny0)
for i=0, nx0-1 do for j=0,ny0-1 do p[i,j]=SQRT(xvalues0_cm[i]^2+yvalues0_cm[j]^2)
;rotate image to PAz=312 def
image=ROT(image,48,/INTERP,MISSING=0)

;Get size, width, and height of rotated image
s=size(image)
w=s[1]
h=s[2]
print,w,h

;Modified by J. Groh on 2010 Oct 07 15:43
;convolve in the SPATIAL direction at each velocity
psf_imagei=frebin(psf_image,nx0,ny0)
imconv = convolve( image, psf_imagei )
image=imconv
hst_pixscale=0.1
rebin_factor=model_pixscale/hst_pixscale
;image=frebin(image,nx0*rebin_factor,ny0*rebin_factor)
image=frebin(image,20,20) ;an even number has to be used to avoid the artificial shift

help,image
aa=800
bb=800
ct=3
nointerp=1
a=min(image,/NAN)
b=max(image,/NAN)/1.5
;b=1e-6
a=0
print,'a b',a,b
ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_CREATE_MONOCHROMATIC_IMAGE_v2,image,a,b,img,SQRT=0,LOG=0
ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_PLOT_GENERIC_IMAGE_XWINDOW,img,a,b,xvalues0,yvalues0,aa,bb,ct,nointerp
ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_PLOT_GENERIC_IMAGE_EPS,img,a,b,xvalues0,yvalues0,aa,bb,ct,nointerp
set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0


END
