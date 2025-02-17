function axiscorrection3,x,y,z,nx,ny,nz,corrnorm=corrnorm

mm = 100;
ntime = 2;

for j=0, n_elements(x)-1 DO BEGIN
    undefine, r, a1, b1, s
    r = sqrt((x(j) - x)^2 + (y(j) - y)^2 + (z(j) - z)^2) & r(j) = 1e20
    b1 = sort(r)
    s = b1(0:mm)
    
    nx1(j) = mean(nx(s))
    ny1(j) = mean(ny(s))
    nz1(j) = mean(nz(s))
endfor

if (ntime NE 0) THEN BEGIN
 for ind=0,ntime -1 DO BEGIN
  for j=0, n_elements(x)-1 DO BEGIN
    undefine, r, a1, b1, s 
    r = sqrt((x(j) - x)^2 + (y(j) - y)^2 + (z(j) - z)^2) & r(j) = 1e20
    b1 = sort(r)
    s = b1(0:mm)

    nx2(j) = mean(nx1(s))
    ny2(j) = mean(ny1(s))
    nz2(j) = mean(nz1(s))
  endfor
  undefine,nx1, ny1, nz1
  nx1 = nx2
  ny1 = ny2
  nz1 = nz2
  undefine, nx2, ny2, nz2
 endfor
endif


corrnorm(0,*) = nx1
corrnorm(1,*) = ny1
corrnorm(2,*) = nz1

END


function sphere_normals2,j, m, dzy, index_sorted_r,x,y,z,v=v       
   
   undefine, theta, phi, r, a, coef, v1, v2, vx1
   undefine, vx2, vy1, vy2, vz1, vz2, nor, v, b2
   undefine, b3, b4, b5, b6, b7
   
   coord_sphere = CV_COORD(FROM_RECT=[x, y, z],/TO_SPHERE)
   phi=REFORM(coord_sphere[0,*]) & theta=REFORM(coord_sphere[1,*]) & r=REFORM(coord_sphere[2,*])
   theta = !pi/2.0D - theta &  theta = theta*180.0D/!pi & theta = (theta + 180.0) MOD 180.0
   phi = phi*180.0D/!pi &  phi = (phi + 360.0) MOD 360.0
   theta = theta*!pi/180.0D
   phi = phi*!pi/180.0D

   nmax = min([50,n_elements(x)])
   ok_index = 0
   a1 = 0
   while (ok_index EQ 0)  DO BEGIN    
     for l=a1,m+a1-3 DO BEGIN
        ;print,l,a1,m
        ;print,dzy
        ;print,index_sorted_r(l)
        if WHERE(dzy EQ index_sorted_r(l)) GE 0 THEN BEGIN
           IF n_elements(set1) EQ 0 THEN set1=index_sorted_r(l) ELSE set1 = [set1, index_sorted_r(l)]
        endif
     endfor

     b2 = WHERE(phi(set1) LE phi(j),countb2)
     b3 = WHERE(theta(set1(b2)) LE theta(j),countb3)

     if (countb2 GE 0 AND countb3 GE 0) THEN BEGIN
         coef(0) = set1(b2(b3(0)))
         ok_index = 1
     ENDIF else begin
         a1 = a1 + 10
         if (a1 GT nmax) THEN BEGIN
             break
         endif
     endelse
   endwhile
   
   ok_index = 0
   a2 = 0
   while (ok_index EQ 0) DO BEGIN
     for l=a2, m+a2 DO BEGIN  
        if WHERE(dzy eq index_sorted_r(l)) GE 0 THEN BEGIN
           IF n_elements(set1) EQ 0 THEN set2=index_sorted_r(l) ELSE set2 = [set2, index_sorted_r(l)]
        endif
     endfor

     b2 = WHERE(phi(set2) LE phi(j))
     b4 = WHERE(theta(set2(b2)) GT theta(j))

     if (b2 GE 0 AND b4 GE 0) THEN BEGIN
         coef(1) = set2(b2(b4(0)))
         ok_index = 1
     endif else BEGIN
         a2 = a2 + 10;
         if (a2 GT nmax) THEN BEGIN
             break
         endif
     endelse
   endwhile
   
   ok_index = 0
   a3 = 0
   while (ok_index EQ 0) DO BEGIN
     for l=a3,m+a3 DO BEGIN
        if WHERE(dzy eq index_sorted_r(l)) GE 0 THEN BEGIN
           IF n_elements(set3) EQ 0 THEN set3=index_sorted_r(l) ELSE set3 = [set3, index_sorted_r(l)]
        endif
     endfor

     b5 = WHERE(phi(set3) GT phi(j))
     b6 = WHERE(theta(set3(b5)) GT theta(j))

     if (b5 GE 0 AND b6 GE 0) THEN BEGIN
         coef(2) = set3(b5(b6(0)))
         ok_index = 1
     endif else BEGIN
         a3 = a3 + 10;
         if (a3 GT nmax) THEN BEGIN 
             break
         endif
     endelse
   endwhile
   
   ok_index = 0
   a4 = 0
   while (ok_index GT 0) DO BEGIN 

     for l=a4,m+a4 DO BEGIN  
        if WHERE(dzy eq index_sorted_r(l)) GE 0 THEN BEGIN
           IF n_elements(set4) EQ 0 THEN set4=index_sorted_r(l) ELSE set4 = [set4, index_sorted_r(l)]
        endif
     endfor

     b5 = WHERE(phi(set4) GT phi(j))
     b7 = wHERE(theta(set4(b5)) LE theta(j))

     if (b5 GE 0 AND b7 GE 0) THEN BEGIN
         coef(3) = set4(b5(b7(0)))
         ok_index = 1
     endif else begin
         a4 = a4 + 10
         if (a4 GT nmax) THEN BEGIN
             break
         endif
     endelse
   endwhile
   
   
   if ((a1 GT nmax) OR (a2 GT nmax) OR (a3 GT nmax) OR (a4 GT nmax)) THEN BEGIN
       v = [0, 0, 0]
   endif else begin
      vx1 = x(coef(2)) - x(coef(0))
      vx2 = x(coef(3)) - x(coef(1))

      vy1 = y(coef(2)) - y(coef(0))
      vy2 = y(coef(3)) - y(coef(1))

      vz1 = z(coef(2)) - z(coef(0))
      vz2 = z(coef(3)) - z(coef(1))
      
      v1 = [vx1, vy1, vz1]
      v2 = [vx2, vy2, vz2]
      
      v = crossp(v1,v2)
      nor = norm(v)
      if nor EQ 0 THEN BEGIN
         v = [0, 0, 0]
      endif else begin
         v = v/nor
      endelse
   endelse

