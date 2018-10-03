PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_COMPARE_MODELS_OPTICAL_FULL_MOD44_GROH
close,/all
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')


close,/all  
;defines ewdata for reading, as generated by CMF_FLUX (including header)
ewdata='/Users/jgroh/ze_models/etacar/mod43_groh/obscont/ewdata_fin_ed'  
openu,1,ewdata     ; open file without writing

linha=''

;finds the i number of points in ewdata
i=0.
while not eof(1) do begin
readf,1,linha
if linha eq '' then begin
goto,skip1
endif
i=i+1.
skip1:
endwhile
close,1


;declare arrays
lambdac=dblarr(i) & cont=lambdac & ew=lambdac & sob=strarr(i) & sobc=strarr(i)
lambdac1=0. & cont1=0. & ew1=0. & sob1='A2' 

;read lambda central, continuum intensity, EW and transition ID
ewdata_header=''
openu,1,ewdata
readf,1,ewdata_header
for k=0., i-2. do begin
readf,1,lambdac1,cont1,ew1,sob1
sob1=strsub(sob1,4,50)
lambdac[k]=lambdac1 & cont[k]=cont1 & ew[k]=ew1 & sob[k]=sob1
endfor
close,1


restore,'/Users/jgroh/espectros/etacar/etc_hst_stis_17apr01_1700_10400_norm.sav'

;filename_17apr01='/Users/jgroh/data/hst/stis/etacar_from_john/star_17apr01'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_17apr01,lambda_17apr01,flux_17apr01,mask_17apr01
;;
;;;normalize observations?
;line_norm,lambda_17apr01,flux_17apr01,flux_17apr01n,norm17apr01,xnodes17apr01,ynodes17apr01

;;normalize observations?
;line_norm,lambda_21feb99,flux_21feb99,flux_21feb99n,norm21feb99,xnodes21feb99,ynodes21feb99


;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod43_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod43_groh/obscont/obs_fin',lmfull,fmfulln,LMIN=1000., LMAX=20000.
ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod44_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lmfull,fmfulln,LMIN=1000., LMAX=20000.
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod47_groh/obs_opt/obs_fin','/Users/jgroh/ze_models/etacar/mod47_groh/obscont/obs_fin',lmfull,fmfulln,LMIN=1000., LMAX=20000.

;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod49_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod49_groh/obscont/obs_fin',lmfull,fmfulln,LMIN=1000., LMAX=20000.
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod50_groh/obs/obs_fin','/Users/jgroh/ze_models/etacar/mod50_groh/obscont/obs_fin',lmfull,fmfulln,LMIN=1000., LMAX=20000.
;ZE_CMFGEN_CREATE_OBSNORM,'/Users/jgroh/ze_models/etacar/mod51_groh/obs_opt/obs_fin','/Users/jgroh/ze_models/etacar/mod51_groh/obscont/obs_fin',lmfull,fmfulln,LMIN=1000., LMAX=20000.


;dir2='/Users/jgroh/ze_models/2D_models/etacar/mod45_groh/'
;model2='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
;sufix2='c' ;opening angle 50.4
;;sufix2='b' ;opening angle 54
;;sufix1='final_paper2' ;opening angle 54, falpha=4 (expected from adiabatic case)
;filename2='OBSFRAME1'
;ZE_BH05_CREATE_OBSNORM,filename2,dir2+model2+'/'+sufix2+'/','/Users/jgroh/ze_models/etacar/mod45_groh/obscont/obs_fin',lambdamodopt2,fluxmodopt2n
;ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir2,model2,sufix2,filename2,inc2,inc_str2

dir1='/Users/jgroh/ze_models/2D_models/etacar/mod44_groh/'
model1='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
sufix1='d' ;opening angle 54
filename1='OBSFRAME1'
ZE_BH05_CREATE_OBSNORM,filename1,dir1+model1+'/'+sufix1+'/','/Users/jgroh/ze_models/etacar/mod44_groh/obscont/obs_fin',lambdamodopt1,fluxmodopt1n
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir1,model1,sufix1,filename1,inc1,inc_str1

lambdaobsopt=lambda_17apr01
fluxobsopt=flux_17apr01n

