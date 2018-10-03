pro rashrc,dx,dy,v2,v3

; Compute RAS source plate offsets required to move image given amount on HRC CCD

t=-20.2		; angle of anamorphic correction
m=1.080		; anamorphic mag in X, reciprocal in Y
phi=2.68	; residual angle between -V2 and X
sf=1.151e-4	; RAS source plate micrometer (inches) per HRC pixel

; first correct anamorphism
ct=cos(t/!radeg)
st=sin(t/!radeg)
xx=ct*dx+st*dy	; rotate CCW
yy=-st*dx+ct*dy
yy=yy/m		; apply mag to each axis
xx=xx*m
xa=ct*xx-st*yy	; rotate back to CCD coords
ya=st*xx+ct*yy

; compute source plate offsets
cphi=cos(phi/!radeg)
sphi=sin(phi/!radeg)
dv2=-sf*(cphi*xa+sphi*ya)
dv3=sf*(-sphi*xa+cphi*ya)

n=strtrim(string(n_elements(dx)),2)
fmt='(a,'+n+'f10.4)'
fmtp='(a,'+n+'f8.2)'
print,'Delta X:  ',dx,format=fmtp
print,'Delta Y:  ',dy,format=fmtp
print,'Delta V2: ',dv2,format=fmt
print,'Delta V3: ',dv3,format=fmt
if n_params(0) eq 4 then begin
  print,'New V2: ',v2+dv2,format=fmt
  print,'New V3: ',v3+dv3,format=fmt
endif

end
