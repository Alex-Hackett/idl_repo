;PRO ZE_WORK_ETACAR_CUTS_FROM_3D_HYDRO_SIMS_OKAZAKI_V2
;trying a better interpolation scheme

working_dir='/Users/jgroh/papers_in_preparation_groh/etacar_10830_aa/'
model_dir='1D_Data_withomega5090/'
;model_dir='1D_Data/'
all_files=working_dir+model_dir+'all_files.txt'
READCOL,all_files,all_filenames,FORMAT='A',DELIMITER=','
all_filenames=working_dir+model_dir+all_filenames
nphases=n_elements(all_filenames)

;reading for the first time, just to obtain the number of lines
ZE_READ_DATA_FROM_TOM_V2,all_filenames[0],l_over_a_for_primt,rho_primt,rho_sect,l_over_a_for_dent,rho_los_i60w243t,vel_los_i60w243t,rho_los_i90w243t,vel_los_i90w243t,rho_los_i41w243t,vel_los_i41w243t,rho_los_i41w270t,vel_los_i41w270t,headert

nlines=n_elements(vel_los_i60w243t)
l_over_a_for_prim=dblarr(nlines,nphases)
rho_prim=l_over_a_for_prim & rho_sec=rho_prim & l_over_a_for_den=rho_prim & rho_los_i60w243=rho_prim &vel_los_i60w243=rho_prim &rho_los_i90w243=rho_prim &vel_los_i90w243=rho_prim &rho_los_i41w243=rho_prim &vel_los_i41w243=rho_prim &rho_los_i41w270=rho_prim &vel_los_i41w270=rho_prim
header=strarr(nphases)

FOR I=0, nphases-1 DO BEGIN
ZE_READ_DATA_FROM_TOM_V2,all_filenames[i],l_over_a_for_primt,rho_primt,rho_sect,l_over_a_for_dent,rho_los_i60w243t,vel_los_i60w243t,rho_los_i90w243t,vel_los_i90w243t,rho_los_i41w243t,vel_los_i41w243t,rho_los_i41w270t,vel_los_i41w270t,headert
l_over_a_for_prim[*,i]=l_over_a_for_primt
rho_prim[*,i]=rho_primt
rho_sec[*,i]=rho_sect
l_over_a_for_den[*,i]=l_over_a_for_dent
rho_los_i60w243[*,i]=rho_los_i60w243t
vel_los_i60w243[*,i]=vel_los_i60w243t
rho_los_i90w243[*,i]=rho_los_i90w243t
vel_los_i90w243[*,i]=vel_los_i90w243t
rho_los_i41w243[*,i]=rho_los_i41w243t
vel_los_i41w243[*,i]=vel_los_i41w243t
rho_los_i41w270[*,i]=rho_los_i41w270t
vel_los_i41w270[*,i]=vel_los_i41w270t
header[i]=headert
ENDFOR

;choose desired orientation:
orient_val=7.

CASE orient_val OF

0: BEGIN
rho_los=rho_los_i90w243
vel_los=vel_los_i90w243
orient_str='i90_w243'
orient_tit=TEXTOIDL('i=90^\circ, \omega=243^\circ')
   END
   
1: BEGIN
rho_los=rho_los_i41w243
vel_los=vel_los_i41w243
orient_str='i41_w243'
orient_tit=TEXTOIDL('i=41^\circ, \omega=243^\circ')
   END

2: BEGIN
rho_los=rho_los_i60w243
vel_los=vel_los_i60w243
orient_str='i60_w243'
orient_tit=TEXTOIDL('i=60^\circ, \omega=243^\circ')
   END

3: BEGIN
rho_los=rho_los_i41w270
vel_los=vel_los_i41w270
orient_str='i41_w270'
orient_tit=TEXTOIDL('i=41^\circ, \omega=270^\circ')
   END

4: BEGIN
rho_los=rho_los_i41w270
vel_los=-1.*vel_los_i41w270
l_over_a_for_den=-1.*l_over_a_for_den
orient_str='i41_w90'
orient_tit=TEXTOIDL('i=41^\circ, \omega=90^\circ')
   END
   
5: BEGIN
rho_los=rho_los_i41w243
vel_los=-1.*vel_los_i41w243
l_over_a_for_den=-1.*l_over_a_for_den
orient_str='i41_w63'
orient_tit=TEXTOIDL('i=41^\circ, \omega=63^\circ')
   END   
   
