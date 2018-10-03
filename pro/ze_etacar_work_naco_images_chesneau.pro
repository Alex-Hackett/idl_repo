PRO ZE_ETACAR_WORK_NACO_IMAGES_CHESNEAU,imgpsfsub
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

file374='/Users/jgroh/Downloads/JoseGroh/EC_F3d74_2006_p.fits'
file405='/Users/jgroh/Downloads/JoseGroh/EC_F4d05_2006_p.fits'

;NACO images have 27.1 mas per pixel
image374=MRDFITS(file374,0,header374)
image405=MRDFITS(file405,0,header405)

imgasinh = ASINHSCL(image374,min=0,max=50000)
getrot,header374,rot_val,cdelt
imgrot=rot(imgasinh,rot_val)
xcenter=646.5
ycenter=666.5
size_val=100
window,0
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrot, header374, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)'
!P.Color = fsc_color('white')
IMCONTOUR, imgrot, header374, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
;TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
HEXTRACT, imgrot, header374, imgrotsel, header374imgsel, xcenter-size_val, xcenter+size_val, ycenter-size_val, ycenter+size_val

window,1
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrotsel, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrotsel, header374imgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE 
!P.Color = fsc_color('white')
IMCONTOUR, imgrotsel, header374imgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
;IMCONTOUR, imgrotsel, header374imgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ', /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'

aa=900
bb=900

image1=imgrotsel
image1=ROT(image1,15.0)

;capturing TRUE COLOR image of th NACO image to pic1
window,2,retain=2,xsize=aa,ysize=bb
LOADCT,3
tvimage,image1,POSITION=[0,0,1.0,1.0]
pic1=tvrd(0,0,aa,bb,/true)
;wdelete,!d.window

;groh images have original pixel scale of 86 mas/pixel x 200 mas/pixel : that corresponds to a factor (86/27,200/27) less pixels in the (x,y) direction compared to NACO=(3.186,7.407) 
image2=imgpsfsub
;image2=ROT(image2,-1.0)
size_naco_x_mas=(size_val*2+1.0)*27.0
size_naco_y_mas=size_naco_x_mas;assuming square
size_crires_x=(size(image2))[1]
size_crires_y=(size(image2))[2]
size_crires_x_mas=(size(image2))[1]*86.0
size_crires_y_mas=(size(image2))[2]*200.0
resize_factor_x=size_crires_x_mas/size_naco_x_mas
resize_factor_y=size_crires_y_mas/size_naco_y_mas
index_lambda=80
image2=ShiFT_sub(image2,2.0,0.5)
image2_resize_to_naco_rot=ROT(image2,0.0)


;capturing TRUE COLOR image of the velocity slice in 2D space to pic2
LOADCT,0
!P.Background = fsc_color('white')
window,3,retain=2,xsize=aa,ysize=bb
LOADCT,13
tvimage,image2_resize_to_naco_rot,POSITION=[(1-resize_factor_x)/2.,(1-resize_factor_y)/2.,(1+resize_factor_x)/2.,(1+resize_factor_y)/2.]
pic2=tvrd(0,0,aa,bb,/true)
;wdelete,!d.window


Window,4,xsize=aa,ysize=bb
  BlendImage, pic2, pic1, ALPHA=0.3

END