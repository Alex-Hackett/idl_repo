;PRO ZE_BH05_CREATE_3D_VOLUME_FROM_DENCON_v0
DEG2RAD=!DPI/180D0
RAD2DEG=180D0/!DPI

;beta=beta_vec*180./!PI
;r=dencon_owovar
;r_2d=dblarr(n_elements(r),n_elements(r))
;for i=0, r_2d[

omega=0.84 ;vrot/vcrit, remember that BH05 currently assumes vrot^2/vcrit^2
inc_model=41.0 ;best=130

inc_str=strcompress(string(inc_model, format='(I02)'))
omega_str=strcompress(string(omega*100, format='(I02)'))

  NB=360.
  b=dblarr(NB)
  FOR I=0,NB-1 DO BEGIN
    B(I)=0.D0 + (I+0.D0)*(1.D0*ACOS(-1.D0))/(NB-1.D0)  ;for now don't assume top-bottom symmetry
  ENDFOR
  
t1=1.0
dencon_owocki=T1*(1-omega^2*SIN(b)^2)^0.5

dencon_owocki=T1*1.D0/(1-omega^2*SIN(b)^2)

azi=REPLICATE(1.0,nb)
azi_val=b*2.0
n_azi=n_elements(azi)

dencon_array=dblarr(n_azi,nb)

;prolate
;FOR I=0, n_azi -1 DO FOR j=0, nb -1 DO dencon_array[i,j]=T1*(1-omega^2*SIN(b[j])^2)^0.5

;spherical
dencon_array[*,*]=T1

;oblate
;FOR I=0, n_azi -1 DO FOR j=0, nb -1 DO dencon_array[i,j]=T1*1.D0/(1-omega^2*SIN(b[j])^2)


alpha=54.0 ;opening angle of the cavity in degrees

;find indexes alpha_azi and alpha_b where azi=alpha and b=alpha, respectively
diff_alpha_azi=MIN(ABS(azi_val-alpha*DEG2RAD), alpha_azi_index)
diff_alpha_b=MIN(ABS(b-alpha*DEG2RAD), alpha_b_index)



i=0
j=0
index_min=0
shift_val=00.0 ;in degrees
step_deg=(b[alpha_b_index] - b[alpha_b_index-1])*RAD2DEG
index_shift=ROUND(shift_val/step_deg)
wall_thickness=0.0 ;in degrees
index_shift_wall=ROUND(wall_thickness/step_deg)
;include crude cavity on spherical model, working but cavity is on the pole!! works only for spherical models
FOR I=0, n_azi -1 DO BEGIN
 FOR j=0, nb -1 DO BEGIN
  IF (J GE index_min+index_shift) AND  (j LE alpha_b_index+index_shift) THEN dencon_array[i,j]=0.2 
    IF (j GT alpha_b_index+index_shift) AND  (j LE alpha_b_index+index_shift+index_shift_wall) THEN dencon_array[i,j]=1.4
 ENDFOR
ENDFOR

;produces only the walls for future merging
dencon_Array_wall=dencon_array
dencon_Array_wall[*,*]=1.0
i=0
j=0
index_min=0
shift_val=00.0 ;in degrees
step_deg=(b[alpha_b_index] - b[alpha_b_index-1])*RAD2DEG
index_shift=ROUND(shift_val/step_deg)
wall_thickness=3.0 ;in degrees
index_shift_wall=ROUND(wall_thickness/step_deg)
;include crude cavity on spherical model, working but cavity is on the pole!! works only for spherical models
FOR I=0, n_azi -1 DO BEGIN
 FOR j=0, nb -1 DO BEGIN
  IF (J GE index_min+index_shift) AND  (j LE alpha_b_index+index_shift) THEN dencon_array[i,j]=0.2  
    IF (j GT alpha_b_index+index_shift) AND  (j LE alpha_b_index+index_shift+index_shift_wall) THEN dencon_array[i,j]=1.0
 ENDFOR
ENDFOR


window,5
plot,b,dencon_array[5,*]


MESH_OBJ, 4, Vertex_List, Polygon_List, $
 dencon_Array,/CLOSED  

MESH_OBJ, 4, Vertex_List_wall, Polygon_List_wall, $
 dencon_Array_wall,/CLOSED  

aa=512
bb=512

aa=600
bb=600

axval=270
ayval=0
azval=180

; Create the window and view:
WINDOW, 0,retain=2, XSIZE=aa, YSIZE=bb
!P.BAckground=FSC_color('black') 
T3D, /RESET 
T3D, TRANSLATE=[0.30, 0.40, 0.20] 
T3D, ROTATE=[inc_model, 0.0,0.0] 
VERTEX_LIST = VERT_T3D(Vertex_List)
VERTEX_LIST_wall = VERT_T3D(Vertex_List_wall)
;CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.4,AX=axval,AY=ayval,AZ=azval ;for prolate models
;CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.12,AX=axval,AY=ayval,AZ=azval ;for oblate models
CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.3,AX=axval,AY=ayval,AZ=azval ;for cavity models

;SET_SHADING, LIGHT=[-0.5, -0.1, 2.0], REJECT=0 ;best for etacar isodensity talk groh 2010 jun 29
SET_SHADING, LIGHT=[0.7, -0.1, 0.9], REJECT=1
LOADCT,1
TVimage, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95]
;TVimage, POLYSHADE(Vertex_List_wall, Polygon_List_wall, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95],/Overplot
;plots,[0,-0.8],[0,-0.8]
image1=tvrd(0,0,0.95*aa,0.95*bb,/true)


