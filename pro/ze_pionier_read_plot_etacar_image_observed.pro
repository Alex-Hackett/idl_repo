;PRO ZE_PIONIER_READ_PLOT_ETACAR_IMAGE_OBSERVED
;read observed image in fits format from JB Le Bouquin
dir='/Users/jgroh/papers_in_preparation_groh/groh_Etacar_pionier/'
obsimagefile='image_20140109_0p3mas.fits'
;obsimagefile='image_20140109_dirty.fits'
circ_griddedData=mrdfits(dir+obsimagefile, 0, header)
orig_size=(size(circ_griddeddata))[1]
pix_scale=0.3
npix=128

circxvector=pix_Scale*indgen(128.0)
circyvector=pix_Scale*indgen(128.0)


;zoom in image
;
;;best for binary
;circ_griddedData=circ_griddedData[31:127-32,31:127-32]
;circxvector=circxvector[0:63]
;circyvector=circyvector[0:63]

;circ_griddedData=circ_griddedData[0+(origsize/2.)-(factor*origsize/2.)

;;best for inner rotation match with model images
circ_griddedData=circ_griddedData[31+14:127-32-14,31+14:127-32-14]
circxvector=circxvector[0:35]
circyvector=circyvector[0:35]

a=min(circ_griddedData,/NAN)
;a=-7.0
;a=alog10(a)
b=max(circ_griddedData,/NAN)
;b=24.0
;print,a,b
circ_griddedData=TRANSPOSE(ROT(circ_griddedData,90,/INTERP))
;circ_griddedData=rot(REVERSE(TRANSPOSE(circ_griddedData)),180,/interp)
img=bytscl(circ_griddedData,MIN=a,MAX=b)

;i;mg=bytscl(circ_griddedData,MAX=max(circ_griddedData))
;MWRFITS, img,'/Users/jgroh/temp/intens_124.fits',/ISCALE, /CREATE
!P.Background = fsc_color('white')
LOADCT,0,/SILENT

xwindowsize=700.*1  ;window size in x
ywindowsize=700.*1  ; window size in y

;;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize ;original, working fine

LOADCT,13,/SILENT
tvimage,img,POSITION=[0,0,0.95,0.95],/nointerp
;pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
wdelete,!d.window

xsize=700
ysize=700

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/img_pionier_obs.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches

!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
!Y.OMARGIN=[8,4]
ticklen = 15.
!x.ticklen = ticklen/ywindowsize
!y.ticklen = ticklen/xwindowsize
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')


   
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

title=''


plot, circxvector, circyvector, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[max(circxvector)/2.,-max(circxvector)/2.], $
yrange=[-max(circyvector)/2.,max(circyvector)/2.],xstyle=1,ystyle=1, xtitle='RA offset (mas)', $
ytitle='DEC offset (mas)', /NODATA, Position=[0.24, 0.24, 0.96, 0.96], title=title
LOADCT, 13,/SILENT
tvimage,pic2, /Overplot,/nointerp
;linear colorbar
;converts colobar ticknames to strings and crop it in order to get rid of the many decimals, since it is not possible
; to use TICKNAMES and FORMAT with AXIS (which is used in colorbar)...bummer!  Using NUMBER_FORMATTER function from D Fanning
;circ_griddedData=1.0 ;doing that in order to get the correct values in the colorbar...but screwing uo everything!
nd=2
;colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
;number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar_ticknames_str=['0.0','0.2', '0.4', '0.6', '0.8', '1.0']
LOADCT,13,/SILENT
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, CHARSIZE=1.5,  /RIGHT,$
POSITION=[0.24, 0.04, 0.96, 0.07]
LOADCT,0,/SILENT
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector)/2.,max(circxvector)/2.],xcharsize=xc
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector)/2.,max(circyvector)/2.],ycharsize=yc,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector)/2.,max(circyvector)/2.],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector)/2.,max(circyvector)/2.]
;draws grid lines through 0,0
;PLOTS,[-max(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
;PLOTS,[0,0],[-max(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')
;xyouts,0.08,0.970,'H-band image, '+TEXTOIDL('W=')+w_str+', i='+inc_str+'!Eo!N, PA='+pa_str+'!Eo ',/NORMAL,charsize=3.0,color=fsc_color('black')
;xyouts,0.85,0.85,'c)',/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=12

xyouts,0.08,0.035,TEXTOIDL('I/I_{max}'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12

device,/close
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
set_plot,'x'


END