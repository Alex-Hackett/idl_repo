close,/all
;defines HYDRO for reading, as generated by CMFGEN. Needs to know the value of ND
;hydro='/aux/pc244a/jgroh/ze_models/agcar/223/HYDRO_cut.txt' 
;hydro='/aux/pc244a/jgroh/ze_models/agcar/223/HYDRO'
;hydro='/aux/pc244a/jgroh/ze_models/agcar/291b/HYDRO'
;hydro='/aux/pc244a/jgroh/ze_models/agcar/279_h3/REV_HYDRO'
;hydro='/aux/pc244a/jgroh/ze_models/agcar/223/REV_HYDRO'
;hydro='/aux/pc20117a/jgroh/cmfgen_models/agcar/348/HYDRO'
;hydro='/aux/pc20117a/jgroh/cmfgen_models/agcar/349_monotonic/HYDRO'
;hydro='/aux/pc20117a/jgroh/cmfgen_models/agcar/348_copy_newversion9pr08/HYDRO'
;hydro='/aux/pc20117a/jgroh/cmfgen_models/agcar/382/HYDRO'
hydro='/aux/pc244a/jgroh/ze_models/agcar/381/HYDRO'
openu,1,hydro     ; open file without writing

;number of depth points
ND=54.
linha=''
i=0.

;finds the i number of points in ewdata
i=0
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
i=i+1
skip1:
endwhile
close,1

print,i

;declare arrays
r=dblarr(ND) & v=r & error=r & vdvdr=r & rhodpdr=r & gtot=r & grad=r & gelec=r & gamma=r & gradreq=r
grot=r
grad_over_gradreq=r
g=r
header=''

;read values
openu,1,hydro
readf,1,header
for k=0, ND-1 do begin
readf,1,r1,v1,error1,vdvdr1,rhodpdr1,gtot1,grad1,gelec1,gamma1
r[k]=r1 & v[k]=v1 & error[k]=error1 & vdvdr[k]=vdvdr1 & rhodpdr[k]=rhodpdr1 & gtot[k]=gtot1 & grad[k]=grad1 & gelec[k]=gelec1 & gamma[k]=gamma1
endfor
close,1


;calculate gline
gline=grad-gelec

;calculate g=grad-gtot
g=grad-gtot

for p=0,ND-1 do begin
;grot[p]=250.*250.*r[ND-1]*r[ND-1] / (1.*r[p]*r[p]*r[p]) ;from from Madura et al. 2007
grot[p]=0.
gradreq[p]=+vdvdr[p]+rhodpdr[p]+g[p]-grot[p]
grad_over_gradreq[p]=grad[p]/gradreq[p]
;print,r[p],v[p],grad[p],gradreq[p],grot[p],grad_over_gradreq[p]
endfor



x0min=0
x0max=alog10(r[0]/r[ND-1])
y0min=-1000.
y0max=1000.
x0bmin=v[ND-1]
x0bmax=0
x0bmax=30.
;x0bmin=alog10(v[ND-1])
;x0bmax=alog10(v[0])
y0bmin=1.
y0bmax=3.
x0cmin=0
;x0cmax=max(v)-10
x0cmax=30.
;xwindow plots
i=0
window,i,XSiZE=500,YSiZE=500,TITLE='acceleration as a function of distance'
plot,alog10(r/r[ND-1]),alog10(grad),XSTYLE=1,xtitle='log (r/R!I*!N)',ytitle='log a [cm s!E-2!N]',$
noclip=0,clip=[x0min,y0min,x0max,y0max],XCHARSIZE=2,YCHARSIZE=2,xrange=[x0min,x0max],XMARGIN=[15,6],YMARGIN=[8,4],/nodata
plots,alog10(r/r[ND-1]),alog10(grad),noclip=0,clip=[x0min,y0min,x0max,y0max]
plots,alog10(r/r[ND-1]),alog10(gradreq),color=fsc_color('red'),noclip=0,clip=[x0min,y0min,x0max,y0max]
plots,alog10(r/r[ND-1]),alog10(g),color=fsc_color('magenta'),noclip=0,clip=[x0min,y0min,x0max,y0max]
plots,alog10(r/r[ND-1]),alog10(grot),color=fsc_color('green'),linestyle=1,noclip=0,clip=[x0min,y0min,x0max,y0max]
plots,alog10(r/r[ND-1]),alog10(gelec),color=fsc_color('blue'),noclip=0,clip=[x0min,y0min,x0max,y0max]
plots,alog10(r/r[ND-1]),alog10(gline),color=fsc_color('yellow'),linestyle=1,noclip=0,clip=[x0min,y0min,x0max,y0max]
i=i+1