END




;PRO ZE_NORMALS                                                                   

;% in str1 and str2 you need to put the full path to where the original tecplot 
;% files or ASCII files are, and where the files with the normals added to them 
;% should be located.
;
;% To generate the normals , first you need to extract the isosurfaces by
;% tecplot and save it as ascii files: x,y,z,....
;% It doesn't have to be a file generated by Tecplot, but any ascii file that 
;% describe the surface for which the normals are to be extracted.
;
;% If you are using ascii files generated by Tecplot, you need to save then in
;% new files without heather and vertices! then they can be put in the directory 
;% /input to be used by this subroutine. 
;
;% once the normals are generated and added to the new output ascii file 
;% located in /output you need to add the heather and vertices to this newly generated
;% file. Remember to add in the heather 3 new variables "nx" "ny" "nz"
;
;
;% of course the variables in the input and output files in this example 
;% (in this file) except x,y,z,.....nx,ny,nz can be changed dependent on the variables 
;% in your input file 

str1 = '/Users/jgroh/temp/normal/input/'
str2 = '/Users/jgroh/temp/normal/outputnormals/'

;%filedata.dat is the ascii file

filename1 = str1+'filedata_ze.dat'

data = READ_ASCII(filename1)
undefine, filedata

undefine, x, y, z, rho, p, vx, vy, vz
undefine, bx, by, bz, theta, phi, r
x = data.field01(0,*) & y = data.field01(1,*) & z = data.field01(2,*)
rho = data.field01(3,*) & p = data.field01(10,*)
vx = data.field01(4,*) & vy = data.field01(5,*) & vz = data.field01(6,*)
bx = data.field01(7,*) & by = data.field01(8,*) & bz = data.field01(9,*)
     
coord_sphere = CV_COORD(FROM_RECT=[x, y, z],/TO_SPHERE)
phi=REFORM(coord_sphere[0,*]) & theta=REFORM(coord_sphere[1,*]) & r=REFORM(coord_sphere[2,*])
theta = !pi/2.0D - theta &  theta = theta*180.0D/!pi
theta = (theta + 180.0) MOD 180.0
phi = phi*180.0D/!pi &  phi = (phi + 360.0) MOD 360.0

