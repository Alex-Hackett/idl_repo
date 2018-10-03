function simimg

; basic parameters
nx    = 1024L ;*2
nim   = 2

; prepare image arrays
imgarr = replicate(allocsimimg(nx), nim)

; set parameters
imgarr.nucfrac = 0.

;imgarr.lam_um      = 10.
;imgarr.model       = ['torus', 'torus','gaussian','ring']
;imgarr[0:1].rdin   = [0.4, 1.2]
;imgarr[0:1].beta   = 2.0
;imgarr[2:3].rdeff  = [7.5, 7.5]

;imgarr.lam_um      = [8.0,12.5, 8.0,12.5]
;imgarr.model       = 'torus'
;imgarr.rdin        = [0.4, 0.4, 1.2, 1.2]
;imgarr.beta        = [2.0, 2.0, 2.5, 2.5]

;imgarr.lam_um      = [8.0, 9.5,11.0,12.5]
;imgarr.model       = 'torus'
;imgarr.rdin        = 1.2
;imgarr.beta        = 2.0

imgarr.lam_um = [2.2, 1.6]
;imgarr.model  = 'ring'
;imgarr.rdeff  = 0.5  ; 1.2 
;imgarr.nucfrac= 0.2
imgarr.model  = 'torus'
imgarr.rdin   = [0.6, 0.6]
imgarr.beta   = 3.
imgarr.nucfrac= [0.3,0.5]

; set parameters
for i=0, nim-1 do begin img=imgarr[i] & setparsimimg,img & imgarr[i]=img &endfor

; then calculate model images, visibilities
for i=0, nim-1 do begin img=imgarr[i] & setvalsimimg,img & imgarr[i]=img &endfor
for i=0, nim-1 do begin img=imgarr[i] & setvisimg,   img & imgarr[i]=img &endfor
for i=0, nim-1 do begin img=imgarr[i] & setvis1d,    img & imgarr[i]=img &endfor

return, imgarr
end


