;PRO ZE_DRAW_HOMUNCULUS_3D

npoints=9.
data=dblarr(npoints,3)
data[0,*]=  [         216.0000,       36.53453,       20.80656]    
data[1,*]=  [         219.0000,       38.01759,      -20.36986]    
data[2,*]=  [         222.0000,       40.40577,      -64.19832]   
data[3,*]=  [         225.0000,       42.10126,       72.32301]    
data[4,*]=  [         228.0000,       43.17966,       26.87436]    
data[5,*]=  [         231.0000,       40.97514,      -23.37228]  
data[6,*]=  [         234.0000,       38.18189,      -73.91394]   
data[7,*]=  [         237.0000,       36.25631,       60.23586]    
data[8,*]=  [         240.0000,       36.53518,       20.81928]


window,0,xsize=1000,ysize=1000
LOADCT,3
nps=20
SPHERE = FLTARR(nps, nps, nps)
sphere_sph=sphere   
FOR X=0,nps-1 DO FOR Y=0,nps-1 DO FOR Z=0,nps-1 DO BEGIN $
   SPHERE(X, Y, Z) = SQRT((X-10)^2 + (Y-10)^2 + (Z-10)^2)
   print,SPHERE(X, Y, Z)
   ENDFOR

result_sph = FLTARR(nps, nps, nps)
radius=REPLICATE(10.,nps)
phi_vec=INDGEN(nps)*(360./ (nps-1))
theta_vec=-90. + INDGEN(nps)*(180./ (nps-1)) 

FOR i=0., nps -1 DO FOR j=0.,nps -1 DO FOR k=0., nps -1 DO BEGIN 
;print,[radius[i],phi_vec[j],theta_vec[k]]
;print,i,j,k
sphere_coord=[radius[i],phi_vec[j],theta_vec[k]]
temp=CV_COORD(FROM_SPHERE=sphere_coord,/TO_RECT)
;print,temp
;result_sph[i,j,k]=temp
ENDFOR

; create the orb object
 orb = obj_new('orb', color=[240,0,0], style=1)

; since it is a subclass of IDLgrModel we can scale it.
; stretch the sphere out 2x it's original length along the z axis
orb -> scale, 1, 1, 2


xobjview, orb

axis = [0,1,0] & angle = 45
orb->Rotate, axis, angle 


; get the vertices, polygon connectivity, and transform matrix
; from the orb object. Even though you are looking at an ellipsoid
; the verts will still define a sphere. The orb's transform matrix
; holds the key to scaling the vertices such that they define an
; ellipsoid.
orb -> getproperty, data=verts, polygons=polys, transform=xform

; apply the transform matrix to the spherical verts to make them
; ellipsoidal
dgVerts = vert_t3d(verts, matrix=xform)

; display using DG
scale3, xrange=[-2,2],yrange=[-2,2],zrange=[-2,2]
image=polyshade(dgVerts,polys, /t3d)
tv, image



sphere=result_sph
;sphere=vol_gau_ellipsoid(20)
SHADE_VOLUME, SPHERE, 8, V, P
SCALE3, XRANGE=[0,nps], YRANGE=[0,nps], ZRANGE=[0,nps]
;image = POLYSHADE(V, P,/T3D) ;Render the image. 
;SET_SHADING, LIGHT = [0.5, 0.5, 2.0]
;TVimage, image 


MAP_SET,/orthographic,/Grid,/Label,/Isotropic,35,0,/NOERASE,XMARGIN=[30,30],yMARGIN=[27,27],/NOBORDER
for i=0, npoints -1 DO BEGIN
plots,data[i,2],data[i,1],psym=4,symsize=5,color=fsc_color('green')
xyouts,data[i,2]-5,data[i,1],strcompress(string(data[i,0], format='(I03)')),color=fsc_color('green'),charsize=1.6
ENDFOR

for i=0, npoints -1 DO TVCIRCLE,5,data[i,2],data[i,1],color=fsc_color('green'),/DATA

; First, create some data:  
vol = RANDOMU(S, 40, 40, 40)   
nps=40.
SPHERE = FLTARR(nps, nps, nps)
   
FOR X=0,nps-1 DO FOR Y=0,nps-1 DO FOR Z=0,nps-1 DO $
   SPHERE(X, Y, Z) = SQRT((X-10)^2 + (Y-10)^2 + (Z-10)^2)
vol=SPHERE
;FOR I=0, 10 DO vol = SMOOTH(vol, 3)   
vol = BYTSCL(vol(3:37, 3:37, 3:37))   
;opaque = RANDOMU(S, 40, 40, 40)   
;FOR I=0, 10 DO opaque = SMOOTH(opaque, 3)   
;opaque = BYTSCL(opaque(3:37, 3:37, 3:37), TOP=25B)  
  
; Set up the view:  
xmin = 0 & ymin = 0 & zmin = 0  
xmax = 34 & ymax = 34 & zmax = 34  
!X.S = [-xmin, 1.0] / (xmax - xmin)  
!Y.S = [-ymin, 1.0] / (ymax - ymin)  
!Z.S = [-zmin, 1.0] / (zmax - zmin)  
T3D, /RESET   
T3D, TRANSLATE=[-0.5, -0.5, -0.5]   
T3D, SCALE=[0.7, 0.7, 0.7]   
T3D, ROTATE=[30, -30, 60]   
T3D, TRANSLATE=[0.5, 0.5, 0.5]  
WINDOW, 0, XSIZE=512, YSIZE=512  
  
; Generate and display the image:  
img = PROJECT_VOL(vol, 64, 64, 64, DEPTH_Q=0.7, $  
  TRANS=(!P.T))   
TVSCL, img  

; Create a 48x64 cylinder with a constant radius of 0.25: 
MESH_OBJ, 3, Vertex_List, Polygon_List, $ 
   Replicate(0.25, 48, 64), P4=0.5 
 
; Transform the vertices: 
T3D, /RESET  
T3D, ROTATE=[0.0, 30.0, 0.0]  
T3D, ROTATE=[0.0, 0.0, 40.0]  
T3D, TRANSLATE=[0.25, 0.25, 0.25] 
VERTEX_LIST = VERT_T3D(Vertex_List) 
 
; Create the window and view: 
WINDOW, 6, XSIZE=512, YSIZE=512  
CREATE_VIEW, WINX=512, WINY=512 
 
; Render the mesh: 
SET_SHADING, LIGHT=[-0.5, 0.5, 2.0], REJECT=0  
TVSCL, POLYSHADE(Vertex_List, Polygon_List, /NORMAL) 

; Create a cone (surface of revolution): 
MESH_OBJ, 4, Vertex_List, Polygon_List, $ 
   Replicate(0.25, 48, 64)
 
; Create the window and view: 
WINDOW, 7, XSIZE=512, YSIZE=512
LOADCT,13  
CREATE_VIEW, WINX=512, WINY=512, AX=30.0, AY=(140.0), ZOOM=0.5 
 
; Render the mesh: 
SET_SHADING, LIGHT=[-0.5, 0.5, 2.0], REJECT=0  
TVSCL, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D) 
 

END  