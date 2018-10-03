ffeion89='/Users/jgroh/ze_models/agcar/390/390_if_iron_vel.txt'
ffeion01='/Users/jgroh/ze_models/agcar/373/373_if_iron_vel.txt'
ffeion02='/Users/jgroh/ze_models/agcar/382/382_if_iron_vel.txt'
ffeion03='/Users/jgroh/ze_models/agcar/381/381_if_iron_vel.txt'

feion89=read_ascii(ffeion89, DATA_START=2, MISSING_VALUE=0.)
feion01=read_ascii(ffeion01, DATA_START=2, MISSING_VALUE=0.)
feion02=read_ascii(ffeion02, DATA_START=2, MISSING_VALUE=0.)
feion03=read_ascii(ffeion03, DATA_START=2, MISSING_VALUE=0.)

ftauc89='/Users/jgroh/ze_models/agcar/389/389_tauc_900_vel.txt'
ftauc01='/Users/jgroh/ze_models/agcar/378/378_tauc_900_vel.txt'
ftauc02='/Users/jgroh/ze_models/agcar/382/382_tauc_900_vel.txt'
ftauc03='/Users/jgroh/ze_models/agcar/381/381_tauc_900_vel.txt'

tauc89=read_ascii(ftauc89, DATA_START=2, MISSING_VALUE=0.)
tauc01=read_ascii(ftauc01, DATA_START=2, MISSING_VALUE=0.)
tauc02=read_ascii(ftauc02, DATA_START=2, MISSING_VALUE=0.)
tauc03=read_ascii(ftauc03, DATA_START=2, MISSING_VALUE=0.)

fhion89='/Users/jgroh/ze_models/agcar/390/390_if_h_vel.txt'
fhion01='/Users/jgroh/ze_models/agcar/373/373_if_h_vel.txt'
fhion02='/Users/jgroh/ze_models/agcar/382/382_if_h_vel.txt'
fhion03='/Users/jgroh/ze_models/agcar/381/381_if_h_vel.txt'

hion89=read_ascii(fhion89, DATA_START=2, MISSING_VALUE=0.)
hion01=read_ascii(fhion01, DATA_START=2, MISSING_VALUE=0.)
hion02=read_ascii(fhion02, DATA_START=2, MISSING_VALUE=0.)
hion03=read_ascii(fhion03, DATA_START=2, MISSING_VALUE=0.)

vsonic=[14.5,13.0,12.6,12.6]

window,3
!p.multi=[0, 4, 2, 0, 0]

a=1
b=1
c=0
d=0
y1=-3.
y2=5

;plotting tau values
plot,tauc89.field1[0,*],tauc89.field1[1,*],xstyle=1,ystyle=1,$;,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[y1,y2],xtickformat='(A1)',$
ytitle=TEXTOIDL('log \tau_{Lyc}'),/nodata,charsize=2,XMARGIN=[c+6,d],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc89.field1[0,*],tauc89.field1[1,*],color=fsc_color('white'),noclip=0,thick=2,linestyle=0

plot,tauc01.field1[0,*],tauc01.field1[1,*],xstyle=1,ystyle=1,$;,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[y1,y2],xtickformat='(A1)',ytickformat='(A1)',$
/nodata,charsize=2,XMARGIN=[c,d],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc01.field1[0,*],tauc01.field1[1,*],color=fsc_color('white'),noclip=0,thick=2,linestyle=0

plot,tauc02.field1[0,*],tauc02.field1[1,*],xstyle=1,ystyle=1,$;,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[y1,y2],xtickformat='(A1)',ytickformat='(A1)',$
/nodata,charsize=2,XMARGIN=[c,d],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc02.field1[0,*],tauc02.field1[1,*],color=fsc_color('white'),noclip=0,thick=2,linestyle=0

plot,tauc03.field1[0,*],tauc03.field1[1,*],xstyle=1,ystyle=1,$;xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[y1,y2],xtickformat='(A1)',ytickformat='(A1)',$
/nodata,charsize=2,XMARGIN=[c,d+3],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc03.field1[0,*],tauc03.field1[1,*],color=fsc_color('white'),noclip=0,thick=2,linestyle=0