;set plot range
;x1l=925. & x1u=1055.
x1l=3500. & x1u=4000.
x2l=4000. & x2u=4500.
x3l=4500. & x3u=5000.

;;only for producing fig for the proposal; comment out later!
;x1l=3500. & x1u=4000.
;x2l=6000. & x2u=7500.
;x3l=4500. & x3u=5000.


;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_obs_optical_full_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.48,/inches
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 1, 3, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')
a=4.0 ;line thick obs
b=3.5 ;line thick model
lm2=2
lm1=2
;coloro=fsc_color('black')
;colorm=fsc_color('red')
;colorm2=fsc_color('blue')
;colorm3=fsc_color('orange')
;x1l=6530
;x1u=6590

plot,lambdamodopt1,fluxmodopt1n,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0.1,10],/ylog,xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.08,0.77,0.97,0.99]
plots,lambdaobsopt,fluxobsopt,color=coloro,noclip=0,clip=[x1l,0,x1u,10],thick=a
plots,lmfull,fmfulln,color=colorm2,linestyle=lm2,noclip=0,clip=[x1l,0,x1u,10],thick=b+1.5
plots,lambdamodopt1,fluxmodopt1n,color=colorm1,linestyle=lm1,noclip=0,clip=[x1l,0,x1u,10],thick=b+3.5
xyouts,400,3000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
;xyouts,2700,7500,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+extra_label1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
;xyouts,2700,7000,model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+extra_label2 ,charthick=3.5,color=fsc_color('blue'),orientation=0,/DEVICE
;xyouts,2700,6500,model3+'_'+sufix3+'_'+filename3+'_i'+inc_str3+extra_label3 ,charthick=3.5,color=fsc_color('orange'),orientation=0,/DEVICE

plot,lambdamodopt1,fluxmodopt1n,xstyle=1,ystyle=1,xrange=[x2l-2,x2u+2],yrange=[0.1,12],/ylog,xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.08,0.45,0.97,0.67]
plots,lambdaobsopt,fluxobsopt,color=coloro,noclip=0,clip=[x2l,0,x2u,35],thick=a
plots,lmfull,fmfulln,color=colorm2,linestyle=lm2,noclip=0,clip=[x2l,0,x2u,35],thick=b+1.5
plots,lambdamodopt1,fluxmodopt1n,color=colorm1,linestyle=lm1,noclip=0,clip=[x2l,0,x2u,35],thick=b+3.5

plot,lambdamodopt1,fluxmodopt1n,xstyle=1,ystyle=1,xrange=[x3l-2,x3u+2],yrange=[0.1,28],/ylog,xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.08,0.13,0.97,0.35],xtitle=TEXTOIDL('Wavelength [ '+Angstrom+' ]')
plots,lambdaobsopt,fluxobsopt,color=coloro,noclip=0,clip=[x3l,0,x3u,35],thick=a
plots,lmfull,fmfulln,color=colorm2,linestyle=lm2,noclip=0,clip=[x3l,0,x3u,35],thick=b+1.5
plots,lambdamodopt1,fluxmodopt1n,color=colorm1,linestyle=lm1,noclip=0,clip=[x3l,0,x3u,35],thick=b+3.5

xyouts,1900,8200,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_obs_optical2_full_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
;!X.OMARGIN=[10,5]
!p.multi=[0, 1, 5, 0, 0]

;set plot range
;x1l=3680. & x1u=3900.
;x2l=3900. & x2u=4180.
;x3l=4300. & x3u=4500.
;x4l=1080. & x4u=1180.
x1l=3500. & x1u=4050.
x2l=4150. & x2u=4730.
x2bl=4375. & x2bu=4730.
x3l=4910. & x3u=5035.
x3cl=5029. & x3cu=5329.
x4l=5650. & x4u=5780.
x4bl=5850. & x4bu=5920.
x4cl=6100 & x4cu=6500.
x5bl=6535. & x5bu=6694.
x5dl=7045. & x5du=7080.
x5cl=8300.1 & x5cu=8850
x6al=9980. & x6au=10150
x6bl=10780. & x6bu=10980

coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')
a=4.0 ;line thick obs
b=3.5 ;line thick model
lm2=2
lm1=2

charsize=0.8 ; character size
charthick=3.5;character thickness

