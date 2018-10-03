;PRO ZE_CONE


;beta=beta_vec*180./!PI
;r=dencon_owovar
;r_2d=dblarr(n_elements(r),n_elements(r))
;for i=0, r_2d[

omega=0.80

  NB=90.
  b=dblarr(NB)
  FOR I=0,NB-1 DO BEGIN
    B(I)=0.D0 + (I+0.D0)*(1.D0*ACOS(-1.D0))/(NB-1.D0)  ;for now don't assume top-bottom symmetry
  ENDFOR
  
t1=1.0
dencon_owocki=T1*(1-omega^2*SIN(b)^2)^0.5

r=REPLICATE(1.0,25)
nd=n_elements(r)

dencon_array=dblarr(nd,nb)

FOR I=0, nd -1 DO FOR j=0, nb -1 DO dencon_array[i,j]=T1*(1-omega^2*SIN(b[j])^2)^0.5

window,5
plot,b,dencon_array[5,*]

; Creating a 360x360 sphere with a constant radius of
; 0.25 to use as the data.
;MESH_OBJ, 4, vertices, polygons, REPLICATE(0.25, 360, 360), $
;   /CLOSED
;
;; Creating the window defining the view.
;WINDOW, 2, XSIZE = 512, YSIZE = 512
;SCALE3, XRANGE = [-0.25,0.25], YRANGE = [-0.25,0.25], $
;   ZRANGE = [-0.25,0.25], AX = 0, AZ = -90
;
;; Displaying data with image as texture map.
;SET_SHADING, LIGHT = [-0.5, 0.5, 2.0]
;!P.BACKGROUND = !P.COLOR
;TVSCL, POLYSHADE(vertices, polygons, SHADES = image, /T3D)
;!P.BACKGROUND = 0




MESH_OBJ, 4, Vertex_List, Polygon_List, $
 dencon_Array, /CLOSED  

aa=512
bb=512

axval=0
ayval=0
azval=0
inc_model=70.0
; Create the window and view:
WINDOW, 0,retain=2, XSIZE=aa, YSIZE=bb 
T3D, /RESET 
T3D, TRANSLATE=[0.0, 0.0, 0.0] 
T3D, ROTATE=[inc_model, 0.0,0.0] 
VERTEX_LIST = VERT_T3D(Vertex_List)
CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.1,AX=axval,AY=ayval,AZ=azval

; Render the mesh:
SET_SHADING, LIGHT=[-0.5, -0.1, 1.0], REJECT=0
LOADCT,1
TVimage, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95]
;plots,[0,-0.8],[0,-0.8]
image1=tvrd(0,0,0.95*aa,0.95*bb,/true)


WINDOW, 1,retain=2, XSIZE=aa, YSIZE=bb 
T3D, /RESET 
T3D, TRANSLATE=[0.5, 0.5, 0.0] 
T3D, ROTATE=[41-inc_model, 0.0, 0.0]
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