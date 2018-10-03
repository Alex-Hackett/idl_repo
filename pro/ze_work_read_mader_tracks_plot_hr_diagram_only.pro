sun = '!D!9n!3!N'

;constants
lsun=3.99e33
msun=1.98892e33

print,(0.2D*(1+0.4))*(10^(3.75))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*4.4)
stop
dir='/Users/jgroh/modrot/'
readme=dir+'readme_cols.txt'

m20=dir+'D20z20S0.dat'
m25=dir+'D25z20S0.dat'
m40=dir+'D40z20S0.dat'
m60=dir+'D60z20S0.dat'
m85=dir+'D85z20S0.dat'
m120=dir+'Dc2z20S0.dat'




m60r=dir+'D60z20S3A.dat'
m85r=dir+'D85z20S3A.dat'
m120r=dir+'Dc2z20S3A.dat'

;NON-ROTATING TRACKS
data60=read_ascii(m60, DATA_START=0, MISSING_VALUE=0.)
logteff60=data60.field01[4,*]
logt60=data60.field01[16,*]
logl60=data60.field01[3,*]
hn60=data60.field01[5,*]
hen60=data60.field01[6,*]
mass60=data60.field01[2,*]
age60=data60.field01[1,*]

;arbitrarily croppin arrays for Y < 0.98

;logteff60=logteff60(where(hn60 gt 0.17))
;logt60=logt60(where(hn60 gt 0.17))
;logl60=logl60(where(hn60 gt 0.17))
;mass60=mass60(where(hn60 gt 0.17))
;age60=age60(where(hn60 gt 0.17))
gammae60=(0.2D*(1+hn60))*(10^(logl60))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*mass60)
;cropping arrays around 0.5 < Y < 0.7

hn60c=hn60(where(hn60 lt 0.48))
hn60c=hn60c(where(hn60c gt 0.28))

logteff60c=logteff60(where(hn60 lt 0.48))
logteff60c=logteff60c(where(hn60c gt 0.28))

logt60c=logt60(where(hn60 lt 0.48))
logt60c=logt60c(where(hn60c gt 0.28))

logl60c=logl60(where(hn60 lt 0.48))
logl60c=logl60c(where(hn60c gt 0.28))

mass60c=mass60(where(hn60 lt 0.48))
mass60c=mass60c(where(hn60c gt 0.28))

data85=read_ascii(m85, DATA_START=0, MISSING_VALUE=0.)
logteff85=data85.field01[4,*]
logt85=data85.field01[16,*]
logl85=data85.field01[3,*]
hn85=data85.field01[5,*]
hen85=data85.field01[6,*]
mass85=data85.field01[2,*]
age85=data85.field01[1,*]

;arbitrarily croppin arrays for Y < 0.98
;logteff85=logteff85(where(hn85 gt 0.15))
;logt85=logt85(where(hn85 gt 0.15))
;logl85=logl85(where(hn85 gt 0.15))
;mass85=mass85(where(hn85 gt 0.15))
;age85=age85(where(hn85 gt 0.15))
gammae85=(0.2D*(1+hn85))*(10^(logl85))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*mass85)
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

data120=read_ascii(m120, DATA_START=0, MISSING_VALUE=0.)
logteff120=data120.field01[4,*]
logt120=data120.field01[16,*]
logl120=data120.field01[3,*]
hn120=data120.field01[5,*]
hen120=data120.field01[6,*]
mass120=data120.field01[2,*]
age120=data120.field01[1,*]


;arbitrarily croppin arrays for Y < 0.98
logteff120=logteff120(where(hn120 gt 0.03))
logt120=logt120(where(hn120 gt 0.03))
logl120=logl120(where(hn120 gt 0.03))
mass120=mass120(where(hn120 gt 0.03))
age120=age120(where(hn120 gt 0.03))
gammae120=(0.2D*(1+hn120))*(10^(logl120))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*mass120)

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
logt89=alog10(26200)
logteff89=alog10(22800)
logl89=alog10(1.5E6)
logt89err=500./(2.3*26200.)
logl89err=(10^(logl89))*0.1/(2.3*10^(logl89))

logt91j=alog10(24640)
logteff91j=alog10(21500)
logl91j=alog10(1.5E6)
logt91jerr=500./(2.3*26200.)
logl91jerr=(10^(logl91j))*0.1/(2.3*10^(logl91j))

logt91a=alog10(13800)
logteff91a=alog10(12100)
logl91a=alog10(1.0E6)
logt91aerr=500./(2.3*13800.)
logl91aerr=(10^(logl91a))*0.1/(2.3*10^(logl91a))

logt93a=alog10(12800)
logteff93a=alog10(10000)
logl93a=alog10(1.0E6)
logt93aerr=500./(2.3*12800.)
logl93aerr=(10^(logl93a))*0.1/(2.3*10^(logl93a))

logt94j=alog10(9100)
logteff94j=alog10(8100)
logl94j=alog10(1.0E6)
logt94jerr=500./(2.3*12800.)
logl94jerr=(10^(logl94j))*0.2/(2.3*10^(logl94j))



logt01a=alog10(22450)
logteff01a=alog10(17000)
logl01a=alog10(1.5E6)
logt01aerr=500./(2.3*22450.)
logl01aerr=1.5E6*0.1/(2.3*1.5E6)

logt02m=alog10(18700)
logteff02m=alog10(16400)
logl02m=alog10(1.0E6)
logt02merr=500./(2.3*21900.)
logl02merr=(10^(logl02m))*0.1/(2.3*10^(logl02m))

logt03j=alog10(17420)
logteff03j=alog10(14420)
logl03j=alog10(1.15E6)
logt03jerr=500./(2.3*21900.)
logl03jerr=(10^(logl03j))*0.1/(2.3*10^(logl03j))