;1st panel, 

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.0,5.3],$
/nodata,charsize=1.5,XMARGIN=[3,0.5], YMARGIN=[2,0.5],yminor=2,yticklen=0.007,xticklen=0.05
plots,lambdaobsopt,fluxobsopt*1.0,color=coloro, thick=a,noclip=0
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,linestyle=0,thick=b
;plots,lambdacont,(0.55*fluxcontescd+0.0e-11),color=255, noclip=0,clip=[x1l,0,x1u,13],linestyle=2
for l=0., i-1. do begin
if (lambdac[l] gt x1l) and (lambdac[l] lt x1u) and (abs(ew[l]) gt 1.5) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HI') && (sobc[l] ne 'Fe2')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+2,4.1,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=0.8,charthick=3.5
endif
if (sobc[l] eq 'HI') then xyouts,lambdac[l]+2,4.1,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
if (sobc[l] eq 'FeII') then xyouts,lambdac[l]+2,4.1,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do H I
endif
endfor

;2nd panel a Hdelta

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[4080,4130],yrange=[-0.5,7.5],/nodata,$
charsize=1.5,XMARGIN=[3,110], YMARGIN=[3,0],xtickinterval=20.,yticklen=0.05,xticklen=0.05
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a, noclip=0
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,linestyle=0,thick=b
;plots,lambdamodopt2,fluxmodopt2n,color=colorm3, noclip=0,linestyle=0,thick=b
xyouts,4090,6.0,TEXTOIDL('H\delta'),alignment=0.0,orientation=00,charsize=charsize,charthick=charthick
;xyouts,4090.5,6.0,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick
!p.multi[0]=!p.multi[2]-1


;2nd panel b 

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,3.2],/nodata,charsize=1.5,XMARGIN=[22,0.5], YMARGIN=[3,0.0],YTICKFORMAT='(I1)',ytickinterval=1,yminor=5,yticklen=0.007,xticklen=0.07
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a,noclip=0
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,linestyle=0,thick=b
for l=0., i-1. do begin
if (lambdac[l] gt x2l) and (lambdac[l] lt x2u) and (abs(ew[l]) gt 1.0) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HI') && (sobc[l] ne 'FeII')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+2,2.4,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=charsize,charthick=charthick
endif
if (sobc[l] eq 'HI') then xyouts,lambdac[l]+2,2.4,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
if (sobc[l] eq 'FeII') then xyouts,lambdac[l]+2,2.6,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do H I
endif
endfor
;xyouts,4347,2.4,TEXTOIDL('H\gamma'),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
;xyouts,4344.5,2.0,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick
;!p.multi[0]=!p.multi[2]-1