window,i,XSiZE=500,YSiZE=500,TITLE='acceleration as a function of velocity'
plot,alog10(v),alog10(grad),XSTYLE=1,xtitle='velocity [km/s]',ytitle='log a [cm s!E-2!N]',$
XCHARSIZE=2,YCHARSIZE=2,xrange=[x0bmin,x0bmax],yrange=[y0bmin,y0bmax],XMARGIN=[15,6],YMARGIN=[8,4],/nodata
plots,v,alog10(grad),noclip=0,clip=[x0bmin,y0bmin,x0bmax,y0bmax]
plots,v,alog10(gradreq),color=fsc_color('red'),noclip=0,clip=[x0bmin,y0bmin,x0bmax,y0bmax]
plots,v,alog10(grot),color=fsc_color('green'),linestyle=1,noclip=0,clip=[x0bmin,y0bmin,x0bmax,y0bmax]
plots,v,alog10(gelec),color=fsc_color('blue'),noclip=0,clip=[x0bmin,y0min,x0bmax,y0max]
plots,v,alog10(gline),color=fsc_color('yellow'),linestyle=1,noclip=0,clip=[x0bmin,y0bmin,x0bmax,y0bmax]
i=i+1

window,i,XSiZE=500,YSiZE=500,TITLE='ratio between model grad and required grad'
plot,alog10(r),grad_over_gradreq,XSTYLE=1,xtitle='velocity [km/s]',ytitle='CMFGEN grad / required grad',$
XCHARSIZE=2,YCHARSIZE=2,xrange=[x0cmin,x0cmax],yrange=[0.0,2],XMARGIN=[15,6],YMARGIN=[8,4],/YNOZERO,/nodata
plots,v,grad_over_gradreq,noclip=0,clip=[x0cmin,0.0,x0cmax,2]
i=i+1

close,/all
;defines ION_LINE_FORCE for reading, as generated by CMFGEN. Needs to know the value of ND
;ion_line_force='/aux/pc244a/jgroh/ze_models/agcar/223/obs/HYDRO_cut.txt' 
;ion_line_force='/aux/pc244a/jgroh/ze_models/agcar/223/obs/HYDRO'
;ion_line_force='/aux/pc244a/jgroh/ze_models/agcar/291b/obs/HYDRO'
;ion_line_force='/aux/pc244a/jgroh/ze_models/agcar/279_h3/obs/REV_HYDRO'
;ion_line_force='/aux/pc244a/jgroh/ze_models/agcar/223/REV_HYDRO'
;ion_line_force='/aux/pc20117a/jgroh/cmfgen_models/agcar/348/obs/HYDRO'
;ion_line_force='/aux/pc20117a/jgroh/cmfgen_models/agcar/349_monotonic/obs/ION_LINE_FORCE'
ion_line_force='/aux/pc20117a/jgroh/cmfgen_models/agcar/348_copy_newversion9pr08/obs/ION_LINE_FORCE'
;ion_line_force='/aux/pc20117a/jgroh/cmfgen_models/agcar/348_copy_newversion9pr08/obs/t'
ion_line_force='/aux/pc20117a/jgroh/cmfgen_models/agcar/349/obs2d/ION_LINE_FORCE'
ion_line_force='/aux/pc244a/jgroh/ze_models/agcar/381/obs2d/ION_LINE_FORCE'
openu,2,ion_line_force     ; open file without writing

;data=read_ascii(ion_line_force)
data=read_ascii(ion_line_force, DATA_START=6, MISSING_VALUE=0.)
close,2
depth=data.field01[0,*]
v=data.field01[1,*]
t=size(data.field01)
tc=t[1]
tl=t[2]

sum_line=dblarr(tl)

