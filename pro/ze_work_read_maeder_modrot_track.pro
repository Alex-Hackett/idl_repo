sun = '!D!9n!3!N'

dir='/Users/jgroh/modrot/'
readme=dir+'readme_cols.txt'
m60=dir+'D60z20S0.dat'
m85=dir+'D85z20S0.dat'
m120=dir+'Dc2z20S0.dat'

m60r=dir+'D60z20S3A.dat'
m85r=dir+'D85z20S3A.dat'
m120r=dir+'Dc2z20S3A.dat'

;NON-ROTATING TRACKS
data=read_ascii(m60, DATA_START=0, MISSING_VALUE=0.)
logteff60=data.field01[4,*]
logt60=data.field01[16,*]
logl60=data.field01[3,*]
hn60=data.field01[5,*]
hen60=data.field01[6,*]

logtorig60=logt60
loglorig60=logl60
logtefforig60=logteff60

;arbitrarily croppin arrays for Y < 0.98
logteff60=logteff60(where(hn60 gt 0.17))
logt60=logt60(where(hn60 gt 0.17))
logl60=logl60(where(hn60 gt 0.17))

;cropping arrays around 0.5 < Y < 0.7

hn60c=hn60(where(hn60 lt 0.48))
hn60c=hn60c(where(hn60c gt 0.28))

logteff60c=logteff60(where(hn60 lt 0.48))
logteff60c=logteff60c(where(hn60c gt 0.28))

logt60c=logt60(where(hn60 lt 0.48))
logt60c=logt60c(where(hn60c gt 0.28))

logl60c=logl60(where(hn60 lt 0.48))
logl60c=logl60c(where(hn60c gt 0.28))

data=read_ascii(m85, DATA_START=0, MISSING_VALUE=0.)
logteff85=data.field01[4,*]
logt85=data.field01[16,*]
logl85=data.field01[3,*]
hn85=data.field01[5,*]
hen85=data.field01[6,*]
mass85=data.field01[2,*]

;arbitrarily croppin arrays for Y < 0.98
logteff85=logteff85(where(hn85 gt 0.15))
logt85=logt85(where(hn85 gt 0.15))
logl85=logl85(where(hn85 gt 0.15))
mass85=mass85(where(hn85 gt 0.15))

;cropping arrays around 0.5 < Y < 0.7

hn85c=hn85(where(hn85 lt 0.48))
hn85c=hn85c(where(hn85c gt 0.28))

logteff85c=logteff85(where(hn85 lt 0.48))
logteff85c=logteff85c(where(hn85c gt 0.28))

logt85c=logt85(where(hn85 lt 0.48))
logt85c=logt85c(where(hn85c gt 0.28))

logl85c=logl85(where(hn85 lt 0.48))
logl85c=logl85c(where(hn85c gt 0.28))

mass85c=mass85(where(hn85 lt 0.48))
mass85c=mass85c(where(hn85c gt 0.28))

data=read_ascii(m120, DATA_START=0, MISSING_VALUE=0.)
logteff120=data.field01[4,*]
logt120=data.field01[16,*]
logl120=data.field01[3,*]
hn120=data.field01[5,*]
hen120=data.field01[6,*]
mass120=data.field01[2,*]

;arbitrarily croppin arrays for Y < 0.98
logteff120=logteff120(where(hn120 gt 0.03))
logt120=logt120(where(hn120 gt 0.03))
logl120=logl120(where(hn120 gt 0.03))
mass120=mass120(where(hn120 gt 0.03))

;cropping arrays around 0.5 < Y < 0.7

hn120c=hn120(where(hn120 lt 0.48))
hn120c=hn120c(where(hn120c gt 0.28))

logteff120c=logteff120(where(hn120 lt 0.48))
logteff120c=logteff120c(where(hn120c gt 0.28))

logt120c=logt120(where(hn120 lt 0.48))
logt120c=logt120c(where(hn120c gt 0.28))

logl120c=logl120(where(hn120 lt 0.48))
logl120c=logl120c(where(hn120c gt 0.28))

mass120c=mass120(where(hn120 lt 0.48))
mass120c=mass120c(where(hn120c gt 0.28))

;ROTATING TRACKS
data=read_ascii(m60r, DATA_START=0, MISSING_VALUE=0.)
logteff60r=data.field01[4,*]
logt60r=data.field01[16,*]
logl60r=data.field01[3,*]
hn60r=data.field01[5,*]
hen60r=data.field01[6,*]

;arbitrarily croppin arrays for Y < 0.98
logteff60r=logteff60r(where(hn60r gt 0.17))
logt60r=logt60r(where(hn60r gt 0.17))
logl60r=logl60r(where(hn60r gt 0.17))

;cropping arrays around 0.5 < Y < 0.7

hn60rc=hn60r(where(hn60r lt 0.48))
hn60rc=hn60rc(where(hn60rc gt 0.28))

logteff60rc=logteff60r(where(hn60r lt 0.48))
logteff60rc=logteff60rc(where(hn60rc gt 0.28))

