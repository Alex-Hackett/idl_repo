;PRO ZE_ConvolvedSlitSpectra

;Modified by Jose Groh on 2010 Oct 07 13:47
dir='/Users/jgroh/borehole_from_tom/phi0d2/'
phi='phi0d96'
spec_line='[N II] 5756'
dir_stis_psf='/Users/jgroh/tinytim/stis_spec/5756_sub10/'
dir_stis_psf='/Users/jgroh/tinytim/stis_spec/4659_sub10/'
file_stis_psf='result00.fits'
ZE_HST_READ_STIS_PSF,dir_stis_psf+file_stis_psf,spec_line,psf_image,psfsize_x,psfsize_y,psf_pixscale

;Modified by Tom Madura

;CONSTANTS
cm_to_au=(1/1.496e+13); conversion factor to AU
cm_to_mas=(1/1.496e+13)/(2300.0); conversion factor to arcsec, assuming d=2.3 kpc
constant=1.


;;reading the file the first time to get minx,maxx,miny,maxy values and to set the x and y vectors
ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,dir+'pgplot_0000.dat',image,minx,maxx,miny,maxy,header

nx0=(size(image))[1]
ny0=(size(image))[2]

xvalues0=indgen(nx0)*1.0D
yvalues0=indgen(ny0)*1.0D

FOR i=0., nx0-1 do xvalues0[i]=minx + ((maxx-minx)/nx0)*i
print,min(xvalues0),max(xvalues0)
FOR i=0., ny0-1 do yvalues0[i]=miny + ((maxy-miny)/ny0)*i
print,min(yvalues0),max(yvalues0)

;xvalues=xvalues*cm_to_au
xvalues0=xvalues0*cm_to_mas
yvalues0=yvalues0*cm_to_mas
model_pixscale=xvalues0[nx0-1]-xvalues0[nx0-2] ;in mas if above lines are not commented
;yvalues=yvalues*cm_to_au

print, min(xvalues0), max(xvalues0)

dimy=49 ;number of velocity images
vel_vector=dblarr(dimy)
onedimage=dblarr(dimy,nx0)
totalfluxy=dblarr(nx0)
dataa2_all_offsets_contsub_crop=dblarr(nx0,ny0,dimy)

j=-600.
step=25
FOR i=0, dimy-1 DO BEGIN
;first, read in image files one at a time ,going from -600 to +600 in
;steps of +25
if i lt dimy/2. THEN  j_str=strcompress(string(j, format='(I04)')) ELSE  j_str='+'+strcompress(string(j, format='(I03)'))
print,'pgplot_'+j_str+'.dat'
ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,dir+'pgplot_'+j_str+'.dat',image,minx,maxx,miny,maxy,header
;next, rotate image to slit PA. Rotations are in degrees clockwise.
;assume z-axis is aligned with Homunculus and Homunculus is at PA=+132
;Then, for PA=+38, angle between z-axis and slit should be 86 degrees.
;Thus,
;For PA=+38, rotate by 356 degrees
;For PA=-28, rotate by 290 degrees
;For PA=+22, rotate by 340 degrees
;modified by J Groh to rotate image to PA=0 (i.e N is up, E is to the left)
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
hst_pixscale=0.0253
;rebin_factor=pixscale_x/hst_pixscale
;onedimagecnvl=frebin(onedimagecnvl,dimy,nx0*rebin_factor)



;Modified by Jgroh to plot images to xwindow and to GIF files
aa=800
bb=800
ct=3
nointerp=1
vel_val=j
a=0
b=6.5
print,'a b',a,b
ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_CREATE_MONOCHROMATIC_IMAGE,image,a,b,img,SQRT=0,LOG=0
ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_PLOT_MONOCHROMATIC_IMAGE_XWINDOW,img,a,b,xvalues0,yvalues0,aa,bb,vel_val,ct,nointerp

