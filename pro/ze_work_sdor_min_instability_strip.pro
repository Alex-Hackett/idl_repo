;PRO ZE_WORK_SDOR_MIN_INSTABILITY_STRIP

sun = '!D!9n!3!N'

;Humphreys-Davidson limit
hd_lum1=[6.4,5.8]
hd_temp1=[4.5,3.8]
hd_lum2=[5.8,5.8]
hd_temp2=[3.8,3.5]

;AG Car during 1990 minimum
agc_teff=alog10(22800.)
agc_tstar=alog10(26200.)
agc_lstar=alog10(1.5E6)
agc_logteff89err=500./(2.3*22800.)
agc_logtstar89err=500./(2.3*26200.)
agc_logl89err=(10^(agc_lstar))*0.1/(2.3*10^(agc_lstar))

;HRCAR during 2009 minimum
hrc_teff=alog10(17900.)
hrc_tstar=alog10(18900.)
hrc_lstar=alog10(0.5E6)
hrc_logteff09err=500./(2.3*17900.)
hrc_logtstar09err=500./(2.3*18900.)
hrc_logl09err=(10^(agc_lstar))*0.1/(2.3*10^(agc_lstar))

;Pcygni stellar param from Najarro 2001
pcold_teff=alog10(18700.)
pcold_tstar=alog10(19900.) ;assuming 
pcold_lstar=alog10(0.61E6)
pcold_logteff09err=500./(2.3*18700.)
pcold_logtstar09err=500./(2.3*19900.)
pcold_logl09err=(10^(pc_lstar))*0.1/(2.3*10^(pc_lstar))

;Pcygni stellar param from Najarro 2011 (priv commun)
pc_teff=alog10(15090.)
pc_tstar=alog10(18500.) ;assuming 
pc_lstar=alog10(0.59E6)
pc_logteff09err=500./(2.3*15090.)
pc_logtstar09err=500./(2.3*18500.)
pc_logl09err=(10^(pc_lstar))*0.1/(2.3*10^(pc_lstar))

;HD 168625 stellar parameters groh et al. in prep
hd168625_teff=alog10(13600.)
hd168625_tstar=alog10(14200.) ;assuming 
hd168625_lstar=alog10(0.3E6)
hd168625_logteff09err=500./(2.3*13600.)
hd168625_logtstar09err=500./(2.3*14200.)
hd168625_logl09err=(10^(pc_lstar))*0.1/(2.3*10^(hd168625_lstar))

;HD 168625 stellar parameters groh et al. in prep
w243_teff=alog10(8500.)
w243_tstar=alog10(8700.) ;assuming 
w243_lstar=alog10(0.75E6)
w243_logteff09err=500./(2.3*8500.)
w243_logtstar09err=500./(2.3*8700.)
w243_logl09err=(10^(pc_lstar))*0.1/(2.3*10^(w243_lstar))

;S Dor min instability strip from Clark et al. 2005
logt_clark1=lindgen(10)/10. + 4.
logl_clark1=2.08*logt_clark1-3.01
logt_clark2=lindgen(10)/10. + 4.
logl_clark2=2.70*logt_clark1-5.82

result = linfit([hrc_teff,agc_teff], [hrc_lstar,agc_lstar], sdev=[hrc_logl09err,agc_logl89err], chisq = chisq, prob = prob, yfit=yfit, sigma=sigma)
result_tstar = linfit([hrc_tstar,agc_tstar], [hrc_lstar,agc_lstar], sdev=[hrc_logl09err,agc_logl89err], chisq = chisq_tstar, prob = prob_tstar, yfit=yfit_tstar, sigma=sigma_tstar)
xfit=[4.18,4.4]
yfit2=result[0]+xfit*result[1]

xfit_for_plot_upper_limit=xfit-0.05
xfit_for_plot_lower_limit=xfit+0.05

yfit2_for_plot_upper_limit=(result[0])+(xfit_for_plot_upper_limit*result[1])
yfit2_for_plot_lower_limit=(result[0])+(xfit_for_plot_lower_limit*result[1])

;plotting
to=2
tm=2
c1=2
charthickv=8.3
;set_plot,'x'
;LOADCT,0, /SILENT
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')

;1st panel
set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/output_for_talk_sdor_min_inst_strip.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=8.48,/inches
!X.THICK=6.5
!Y.THICK=6.5
!P.THICK=6.5
!Y.OMARGIN=[1,0]
!p.multi=0
ymin=5.35
ymax=6.4
x1l=4.7
x1u=3.5
m1=3. ; total length is m1 + m2
t=5
tb=5.5
a=0.77 ;scale factor


