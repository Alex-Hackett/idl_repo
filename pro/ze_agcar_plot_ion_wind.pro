ffeion89='/Users/jgroh/ze_models/agcar/390/390_if_iron_r.txt'
ffeion01='/Users/jgroh/ze_models/agcar/373/373_if_iron_r.txt'
ffeion02='/Users/jgroh/ze_models/agcar/382/382_if_iron_r.txt'
ffeion03='/Users/jgroh/ze_models/agcar/381/381_if_iron_r.txt'

feion89=read_ascii(ffeion89, DATA_START=2, MISSING_VALUE=0.)
feion01=read_ascii(ffeion01, DATA_START=2, MISSING_VALUE=0.)
feion02=read_ascii(ffeion02, DATA_START=2, MISSING_VALUE=0.)
feion03=read_ascii(ffeion03, DATA_START=2, MISSING_VALUE=0.)

fhion89='/Users/jgroh/ze_models/agcar/390/390_if_h_r.txt'
fhion01='/Users/jgroh/ze_models/agcar/373/373_if_h_r.txt'
fhion02='/Users/jgroh/ze_models/agcar/382/382_if_h_r.txt'
fhion03='/Users/jgroh/ze_models/agcar/381/381_if_h_r.txt'

hion89=read_ascii(fhion89, DATA_START=2, MISSING_VALUE=0.)
hion01=read_ascii(fhion01, DATA_START=2, MISSING_VALUE=0.)
hion02=read_ascii(fhion02, DATA_START=2, MISSING_VALUE=0.)
hion03=read_ascii(fhion03, DATA_START=2, MISSING_VALUE=0.)



ftauc89='/Users/jgroh/ze_models/agcar/389/389_tauc_900_vel.txt'
ftauc01='/Users/jgroh/ze_models/agcar/378/378_tauc_900_vel.txt'
ftauc02='/Users/jgroh/ze_models/agcar/382/382_tauc_900_vel.txt'
ftauc03='/Users/jgroh/ze_models/agcar/381/381_tauc_900_vel.txt'

tauc89=read_ascii(ftauc89, DATA_START=2, MISSING_VALUE=0.)
tauc01=read_ascii(ftauc01, DATA_START=2, MISSING_VALUE=0.)
tauc02=read_ascii(ftauc02, DATA_START=2, MISSING_VALUE=0.)
tauc03=read_ascii(ftauc03, DATA_START=2, MISSING_VALUE=0.)

vsonic=[14.5,13.0,12.6,12.6]

window,3
!p.multi=[0, 4, 2, 0, 0]

!P.THICK=10
!X.THiCK=10
!Y.THICK=10
!P.CHARTHICK=8
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

xamin=4
yamin=4

ca=2.3
ct=8
cc=6
cplot=8
cline=8
cl=1.4

a=1
b=1
c=0
d=0
y1=-3.
y2=5
e=0.01      ;log r min
f=2.1      ; log r max


;plotting hydrogen ion struct
plot,hion89.field1[0,*],hion89.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-7.0,0.3],$
ytitle=TEXTOIDL('log (N_{ion}/N_{total})'),/nodata,XMARGIN=[c+6,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion89.field1[0,*],hion89.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0         ;H0
plots,hion89.field1[2,*],hion89.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0        ;H+


plot,hion01.field1[0,*],hion01.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-7.0,0.3],ytickformat='(A1)',$
/nodata,XMARGIN=[c,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion01.field1[0,*],hion01.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,hion01.field1[2,*],hion01.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0



plot,hion02.field1[0,*],hion02.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-7.0,0.3],ytickformat='(A1)',$
/nodata,XMARGIN=[c,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion02.field1[0,*],hion02.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,hion02.field1[2,*],hion02.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0


plot,hion03.field1[0,*],hion03.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-7.0,0.3],ytickformat='(A1)',$
/nodata,XMARGIN=[c,d+3],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion03.field1[0,*],hion03.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,hion03.field1[2,*],hion03.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0