;sequential file numbering has to be used to propely create animated GIFs using convert
file_output='/Users/jgroh/temp/etc_tom_forbidden_line_mapping_feiii_'+phi+'_'+strcompress(string(i, format='(I04)'))
temp = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)

dataa2_all_offsets_contsub_crop[*,*,i]=image

;define max and min size of rotated image
maxx=max(xvalues0)
minx=min(xvalues0)
;define half-width of the slit, i.e. if slit is 0.1", put here 0.05"
slitwidth=0.1
;define starting and stopping indices of slit in image
itop=(slitwidth-minx)*w/(maxx-minx)
ibottom=(-slitwidth-minx)*w/(maxx-minx)
ibottom=ibottom-1
;create slit image by cropping rotated image using above indices
image=image[*,ibottom:itop]
s2=size(image)
w2=s2[1]
h2=s2[2]
print,w2,h2
;Now redo as in read of 1st file, but again here for new slit image
nx=(size(image))[1]
ny=(size(image))[2]

xvalues=indgen(nx)*1.0D
yvalues=indgen(ny)*1.0D

FOR k=0., nx-1 do xvalues[k]=minx + ((maxx-minx)/nx)*k
print,min(xvalues),max(xvalues)
FOR k=0., ny-1 do yvalues[k]=miny + ((maxy-miny)/ny)*k
print,min(yvalues),max(yvalues)

xvalues=xvalues*cm_to_mas

print, 'About to compute flux for velocity: ', j

;compute flux along y direction
for r=0., nx-1 do totalfluxy[r]=int_tabulated(yvalues*constant,image[r,*],/DOUBLE) 
onedimage[i,*]=totalfluxy[*]
vel_vector[i]=j
j=j+step

print,'Done for velocity: ', j-step
ENDFOR

;obtain pixel scale in the x(vel_vector) and y(i.e. xvalues) directions
pixscale_x=xvalues0[nx0-1]-xvalues0[nx0-2] ;in arcsec
pixscale_vel=vel_vector[dimy-1]-vel_vector[dimy-2] ;in km/s

;need to rotate image so that origin is at bottom left so that position along slit is displayed properly
onedimage=ROTATE(onedimage, 7)

;convolve in the SPECTRAL (i.e. VELOCITY) direction
onedimagecnvl=onedimage
hst_spec_res=37.5 ;in km/s
model_res=25. ; km/s
hst_cnvl_spec_res=SQRT(hst_spec_res^2-model_res^2)
hst_fwhm_pix_vel=hst_cnvl_spec_res/pixscale_vel

FOR I=0,nx -1 DO BEGIN
onedimaget=REFORM(onedimagecnvl[*,i])
onedimagecnvlt=cnvlgauss(onedimaget,fwhm=hst_fwhm_pix_vel)
onedimagecnvl[*,i]=onedimagecnvlt
ENDFOR

;Rebin image to HST double-sampling binning (0.0253 arcsec/pix)
hst_pixscale=0.0253
rebin_factor=pixscale_x/hst_pixscale
onedimagecnvl=frebin(onedimagecnvl,dimy,nx0*rebin_factor)

;circ_griddedData=onedimage
circ_griddedData=onedimagecnvl
circxvector=vel_vector
circyvector=xvalues0

