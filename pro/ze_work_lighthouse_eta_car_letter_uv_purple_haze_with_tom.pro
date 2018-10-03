;PRO ZE_WORK_LIGHTHOUSE_ETA_CAR_LETTER_UV_PURPLE_HAZE_WITH_TOM

t0=52819.8
p=2022.7
t1=52561.1
t2=52682.6
t3=52803.1
t4=52840.2
t5=52896.0
t6=52957.8 

phases=1.0 + ([t1,t2,t3,t4,t5,t6]-52819.8)/p -0.007

print,phases

dir='/Users/jgroh/data/hst/acs/'
data=mrdfits(dir+'AC78_0010.fits',1,header)

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

file0=dir+'AC78_0010.fits'

;NACO images have 27.1 mas per pixel
image0=MRDFITS(file0,1,header0)

imgasinh = ASINHSCL(image0,min=0,max=50000)
imgasinh=image0
getrot,header0,rot_val,cdelt
imgrot=rot(imgasinh,rot_val)
xcenter=572.0
ycenter=591.2

size_val=100
window,0
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrot, header0, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)'
!P.Color = fsc_color('white')
IMCONTOUR, imgrot, header0, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
;TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
HEXTRACT, imgrot, header0, imgrotsel, header0imgsel, xcenter-size_val, xcenter+size_val, ycenter-size_val, ycenter+size_val

window,1
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrotsel, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrotsel, header0imgsel, TYPE=0, POSITION=pos, XMID=size_val,YMID=size_val,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE 
!P.Color = fsc_color('white')
IMCONTOUR, imgrotsel, header0imgsel, TYPE=0, POSITION=pos, XMID=size_val,YMID=size_val,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
;IMCONTOUR, imgrotsel, header374imgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ', /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'

aa=900
bb=900

imageini=imgrotsel

file1=dir+'AD87_0020.fits'
;NACO images have 27.1 mas per pixel
image1=MRDFITS(file1,1,header1)

imgasinh = ASINHSCL(image1,min=0,max=50000)
imgasinh=image1
getrot,header1,rot_val,cdelt
imgrot=rot(imgasinh,rot_val)
xcenter=694.8
ycenter=444.5

size_val=100
window,0
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrot, header1, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)'
!P.Color = fsc_color('white')
IMCONTOUR, imgrot, header1, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
;TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
HEXTRACT, imgrot, header1, imgrotsel, header1imgsel, xcenter-size_val, xcenter+size_val, ycenter-size_val, ycenter+size_val

window,1
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrotsel, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrotsel, header1imgsel, TYPE=0, POSITION=pos, XMID=size_val,YMID=size_val,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE 
!P.Color = fsc_color('white')
IMCONTOUR, imgrotsel, header1imgsel, TYPE=0, POSITION=pos, XMID=size_val,YMID=size_val,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
;IMCONTOUR, imgrotsel, header374imgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ', /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'

imagefin=imgrotsel

;;capturing TRUE COLOR image of th NACO image to pic1
;window,2,retain=2,xsize=aa,ysize=bb
;LOADCT,3
;tvimage,image1,POSITION=[0,0,1.0,1.0]
;pic1=tvrd(0,0,aa,bb,/true)
;;wdelete,!d.window

;atv,imgrotsel-imagerotsela
END