;plotting iron ionization structure
plot,feion89.field01[0,*],feion89.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[-8.0,-4.0],$
ytitle=TEXTOIDL('log (N_{ion}/N_{total})'),/nodata,charsize=2,XMARGIN=[c+6,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion89.field01[0,*],feion89.field01[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0         ;Fe+
plots,feion89.field01[2,*],feion89.field01[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0        ;Fe2+
plots,feion89.field01[4,*],feion89.field01[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0   ;Fe3+
plots,feion89.field01[6,*],feion89.field01[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0      ;Fe4+
plots,feion89.field01[8,*],feion89.field01[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0     ;Fe5+

plot,feion01.field01[0,*],feion01.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[-8.0,-4.0],ytickformat='(A1)',$
/nodata,charsize=2,XMARGIN=[c,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion01.field01[0,*],feion01.field01[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[2,*],feion01.field01[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[4,*],feion01.field01[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[6,*],feion01.field01[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[8,*],feion01.field01[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0


plot,feion02.field1[0,*],feion02.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[-8.0,-4.0],ytickformat='(A1)',$
/nodata,charsize=2,XMARGIN=[c,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion02.field1[0,*],feion02.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,feion02.field1[2,*],feion02.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0
plots,feion02.field1[4,*],feion02.field1[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0
plots,feion02.field1[6,*],feion02.field1[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0
;plots,feion02.field1[8,*],feion02.field1[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0

plot,feion03.field1[0,*],feion03.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,29.000],yrange=[-8.0,-4.0],ytickformat='(A1)',$
/nodata,charsize=2,XMARGIN=[c,d+3],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion03.field1[0,*],feion03.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,feion03.field1[2,*],feion03.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0
plots,feion03.field1[4,*],feion03.field1[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0
plots,feion03.field1[6,*],feion03.field1[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0
;plots,feion03.field1[8,*],feion03.field1[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0

;eps plots

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/output_tauc_ion_min.eps',/encapsulated,/color,bit=8,xsize=10,ysize=7.5,/inches

!p.multi=[0, 4, 2, 0, 0]

!Y.ThICK=2.
!X.thick=2.
;!X.OMARGIN=[-1.5,-2.5]
;!Y.OMARGIN=[3,1.5]


ca=3.3
ct=2.2
cl=1.4

a=1
b=1
c=0
d=0
y1=-3.
y2=5

xmin=-0.5
xmax=24.9

;plotting tau values
plot,tauc89.field1[0,*],tauc89.field1[1,*],xstyle=1,ystyle=1,charthick=ct,xtickinterval=10.,$
xrange=[xmin,xmax],yrange=[y1,y2],xtickformat='(A1)',$
ytitle=TEXTOIDL('log \tau_{Lyc}'),/nodata,charsize=ca,XMARGIN=[c+6,d-4.25],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc89.field1[0,*],tauc89.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2
xyouts,2,-0.9,'1985-1990', charsize=cl,charthick=ct
xyouts,2,-1.5,TEXTOIDL('T_{eff}=22.8 kK'), charsize=cl,charthick=ct
xyouts,2,-2.1,TEXTOIDL('Mdot=1.5x10^{-5}'), charsize=cl,charthick=ct

plot,tauc01.field1[0,*],tauc01.field1[1,*],xstyle=1,ystyle=1,charthick=ct,xtickinterval=10.,$
xrange=[xmin,xmax],yrange=[y1,y2],xtickformat='(A1)',ytickformat='(A1)',$
/nodata,charsize=ca,XMARGIN=[c+4.25,d-2.5],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc01.field1[0,*],tauc01.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2
xyouts,2,-0.9,'2001 April', charsize=cl,charthick=ct
xyouts,2,-1.5,TEXTOIDL('T_{eff}=17.0 kK'), charsize=cl,charthick=ct
xyouts,2,-2.1,TEXTOIDL('Mdot=3.7x10^{-5}'), charsize=cl,charthick=ct

plot,tauc02.field1[0,*],tauc02.field1[1,*],xstyle=1,ystyle=1,charthick=ct,xtickinterval=10.,$
xrange=[xmin,xmax],yrange=[y1,y2],xtickformat='(A1)',ytickformat='(A1)',$
/nodata,charsize=ca,XMARGIN=[c+2.5,d-0.75],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc02.field1[0,*],tauc02.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2
xyouts,2,-0.9,'2002 March', charsize=cl,charthick=ct
xyouts,2,-1.5,TEXTOIDL('T_{eff}=16.4 kK'), charsize=cl,charthick=ct
xyouts,2,-2.1,TEXTOIDL('Mdot=4.7x10^{-5}'), charsize=cl,charthick=ct

plot,tauc03.field1[0,*],tauc03.field1[1,*],xstyle=1,ystyle=1,charthick=ct,xtickinterval=10.,$
xrange=[xmin,xmax],yrange=[y1,y2],xtickformat='(A1)',ytickformat='(A1)',$
/nodata,charsize=ca,XMARGIN=[c+0.75,d+1],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,tauc03.field1[0,*],tauc03.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2
xyouts,2,-0.9,'2003 January', charsize=cl,charthick=ct
xyouts,2,-1.5,TEXTOIDL('T_{eff}=14.3 kK'), charsize=cl,charthick=ct
xyouts,2,-2.1,TEXTOIDL('Mdot=6.0x10^{-5}'), charsize=cl,charthick=ct




;plotting iron ionization structure
plot,feion89.field01[0,*],feion89.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),charthick=ct,xtickinterval=10.,$
xrange=[xmin,xmax],yrange=[-8.0,-4.0],$
ytitle=TEXTOIDL('log (N_{ion}/N_{total})'),/nodata,charsize=ca,XMARGIN=[c+6,d-4.25],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion89.field01[0,*],feion89.field01[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=4         ;Fe+
plots,feion89.field01[2,*],feion89.field01[3,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=0        ;Fe2+
plots,feion89.field01[4,*],feion89.field01[5,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2        ;Fe3+
plots,feion89.field01[6,*],feion89.field01[7,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=1      ;Fe4+
plots,feion89.field01[8,*],feion89.field01[9,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=3     ;Fe5+
plots,hion89.field1[0,*],hion89.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=3         ;H+
;xyouts,vsonic[0],-5.2,TEXTOIDL('v_s'), align=0.5,charthick=ct, charsize=cl
xyouts,vsonic[0],-8.07,'x',align=0.0,orientation=0,charthick=ct,charsize=2
xyouts,5,-5.4,TEXTOIDL('Fe^{4+}'), charsize=cl,charthick=ct
xyouts,5,-4.7,TEXTOIDL('Fe^{3+}'), charsize=cl,charthick=ct
xyouts,19,-6.9,TEXTOIDL('Fe^{2+}'), charsize=cl,charthick=ct
xyouts,19,-6.1,TEXTOIDL('H^{0}'), charsize=cl,charthick=ct

plot,feion01.field01[0,*],feion01.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),charthick=ct,$
xrange=[xmin,xmax],yrange=[-8.0,-4.0],ytickformat='(A1)',xtickinterval=10.,$
/nodata,charsize=ca,XMARGIN=[c+4.25,d-2.5],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion01.field01[0,*],feion01.field01[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=4
plots,feion01.field01[2,*],feion01.field01[3,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[4,*],feion01.field01[5,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2
plots,feion01.field01[6,*],feion01.field01[7,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=1
plots,feion01.field01[8,*],feion01.field01[9,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=3
plots,hion01.field1[0,*],hion01.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=3         ;H+
;xyouts,vsonic[1],-5.2,TEXTOIDL('v_s'), align=0.5,charthick=ct, charsize=cl
xyouts,vsonic[1],-8.07,'x',align=0,charthick=ct,charsize=2
xyouts,5,-4.7,TEXTOIDL('Fe^{3+}'), charsize=cl,charthick=ct
xyouts,10,-6.1,TEXTOIDL('Fe^{2+}'), charsize=cl,charthick=ct
xyouts,10,-5.4,TEXTOIDL('H^{0}'), charsize=cl,charthick=ct

plot,feion02.field1[0,*],feion02.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),charthick=ct,$
xrange=[xmin,xmax],yrange=[-8.0,-4.0],ytickformat='(A1)',xtickinterval=10.,$
/nodata,charsize=ca,XMARGIN=[c+2.5,d-0.75],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion02.field1[0,*],feion02.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=4
plots,feion02.field1[2,*],feion02.field1[3,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=0
plots,feion02.field1[4,*],feion02.field1[5,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2
plots,feion02.field1[6,*],feion02.field1[7,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=1
plots,hion02.field1[0,*],hion02.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=3         ;H+
;plots,feion02.field1[8,*],feion02.field1[9,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=3
;xyouts,vsonic[2],-5.4,TEXTOIDL('v_s'), align=0.5,charsize=cl,charthick=ct
xyouts,vsonic[2],-8.07,'x',align=0,charthick=ct,charsize=2
xyouts,5,-4.35,TEXTOIDL('Fe^{3+}'), charsize=cl,charthick=ct
xyouts,10,-5.05,TEXTOIDL('Fe^{2+}'), charsize=cl,charthick=ct
xyouts,10,-5.8,TEXTOIDL('H^{0}'), charsize=cl,charthick=ct

plot,feion03.field1[0,*],feion03.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),charthick=ct,$
xrange=[xmin,xmax],yrange=[-8.0,-4.0],ytickformat='(A1)',xtickinterval=10.,$
/nodata,charsize=ca,XMARGIN=[c+0.75,d+1],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion03.field1[0,*],feion03.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=4
plots,feion03.field1[2,*],feion03.field1[3,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=0
plots,feion03.field1[4,*],feion03.field1[5,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=2
plots,feion03.field1[6,*],feion03.field1[7,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=1
plots,hion03.field1[0,*],hion03.field1[1,*],color=fsc_color('black'),noclip=0,thick=2,linestyle=3         ;H+
;plots,feion03.field1[8,*],feion03.field1[9,*],color=fsc_color('darkgrey'),noclip=0,thick=2,linestyle=3
;xyouts,vsonic[3],-5.4,TEXTOIDL('v_s'), align=0.5,charsize=cl,charthick=ct
xyouts,vsonic[3],-8.07,'x',align=0,charthick=ct,charsize=2
xyouts,5,-4.4,TEXTOIDL('Fe^{3+}'), charsize=cl,charthick=ct
xyouts,20,-4.4,TEXTOIDL('Fe^{2+}'), charsize=cl,charthick=ct
xyouts,10,-5.8,TEXTOIDL('H^{0}'), charsize=cl,charthick=ct


device,/close

set_plot,'x'
$open '/Users/jgroh/temp/output_tauc_ion_min.eps'
$ls
END
