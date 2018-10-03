;PRO ZE_VH1_WORK
!P.Background = fsc_color('white')
GS_TO_MSUNYR=1D0/(1.99e33/(3600.0*24.0*365.0))
S_TO_DAY=1.0d/(24.0D*3600.0D)

dir='/Users/jgroh/vh1_models/20/'

ZE_VH1_READ_INDAT,dir,'tprin',tprin
ZE_VH1_READ_INDAT,dir,'endtime',endtime
ZE_VH1_READ_VH1_OUT,dir,vh1_out_array

;convert velocities to km/s
vh1_out_array[2,*,*]=vh1_out_array[2,*,*]/1e5

r=REFORM(vh1_out_array[1,*,0])
time=dblarr(endtime/tprin)
ntime=n_elements(time)
nd=n_elements(r)

FOR I=0, ntime -1 DO time[i]=(i+1)*tprin

r_array=REFORM(vh1_out_array[1,*,*])
rstar=100.0*6.96e10
v_array=REFORM(vh1_out_array[2,*,*])
den_array=REFORM(vh1_out_array[3,*,*])
mass_flux=den_array*v_array*1e5*(1+r_array)^2*rstar^2
mdot=4D0*!PI*mass_flux*GS_TO_MSUNYR


var_index=2

a=min(vh1_out_array[var_index,*,*])
b=max(vh1_out_array[var_index,*,*])

;a=0
;b=380.0
img=bytscl(REFORM(vh1_out_array[var_index,*,*]),MIN=a,MAX=b)


x1=0.0
x2=4.0
y1=0.
y2=700000.
LOADCT,13
shade_surf,REFORM(vh1_out_array[var_index,*,*]),r,time,shades=BYTSCL((REFORM(vh1_out_array[var_index,*,*])),MIN=a,MAX=b),zaxis=-1,az=0,ax=90,Xrange=[x1,x2],yrange=[y1,y2],charsize=2,ycharsize=1,xcharsize=1,$
xstyle=1,ystyle=1, xtitle='distance', $
ytitle='Time', Position=[0,0,1,1],PIXELS=10000,image=vel;, title=title


aa=800
bb=700
ct=13
nointerp=1
ZE_VH1_PLOT_VARIABLE_DISTANCE_TIME_XWINDOW,img,a,b,r,time,aa,bb,ct,nointerp

var_index=3
a=1e-17
b=2.5e-11
t1=0
t2=50

img=bytscl(REFORM(alog10(vh1_out_array[var_index,*,*])),MIN=alog10(a),MAX=alog10(b))

aa=800
bb=700
ct=13
nointerp=1
ZE_VH1_PLOT_VARIABLE_DISTANCE_TIME_XWINDOW,img,a,b,r,time,aa,bb,ct,nointerp


den_rel=REFORM(vh1_out_array[var_index,*,*])

FOR i=1, (size(den_rel))[2] -1 DO den_rel[*,i]=den_rel[*,i]/den_rel[*,0]
den_rel[*,0]=1.0

a=min(den_rel)
b=max(den_rel)
print,a,b
t1=0
t2=50

img=bytscl(den_rel,MIN=a,MAX=b)

aa=800
bb=700
ct=13
nointerp=1
ZE_VH1_PLOT_VARIABLE_DISTANCE_TIME_XWINDOW,img,a,b,r,time,aa,bb,ct,nointerp

window,5
x1=0.0
x2=10.0
y1=0.
y2=1500000.
LOADCT,13
shade_surf,den_rel,r,time,shades=BYTSCL(den_rel,MIN=a,MAX=b),zaxis=-1,az=0,ax=90,Xrange=[x1,x2],yrange=[y1,y2],charsize=2,ycharsize=1,xcharsize=1,$
xstyle=1,ystyle=1, xtitle='distance', $
ytitle='Time', Position=[0,0,1,1],PIXELS=100000,image=den_rel;, title=title



a=min(mass_flux)
b=max(mass_flux)
t1=0
t2=50

img=bytscl(mass_flux,MIN=a,MAX=b)

aa=800
bb=700
ct=13
nointerp=1
ZE_VH1_PLOT_VARIABLE_DISTANCE_TIME_XWINDOW,img,a,b,r,time,aa,bb,ct,nointerp


var_index=4
a=min(vh1_out_array[var_index,*,*])
b=max(vh1_out_array[var_index,*,*])
a=0.01
b=315
t1=0
t2=50

img=bytscl(REFORM(alog10(vh1_out_array[var_index,*,*])),MIN=alog10(a),MAX=alog10(b))

aa=800
bb=700
ct=13
nointerp=1
ZE_VH1_PLOT_VARIABLE_DISTANCE_TIME_XWINDOW,img,a,b,r,time,aa,bb,ct,nointerp




deltat=30
rstar=696.0
r1=REVERSE((r+1.0)*rstar)
nd1=nd
nd2=nd
r2=REVERSE((r+1.0)*rstar)
v1=REVERSE(REFORM(v_array[*,0]))
v2=REVERSE(REFORM(v_array[*,25]))

vs1=v1[nd1-2]
ZE_COMPUTE_FLOWTIMESCALE,r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1

vs2=v2[nd-2]
ZE_COMPUTE_FLOWTIMESCALE,r2,v2,nd2,vs2,flowtime2,rirev2,virev2,flowtimerev2,dflowtimerev2

;then compute delta_x,x1, x2 for a given deltat using ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT
;for a given deltat after the change, computes:
;x1=position of the beginning of wind 1 (i.e., old wind) 
;x2=position of the end of wind 2 (i.e., new wind) 
;delta_x=x1-x2

ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT,deltat,r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1,x1,x_r1,index_x_r1
ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT,deltat,r2,v2,nd2,vs2,flowtime2,rirev2,virev2,flowtimerev2,dflowtimerev2,x2,x_r2,index_x_r2
delta_x=x1-x2




END