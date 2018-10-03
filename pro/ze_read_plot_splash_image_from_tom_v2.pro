PRO ZE_SPLASH_COMPUTE_IMAGE_I_P_DELTA_LAMBDA_V2,circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData,AVERAGE=AVERAGE,n_average

i=81
i_str=strcompress(string(i+1, format='(I05)'))
ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,'/Users/jgroh/borehole_from_tom/k_band/splash_'+i_str+'.dat',image,minx,maxx,miny,maxy,header
t=size(image)
xsize_image=t[1]
ysize_image=t[2]

IF KEYWORD_SET(AVERAGE) THEN BEGIN
image_array=dblarr(xsize_image,ysize_image,n_average)
  FOR j=0, n_average-1 DO BEGIN
    i_str=strcompress(string(i+1, format='(I05)'))
    ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,'/Users/jgroh/borehole_from_tom/k_band/splash_'+i_str+'.dat',image,minx,maxx,miny,maxy,header
    image_array[*,*,j]=image
    i=i+2  
  ENDFOR
;do average
Result = AVG( image_array, 2 )
image=result
ENDIF ELSE BEGIN
ENDELSE

pix=1027. 

;;adapting to use Tom's image
circxvector=indgen(pix)*1.0D

FOR i=0., pix-1 do circxvector[i]=minx + ((maxx-minx)/pix)*i
;print,min(x2),max(x2)
circxvector=(circxvector/1.496e+13)/(2.3) ; converting from CM to mas
circyvector=circxvector                   ; converting from CM to mas

res_array_i_pix=congrid(image,pix,pix)

xcen_guess=pix/2+1
ycen_guess=pix/2+1
CNTRD, res_array_i_pix, xcen_guess,ycen_guess, xcen, ycen, 4./(circxvector[300]-circxvector[299]) 
xshift=(pix/2+1)-xcen
yshift=(pix/2+1)-ycen
res_array_i_pix_shift=shift_sub(res_array_i_pix,xshift,yshift)

circ_griddedData=res_array_i_pix_shift



;circxvector=x2
;circyvector=y2
;circ_griddedData=res_array

END
;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_SPLASH_PLOT_IMAGE_I_P_DELTA_LAMBDA,circxvector,circyvector,circ_griddedData,imginv=imginv