undefine, dz1, dzy11, dzy12, dz2, dzy21, dzy22

dz1 = WHERE(z GE 0, countdz1)
IF countdz1 GT 0 THEN dzy11 = dz1(WHERE(y(dz1) GE 0)) ELSE dzy11=-1
IF countdz1 GT 0 THEN dzy12 = dz1(WHERE(y(dz1) LT 0)) ELSE dzy12=-1
dz2 = WHERE(z LT 0, countdz2)
IF countdz2 GT 0 THEN BEGIN
    tempdzy21=WHERE(y(dz2) GE 0,countdzy21)
    IF countdzy21 GT 0 THEN dzy21 = dz2(WHERE(y(dz2) GE 0)) ELSE dzy21=-1
ENDIF
IF countdz2 GT 0 THEN BEGIN
    tempdz22=WHERE(y(dz2) LT 0,countdzy22)
    IF countdzy22 GT 0 THEN dzy22 = dz2(WHERE(y(dz2) LT 0)) ELSE dzy22=-1
ENDIF
m = 10        ; % initial number of close by points
undefine,nx, ny, nz
nx=dblarr(n_elements(x)) & ny=nx & nz=nx
for j=0, n_elements(x)-1 do BEGIN
   undefine, v1, n1, ra, index_sorted_ra, a1, d1, d2, d3, d4
   v1 = [x(j), y(j), z(j)] & n1 = norm(v1)
   ra = sqrt((x(j) - x)^2 + (y(j) - y)^2 + (z(j) - z)^2) & ra(j) = 1e20
    index_sorted_ra = sort(ra)
;    find which of the 4 hemispheres our point (ind1) is
   d1 = WHERE(dzy11 EQ j) 
   d2 = WHERE(dzy12 EQ j)
   d3 = WHERE(dzy21 EQ j)
   d4 = WHERE(dzy22 EQ j)
   nx(j) = 0 & ny(j) = 0 & nz(j) = 0
   if  (d1 GE 0)  THEN BEGIN           ; hemisphere 1:  z >= 0 and y >= 0
      undefine, v
      v = sphere_normals2(j, m,dzy11, index_sorted_ra,x,y,z)
      nx(j) = v(0)
      ny(j) = v(1)
      nz(j) = v(2)
   endif
   if (d2 GE 0)  THEN BEGIN           ; hemisphere 1:  z>=0 and y< 0
      undefine, v
      v = sphere_normals2(j, m, dzy12, index_sorted_ra,x,y,z)
      nx(j) = v(0)
      ny(j) = v(1)
      nz(j) = v(2)
   endif
   if (d3 GE 0)  THEN BEGIN         ; hemisphere 1:  z < 0 and y >= 0
      undefine, v
      v = sphere_normals2(j, m, dzy21, index_sorted_ra,x,y,z)
      nx(j) = v(0)
      ny(j) = v(1)
      nz(j) = v(2)
   endif
   if (d4 GE 0)  THEN BEGIN          ; hemisphere 1:  z < 0 and y < 0
      undefine, v
      v = sphere_normals2(j, m, dzy22, index_sorted_ra,x,y,z)
      nx(j) = v(0)
      ny(j) = v(1)
      nz(j) = v(2)
   endif
endfor


undefine, nn, theta1, phi1, nx1, ny1, nz1
nn = axicorrection3(x,y,z,nx,ny,nz)   ;   % take care of the axis
nx1 = nn(0,*)
ny1 = nn(1,*)
nz1 = nn(2,*)

undefine, var, filename1
filename1 = str2+'filedatawithnormals.dat'

;var = [x y z rho vx vy vz bx by bz p nx1' ny1' nz1']; save(filename1,'var','-ASCII','-double');
close,1
openw,1,file     ; open file to write

for k=0, n_elements(x)-1 do begin
printf,1,FORMAT='(1x,E17.10,1x,E17.10,1x,E17.10,1x,E17.10,1x,E17.10,1x,E17.10,1x,E17.10,1x,E17.10,1x,E17.10,1x,E17.10)',$
                    x[k], y[k], z[k], rho[k], vx[k], vy[k], vz[k], bx[k], by[k], bz[k], p[k], nx1[k], ny1[k], nz1[k]
endfor
close,1


END 