;;2nd panelb
;plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x2bl,x2bu],yrange=[0.0,3.0],/nodata,charsize=1.5,XMARGIN=[63,0.5], YMARGIN=[3,0.5]
;plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a,noclip=0,clip=[x2bl,0,x2bu,7]
;plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
;plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,clip=[x2bl,0,x2bu,7],linestyle=0,thick=b
;for l=0., i-1. do begin
;if (lambdac[l] gt x2bl) and (lambdac[l] lt x2bu) and (abs(ew[l]) gt 0.30) then begin
;pos=strpos(strtrim(sob[l],1),'(')
;sobc[l]=strmid(sob[l],4,pos)
;if ((sobc[l] ne 'FeV') && (sobc[l] ne 'FeVI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
;xyouts,lambdac[l]+1,2.0,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=charsize,charthick=charthick
;endif
;endif
;endfor
;xyouts,4719,2.0,TEXTOIDL('HeI'),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
;xyouts,4716.5,1.8,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick


;3rd panel a

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[4845,4879],yrange=[0,22],/nodata,$
charsize=1.5,XMARGIN=[3,110], YMARGIN=[3,0],xtickinterval=10.,yticklen=0.05,xticklen=0.05
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a, noclip=0
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,linestyle=0,thick=b
xyouts,4850,17.0,TEXTOIDL('H\beta'),alignment=0.0,orientation=0,charsize=charsize,charthick=charthick
;xyouts,4863.5,9.0,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick
!p.multi[0]=!p.multi[2]-2
;3rd panel b

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x3l,x3u],yrange=[0,5.6],/nodata,charsize=1.5,XMARGIN=[22,80], YMARGIN=[3,0],xticks=5,yticklen=0.03,xticklen=0.05,yminor=5,xminor=5
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a, noclip=0,clip=[x3l,0,x3u,12]
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,clip=[x3l,0,x3u,12],linestyle=0,thick=b
for l=0., i-1. do begin
if (lambdac[l] gt x3l) and (lambdac[l] lt x3u) and (abs(ew[l]) gt 1.0) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HI') && (sobc[l] ne 'FeII')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+2,4.5,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=charsize,charthick=charthick
endif
if (sobc[l] eq 'HI') then xyouts,lambdac[l]+2,4.1,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
if (sobc[l] eq 'FeII') then xyouts,lambdac[l]+2,4.1,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do H I
endif
endfor
!p.multi[0]=!p.multi[2]-2

;3rd panel c

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x3cl,x3cu],yrange=[0.3,4.6],/nodata,charsize=1.5,XMARGIN=[53,0.5], YMARGIN=[3,0],xticklen=0.05,yminor=5,xminor=5
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a, noclip=0,clip=[x3cl,0.3,x3cu,12]
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n*1.00,color=colorm1, noclip=0,clip=[x3cl,0.3,x3cu,12],linestyle=0,thick=b
for l=0., i-1. do begin
if (lambdac[l] gt x3cl) and (lambdac[l] lt x3cu) and (abs(ew[l]) gt 1.0) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HI') && (sobc[l] ne 'FeII')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+2,3,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=charsize,charthick=charthick
endif
if (sobc[l] eq 'HI') then xyouts,lambdac[l]+2,3.6,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
if (sobc[l] eq 'FeII') then xyouts,lambdac[l]+2,3.6,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do H I
endif
endfor


;4th panel a

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x4l,x4u],yrange=[0.5,2.3],$
/nodata,charsize=1.5,XMARGIN=[3.5,101.5], YMARGIN=[3,0],xtickinterval=30.,yminor=5,xminor=5,yticklen=0.03,xticklen=0.05
plots,lambdaobsopt,fluxobsopt*1.00,color=coloro, thick=a,noclip=0,clip=[x4l,0.5,x4u,7]
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n*1.00,color=colorm1, noclip=0,clip=[x4l,0.5,x4u,7],linestyle=0,thick=b
for l=0., i-1. do begin
if (lambdac[l] gt x4l) and (lambdac[l] lt x4u) and (abs(ew[l]) gt 1.0) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HI') && (sobc[l] ne 'FeII')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+2,1.9,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=charsize,charthick=charthick
endif
if (sobc[l] eq 'HI') then xyouts,lambdac[l]+2,1.8,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
if (sobc[l] eq 'FeII') then xyouts,lambdac[l]+2,1.8,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do H I
endif
endfor
!p.multi[0]=!p.multi[2]-3

;4th panelb

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x4bl,x4bu],yrange=[0.0,4.0],/nodata,charsize=1.5,XMARGIN=[30,84], YMARGIN=[3,0],xticks=2,yminor=3,yticklen=0.05,xticklen=0.05,xminor=5
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a,noclip=0
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n*1.00,color=colorm1, noclip=0,linestyle=0,thick=b
xyouts,5883,3.1,TEXTOIDL('HeI'),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
xyouts,5881,2.6,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick
xyouts,5897,3.1,TEXTOIDL('NaI'),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
xyouts,5897,2.6,'!3'+string(45B),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
!p.multi[0]=!p.multi[2]-3

;4th panel c

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x4cl,x4cu],yrange=[0.5,1.9],/nodata,charsize=1.5,XMARGIN=[50,0.5], YMARGIN=[3,0],yticklen=0.014,xticklen=0.05,xminor=10
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a,noclip=0,clip=[x4cl,0.8,x4cu,7]
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n*1.0,color=colorm1, noclip=0,clip=[x4cl,0.8,x4cu,7],linestyle=0,thick=b
for l=0., i-1. do begin
if (lambdac[l] gt x4cl) and (lambdac[l] lt x4cu) and (abs(ew[l]) gt 1.0) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HI') && (sobc[l] ne 'FeII')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+2,1.6,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=charsize,charthick=charthick
endif
if (sobc[l] eq 'HI') then xyouts,lambdac[l]+2,1.6,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
if (sobc[l] eq 'FeII') then xyouts,lambdac[l]+2,1.6,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco laranja nas transicoes do Fe II
endif
endfor


