;PRO ZE_WORK_ETACAR_IMAGES_TO_BOREHOLE_TOM_MOD44_GROH

file44='/Users/jgroh/ze_models/etacar/mod44_groh/obs/etacar_mod44_groh_ip_p_logr_4314_5506_6737_7936_12617_16569_21029_35556.txt'
ip44=read_ascii(file44)

;rstar for model 44
rstar44=0.29296873 ;in AU
dist=2.3           ; in kpc

;all r values are in log r/rstar, so we have to convert to mas
r1t=rstar44*10^(REFORM(ip44.field01[0,*]))/dist

;all i(p) values are not normalized, so we have to normalize them
i1t=REFORM(ip44.field01[1,*]/ip44.field01[1,0])

;does the same for r, i(p) of the other bands
r2t=rstar44*10^(REFORM(ip44.field01[2,*]))/dist
r3t=rstar44*10^(REFORM(ip44.field01[4,*]))/dist
r4t=rstar44*10^(REFORM(ip44.field01[6,*]))/dist
r5t=rstar44*10^(REFORM(ip44.field01[8,*]))/dist
r6t=rstar44*10^(REFORM(ip44.field01[10,*]))/dist
r7t=rstar44*10^(REFORM(ip44.field01[12,*]))/dist
r8t=rstar44*10^(REFORM(ip44.field01[14,*]))/dist

i2t=REFORM(ip44.field01[3,*]/ip44.field01[3,0])
i3t=REFORM(ip44.field01[5,*]/ip44.field01[5,0])
i4t=REFORM(ip44.field01[7,*]/ip44.field01[7,0])
i5t=REFORM(ip44.field01[9,*]/ip44.field01[9,0])
i6t=REFORM(ip44.field01[11,*]/ip44.field01[11,0])
i7t=REFORM(ip44.field01[13,*]/ip44.field01[13,0])
i8t=REFORM(ip44.field01[15,*]/ip44.field01[15,0])

;r1t,i1t, etc have only the positive side of the brightness distribution -- since it's spherical, mirror that to the negative side
r1=[REVERSE(-1D0*r1t),r1t] & r2=[REVERSE(-1D0*r2t),r2t] & r3=[REVERSE(-1D0*r3t),r3t] & r4=[REVERSE(-1D0*r4t),r4t] & r5=[REVERSE(-1D0*r5t),r5t] & r6=[REVERSE(-1D0*r6t),r6t] & r7=[REVERSE(-1D0*r7t),r7t] & r8=[REVERSE(-1D0*r8t),r8t] 
i1=[REVERSE(1D0*i1t),i1t] & i2=[REVERSE(1D0*i2t),i2t] & i3=[REVERSE(1D0*i3t),i3t] & i4=[REVERSE(1D0*i4t),i4t] & i5=[REVERSE(1D0*i5t),i5t] & i6=[REVERSE(1D0*i6t),i6t] & i7=[REVERSE(1D0*i7t),i7t] & i8=[REVERSE(1D0*i8t),i8t] 



!P.THICK=12
!X.THiCK=25
!Y.THICK=25
!P.CHARTHICK=2.5
!P.FONT=-1
;!P.CHARSIZE=3.5
;!X.CHARSIZE=3.5
;!Y.CHARSIZE=3.5

!P.Background = fsc_color('white')
LOADCT,0
xwindowsize=900.*1  ;window size in x
ywindowsize=360.*1  ; window size in y

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/etc_mod44_groh_I_p_lambda_mas.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
!X.THICK=12
!Y.THICK=12
!P.CHARTHICK=10
 LOADCT, 0

colorm1=fsc_color('black')
colorm2=fsc_color('red')
colorm3=fsc_color('blue')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

plot, r1,i1, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-10,10], $
xstyle=1,ystyle=1, ytitle='Intensity (normalized)', $
xtitle='Impact parameter (AU)', /NODATA, Position=[0.12, 0.17, 0.92, 0.97], title=title
plots,r1*2.3,i1,noclip=0,color=colorm1
plots,r2*2.3,i2,noclip=0,color=colorm2
plots,r3*2.3,i3,noclip=0,color=colorm3
plots,r4*2.3,i4,noclip=0,color=colorm4
plots,r5*2.3,i5,noclip=0,color=colorm5
plots,r6*2.3,i6,noclip=0,color=colorm6
plots,r7*2.3,i7,noclip=0,color=colorm7
plots,r8*2.3,i8,noclip=0,color=colorm8
device,/close


set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!Y.charsize=0
!X.charsize=0
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.MULTI=0
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!P.Background = fsc_color('white')




END