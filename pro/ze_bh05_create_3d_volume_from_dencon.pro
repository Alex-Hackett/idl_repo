;PRO ZE_BH05_CREATE_3D_VOLUME_FROM_DENCON


;beta=beta_vec*180./!PI
;r=dencon_owovar
;r_2d=dblarr(n_elements(r),n_elements(r))
;for i=0, r_2d[

omega=0.92 ;vrot/vcrit, remember that BH05 currently assumes vrot^2/vcrit^2
inc_model=90.0

  NB=151.
  b=dblarr(NB)
  FOR I=0,NB-1 DO BEGIN
    B(I)=0.D0 + (I+0.D0)*(1.D0*ACOS(-1.D0))/(NB-1.D0)  ;for now don't assume top-bottom symmetry
  ENDFOR
  
t1=1.0
dencon_owocki=T1*(1-omega^2*SIN(b)^2)^0.5

;dencon_owocki=T1*1.D0/(1-omega^2*SIN(b)^2)

r=REPLICATE(1.0,25)
;nd=n_elements(r)

;dencon_array=dblarr(nd,nb)

;prolate
;FOR I=0, nd -1 DO FOR j=0, nb -1 DO dencon_array[i,j]=T1*(1-omega^2*SIN(b[j])^2)^0.5

;;prolate crude cavity
;FOR I=0, nd -1 DO BEGIN
; IF i gt 4 AND i LT 10 THEN BEGIN
; FOR j=0, nb -1 DO dencon_array[i,j]=0.0
; ENDIF ELSE BEGIN
; FOR j=0, nb -1 DO dencon_array[i,j]=T1*(1-omega^2*SIN(b[j])^2)^0.5
; ENDELSE 
;ENDFOR

;oblate
;FOR I=0, nd -1 DO FOR j=0, nb -1 DO dencon_array[i,j]=T1*1.D0/(1-omega^2*SIN(b[j])^2)
print,nd,beta
dencon_array=dblarr(nd,beta)

;dencon vector from ze_read_2d_rv_data has nd*beta points, FORMAT is r0....rn for beta=0 then r0....rn for beta=1, etc

;working
k=0
m=1
FOR J=0, beta -1 DO BEGIN
print,j,k,m*(nd-1)
dencon_array[*,j]=dencon[k:(m*nd)-1]
k=k+nd
m=m+1
ENDFOR


;removing wall for visualization purposes
;dencon_array(where(dencon_array eq 10.0))=1.0
;working
;k=0
;m=1
;FOR J=0, beta -1 DO BEGIN
;dencon_array[*,j]=dencon[k:(m*nd)-1]
;ENDFOR

window,5
plot,b,dencon_array[5,*]
;dencon_array=dencon_array[40:64,*]


;;working
;MESH_OBJ, 4, Vertex_List, Polygon_List, $
; dencon_Array, /CLOSED  

MESH_OBJ, 4, Vertex_List, Polygon_List, $
 dencon_Array, /CLOSED  

aa=512
bb=512

axval=80
ayval=360
azval=310

; Create the window and view:
WINDOW, 0,retain=2, XSIZE=aa, YSIZE=bb 
T3D, /RESET 
T3D, TRANSLATE=[0.0, 0.0, 0.0] 
;T3D, ROTATE=[inc_model, 0.0,0.0] 
VERTEX_LIST = VERT_T3D(Vertex_List)
CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.2,AX=axval,AY=ayval,AZ=azval

; Render the mesh:
SET_SHADING, LIGHT=[-0.5, -0.1, 1.0], REJECT=0
LOADCT,1
TVimage, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95]
;plots,[0,-0.8],[0,-0.8]
image1=tvrd(0,0,0.95*aa,0.95*bb,/true)


WINDOW, 1,retain=2, XSIZE=aa, YSIZE=bb 
T3D, /RESET 
T3D, TRANSLATE=[0.5, 0.5, 0.0] 
;T3D, ROTATE=[41-inc_model, 0.0, 0.0]
VERTEX_LIST = VERT_T3D(Vertex_List)
CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.4,AX=axval,AY=ayval,AZ=azval

; Render the mesh:
SET_SHADING, LIGHT=[-0.5, 0.5, 2.0], REJECT=0
LOADCT,3
tvimage, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95]
image2=tvrd(0,0,0.95*aa,0.95*bb,/true)


Window,2, XSIZE=aa, YSIZE=bb
  BlendImage, image1, image2, ALPHA=0.67
   !P.Multi = 0



;cone=[[0.75, 0.4, 0.0], [0.5, 0.1, 0.3]]
;; Create a cone (surface of revolution):
;MESH_OBJ, 6, Vertex_List, Polygon_List, $
;  cone, $
;   P1=50, P2=[0.5, 0.5, 0.5]
;
;; Create the window and view:
;WINDOW, 0, XSIZE=512, YSIZE=512 
;LOADCT,5
;CREATE_VIEW, WINX=512, WINY=512, AX=30.0, AY=(140.0), ZOOM=0.5
;
;; Render the mesh:
;SET_SHADING, LIGHT=[-0.5, 0.5, 2.0], REJECT=0
;LOADCT,5 
;TVSCL, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D)
END