;plotting iron ionization structure
plot,feion89.field01[0,*],feion89.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-8.0,-4.0],$
ytitle=TEXTOIDL('log (N_{ion}/N_{total})'),/nodata,XMARGIN=[c+6,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion89.field01[0,*],feion89.field01[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0         ;Fe+
plots,feion89.field01[2,*],feion89.field01[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0        ;Fe2+
plots,feion89.field01[4,*],feion89.field01[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0   ;Fe3+
plots,feion89.field01[6,*],feion89.field01[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0      ;Fe4+
plots,feion89.field01[8,*],feion89.field01[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0     ;Fe5+

plot,feion01.field01[0,*],feion01.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-8.0,-4.0],ytickformat='(A1)',$
/nodata,XMARGIN=[c,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion01.field01[0,*],feion01.field01[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[2,*],feion01.field01[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[4,*],feion01.field01[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[6,*],feion01.field01[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0
plots,feion01.field01[8,*],feion01.field01[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0


plot,feion02.field1[0,*],feion02.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-8.0,-4.0],ytickformat='(A1)',$
/nodata,XMARGIN=[c,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion02.field1[0,*],feion02.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,feion02.field1[2,*],feion02.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0
plots,feion02.field1[4,*],feion02.field1[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0
plots,feion02.field1[6,*],feion02.field1[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0
;plots,feion02.field1[8,*],feion02.field1[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0

plot,feion03.field1[0,*],feion03.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,$
xrange=[e,f],yrange=[-8.0,-4.0],ytickformat='(A1)',$
/nodata,XMARGIN=[c,d+3],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion03.field1[0,*],feion03.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,feion03.field1[2,*],feion03.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0
plots,feion03.field1[4,*],feion03.field1[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0
plots,feion03.field1[6,*],feion03.field1[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0
;plots,feion03.field1[8,*],feion03.field1[9,*],color=fsc_color('magenta'),noclip=0,thick=2,linestyle=0

;eps plots

set_plot,'ps'
device,/close
!P.THICK=10
!X.THiCK=10
!Y.THICK=10
!P.CHARTHICK=8
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

xamin=4
yamin=4

ca=2.9
ct=7
cc=6
cplot=8
cline=8
cl=1.4

a=1
b=1
c=0
d=0
y1=-3.
y2=5
e=0.01      ;log r min
f=2.1      ; log r max

a=10
b=7.5

device,filename='/Users/jgroh/temp/output_wind_ion_min.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!p.multi=[0, 4, 2, 0, 0]

a=1
b=1
c=0
d=0
y1=-3.
y2=5

ticklen = 0.04
yticklen = ticklen/a
xticklen = ticklen/b

;plotting hydrogen ion structure

plot,hion89.field1[0,*],hion89.field1[1,*],xstyle=1,ystyle=1,$
xrange=[e,f],yrange=[-8.0,0.3],xtickformat='(A1)',charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
ytitle=TEXTOIDL('log (N_{ion}/N_{total})'),/nodata,XMARGIN=[c+6,d-4.25],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion89.field1[0,*],hion89.field1[1,*],color=fsc_color('black'),noclip=0,linestyle=0,thick=cplot         ;H0
plots,hion89.field1[2,*],hion89.field1[3,*],color=fsc_color('black'),noclip=0,linestyle=2,thick=cplot        ;H+
xyouts,1.6,-0.8,TEXTOIDL('H^+'), charsize=1.2,charthick=cc
xyouts,1.6,-6.2,TEXTOIDL('H^0'), charsize=1.2,charthick=cc
xyouts,0.2,-6.93,'1985-1990', charsize=1.2,charthick=cc
xyouts,0.2,-7.53,TEXTOIDL('T_{eff}=22.8 kK'), charsize=1.2,charthick=cc

plot,hion01.field1[0,*],hion01.field1[1,*],xstyle=1,ystyle=1,$
xrange=[e,f],yrange=[-8.0,0.3],xtickformat='(A1)',ytickformat='(A1)',charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
/nodata,XMARGIN=[c+4.25,d-2.5],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion01.field1[0,*],hion01.field1[1,*],color=fsc_color('black'),noclip=0,linestyle=0,thick=cplot
plots,hion01.field1[2,*],hion01.field1[3,*],color=fsc_color('black'),noclip=0,linestyle=2,thick=cplot
xyouts,0.2,-6.93,'2001 April', charsize=1.2,charthick=cc
xyouts,0.2,-7.53,TEXTOIDL('T_{eff}=17.0 kK'), charsize=1.2,charthick=cc
xyouts,1.6,-0.8,TEXTOIDL('H^+'), charsize=1.2,charthick=cc
xyouts,1.6,-3.2,TEXTOIDL('H^0'), charsize=1.2,charthick=cc

plot,hion02.field1[0,*],hion02.field1[1,*],xstyle=1,ystyle=1,$
xrange=[e,f],yrange=[-8.0,0.3],xtickformat='(A1)',ytickformat='(A1)',charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
/nodata,XMARGIN=[c+2.5,d-0.75],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion02.field1[0,*],hion02.field1[1,*],color=fsc_color('black'),noclip=0,linestyle=0,thick=cplot
plots,hion02.field1[2,*],hion02.field1[3,*],color=fsc_color('black'),noclip=0,linestyle=2,thick=cplot
xyouts,0.2,-6.93,'2002 March', charsize=1.2,charthick=cc
xyouts,0.2,-7.53,TEXTOIDL('T_{eff}=16.4 kK'), charsize=1.2,charthick=cc
xyouts,1.6,-0.8,TEXTOIDL('H^+'), charsize=1.2,charthick=cc
xyouts,1.6,-3.2,TEXTOIDL('H^0'), charsize=1.2,charthick=cc

plot,hion03.field1[0,*],hion03.field1[1,*],xstyle=1,ystyle=1,$
xrange=[e,f],yrange=[-8.0,0.3],xtickformat='(A1)',ytickformat='(A1)',charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
/nodata,XMARGIN=[c+0.75,d+1],YMARGIN=[a,b];,POSITION=[0.11,0.10,0.959,0.49]
plots,hion03.field1[0,*],hion03.field1[1,*],color=fsc_color('black'),noclip=0,linestyle=0,thick=cplot
plots,hion03.field1[2,*],hion03.field1[3,*],color=fsc_color('black'),noclip=0,linestyle=2,thick=cplot
xyouts,0.2,-6.93,'2003 January', charsize=1.2,charthick=cc
xyouts,0.2,-7.53,TEXTOIDL('T_{eff}=14.3 kK'), charsize=1.2,charthick=cc
xyouts,1.6,-0.8,TEXTOIDL('H^+'), charsize=1.2,charthick=cc
xyouts,1.6,-3.2,TEXTOIDL('H^0'), charsize=1.2,charthick=cc


;plotting iron ionization structure
plot,feion89.field01[0,*],feion89.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
xrange=[e,f],yrange=[-8.0,-4.01],$
ytitle=TEXTOIDL('log (N_{ion}/N_{total})'),/nodata,XMARGIN=[c+6,d-4.25],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion89.field01[0,*],feion89.field01[1,*],color=fsc_color('red'),noclip=0,linestyle=4,thick=cplot        ;Fe+
plots,feion89.field01[2,*],feion89.field01[3,*],color=fsc_color('blue'),noclip=0,linestyle=0,thick=cplot        ;Fe2+
plots,feion89.field01[4,*],feion89.field01[5,*],color=fsc_color('darkgreen'),noclip=0,linestyle=2,thick=cplot       ;Fe3+
;plots,feion89.field01[6,*],feion89.field01[7,*],color=fsc_color('darkgrey'),noclip=0,linestyle=1      ;Fe4+
;plots,feion89.field01[8,*],feion89.field01[9,*],color=fsc_color('darkgrey'),noclip=0,linestyle=3     ;Fe5+
xyouts,1.6,-4.8,TEXTOIDL('Fe^{3+}'), charsize=1.2,charthick=cc
xyouts,1.6,-5.5,TEXTOIDL('Fe^{2+}'), charsize=1.2,charthick=cc

plot,feion01.field01[0,*],feion01.field01[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
xrange=[e,f],yrange=[-8.0,-4.01],ytickformat='(A1)',$
/nodata,XMARGIN=[c+4.25,d-2.5],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion01.field01[0,*],feion01.field01[1,*],color=fsc_color('red'),noclip=0,linestyle=4,thick=cplot
plots,feion01.field01[2,*],feion01.field01[3,*],color=fsc_color('blue'),noclip=0,linestyle=0,thick=cplot
plots,feion01.field01[4,*],feion01.field01[5,*],color=fsc_color('darkgreen'),noclip=0,linestyle=2,thick=cplot
;plots,feion01.field01[6,*],feion01.field01[7,*],color=fsc_color('darkgrey'),noclip=0,linestyle=1
;plots,feion01.field01[8,*],feion01.field01[9,*],color=fsc_color('darkgrey'),noclip=0,linestyle=3
xyouts,0.4,-6.0,TEXTOIDL('Fe^{3+}'), charsize=1.2,charthick=cc
xyouts,1.0,-4.7,TEXTOIDL('Fe^{2+}'), charsize=1.2,charthick=cc
xyouts,1.4,-6.8,TEXTOIDL('Fe^{+}'), charsize=1.2,charthick=cc

plot,feion02.field1[0,*],feion02.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
xrange=[e,f],yrange=[-8.0,-4.01],ytickformat='(A1)',$
/nodata,XMARGIN=[c+2.5,d-0.75],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion02.field1[0,*],feion02.field1[1,*],color=fsc_color('red'),noclip=0,linestyle=4,thick=cplot
plots,feion02.field1[2,*],feion02.field1[3,*],color=fsc_color('blue'),noclip=0,linestyle=0,thick=cplot
plots,feion02.field1[4,*],feion02.field1[5,*],color=fsc_color('darkgreen'),noclip=0,linestyle=2,thick=cplot
;plots,feion02.field1[6,*],feion02.field1[7,*],color=fsc_color('darkgrey'),noclip=0,linestyle=1
;plots,feion02.field1[8,*],feion02.field1[9,*],color=fsc_color('darkgrey'),noclip=0,linestyle=3
xyouts,0.55,-6.0,TEXTOIDL('Fe^{3+}'), charsize=1.2,charthick=cc
xyouts,1.0,-4.7,TEXTOIDL('Fe^{2+}'), charsize=1.2,charthick=cc
xyouts,1.5,-6.8,TEXTOIDL('Fe^{+}'), charsize=1.2,charthick=cc

plot,feion03.field1[0,*],feion03.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('log (r/R_*)'),charsize=ca,charthick=ct,xticklen=xticklen, yticklen=yticklen,$
xrange=[e,f],yrange=[-8.0,-4.01],ytickformat='(A1)',$
/nodata,XMARGIN=[c+0.75,d+1],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,feion03.field1[0,*],feion03.field1[1,*],color=fsc_color('red'),noclip=0,linestyle=4,thick=cplot
plots,feion03.field1[2,*],feion03.field1[3,*],color=fsc_color('blue'),noclip=0,linestyle=0,thick=cplot
plots,feion03.field1[4,*],feion03.field1[5,*],color=fsc_color('darkgreen'),noclip=0,linestyle=2,thick=cplot
;plots,feion03.field1[6,*],feion03.field1[7,*],color=fsc_color('darkgrey'),noclip=0,linestyle=1
;plots,feion03.field1[8,*],feion03.field1[9,*],color=fsc_color('darkgrey'),noclip=0,linestyle=3
xyouts,0.2,-6.0,TEXTOIDL('Fe^{3+}'), charsize=1.2,charthick=cc
xyouts,1.0,-4.7,TEXTOIDL('Fe^{2+}'), charsize=1.2,charthick=cc
xyouts,1.3,-6.8,TEXTOIDL('Fe^{+}'), charsize=1.2,charthick=cc


device,/close

set_plot,'x'


END
