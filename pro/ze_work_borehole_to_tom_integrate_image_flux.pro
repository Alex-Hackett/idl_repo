;PRO ZE_WORK_BOREHOLE_TO_TOM_INTEGRATE_IMAGE_FLUX
;integrate flux from Tom's borehole image
;CONSTANTS
cm_to_au=(1/1.496e+13); conversion factor to AU
cm_to_mas=(1/1.496e+13)/(2.3); conversion factor to mas, assuming d=2.3 kpc
constant=1.
model='k_band_half_opacity'

restore,'/Users/jgroh/borehole_from_tom/k_band/bh_kband'+model+'.sav'

IF N_elements(totalfluxfinal) eq 0 THEN BEGIN 
;;reading the file the first time to get minx,maxx,miny,maxy values and to set the x and y vectors
ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,'/Users/jgroh/borehole_from_tom/k_band_half_opacity/splash_00001.dat',image,minx,maxx,miny,maxy,header
nx=(size(image))[1]
ny=(size(image))[2]
xvalues=indgen(nx)*1.0D
yvalues=indgen(ny)*1.0D

FOR i=0., nx-1 do xvalues[i]=minx + ((maxx-minx)/nx)*i
print,min(xvalues),max(xvalues)
FOR i=0., ny-1 do yvalues[i]=miny + ((maxy-miny)/ny)*i
print,min(yvalues),max(yvalues)

;xvalues=xvalues*cm_to_au
xvalues=xvalues*cm_to_mas
;yvalues=yvalues*cm_to_au

dimy=627. ;number of phase images 
dimy=298. ;number of phase images
phase_vector=dblarr(dimy)
onedimage=dblarr(dimy,nx)
totalfluxy=dblarr(nx)
j=0.50108
step=0.00159
FOR i=0, dimy-1 DO BEGIN
i_str=strcompress(string(i+1, format='(I05)'))
print,'splash_'+i_str+'.dat'
ZE_BOREHOLE_TO_TOM_READ_SLIT_IMAGE,'/Users/jgroh/borehole_from_tom/k_band_half_opacity/splash_'+i_str+'.dat',image,minx,maxx,miny,maxy,header
;compute flux along y direction
for r=0., nx-1 do totalfluxy[r]=int_tabulated(yvalues*constant,image[r,*],/DOUBLE) 
onedimage[i,*]=totalfluxy[*]
phase_vector[i]=j
j=j+step

print,'Done for velocity: ', j
ENDFOR

totalfluxfinal=dblarr(dimy)
totalmag=totalfluxfinal
for i=0, dimy-1 do totalfluxfinal[i]=int_tabulated(xvalues*constant,onedimage[i,*],/DOUBLE) 

for i=0, dimy-1 do totalmag[i]=(-2.5)*alog10((totalfluxfinal[i]/totalfluxfinal[1]))

;obtain pixel scale in the x(phase_vector) and y(i.e. xvalues) directions
pixscale_x=xvalues[nx-1]-xvalues[nx-2] ;in mas
pixscale_phase=phase_vector[dimy-1]-phase_vector[dimy-2] ;in km/s


circ_griddedData=onedimage
circxvector=phase_vector
circyvector=xvalues

ENDIF

;circ_griddedDAta=alog10(circ_griddedData)
a=min(circ_griddedData,/NAN)
;a=1.5e+16
b=max(circ_griddedData,/NAN)
;b=1e+16
img=bytscl(circ_griddedData,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage


;plotting in window
xsize=900
ysize=760
window,8,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[min(circxvector),max(circxvector)], $
yrange=[min(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Offset (mas)', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 3
tvimage,img, /Overplot

nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[min(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[min(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[min(circyvector),max(circyvector)]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')


;plotting to EPS file

set_plot,'x'

aa=960
bb=760
;capturing TRUE COLOR image of the 2D spectrum to pic2
window,retain=2,xsize=aa,ysize=bb
LOADCT,3 
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
wdelete,!d.window

imgname='tom_forbidden_lines_slit_image_vel_x'
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/'+imgname+'.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

!X.THICK=8
!Y.THICK=8
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=8
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot, circxvector, circyvector, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[min(circxvector),max(circxvector)], $
yrange=[min(circyvector),max(circyvector)],xstyle=1,ystyle=1, xtitle='Velocity (km/s)', $
ytitle='Offset (mas)', /NODATA, Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
LOADCT, 3
tvimage,pic2, /Overplot

nd=1
;normalize colorbar between min and max values?
a=0.
b=1.
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
LOADCT,3
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.09, 0.92, 0.78*xsize/ysize]
LOADCT,0
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[min(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[min(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[min(circyvector),max(circyvector)]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')
xyouts,0.885,0.95,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')


device,/close_file
set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0

save,/variables,FILENAME='/Users/jgroh/borehole_from_tom/k_band/bh_kband'+model+'.sav'

END