6: BEGIN
rho_los=rho_los_i60w243
vel_los=-1.*vel_los_i60w243
l_over_a_for_den=-1.*l_over_a_for_den
orient_str='i60_w63'
orient_tit=TEXTOIDL('i=60^\circ, \omega=63^\circ')
   END      

7: BEGIN
rho_los=rho_los_i90w243
vel_los=-1.*vel_los_i90w243
l_over_a_for_den=-1.*l_over_a_for_den
orient_str='i90_w63'
orient_tit=TEXTOIDL('i=90^\circ, \omega=63^\circ')
   END      
   
ENDCASE
;remove extra zeros at the end of the vector
cur_for_prim_sec=min(where(rho_prim[*,0] gt -8))
rho_prim=rho_prim[0:(cur_for_prim_sec-1),*]
rho_sec=rho_sec[0:(cur_for_prim_sec-1),*]
l_over_a_for_prim=l_over_a_for_prim[0:(cur_for_prim_sec-1),*]

npts=2^16.
l_over_a_for_den_i=dblarr(npts,5) 
FOR J=0, 4 do l_over_a_for_den_i[*,j]=indgen(npts,/double)
vel_los_i=l_over_a_for_den_i
rho_los_i=l_over_a_for_den_i
for j=0, 4 do begin
for i=0., npts-1. do begin
l_over_a_for_den_i[i,j]=min(l_over_a_for_den)+((l_over_a_for_den_i[i,j])*(max(l_over_a_for_den)-min(l_over_a_for_den))/(npts-1.*1.))
endfor

linterp,REFORM(l_over_a_for_den[*,j]),REFORM(vel_los[*,j]),REFORM(l_over_a_for_den_i[*,j]),vel_los_i_temp
;vel_los_i_temp=CSPLINE(REFORM(l_over_a_for_den[*,j]),REFORM(vel_los[*,j]),REFORM(l_over_a_for_den_i[*,j]))
vel_los_i[*,j]=vel_los_i_temp

linterp,REFORM(l_over_a_for_den[*,j]),REFORM(rho_los[*,j]),REFORM(l_over_a_for_den_i[*,j]),rho_los_i_temp
;rho_los_i_temp=CSPLINE(REFORM(l_over_a_for_den[*,j]),REFORM(rho_los[*,j]),REFORM(l_over_a_for_den_i[*,j]))
rho_los_i[*,j]=rho_los_i_temp

endfor

rho_los_orig=rho_los
vel_los_orig=vel_los
l_over_a_for_den_orig=l_over_a_for_den

rho_los=rho_los_i
vel_los=vel_los_i
l_over_a_for_den=l_over_a_for_den_i


;interpolate on the same grid of rho_los and vel_los
;STILL TO BE DONE
rho_seci=CSPLINE(REFORM(l_over_a_for_prim[*,0]),REFORM(rho_sec[*,0]),REFORM(l_over_a_for_den[*,0]))


;read vel and rho from secondary star from john's model
dirjohn='/Users/jgroh/'
vel_file='etacarB_vel_log_au.txt'
rho_file='etacarB_den_log_au.txt'
ZE_READ_SPECTRA_COL_VEC, dirjohn+vel_file,logauvel,vel_second_john
ZE_READ_SPECTRA_COL_VEC, dirjohn+rho_file,logaurho,rho_second_john
ZE_READ_SPECTRA_COL_VEC, dirjohn+'etacarB_column_density_g_cm2_vel.txt',vel_for_yden,ydenvel
vel_for_yden=vel_for_yden*(-1.)
ydenvel=10^(ydenvel+23.78)
l_over_a_john=10^(logauvel)/15.
vel_second_john=vel_second_john*(-1.)
l_over_a_john_i=indgen(npts,/DOUBLE)*1. 
for i=0., npts-1. do begin
l_over_a_john_i[i]=min(l_over_a_john)+((l_over_a_john_i[i])*(max(l_over_a_john)-min(l_over_a_john))/(npts-1.*1.))
endfor
linterp,l_over_a_john,vel_second_john,l_over_a_john_i,vel_Second_john_i
linterp,l_over_a_john,rho_second_john,l_over_a_john_i,rho_Second_john_i

vel_second_john_array=Replicate_Array(vel_second_john_i,5)
rho_second_john_array=Replicate_Array(rho_second_john_i,5)
l_over_a_john_array=Replicate_Array(l_over_a_john_i,5)

;extrapolate
linterp,l_over_a_john,vel_second_john,REFORM(l_over_a_for_den_orig[*,0]),vel_Second_john_i_upto10