logt01=alog10(22450)
logteff01=alog10(17000)
logl01=alog10(1.5E6)
logt01err=500./(2.3*22450.)
logl01err=1.5E6*0.1/(2.3*1.5E6)

hd_lum1=[6.4,5.8]
hd_temp1=[4.5,3.8]
hd_lum2=[5.8,5.8]
hd_temp2=[3.8,3.5]


;NEW: compute gamma e for MM03 tracks + Crowther+10 very high mass 
regra_tres_grafico_keynote_lmc=[16.,94.,189.,316.,462.]
lum_val_lmc=6.2+regra_tres_grafico_keynote_lmc*(0.2/107.)
regra_tres_grafico_keynote_solar=[19.,98.,191.]
lum_val_solar=6.2+regra_tres_grafico_keynote_solar*(0.2/107.)
ms_ini_mass_lmc=[20,25,40,60,85,120,150.,200,300,500]
ms_ini_mass_solar=[20,25,40,60,85,120,150.,200]
ms_ini_logl_nonrot_solar=[[4.621,4.873,5.350,5.708,5.984,6.234],lum_val_solar[1:2]]

ms_ini_gammae=(0.2D*(1+0.7))*(10^(ms_ini_logl_nonrot_solar))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*ms_ini_mass_solar)
kappa=0.7 
ms_ini_gammafull=(kappa)*(10^(ms_ini_logl_nonrot_solar))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*ms_ini_mass_solar)

ms_med_mass_solar=[20,25,40,60,85,120,150.,175]
ms_half_logl_nonrot_solar=[[4.867,5.105,5.350,5.708,5.984,6.234],lum_val_solar[1:2]]
ms_half_gammae=(0.2D*(1+0.7))*(10^(ms_half_logl_nonrot_solar))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*ms_med_mass_solar)

;end of main sequence, based on MM03
m20_amlt=[7.3501575E+06, 19.7222, 4.900, 4.444]
m25_amlt=[5.9360650E+06,  24.2913, 5.144, 4.453]
m40_amlt=[4.1534765E+06,  36.7774,5.571, 4.453]
m60_amlt=[3.3603445E+06,  49.5179, 5.876, 4.317]
m85_amlt=[2.9208428E+06,  52.9895, 6.091, 4.322] ;guestimated
m120_amlt=[2.5681895E+06,  61.8478, 6.266, 4.277]
m200_amlt=[2.2e+06,130.,6.6,4.5]

ms_end_xh_solar=[0.7 , 0.7, 0.7, 0.7,0.46,0.187,0.3]
ms_end_mass_solar=[19.72,24.29,36.77,49.51,52.98,61.8,130.]
ms_end_logl_nonrot_solar=[4.9,5.133,5.571,5.876,6.091,6.266,6.6]
ms_end_gammae=(0.2D*(1+ms_end_xh_solar))*(10^(ms_end_logl_nonrot_solar))*(lsun/msun)/(4.0*!PI*6.674e-8*2.99792e10*ms_end_mass_solar)

;plotting
to=2
tm=2
c1=2
charthickv=8.3

LOADCT,0
colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black

;1st panel
set_plot,'ps'
device,/close


device,filename='/Users/jgroh/temp/output_for_talk_mm03_evol_track_85_msun_rot_norot.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!P.FONT=-1
!P.THICK=8
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 15.
;!x.ticklen = ticklen/bb
;!y.ticklen = ticklen/aa

!Y.OMARGIN=[1,0]
!p.multi=0

m1=3. ; total length is m1 + m2
t=3
tb=2.5
a=0.77 ;scale factor

ymin=5.3
ymax=6.8
x1l=4.9
x1u=4.0

;;for talk schematic HR diagram
ymin=5.35
ymax=6.8
x1l=4.7
x1u=3.7

plot,logteff85,logl85,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[ymin,ymax],YMARGIN=[3./a,0.5/a],ytickinterval=0.5,$ 
ytitle='log (L/L'+sun+')',xtitle=TEXTOIDL('log T_{eff} '),/nodata,charsize=2.*a,XMARGIN=[6./a,m1/a],charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]
;plots,logteff85,logl85,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],linestyle=0
;plots,logteff85c,logl85c,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0
;plots,logteff85r,logl85r,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],linestyle=0
;plots,logteff85rc,logl85rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0

device,/close

device,filename='/Users/jgroh/temp/output_for_talk_mm03_evol_track_85_msun_norot_gamma_age.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!P.THICK=8
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
ticklen = 15.
;!x.ticklen = ticklen/bb
;!y.ticklen = ticklen/aa

!Y.OMARGIN=[1,0]
!p.multi=0

m1=3. ; total length is m1 + m2
t=3
tb=2.5
a=0.77 ;scale factor

ymin=0.2
ymax=0.8
x1l=0
x1u=3.5e6

plot,age85,gammae85,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[ymin,ymax],YMARGIN=[3./a,0.5/a],ytickinterval=0.2,xtickinterval=1e6,$ 
ytitle=TEXTOIDL('\Gamma'),xtitle=TEXTOIDL('Age (Myr) '),/nodata,charsize=2.*a,XMARGIN=[6./a,m1/a],charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]
plots,age85,gammae85,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],linestyle=0
;plots,logteff85c,logl85c,color=fsc_color('black'),noclip=0,clip=[x1l,ymin,x1u,ymax],thick=to+3,linestyle=0
;plots,logteff85r,logl85r,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],linestyle=0
;plots,logteff85rc,logl85rc,color=fsc_color('red'),noclip=0,clip=[x2l,ymin,x2u,ymax],thick=to+3,linestyle=0

device,/close

set_plot,'x'
!P.Background = fsc_color('white')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
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