logt60rc=logt60r(where(hn60r lt 0.48))
logt60rc=logt60rc(where(hn60rc gt 0.28))

logl60rc=logl60r(where(hn60r lt 0.48))
logl60rc=logl60rc(where(hn60rc gt 0.28))

data=read_ascii(m85r, DATA_START=0, MISSING_VALUE=0.)
logteff85r=data.field01[4,*]
logt85r=data.field01[16,*]
logl85r=data.field01[3,*]
hn85r=data.field01[5,*]
hen85r=data.field01[6,*]

;arbitrarily croppin arrays for Y < 0.98
logteff85r=logteff85r(where(hn85r gt 0.15))
logt85r=logt85r(where(hn85r gt 0.15))
logl85r=logl85r(where(hn85r gt 0.15))

;cropping arrays around 0.5 < Y < 0.7

hn85rc=hn85r(where(hn85r lt 0.48))
hn85rc=hn85rc(where(hn85rc gt 0.28))

logteff85rc=logteff85r(where(hn85r lt 0.48))
logteff85rc=logteff85rc(where(hn85rc gt 0.28))

logt85rc=logt85r(where(hn85r lt 0.48))
logt85rc=logt85rc(where(hn85rc gt 0.28))

logl85rc=logl85r(where(hn85r lt 0.48))
logl85rc=logl85rc(where(hn85rc gt 0.28))

data=read_ascii(m120r, DATA_START=0, MISSING_VALUE=0.)
logteff120r=data.field01[4,*]
logt120r=data.field01[16,*]
logl120r=data.field01[3,*]
hn120r=data.field01[5,*]
hen120r=data.field01[6,*]

;arbitrarily croppin arrays for Y < 0.98
logteff120r=logteff120r(where(hn120r gt 0.03))
logt120r=logt120r(where(hn120r gt 0.03))
logl120r=logl120r(where(hn120r gt 0.03))

;cropping arrays around 0.5 < Y < 0.7

hn120rc=hn120r(where(hn120r lt 0.48))
hn120rc=hn120rc(where(hn120rc gt 0.28))

logteff120rc=logteff120r(where(hn120r lt 0.48))
logteff120rc=logteff120rc(where(hn120rc gt 0.28))

logt120rc=logt120r(where(hn120r lt 0.48))
logt120rc=logt120rc(where(hn120rc gt 0.28))

logl120rc=logl120r(where(hn120r lt 0.48))
logl120rc=logl120rc(where(hn120rc gt 0.28))




;observations from paper I
logt89=alog10(27000)
logteff89=alog10(22800)
logl89=alog10(1.5E6)
logt89err=500./(2.3*27000.)
logl89err=0.08

logt01=alog10(22450)
logteff01=alog10(17000)
logl01=alog10(1.5E6)
logt01err=500./(2.3*22450.)
logl01err=0.08



;plotting
to=3.5
tm=2
c1=2
charthickv=8.3

LOADCT,0

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

;1st panel
set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/output_agc_min_evol_mm03.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!X.THICK=3.5
!Y.THICK=3.5
!Y.OMARGIN=[-0.7,0]
!X.OMARGIN=[4,0]
!p.multi=[0,2,2]
ymin=5.65
ymax=6.35
x1l=4.8
x1u=3.81
m1=-2. ; total length is m1 + m2
t=3
tb=4.5
a=0.77 ;scale factor

