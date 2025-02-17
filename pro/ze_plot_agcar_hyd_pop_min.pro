fhpop89='/aux/pc20117a/jgroh/cmfgen_models/agcar/389/389_hi_pop_4l.txt'
fhpop01='/aux/pc20117a/jgroh/cmfgen_models/agcar/373/373_hi_pop_4l.txt'
fhpop02='/aux/pc20117a/jgroh/cmfgen_models/agcar/382/382_hi_pop_4l.txt'
ffeion03='/aux/pc244a/jgroh/ze_models/agcar/381/381_if_iron_vel.txt'

hpop89=read_ascii(fhpop89, DATA_START=2, MISSING_VALUE=0.)
hpop01=read_ascii(fhpop01, DATA_START=2, MISSING_VALUE=0.)
;hpop02=read_ascii(fhpop02, DATA_START=2, MISSING_VALUE=0.)
feion03=read_ascii(ffeion03, DATA_START=2, MISSING_VALUE=0.)

;plotting hydrogen population

window,3
!p.multi=[0, 1, 2, 0, 0]

a=1
b=1
c=0
d=0
y1=-3.
y2=5

plot,hpop89.field1[0,*],hpop89.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,300.000],yrange=[-8.0,5.0],$
ytitle=TEXTOIDL('log (N_{ion}/N_{total})'),/nodata,charsize=2,XMARGIN=[c+6,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,hpop89.field1[0,*],hpop89.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0         ;Fe+
plots,hpop89.field1[2,*],hpop89.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0        ;Fe2+
plots,hpop89.field1[4,*],hpop89.field1[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0   ;Fe3+
plots,hpop89.field1[6,*],hpop89.field1[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0      ;Fe4+


plot,hpop01.field1[0,*],hpop01.field1[1,*],xstyle=1,ystyle=1,xtitle=TEXTOIDL('v [km/s]'),$
xrange=[-0.5,120.000],yrange=[-8.0,5.0],ytickformat='(A1)',$
/nodata,charsize=2,XMARGIN=[c,d],YMARGIN=[a+3,b-2];,POSITION=[0.11,0.10,0.959,0.49]
plots,hpop01.field1[0,*],hpop01.field1[1,*],color=fsc_color('red'),noclip=0,thick=2,linestyle=0
plots,hpop01.field1[2,*],hpop01.field1[3,*],color=fsc_color('blue'),noclip=0,thick=2,linestyle=0
plots,hpop01.field1[4,*],hpop01.field1[5,*],color=fsc_color('darkgreen'),noclip=0,thick=2,linestyle=0
plots,hpop01.field1[6,*],hpop01.field1[7,*],color=fsc_color('purple'),noclip=0,thick=2,linestyle=0

window,4
plot,hpop89.field1[0,*],(hpop89.field1[3,*]/hpop89.field1[1,*]),color=fsc_color('red'),noclip=0,thick=2,linestyle=0,$
 xrange=[-0.5,300.000],yrange=[-2.0,1.3],xstyle=1,ystyle=1
plots,hpop01.field1[0,*],(hpop01.field1[1,*]/hpop01.field1[1,*]),color=fsc_color('blue'),noclip=0,thick=2,linestyle=2

END