plot,hd_temp1,hd_lum1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[ymin,ymax],YMARGIN=[2.7/a,0.2/a],ytickinterval=0.2,$ 
ytitle='log (L/L'+sun+')',/nodata,charsize=2.*a,XMARGIN=[6./a,m1/a],xtitle=TEXTOIDL('log Teff '),$
charthick=charthickv/1.4;,POSITION=[0.09,0.80,0.97,0.99]

xpoly = [xfit_for_plot_lower_limit[1],   xfit_for_plot_lower_limit[0],  xfit_for_plot_upper_limit[0], xfit_for_plot_upper_limit[1],     xfit_for_plot_lower_limit[1]]
ypoly = [yfit2[1],   yfit2[0],  yfit2[0], yfit2[1], yfit2[1]]
PolyFill, xpoly, ypoly, Color=fsc_color('grey')

xpoly2 = [x1l,          x1l,   xfit_for_plot_lower_limit[0],   xfit_for_plot_lower_limit[1],  x1l]
ypoly2 = [yfit2[1],   yfit2[0],  yfit2[0], yfit2[1], yfit2[1]]
PolyFill,xpoly2, ypoly2, LINE_FILL=1, SPACING=0.5, ORIENTATION=45,Color=fsc_color('dark green'); , PATTERN=parr

plots,agc_teff,agc_lstar,color=fsc_color('black'),psym=1
oploterror,agc_teff,agc_lstar,agc_logteff89err,agc_logl89err,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb

plots,hrc_teff,hrc_lstar,color=fsc_color('black'),psym=1
oploterror,hrc_teff,hrc_lstar,hrc_logteff09err,hrc_logl09err,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('black'),thick=tb

plots,pc_teff,pc_lstar,color=fsc_color('blue'),psym=4
oploterror,pc_teff,pc_lstar,pc_logteff09err,pc_logl09err,psym=2,color=fsc_color('blue'),ERRCOLOR=fsc_color('blue'),thick=tb

plots,hd168625_teff,hd168625_lstar,color=fsc_color('blue'),psym=4
oploterror,hd168625_teff,hd168625_lstar,hd168625_logteff09err,hd168625_logl09err,psym=2,color=fsc_color('blue'),ERRCOLOR=fsc_color('blue'),thick=tb

plots,w243_teff,w243_lstar,color=fsc_color('blue'),psym=4
oploterror,w243_teff,w243_lstar,w243_logteff09err,w243_logl09err,psym=2,color=fsc_color('blue'),ERRCOLOR=fsc_color('blue'),thick=tb

;plots,logt_clark1,logl_clark1,linestyle=2,thick=3.5,color=fsc_color('red')
;plots,logt_clark2,logl_clark2,linestyle=2,thick=3.5,color=fsc_color('red')
plots,xfit,yfit2,linestyle=2,thick=6.0,color=fsc_color('red')

xyouts,3.95,5.94,'HD limit',charthick=6.0,color=fsc_color('black'),charsize=2
plots,hd_temp1,hd_lum1,linestyle=2,thick=6.0,color=fsc_color('black')
plots,hd_temp2,hd_lum2,linestyle=2,thick=6.0,color=fsc_color('black')

;legengs with star names
xyouts,4.0,6.17,'AG Car',charthick=6.0,color=fsc_color('black'),charsize=2
xyouts,4.0,6.14,TEXTOIDL('v_{rot}/v_{crit} > 0.86'),charthick=6.0,color=fsc_color('black'),charsize=1.5
ARROW, 4.02, 6.173, 4.33, 6.173, /DATA,color=fsc_color('black'),thick=2.5

xyouts,4.2,5.70,'HR Car',charthick=6.0,color=fsc_color('black'),charsize=2
xyouts,4.2,5.66,TEXTOIDL('v_{rot}/v_{crit}=0.88\pm0.2'),charthick=6.0,color=fsc_color('black'),charsize=1.5


xyouts,4.18,5.44,'LBV minimum instability strip',charthick=6.0,color=fsc_color('red'),charsize=1.8
xyouts,4.09,5.39,TEXTOIDL('v_{rot}/v_{crit}\sim1'),charthick=6.0,color=fsc_color('red'),charsize=2
ARROW, 4.1, 5.4, 4.18, 5.4, /DATA,color=fsc_color('red'),thick=2.5


xpoly3 = [4.67,   4.67,4.40 ,4.40 ,  4.67]
ypoly3 = [5.91,5.782,5.782,5.91,5.91]
PolyFill, xpoly3, ypoly3, Color=fsc_color('white')
xyouts,4.66,5.86,TEXTOIDL('v_{rot}/v_{crit}>1'),charthick=6.0,color=fsc_color('dark green'),charsize=2
xyouts,4.66,5.81,TEXTOIDL('for LBVs'),charthick=6.0,color=fsc_color('dark green'),charsize=2

plots,xpoly3,ypoly3,thick=6.0

device,/close
set_plot,'x'

END