plot,logteff85,logl85,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[ymin,ymax],YMARGIN=[2.7/a,0.2/a],ytickinterval=0.2,$ 
ytitle='log (L/L'+sun+')',/nodata,charsize=2.*a,XMARGIN=[6./a,m1/a],xtitle=TEXTOIDL('log T_{*} '),$
charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]
plots,logt60,logl60,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to,linestyle=0
plots,logt60c,logl60c,color=fsc_color('red'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0
plots,logt85,logl85,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+1,linestyle=1
plots,logt85c,logl85c,color=fsc_color('red'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0
plots,logt120,logl120,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to,linestyle=2
plots,logt120c,logl120c,color=fsc_color('red'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0

xyouts,4.22,5.75,TEXTOIDL('v_{ini}=0 km s^{-1}'),charthick=charthickv/1.4,charsize=1.4,alignment=0
xyouts,4.75,6.28,TEXTOIDL('a)'),charthick=charthickv/1.4,charsize=1.4,alignment=0

plots,logt89,logl89,color=fsc_color('black'),psym=1,thick=tb
oploterror,logt89,logl89,logt89err,logl89err,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb
plots,logt01,logl01,color=fsc_color('black'),psym=1,thick=tb
oploterror,logt01,logl01,logt01err,logl01err,psym=5,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb

xyouts,4.70,6.2,TEXTOIDL('120'),charthick=charthickv/1.4,charsize=1,alignment=0
xyouts,4.70,5.93,TEXTOIDL('85'),charthick=charthickv/1.4,charsize=1,alignment=0
xyouts,4.70,5.75,TEXTOIDL('60'),charthick=charthickv/1.4,charsize=1,alignment=0

x2l=4.79
x2u=4.2

plot,logteff85,logl85,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[ymin,ymax],YMARGIN=[2.7/a,0.2/a], ytickinterval=0.2,$
/nodata,charsize=2.*a,XMARGIN=[-m1/a,2./a],YTICKFORMAT="(A1)",xtitle=TEXTOIDL('log T_{*} '),$
charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]
plots,logt60r,logl60r,color=fsc_color('black'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to,linestyle=0
plots,logt60rc,logl60rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0
plots,logt85r,logl85r,color=fsc_color('black'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+1,linestyle=1
plots,logt85rc,logl85rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0
plots,logt120r,logl120r,color=fsc_color('black'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to,linestyle=2
plots,logt120rc,logl120rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0

xyouts,4.5,5.75,TEXTOIDL('v_{ini}=300 km s^{-1}'),charthick=charthickv/1.4,charsize=1.4,alignment=0
xyouts,4.75,6.28,TEXTOIDL('b)'),charthick=charthickv/1.4,charsize=1.4,alignment=0

plots,logt89,logl89,color=fsc_color('black'),psym=1,thick=tb
oploterror,logt89,logl89,logt89err,logl89err,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb
plots,logt01,logl01,color=fsc_color('black'),psym=1,thick=tb
oploterror,logt01,logl01,logt01err,logl01err,psym=5,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb


ymin=5.7
ymax=6.33
x1l=4.8
x1u=3.81

plot,logteff85,logl85,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[ymin,ymax],YMARGIN=[3./a,0.5/a],ytickinterval=0.2,$ 
ytitle='log (L/L'+sun+')',xtitle=TEXTOIDL('log T_{eff} '),/nodata,charsize=2.*a,XMARGIN=[6./a,m1/a],charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]
plots,logteff60,logl60,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to,linestyle=0
plots,logteff60c,logl60c,color=fsc_color('red'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0
plots,logteff85,logl85,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+1,linestyle=1
plots,logteff85c,logl85c,color=fsc_color('red'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0
plots,logteff120,logl120,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to,linestyle=2
plots,logteff120c,logl120c,color=fsc_color('red'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0

xyouts,4.22,5.75,TEXTOIDL('v_{ini}=0 km s^{-1}'),charthick=charthickv/1.4,charsize=1.4,alignment=0
xyouts,4.75,6.27,TEXTOIDL('c)'),charthick=charthickv/1.4,charsize=1.4,alignment=0

plots,logteff89,logl89,color=fsc_color('black'),psym=1,thick=tb
oploterror,logteff89,logl89,logt89err,logl89err,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb
plots,logteff01,logl01,color=fsc_color('black'),psym=1,thick=tb
oploterror,logteff01,logl01,logt01err,logl01err,psym=5,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb

xyouts,4.70,6.2,TEXTOIDL('120'),charthick=charthickv/1.4,charsize=1,alignment=0
xyouts,4.70,5.93,TEXTOIDL('85'),charthick=charthickv/1.4,charsize=1,alignment=0
xyouts,4.70,5.75,TEXTOIDL('60'),charthick=charthickv/1.4,charsize=1,alignment=0


plot,logteff85,logl85,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[ymin,ymax], ytickinterval=0.2,$
/nodata,charsize=2.*a,XMARGIN=[-m1/a,2./a],YMARGIN=[3./a,0.5/a],$
YTICKFORMAT="(A1)",xtitle=TEXTOIDL('log T_{eff} '),charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]
plots,logteff60r,logl60r,color=fsc_color('black'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to,linestyle=0
plots,logteff60rc,logl60rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0
plots,logteff85r,logl85r,color=fsc_color('black'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+1,linestyle=1
plots,logteff85rc,logl85rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0
plots,logteff120r,logl120r,color=fsc_color('black'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to,linestyle=2
plots,logteff120rc,logl120rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0

xyouts,4.5,5.75,TEXTOIDL('v_{ini}=300 km s^{-1}'),charthick=charthickv/1.4,charsize=1.4,alignment=0
xyouts,4.75,6.27,TEXTOIDL('d)'),charthick=charthickv/1.4,charsize=1.4,alignment=0

plots,logteff89,logl89,color=fsc_color('black'),psym=1,thick=tb
oploterror,logteff89,logl89,logt89err,logl89err,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb
plots,logteff01,logl01,color=fsc_color('black'),psym=1,thick=tb
oploterror,logteff01,logl01,logt01err,logl01err,psym=5,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb

device,/close
set_plot,'x'


;debugging
;x2l=4.8
;x2u=3.8
;window,2
;!p.multi=0
;plot,logteff85,logl85,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[ymin,ymax], $
;/nodata,charsize=2,XMARGIN=[8,3],charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]
;for i=0, 139 do begin
;plots,logt60c[i],logl60c[i],color=fsc_color('black'),psym=2
;plots,logteff60c[i],logl60c[i],color=fsc_color('red'),psym=1
;wait,0.1
;endfor



END
