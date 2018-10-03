;PRO ZE_ETACAR_CRIRES_READ_PLOT_HST_IMAGE_SLIT_OFFSET

dir='/Users/jgroh/images/etacar/'
imghst=dir+'AF85_0060.fits'
data=mrdfits(imghst,1,headerhst)

;ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,data,0,20000,img,/SQRT
imgasinh = ASINHSCL(data,min=0,max=250000)
getrot,headerhst,rot_val,cdelt
imgrot=rot(imgasinh,rot_val)
xcenter=698.5
ycenter=448.5
size_val=100
window,0
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrot, headerhst, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)'
!P.Color = fsc_color('white')
IMCONTOUR, imgrot, headerhst, TYPE=0, POSITION=pos, XMID=xcenter,YMID=ycenter,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
;TVIMAGE, imgrot, /KEEP_ASPECT, POSITION=pos
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
HEXTRACT, imgrot, headerhst, imgrotsel, headerhstimgsel, xcenter-size_val, xcenter+size_val, ycenter-size_val, ycenter+size_val

window,1
LOADCT,3
pos = [0.1,0.1,0.9,0.9]
; plotar a imagem:
TVIMAGE, imgrotsel, /KEEP_ASPECT, POSITION=pos
IMCONTOUR, imgrotsel, headerhstimgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE 
!P.Color = fsc_color('white')
IMCONTOUR, imgrotsel, headerhstimgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ',/NODATA, /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'
IMCONTOUR, imgrotsel, headerhstimgsel, TYPE=0, POSITION=pos, XMID=size_val-1,YMID=size_val-1,SUBTITLE=' ', /OVERLAY,/NOERASE ,XTICKFORMAT='(A2)',YTICKFORMAT='(A2)'

END