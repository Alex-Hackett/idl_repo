dir='/Users/jgroh/espectros/'
file='wd1_photometry_bonanos_16465878.txt'

readcol,dir+file,coord,band,hjd,mag,err,FORMAT='A,A,F,F,F'

bandi=band(where(band eq 'I'))
hjdi=hjd(where(band eq 'I'))
magi=mag(where(band eq 'I'))
erri=err(where(band eq 'I'))

bandr=band(where(band eq 'R'))
hjdr=hjd(where(band eq 'R'))
magr=mag(where(band eq 'R'))
errr=err(where(band eq 'R'))

bandv=band(where(band eq 'V'))
hjdv=hjd(where(band eq 'V'))
magv=mag(where(band eq 'V'))
errv=err(where(band eq 'V'))

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

window,1
plot,hjdi,magi,yrange=[15.6,14.5],/NODATA
plots,hjdi,magi,noclip=0,linestyle=1
plots,hjdi,magi,noclip=0,psym=2


tzero=hjdi[0]+2.237    ; [in days], 
period=4.43
epochi = (hjdi - TZERO)  /  PERIOD
;epoch2i=epochi
epoch2i = epochi - LONG(epochi)

;epoch2i=epoch2i-0.505036

neg=[WHERE(epoch2i lt 0)]
epoch2i[neg]=epoch2i[neg]+1.0

magi=magi(sort(epoch2i))
epoch2i=epoch2i(sort(epoch2i))


window,2
hjdi0=hjdi[0]
plot,epoch2i,magi,yrange=[15.6,14.5],/NODATA
;plots,epoch2i,magi,noclip=0,linestyle=1
plots,epoch2i,magi,noclip=0,psym=2


END