; Create the window and view:
WINDOW, 3,retain=2, XSIZE=aa, YSIZE=bb
!P.BAckground=FSC_color('black') 
T3D, /RESET 
T3D, TRANSLATE=[0.30, 0.40, 0.20] 
T3D, ROTATE=[0, 0.0,0.0] 
VERTEX_LIST = VERT_T3D(Vertex_List)
VERTEX_LIST_wall = VERT_T3D(Vertex_List_wall)
;CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.4,AX=axval,AY=ayval,AZ=azval ;for prolate models
;CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.12,AX=axval,AY=ayval,AZ=azval ;for oblate models
CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.3,AX=axval,AY=ayval,AZ=azval ;for cavity models

;SET_SHADING, LIGHT=[-0.5, -2.1, -1.0], REJECT=0 ;best for etacar isodensity talk groh 2010 jun 29
;SET_SHADING, LIGHT=[-10.0, -1.1, -10.0], REJECT=0 ;best for etacar isodensity talk groh 2010 jun 29
SET_SHADING, LIGHT=[0.0, 1.1, 1.0], REJECT=0,/GOURAUD ;best for etacar isodensity talk groh 2010 jun 29
LOADCT,1
TVimage, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95]
TVimage, POLYSHADE(Vertex_List_wall, Polygon_List_wall, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95]
;plots,[0,-0.8],[0,-0.8]
image3=tvrd(0,0,0.95*aa,0.95*bb,/true)

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/img_isodensity_surface_wall_i'+inc_str+'_omega_'+omega_str+'.eps',/encapsulated,/color,bit=8,xsize=7*aa/bb,ysize=7,/inches

!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
!Y.OMARGIN=[8,4]

   
;!P.Background = fsc_color('black')

title=''

LOADCT, 13,/SILENT
tvimage,image3

device,/close
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
set_plot,'x'


WINDOW, 1,retain=2, XSIZE=aa, YSIZE=bb 
T3D, /RESET 
;T3D, TRANSLATE=[0.5, 0.3, 0.0] 
T3D, ROTATE=[0, 0.0, 0.0]
VERTEX_LIST = VERT_T3D(Vertex_List)
CREATE_VIEW, WINX=512, WINY=512,ZOOM=0.3,AX=axval,AY=ayval,AZ=azval

; Render the mesh:
SET_SHADING, LIGHT=[0.0, 1.1, 0.9], REJECT=0
LOADCT,3
tvimage, POLYSHADE(Vertex_List, Polygon_List, /DATA, /T3D),POSITION=[0.0,0.0,0.95,0.95]
image2=tvrd(0,0,0.95*aa,0.95*bb,/true)

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/img_isodensity_surface_i'+inc_str+'_omega_'+omega_str+'.eps',/encapsulated,/color,bit=8,xsize=7*aa/bb,ysize=7,/inches

!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
!Y.OMARGIN=[8,4]

   
;!P.Background = fsc_color('black')

title=''

LOADCT, 13,/SILENT
tvimage,image2

device,/close
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
set_plot,'x'




Window,2, XSIZE=aa, YSIZE=bb
  BlendImage, image1, image2, ALPHA=0.77
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
