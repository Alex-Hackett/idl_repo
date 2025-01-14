
;oblate(-) and prolate(+) density distrbutions \rho(2D) \propto \rho(1D) \times (1 - + a cos^b \theta]\,\,,

DP1=7.
DP2=5.
ND=40.
angles=20.
angles=angles+1.

phi=FINDGEN(angles)*(90./(angles-1))*3.141592/180.
;creating matrix of size (2,ys[1]*angles) to store the pairs of (angles,ND) to further convert to x,y
polarcoord=dblarr(2,ND*angles)
dencon=phi

FOR i=0., angles-1 DO BEGIN

       ; dencon[i]= 1-(DP1*(COS(phi[i]))^DP2)
	 dencon[i]=(1.0+DP1*(1.0-COS(phi(i))^2)^DP2)
ENDFOR


p=FINDGEN(ND)

;counters
l=0
r=1
m=0
s=1

for j=0., (ND*angles-1) do begin ;running through all the lines of the matrix
  if j ge (ND*r) then begin
    l=l+1
    r=r+1
  endif
  polarcoord(0,j)=phi[l]    ;positions polarcoord(0,*)=values of beta, working!!!
    
  polarcoord(1,j)=p[m]         ;positions polarcoord(1,*)=values of r1, working!!!
  m=m+1
  if m gt (ND-1) then begin
    m=0
  endif
endfor


;getting x,y coordinates, where 0,0 is center the center of the star.
rect_coord = CV_COORD(From_Polar=polarcoord, /To_Rect)
x=rect_coord(1,*)
y=rect_coord(0,*)



dencon1d=DBLARR(ND*angles)

l=0.
m=1.
FOR i=0., (ND*angles)-1 DO BEGIN
	dencon1d[i]=dencon[i-l]
	IF ((i+1)/m) ge angles THEN BEGIN
        m=m+1
	l=i+1
	ENDIF
ENDFOR


TRIANGULATE, x, y, circtriangles, circboundaryPts
circ_gridSpace = [0.9, 0.9] ; space in x and y directions [mas]
circ_griddedData = TRIGRID(x, y, dencon1d, circtriangles, circ_gridSpace,[MIN(x), MIN(y), MAX(x), MAX(y)], XGrid=circxvector, YGrid=circyvector)


END