phase_vector=[0.875,0.991,0.998,1.014,1.041]
!P.Background = fsc_color('white')
;lineplot,l_over_a_for_den,rho_los

x1=00
x2=10
y1=0.875
y2=1.040
minc=-20
a=minc
maxc=-15
b=maxc
;rho_los_repl=REPLICATE(rho_los[*,0],600)

shade_surf,rho_los,l_over_a_for_den[*,0],phase_vector,shades=BYTSCL((rho_los),MIN=minc,MAX=maxc),zaxis=-1,az=0,ax=90,Xrange=[x1,x2],yrange=[y1,y2],charsize=2,ycharsize=1,xcharsize=1,$
xstyle=1,ystyle=1, xtitle='Line-of-sight distance', $
ytitle='Phase', Position=[0,0,1,1],PIXELS=1000,image=surface


xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
PositionPlot=[0.13, 0.18, 0.95, 0.92]
PositionPlot1=[0.16, 0.53, 0.95, 0.92]
PositionPlot2=[0.16, 0.14, 0.95, 0.53]
set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=2.0
!X.charsize=2.0
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

width=20
PositionPlot=[0.11, 0.16, 0.88, 0.96]


device,filename='/Users/jgroh/temp/etacar_from_3Dhydrosims_okazaki_tom_rho_los_phase_2D_'+orient_str+'.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
LOADCT,0
plot, l_over_a_for_den[*,0], phase_vector,YTICKFORMAT='(F9.2)',XTICKFORMAT='(F9.2)',/NODATA ,COLOR=FSC_COLOR('black'), $
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, XTITLE='Line-of-sight distance', YTITLE='Orbital phase', Position=PositionPlot;,XTICKINTERVAL=500
;, title=title
LOADCT, 13,/SILENT
tvimage,surface, /Overplot
LOADCT,0
plot,l_over_a_for_den[*,0], phase_vector,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',/NODATA , COLOR=FSC_COLOR('black'),$
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, XTITLE='', YTITLE='', Position=PositionPlot;,XTICKINTERVAL=500

LOADCT, 13,/SILENT
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),'>'+number_formatter((b-a) +a ,decimals=0)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.16, 0.92, 0.96]

xyouts,0.95,0.98,TEXTOIDL('log \rho'),/NORMAL,color=fsc_color('black')


date_obs=['2007 Jun 28', '2008 May 19','2008 Dec 08', '2009 Jan 08', '2009 Feb 17', '2009 Apr 20','2009 Jun 06']
FOR I=0, n_elements(mjd_sort)-1 DO BEGIN
plots,[350,400],[mjd_sort[i],mjd_sort[i]]
xyouts,100,mjd_sort[i]-0.003,date_obs[i]
ENDFOR
xyouts,-1900,1.05,'2009.0 event',charsize=3.

device,/close

set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0

minc=-3000.
a=minc
maxc=500.
b=maxc
window,1
shade_surf,vel_los,l_over_a_for_den[*,0],phase_vector,shades=BYTSCL((vel_los),MIN=minc,MAX=maxc),zaxis=-1,az=0,ax=90,Xrange=[x1,x2],yrange=[y1,y2],charsize=2,ycharsize=1,xcharsize=1,$
xstyle=1,ystyle=1, xtitle='Line-of-sight distance', $
ytitle='Phase', Position=[0,0,1,1],PIXELS=1000,image=surface

set_plot,'ps'
!p.multi=[0, 1, 2]
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=2.0
!X.charsize=2.0
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT,0
device,filename='/Users/jgroh/temp/etacar_from_3Dhydrosims_okazaki_tom_vel_los_phase_2D_'+orient_str+'.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot, l_over_a_for_den[*,0], phase_vector,YTICKFORMAT='(F9.2)',XTICKFORMAT='(F9.2)',/NODATA ,COLOR=FSC_COLOR('black'), $
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, XTITLE='Line-of-sight distance', YTITLE='Orbital phase', Position=PositionPlot;,XTICKINTERVAL=500
;, title=title
LOADCT, 13,/SILENT
tvimage,surface, /Overplot
LOADCT,0
plot,l_over_a_for_den[*,0], phase_vector,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',/NODATA , COLOR=FSC_COLOR('black'),$
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, XTITLE='', YTITLE='', Position=PositionPlot;,XTICKINTERVAL=500

LOADCT, 13,/SILENT
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),'>'+number_formatter((b-a) +a ,decimals=0)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.90, 0.16, 0.92, 0.96]