;circ_griddedDAta=alog10(circ_griddedData)
a=min(circ_griddedData,/NAN)
;a=1.0e+17
;a=0.0
b=max(circ_griddedData,/NAN)/1
;b=6.48e+17
img=bytscl(circ_griddedData,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage


;plotting in window
xsize=900
ysize=760
window,9,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-max(circxvector),max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Angular Size (")', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13
tvimage,img, /Overplot,/nointerp

nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

;create animated GIF using convert
dir_movie='/Users/jgroh/temp/'
sufix_gif='etc_tom_forbidden_line_mapping_feiii_'+phi+'_'
movie_output_gif='etc_tom_forbidden_line_mapping_feiii_'+phi+'.gif'
movie_output_mov='etc_tom_forbidden_line_mapping_feiii_'+phi+'.mov'
digits=4
init_image=0
end_image=dimy
delay_time='30'
;ZE_GIF_ANIMATE_USING_CONVERT,dir_movie,sufix_gif,digits,init_image,end_image,delay_time,movie_output_gif,CONVERT_MOV=1

;command line to close QTAmateur application
;osascript -e 'tell application "QTAmateur" to quit'

;rename 'teste' to the correct filename; has to be run after this procedure is finished and the QTAmateur conversion is done
;spawn,'mv /Users/jgroh/Documents/teste '+dir_movie+movie_output_mov

;plot images integrated over a certain velocity range
vel_min=-600.    ;in km/s
vel_max=-200      ;in km/s
near = Min(Abs(vel_vector - vel_min), index7)
near2= Min(Abs(vel_vector - vel_max), index8)
a=0.0
b=max(TOTAL(dataa2_all_offsets_contsub_crop[*,*,index7:index8],3))/10.0
img_250_500_contsub=bytscl(TOTAL(dataa2_all_offsets_contsub_crop[*,*,index7:index8],3),MIN=a,MAX=b)
ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_PLOT_MONOCHROMATIC_IMAGE_XWINDOW,img_250_500_contsub,a,b,xvalues0,yvalues0,aa,bb,vel_val,ct,nointerp


;;trying to scale 2D images according to the velocity; doesn't work
;dataa2_scaled_vel=dataa2_all_offsets_contsub_crop
;FOR i=0, dimy-1 DO BEGIN
;dataa2_scaled_vel[*,*,i]=(dataa2_all_offsets_contsub_crop[*,*,i]/MAX(dataa2_all_offsets_contsub_crop[*,*,i]))*vel_vector[i]
;ENDFOR
;
;window,11
;ct=17
;loadct,ct
;imgtest=bytscl(TOTAL(dataa2_scaled_vel[*,*,*],3))
;ZE_BOREHOLE_FORBIDDEN_LINES__WITH_TOM_PLOT_MONOCHROMATIC_IMAGE_XWINDOW,imgtest,a,b,xvalues0,yvalues0,aa,bb,vel_val,ct,nointerp


;plotting to EPS file

;; set_plot,'x'

;; aa=960
;; bb=760
;; ;capturing TRUE COLOR image of the 2D spectrum to pic2
;; window,retain=2,xsize=aa,ysize=bb
;; LOADCT,3 
;; tvimage,img,POSITION=[0,0,0.95,0.95]
;; pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
;; wdelete,!d.window

;; imgname='tom_forbidden_lines_slit_image_vel_x'
;; ps_ysize=10.
;; ps_xsize=ps_ysize*aa/bb
;; ps_filename='/home/tmadura/'+imgname+'.eps'
;; set_plot,'ps'
;; device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

;; !X.THICK=8
;; !Y.THICK=8
;; !X.CHARSIZE=1.2
;; !Y.CHARSIZE=1.2
;; !P.CHARSIZE=2
;; !P.CHARTHICK=8
;; ticklen = 15.
;; !x.ticklen = ticklen/bb
;; !y.ticklen = ticklen/aa
;; LOADCT,0
;; !P.Background = fsc_color('white')
;; !P.Color = fsc_color('black')

;; plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
;; xrange=[-max(circxvector),max(circxvector)], $
;; yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
;; ytitle='Angular Size (")', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
;; LOADCT, 3
;; tvimage,pic2, /Overplot

;; nd=1
;; ;normalize colorbar between min and max values?
;; a=0.
;; b=1.
;; colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
;; number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
;; LOADCT,3
;; colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
;; POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
;; LOADCT,0
;; ;draws axes, white tick marks
;; AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
;; AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
;; AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
;; AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]
;; ;draws grid lines through 0,0
;; ;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;; ;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')
;; xyouts,0.885,0.95,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')


;; device,/close_file
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