;circ_griddedDAta=alog10(circ_griddedData)
a=min(circ_griddedData,/NAN)
b=max(circ_griddedData,/NAN)
img=bytscl(circ_griddedData,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
;img=bytscl(circ_griddedData,MAX=1.0); byte scaling the image for display purposes with tvimage
;log
;img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img

;plotting in window
xsize=900
ysize=760
window,8,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[max(circxvector),-max(circxvector)], $
yrange=[-max(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 13
tvimage,imginv, /Overplot
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
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
PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

END
;--------------------------------------------------------------------------------------------------------------------------

;plot intensity profile for a given PA? TESTING;plot image profile along a given PA, passing through the center; useful for plotting the visibility.; PA convention: 0=N, increase eastwards
PRO ZE_PLOT_1DINTENSITY_PA_MAS, paprof,image,circxvector,circyvector,lambda_val,circ_GridSpace_mas,profile=profile,ang_radius=ang_radius

nx = (size(image, /dim))[0]
ny = (size(image, /dim))[1]

; if (xcen,ycen) are specified, then shift the image by (-xcen,-ycen) pixels
; to have the pixel (xcen, ycen) at (0,0). This does not have any effect
; on the resulting visibility amplitude image, but it does change phase, 
; real, and imag.

xcen=fix(nx/2. - 0.5)
ycen=fix(ny/2. - 0.5)

;intensity profile starting on the center? 
;x1=xcen
;y1=ycen

;intensity profile starting on the negative edge
x1=xcen-(nx/2)*(-1.)*SIN(paprof*!PI/180.)
y1=ycen-(ny/2)*COS(paprof*!PI/180.)
print,x1,y1

x2=xcen+(nx/2)*(-1.)*SIN(paprof*!PI/180.)
y2=ycen+(ny/2)*COS(paprof*!PI/180.)
print,x2,y2
nPoints = ABS(x2-x1+1) > ABS(y2-y1+1)

;Next, you must construct two vectors containing the X and Y locations, respectively, of these points. This is easily done in IDL, like this:
xloc = x1 + (x2 - x1) * Findgen(nPoints) / (nPoints - 1)
yloc = y1 + (y2 - y1) * Findgen(nPoints) / (nPoints - 1)
;Finally, the profile values are calculated by interpolating the image values at these locations along the line with the Interpolate command. (These will be bilinearly interpolated values, by default.) The code looks like this:
ang_radius_x=(xloc-xcen)*circ_GridSpace_mas[0]
ang_radius_y=(yloc-ycen)*circ_GridSpace_mas[1]
;print,ang_radius_x,ang_radius_y
ang_radius=SQRT(ang_radius_x^2. + ang_radius_y^2)
;help,ang_radius
for i=0,(n_elements(ang_radius)/2.)-1 DO ang_radius[i]=ang_radius[i]*(-1.)
profile = Interpolate(image, xloc, yloc)

END
;
;--------------------------------------------------------------------------------------------------------------------------
 
$MAIN CODE
;V2 INCLUDES AVERAGE of N_AVERAGE SPH FRAMES

CLOSE,/ALL
Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458

dist=2.3 ;in kpc
pa=0.
pa_str=strcompress(string(pa, format='(I03)'))

pix=1027.

!P.THICK=3
!X.THiCK=3
!Y.THICK=3
!P.CHARTHICK=1.5
!P.FONT=-1
nimages=1
totalflux=dblarr(pix,nimages)

;first loop computes the high spatial resolution images and the spectrum; cannot be used for computing visibilities and phases. 
circ_GridSpace_mas=[0.035,0.035]
;circ_GridSpace_mas=[0.035*3.75,0.035*3.75]
circ_GridSpace_mas=[0.015,0.015]
for i=0., nimages-1 do begin

ZE_SPLASH_COMPUTE_IMAGE_I_P_DELTA_LAMBDA_V2,circxvector=circxvector,circyvector=circyvector,circ_griddedData=circ_griddedData,AVERAGE=1,4
ZE_SPLASH_PLOT_IMAGE_I_P_DELTA_LAMBDA, circxvector,circyvector,circ_griddedData,imginv=imginv
;first loop to compute flux spectrum from Ip values
for j=0, pix -1  do totalflux[j,i]=int_tabulated(circxvector*(6.96*214.08*dist),circ_griddedData[j,*],/DOUBLE) ;using circxvector in 10^10cm
print,'Finished IMG '
endfor
;compute flux spectrum from Ip values ; we are doing the integral in P and delta (BH05 eq 12), F=1/d^2 *Int(0,2pi)Int(0,pmax)I(p,delta)dp ddelta
;first we do the integral in x inside the for LOOP above, and the the integral in y with the for loop below; units are Jy
totalfluxfim=dblarr(nimages)
for i=0, nimages-1 do totalfluxfim[i]=int_tabulated(circyvector*(6.96*214.08*dist),totalflux[*,i],/DOUBLE) ;;using circxvector in 10^10cm      /(3.08568025E+21)^2.
print,'Finished Images'
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

paprof=0. ; PA in degrees
image=imginv

LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

paprof_str=strcompress(string(paprof, format='(I02)'))

ZE_SPLASH_CREATE_INTENSITYIMAGE_EPS,pa,circ_griddedData=circ_griddedData,circxvector=circxvector,circyvector=circyvector
image=circ_griddedData
ZE_PLOT_1DINTENSITY_PA_MAS, paprof,image,circxvector,circyvector,lambda_val,circ_GridSpace_mas,profile=profile12,ang_radius=ang_radius12
ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/splash_intens_profile_'+'_PAimage'+pa_str+'_'+'_PAprof_'+paprof_str+'.txt',ang_radius12,profile12/max(profile12)



;read and plot files with p(mas), I from John's model
model2d='4314'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_043150.txt', r1,i1
model2d='5506'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_055060.txt', r2,i2
model2d='6737'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_067370.txt', r3,i3
model2d='7936'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_079380.txt', r4,i4
model2d='12617'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_126200.txt', r5,i5
model2d='16569'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_165700.txt', r6,i6
model2d='21029'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_210400.txt', r7,i7

!P.THICK=12
!X.THiCK=25
!Y.THICK=25
!P.CHARTHICK=2.5
!P.FONT=-1
;!P.CHARSIZE=3.5
;!X.CHARSIZE=3.5
;!Y.CHARSIZE=3.5

!P.Background = fsc_color('white')
LOADCT,0
xwindowsize=900.*1  ;window size in x
ywindowsize=360.*1  ; window size in y

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/etc_mod111_john_I_p_lambda_mas.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
!X.THICK=12
!Y.THICK=12
!P.CHARTHICK=10
 LOADCT, 0

colorm1=fsc_color('black')
colorm2=fsc_color('red')
colorm3=fsc_color('blue')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')

plot, r1,i1, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-10,10], $
xstyle=1,ystyle=1, ytitle='Intensity (normalized)', $
xtitle='Impact parameter (AU)', /NODATA, Position=[0.12, 0.17, 0.92, 0.97], title=title
plots,r1*2.3,i1,noclip=0,color=colorm1
plots,r2*2.3,i2,noclip=0,color=colorm2
plots,r3*2.3,i3,noclip=0,color=colorm3
plots,r4*2.3,i4,noclip=0,color=colorm4
plots,r5*2.3,i5,noclip=0,color=colorm5
plots,r6*2.3,i6,noclip=0,color=colorm6
plots,r7*2.3,i7,noclip=0,color=colorm7
device,/close

set_plot,'x'
set_plot,'ps'
!P.Background = fsc_color('white')
LOADCT,0
;plot K-band I(p) from John's model and overplot I(p) from Tom's  Splash image
device,filename='/Users/jgroh/temp/kband_splash_plus_john_I_p_mas.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
!X.THICK=12
!Y.THICK=12
!P.CHARTHICK=10
 LOADCT, 0
 
plot, r7,i7*2.3, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-10,10], yrange=[0,1.1],$
xstyle=1,ystyle=1, ytitle='Intensity (normalized)', $
xtitle='Impact parameter (AU)', /NODATA, Position=[0.12, 0.17, 0.92, 0.97], title=title
plots,r7*2.3,i7,noclip=0,color=colorm7
plots,ang_radius12*2.3,profile12/max(profile12),noclip=0,color=colorm1
device,/close

set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!Y.charsize=0
!X.charsize=0
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.MULTI=0
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!P.Background = fsc_color('white')


END