xyouts,0.95,0.98,TEXTOIDL('vel'),/NORMAL,color=fsc_color('black')
xyouts,0.8,0.8,orient_tit,/NORMAL,color=fsc_color('red')

date_obs=['2007 Jun 28', '2008 May 19','2008 Dec 08', '2009 Jan 08', '2009 Feb 17', '2009 Apr 20','2009 Jun 06']
FOR I=0, n_elements(mjd_sort)-1 DO BEGIN
plots,[350,400],[mjd_sort[i],mjd_sort[i]]
xyouts,100,mjd_sort[i]-0.003,date_obs[i]
ENDFOR
xyouts,-1900,1.05,'2009.0 event',charsize=3.

device,/close

set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0

;column_density calculations
;index_lt_0=WHERE(vel_los[*,0] lt 0)
;index_0_500=WHERE(vel_los[*,0] gt 0 AND vel_los[*,0] lt 500)
;index_m1500_m2500=WHERE(vel_los[*,0] gt -2500 AND vel_los[*,0] lt -1500,COMPLEMENT=index_not_m1500_m2500)
;rho_los[index_not_m1500_m2500,0]=-28 ;REMEMBER WE ARE DEALING WITH LOG 
;column_density=int_tabulated(l_over_a_for_den[*,0]*15.*1.496e13,10^(rho_los[*,0] + 23.78),/DOUBLE,SORT=1)
;print,column_density
;
;index_m1500_m2500=WHERE(vel_los[*,1] gt -2500 AND vel_los[*,1] lt -1500,COMPLEMENT=index_not_m1500_m2500)
;rho_los[index_not_m1500_m2500,1]=-28 ;REMEMBER WE ARE DEALING WITH LOG 
;column_density=int_tabulated(l_over_a_for_den[*,1]*15.*1.496e13,10^(rho_los[*,1] + 23.78),/DOUBLE,SORT=1)
;print,column_density
;
;index_m1500_m2500=WHERE(vel_los[*,2] gt -2500 AND vel_los[*,2] lt -1500,COMPLEMENT=index_not_m1500_m2500)
;rho_los[index_not_m1500_m2500,2]=-28 ;REMEMBER WE ARE DEALING WITH LOG 
;column_density=int_tabulated(l_over_a_for_den[*,2]*15.*1.496e13,10^(rho_los[*,2] + 23.78),/DOUBLE,SORT=1)
;print,column_density
;
;index_m1500_m2500=WHERE(vel_los[*,3] gt -2500 AND vel_los[*,3] lt -1500,COMPLEMENT=index_not_m1500_m2500)
;rho_los[index_not_m1500_m2500,3]=-28 ;REMEMBER WE ARE DEALING WITH LOG 
;column_density=int_tabulated(l_over_a_for_den[*,3]*15.*1.496e13,10^(rho_los[*,3] + 23.78),/DOUBLE,SORT=1)
;print,column_density
;
;index_m1500_m2500=WHERE(vel_los[*,4] gt -2500 AND vel_los[*,4] lt -1500,COMPLEMENT=index_not_m1500_m2500)
;rho_los[index_not_m1500_m2500,4]=-28 ;REMEMBER WE ARE DEALING WITH LOG 
;column_density=int_tabulated(l_over_a_for_den[*,4]*15.*1.496e13,10^(rho_los[*,4] + 23.78),/DOUBLE,SORT=1)
;print,column_density

vmin_start=-3000
vmax_start=-2950
vstep=vmax_start-vmin_Start

;ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,0,-3000,-2800,column_density_1
;ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,0,-2500,-1500,column_density_2

n_val_vel_col_den=60.
column_density_0=dblarr(n_val_vel_col_den)
column_density_1=column_density_0
column_density_2=column_density_0
column_density_3=column_density_0
column_density_4=column_density_0
column_density_sec=column_density_0
vmin_start_vec=column_density_0

FOR I=0, n_val_vel_col_den -1 DO BEGIN 
ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_john_array,rho_second_john_array,vel_second_john_array,0,vmin_start+i*vstep,vmax_start+i*vstep,column_density_t
column_density_sec[i]=column_density_t
vmin_start_vec[i]=vmin_start+i*vstep
ENDFOR


FOR I=0, n_val_vel_col_den -1 DO BEGIN 
ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,0,vmin_start+i*vstep,vmax_start+i*vstep,column_density_t
column_density_0[i]=column_density_t
vmin_start_vec[i]=vmin_start+i*vstep
ENDFOR