;5th panel a
;restore,'/Users/jgroh/temp/etc_stis_halpha_obs_apastron_norm.sav',/verbose
plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[6540,6585],yrange=[0,80],$
/nodata,charsize=1.5,XMARGIN=[3,115], YMARGIN=[3,0],xtickinterval=20.,yticklen=0.01,xticklen=0.05
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a, noclip=0
;plots,LAMBDA_20MAR00,FLUX_20MAR00n,color=coloro, thick=a, noclip=0
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,linestyle=0,thick=b
;plots,lambdamodopt2,fluxmodopt2n,color=colorm3, noclip=0,linestyle=0,thick=b
xyouts,6545,60.0,TEXTOIDL('H\alpha'),alignment=0.0,orientation=00,charsize=charsize,charthick=charthick
;xyouts,6566,35.5,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick
!p.multi[0]=!p.multi[2]-4

;5th panel b

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x5bl,x5bu],yrange=[0.0,8.5],$
/nodata,charsize=1.5,XMARGIN=[17,84], YMARGIN=[3,0],yticklen=0.03,xticklen=0.05
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a,noclip=0
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,linestyle=0,thick=b
xyouts,6685,3.6,TEXTOIDL('HeI'),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
xyouts,6683,2.5,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick
!p.multi[0]=!p.multi[2]-4

;5th panel d (has to be before c)
;
;plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x5dl,x5du],yrange=[0.5,7.0],xtickinterval=15.,/nodata,charsize=1.5,XMARGIN=[32,83], YMARGIN=[3,0],xticks=3
;plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a,noclip=0,clip=[x5dl,0.5,x5du,7]
;plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
;plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,clip=[x5dl,0.5,x5du,7],linestyle=0,thick=b
;xyouts,7073,4.0,TEXTOIDL('HeI'),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
;xyouts,7071,3.5,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick
;!p.multi[0]=!p.multi[2]-4


;5th panel c

plot,lambdaobsopt,fluxobsopt,xstyle=1,ystyle=1,xrange=[x5cl,x5cu],yrange=[0.5,2.6],/nodata,charsize=1.5,XMARGIN=[50,0.5], YMARGIN=[3,0],yticklen=0.014,xticklen=0.05,xminor=10
plots,lambdaobsopt,fluxobsopt,color=coloro, thick=a,noclip=0,clip=[x5cl,0.5,x5cu,7]
plots,lmfull,fmfulln,color=colorm2, thick=a,noclip=0,linestyle=lm2
plots,lambdamodopt1,fluxmodopt1n,color=colorm1, noclip=0,clip=[x5cl,0.5,x5cu,7],linestyle=0,thick=b
for l=0., i-1. do begin
if (lambdac[l] gt x5cl) and (lambdac[l] lt x5cu) and (abs(ew[l]) gt 1.0) then begin
pos=strpos(strtrim(sob[l],1),'(')
sobc[l]=strmid(sob[l],4,pos)
if ((sobc[l] ne 'HI') && (sobc[l] ne 'FeII')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,lambdac[l]+2,2.2,'!3'+string(45B)+sobc[l],alignment=0.5,orientation=90,charsize=charsize,charthick=charthick
endif
if (sobc[l] eq 'HI') then xyouts,lambdac[l]+2,2.2,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
if (sobc[l] eq 'FeII') then xyouts,lambdac[l]+2,2.2,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do H I
endif
endfor
xyouts,8458,2.2,TEXTOIDL('OI'),alignment=0.0,orientation=90,charsize=charsize,charthick=charthick
xyouts,8453,2.0,'!3'+string(45B),alignment=0.0,orientation=60,charsize=charsize,charthick=charthick

;puttnig axel lalbes
xyouts,0.45,0.02,TEXTOIDL('Wavelength [ '+Angstrom+' ]'),charthick=4.0,orientation=0,/NORMAL
;xyouts,400,2000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE


!p.multi=[0, 0, 0, 0, 0]
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
;save,/variables,FILENAME='/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.sav'
END
