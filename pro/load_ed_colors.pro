pro load_ed_colors,color
; by Edwin Sirko
; 2003-01-25. Return color, which is an array where each element
; represents a new color
; color[[0,1,2,3]] = 
; background color, red, blue, green, magenta, orange
; Use color=-1 for foreground color
; 2004-12-16. Changing color scheme to
; white, red, dark green, blue, magenta, yellow, cyan, orange, bright green
; 2005-2-6. Adding medium gray, light gray, (light green, light purple?)
; 2005-4-8. dark green, medium magenta

; --- color stuff
rrr = intarr(256) & ggg = intarr(256) & bbb = intarr(256)
rrr[0:14] = [255,255,  0,  0,255,255,  0,220,  0, 160,220,255,64, 0, 128]
ggg[0:14] = [255,  0,150,  0,  0,255,255,120,255, 160,220,255,192,64,0]
bbb[0:14] = [255,  0,  0,255,255,  0,255,  0,  0, 160,220,128,255,0, 128]
rrr[20:27] = [255, 64, 128, 192, 32, 224, 160, 96] ; 2005-8-7 for b/w
ggg[20:27] = [255, 64, 128, 192, 32, 224, 160, 96]
bbb[20:27] = [255, 64, 128, 192, 32, 224, 160, 96]
rrr[255] = 255 & ggg[255] = 255 & bbb[255] = 255
if (!d.name eq 'PS') then begin 
	rrr[0] = 0 & ggg[0] = 0 & bbb[0] = 0
endif
tvlct,rrr,ggg,bbb
if (!d.name eq 'PS' or !d.n_colors ne 16777216L ) then $
	color = indgen(!d.n_colors)
if (!d.name eq 'X' and !d.n_colors eq 16777216L) then $
	color = rrr + ggg*256L + bbb*256L^2
if (!d.name eq 'X' and !d.n_colors eq 65536L) then $
	color = rrr + ggg*256L + bbb



return
end