FOR I=0, n_val_vel_col_den -1 DO BEGIN 
ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,1,vmin_start+i*vstep,vmax_start+i*vstep,column_density_t
column_density_1[i]=column_density_t
vmin_start_vec[i]=vmin_start+i*vstep
ENDFOR

FOR I=0, n_val_vel_col_den -1 DO BEGIN 
ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,2,vmin_start+i*vstep,vmax_start+i*vstep,column_density_t
column_density_2[i]=column_density_t
vmin_start_vec[i]=vmin_start+i*vstep
ENDFOR

FOR I=0, n_val_vel_col_den -1 DO BEGIN 
ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,3,vmin_start+i*vstep,vmax_start+i*vstep,column_density_t
column_density_3[i]=column_density_t
vmin_start_vec[i]=vmin_start+i*vstep
ENDFOR

FOR I=0, n_val_vel_col_den -1 DO BEGIN 
ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,4,vmin_start+i*vstep,vmax_start+i*vstep,column_density_t
column_density_4[i]=column_density_t
vmin_start_vec[i]=vmin_start+i*vstep
ENDFOR

!P.MULTI=0
window,0
plot,vmin_start_vec,column_density_0,xrange=[-500,-3000],yrange=[1e18,1e24],/ylog
plots,vmin_start_vec,column_density_1,color=fsc_color('red'),noclip=0
plots,vmin_start_vec,column_density_2,color=fsc_color('blue'),noclip=0
plots,vmin_start_vec,column_density_3,color=fsc_color('green'),noclip=0
plots,vmin_start_vec,column_density_4,color=fsc_color('orange'),noclip=0



xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
PositionPlot=[0.13, 0.18, 0.95, 0.92]
PositionPlot1=[0.16, 0.53, 0.95, 0.92]
PositionPlot2=[0.16, 0.14, 0.95, 0.53]
set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=3.0
!X.charsize=3.0
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

width=20
PositionPlot=[0.13, 0.15, 0.94, 0.96]

lc=3.5 ;legend charsize

device,filename='/Users/jgroh/temp/etacar_from_3Dhydrosims_okazaki_tom_column_density_los_phase_2D_'+orient_str+'.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
LOADCT,0
plot,vmin_start_vec,column_density_0,xrange=[-3000,-500],yrange=[1e18,1e25],/ylog,/NODATA ,COLOR=FSC_COLOR('black'), $
xstyle=1,ystyle=1, XTITLE='Line-of-sight velocity (km/s)', YTITLE='Column density', Position=PositionPlot;,YTICKINTERVAL=100
;, title=title
plots,vmin_start_vec,column_density_0,color=fsc_color('black'),noclip=0
plots,vmin_start_vec,column_density_1,color=fsc_color('red'),noclip=0
plots,vmin_start_vec,column_density_2,color=fsc_color('blue'),noclip=0
plots,vmin_start_vec,column_density_3,color=fsc_color('green'),noclip=0
plots,vmin_start_vec,column_density_4,color=fsc_color('orange'),noclip=0
;plots,vmin_start_vec,column_density_sec,color=fsc_color('purple'),noclip=0,linestyle=2
xyouts,0.7,0.85,orient_tit,/NORMAL,color=fsc_color('black'),charsize=lc
;xyouts,-1900,1.05,'2009.0 event',charsize=3.

;draw legends
legxpos=-1300
legoffset=10.
legypos_rel=8e24
yf=1e25
xyouts,0.4,0.9,'t=0.875',charsize=lc,color=FSC_COLOR('black'),/normal
xyouts,0.4,0.85,'t=0.991',charsize=lc,color=FSC_COLOR('red'),/normal
xyouts,0.4,0.8,'t=0.998',charsize=lc,color=FSC_COLOR('blue'),/normal
xyouts,0.4,0.75,'t=1.014',charsize=lc,color=FSC_COLOR('green'),/normal
xyouts,0.4,0.7,'t=1.041',charsize=lc,color=FSC_COLOR('orange'),/normal
;xyouts,0.4,0.65,'Eta Car B wind',charsize=lc,color=FSC_COLOR('purple'),/normal
device,/close


xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
width=20
device,filename='/Users/jgroh/temp/etacar_from_3Dhydrosims_okazaki_tom_rho_los_phase_'+orient_str+'.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
LOADCT,0
plot,l_over_a_for_den[*,0],rho_los[*,0],xrange=[x1,x2],yrange=[-20,-12],/NODATA ,COLOR=FSC_COLOR('black'), $
xstyle=1,ystyle=1, XTITLE='Line-of-sight distance (a)', YTITLE=TEXTOIDL('log density (g/cm^3)'), Position=PositionPlot;,YTICKINTERVAL=100
;, title=title
plots,l_over_a_for_den_orig[*,0],rho_los_orig[*,0],color=fsc_color('black'),noclip=0
plots,l_over_a_for_den_orig[*,1],rho_los_orig[*,1],color=fsc_color('red'),noclip=0
plots,l_over_a_for_den_orig[*,2],rho_los_orig[*,2],color=fsc_color('blue'),noclip=0
plots,l_over_a_for_den_orig[*,3],rho_los_orig[*,3],color=fsc_color('green'),noclip=0
plots,l_over_a_for_den_orig[*,4],rho_los_orig[*,4],color=fsc_color('orange'),noclip=0
plots,l_over_a_for_prim[*,4],rho_sec[*,4],color=fsc_color('purple'),noclip=0,linestyle=2

xyouts,0.7,0.85,orient_tit,/NORMAL,color=fsc_color('black'),charsize=lc
;xyouts,-1900,1.05,'2009.0 event',charsize=3.

;draw legends
legxpos=-1300
legoffset=10.
legypos_rel=8e24
yf=1e25
xyouts,0.2,0.9,'t=0.875',charsize=lc,color=FSC_COLOR('black'),/normal
xyouts,0.2,0.85,'t=0.991',charsize=lc,color=FSC_COLOR('red'),/normal
xyouts,0.2,0.8,'t=0.998',charsize=lc,color=FSC_COLOR('blue'),/normal
xyouts,0.2,0.75,'t=1.014',charsize=lc,color=FSC_COLOR('green'),/normal
xyouts,0.2,0.7,'t=1.041',charsize=lc,color=FSC_COLOR('orange'),/normal
xyouts,0.2,0.65,'Eta Car B wind',charsize=lc,color=FSC_COLOR('purple'),/normal
device,/close

device,filename='/Users/jgroh/temp/etacar_from_3Dhydrosims_okazaki_tom_vel_los_phase_'+orient_str+'.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
LOADCT,0
plot,l_over_a_for_den[*,0],rho_los[*,0],xrange=[x1,x2],yrange=[-4000,3500],/NODATA ,COLOR=FSC_COLOR('black'), $
xstyle=1,ystyle=1, XTITLE='Line-of-sight distance (a)', YTITLE='Line-of-sight velocity (km/s)', Position=PositionPlot;,YTICKINTERVAL=100
;, title=title
plots,l_over_a_for_den_orig[*,0],vel_los_orig[*,0],color=fsc_color('black'),noclip=0
plots,l_over_a_for_den_orig[*,1],vel_los_orig[*,1],color=fsc_color('red'),noclip=0
plots,l_over_a_for_den_orig[*,2],vel_los_orig[*,2],color=fsc_color('blue'),noclip=0
plots,l_over_a_for_den_orig[*,3],vel_los_orig[*,3],color=fsc_color('green'),noclip=0
plots,l_over_a_for_den_orig[*,4],vel_los_orig[*,4],color=fsc_color('orange'),noclip=0
plots,l_over_a_for_den_orig[*,4],vel_Second_john_i_upto10,color=fsc_color('purple'),noclip=0,linestyle=2


xyouts,0.7,0.85,orient_tit,/NORMAL,color=fsc_color('black'),charsize=lc
;xyouts,-1900,1.05,'2009.0 event',charsize=3.

;draw legends
legxpos=-1300
legoffset=10.
legypos_rel=8e24
yf=1e25
xyouts,0.2,0.9,'t=0.875',charsize=lc,color=FSC_COLOR('black'),/normal
xyouts,0.2,0.85,'t=0.991',charsize=lc,color=FSC_COLOR('red'),/normal
xyouts,0.2,0.8,'t=0.998',charsize=lc,color=FSC_COLOR('blue'),/normal
xyouts,0.2,0.75,'t=1.014',charsize=lc,color=FSC_COLOR('green'),/normal
xyouts,0.2,0.7,'t=1.041',charsize=lc,color=FSC_COLOR('orange'),/normal
xyouts,0.2,0.65,'Eta Car B wind',charsize=lc,color=FSC_COLOR('purple'),/normal
device,/close
set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
!P.Background = fsc_color('white')
END