FOR s=0, tl-1 DO BEGIN
sum_line[s]=TOTAL(data.field01[3:(tc-1),s]) 
ENDFOR
;v[57]=0.0003
x0dmin=sqrt(min(v))
x0dmax=sqrt(max(v))
x0dminb=0
;x0dmaxb=max(v)-280.
x0dmaxb=30.
window,i,XSiZE=500,YSiZE=500,TITLE='Fraction of radiative force as a function of velocity'
plot,v,sum_line,XSTYLE=1,xtitle='velocity [km/s]',ytitle='Fraction of radiative force',$
XCHARSIZE=2,YCHARSIZE=2,XRANGE=[x0dminb,x0dmaxb],yrange=[0,1],XMARGIN=[15,6],YMARGIN=[8,4],/YNOZERO,/nodata
plots,v,0.01*sum_line,noclip=0,clip=[x0dminb,0,x0dmaxb,1],color=fsc_color('red'),linestyle=2
plots,v,gelec/grad,noclip=0,clip=[x0dminb,0,x0dmaxb,1]
plots,v,1-(gelec/grad + 0.01*sum_line),noclip=0,clip=[x0dminb,0,x0dmaxb,1],color=fsc_color('yellow'),linestyle=1

;putting legends
plots,[200,230],[0.93,0.93],color=fsc_color('white'),linestyle=0
xyouts,240,0.91,'a!Ie.s.',alignment=0,orientation=0,CHARSIZE=3.0,CHARTHICK=1.5
plots,[200,230],[0.88,0.88],color=fsc_color('red'),linestyle=2
xyouts,240,0.86,'a!Iline',alignment=0,orientation=0,CHARSIZE=3.0,CHARTHICK=1.5
plots,[200,230],[0.83,0.83],color=fsc_color('yellow'),linestyle=1
xyouts,240,0.81,'a!Ib.f.',alignment=0,orientation=0,CHARSIZE=3.0,CHARTHICK=1.5

i=i+1


;making psplots
set_plot,'ps'
device,/close

device,filename='/aux/pc244a/jgroh/temp/output_hydro_plot.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!p.multi=[0, 1, 2]

plot,alog10(r),grad_over_gradreq,XSTYLE=1,YSTYLE=1,XTICKFORMAT='(A1)',ytitle='g!Iline!N/g!Iline,req',$
XCHARSIZE=2,YCHARSIZE=2,xrange=[x0cmin,x0cmax],yrange=[0.4,1.6],/YNOZERO,/nodata,$
POSITION=[0.13,0.55,0.98,0.98]
plots,v,grad_over_gradreq,noclip=0,clip=[x0cmin,0.4,x0cmax,2]

plot,v,sum_line,XSTYLE=9,YSTYLE=1,xtitle='velocity [km/s]',ytitle='Fraction of a!Irad',$
XCHARSIZE=2,YCHARSIZE=2,XRANGE=[x0dminb,x0dmaxb],yrange=[-0.07,1.09],/YNOZERO,/nodata,$
POSITION=[0.13,0.15,0.98,0.55]
plots,v,0.01*sum_line,noclip=0,clip=[x0dminb,0,x0dmaxb,1],color=fsc_color('black'),linestyle=2
plots,v,gelec/grad,noclip=0,clip=[x0dminb,0,x0dmaxb,1]
plots,v,1-(gelec/grad + 0.01*sum_line),noclip=0,clip=[x0dminb,0,x0dmaxb,1.1],color=fsc_color('black'),linestyle=1

;putting legends
plots,[30,64],[1.01,1.01],color=fsc_color('black'),linestyle=0
xyouts,70,0.98,'a!Ie.s.',alignment=0,orientation=0,CHARSIZE=3.0,CHARTHICK=1.5
plots,[30,64],[0.90,0.90],color=fsc_color('black'),linestyle=2
xyouts,70,0.87,'a!Iline',alignment=0,orientation=0,CHARSIZE=3.0,CHARTHICK=1.5
plots,[30,64],[0.79,0.79],color=fsc_color('black'),linestyle=1
xyouts,70,0.76,'a!Ib.f.',alignment=0,orientation=0,CHARSIZE=3.0,CHARTHICK=1.5


!p.multi=[0, 0, 0, 0, 0]
device,/close

set_plot,'x'


END
