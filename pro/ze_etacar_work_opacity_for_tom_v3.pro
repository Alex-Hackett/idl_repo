;PRO ZE_ETACAR_WORK_OPACITY_FOR_TOM_V3
;V2 uses only two files (fileop_all and filechi_all) and has a lot of stuff cleaned up
;V3 do the opac and srce functino fit for all bands

AU_TO_CM=1.496e+13
CM_TO_AU=1./1.496e+13

;primary, Mdot=1e-03 Msun/yr
fileclump='/Users/jgroh/temp/etc_john_mod111_clump_r.txt'
fileden='/Users/jgroh/temp/etc_john_mod111_yden_r.txt'
fileop_all='/Users/jgroh/temp/etacar_john_mod111_chi_op_au_43_54_64_80_125_164_216_354.txt'          ;in cm-1
fileeta_all='/Users/jgroh/temp/etacar_john_mod111_eta_emiss_au_43_54_64_80_125_164_216_354.txt'      ;in erg/s/cm3/Hz
nd=65

;companion, Mdot=1e-05 Msun/yr
;fileclump='/Users/jgroh/etacar_companion_r5_clump_au.txt'
;fileden='/Users/jgroh/etacar_companion_r5_yden_au.txt'
;fileop_all='/Users/jgroh/etacar_companion_r5_chi_op_au_43_54_64_80_125_164_216_354.txt'          ;in cm-1
;fileeta_all='/Users/jgroh/etacar_companion_r5_eta_emiss_43_54_64_80_125_164_216_354.txt'      ;in erg/s/cm3/Hz
;nd=60.

;wavelengths vector:
wavelength=[4360.,5448.,6400.,8000.,12500.,16400.,21600.,35400.]
indices=   [0     , 1   , 2   , 3   ,4    , 5    , 6    , 7    ]
wavelength_ind=0
wavelength_str=strcompress(string(wavelength[wavelength_ind], format='(I05)'))
ZE_READ_SPECTRA_COL_VEC,fileden,dist,yden,nrec
ZE_READ_SPECTRA_COL_VEC,fileclump,dist3,clump,nrec

chi_op=read_ascii(fileop_all) ;does not include clumping factor
eta_emiss=read_Ascii(fileeta_all) ;does not include clumping factor

k_op_cm2_g=chi_op
FOR I=0,14,2 DO BEGIN
k_op_cm2_g.field01[i+1,*]=10^(chi_op.field01[i+1,*])/(10^(yden)*clump) ;corrects opacity due to clumping; 20/04/2010 OK doublechecked with DISPGEN KAPPA task, same result
ENDFOR

file='/Users/jgroh/temp/etacar_mod111_john_op_cm2_g_bvrijhkl_to_tom.asc'
close,1
openw,1,file     ; open file to write

for k=0, nd-1 do begin
printf,1,FORMAT='(F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6,3x,F12.6)',k_op_cm2_g.field01[0,k],k_op_cm2_g.field01[1,k],k_op_cm2_g.field01[3,k],k_op_cm2_g.field01[5,k],k_op_cm2_g.field01[7,k],k_op_cm2_g.field01[9,k],$
                                    k_op_cm2_g.field01[11,k],k_op_cm2_g.field01[13,k],k_op_cm2_g.field01[15,k]
endfor
close,1

!P.Background = fsc_color('white')
temp=size(chi_op.field01)
nd=temp[2]
nlambda=temp[1]/2
srce=dblarr(nlambda,nd)
kappa_cm2_g=dblarr(nlambda,nd) ;reshuffle the values to array form , results are identical to using k_op_cm2_g but that's a structure

j=0
FOR I=0,nlambda -1  DO BEGIN
srce[i,*]=eta_emiss.field01[j+1,*]-chi_op.field01[j+1,*] ;compute source function; note that srce does not need to be corrected by clumping since eta_emiss and chi_op both do not take into account clumping, and both have the same f dependence
kappa_cm2_g[i,*]=alog10(10^(chi_op.field01[j+1,*])/(10^(yden)*clump)) ;OK working, doublechecked 20 04 2010
j=j+2
ENDFOR

dist_au=REFORM(eta_emiss.field01[0,*])
dist_cm=dist_au*AU_TO_CM


;radius index for fitting
a=0 ;max
b=30 ;min 

fit_srce=dblarr(nlambda,2) & yfit_srce=dblarr(nlambda,(b-a)+1) & sigma_srce=fit_Srce
chisq_srce=dblarr(nlambda) & prob_srce=dblarr(nlambda)

;automatically fitting of linear log-log functions to the source function
FOR I=0,nlambda -1  DO BEGIN
 fit_srce_temp=linfit(alog10(dist_cm[a:b]), srce[i,a:b], chisq = chisq_srce_temp, prob = prob_srce_temp ,yfit=yfit_Srce_temp, sigma=sigma_srce_temp)
 fit_srce[i,*]=fit_srce_temp
 yfit_srce[i,*]=yfit_srce_temp
 sigma_srce[i,*]=sigma_srce_temp
 chisq_srce[i]=chisq_srce_temp
 prob_srce[i]=prob_srce_temp
END
a=0
b=40

Result = POLY_FIT(alog10(dist_cm[a:b]),REFORM(kappa_cm2_g[wavelength_ind,a:b]), 1,yfit=yfit_kappa)
result3= linfit(alog10(dist_cm[a:b]), kappa_cm2_g[wavelength_ind,a:b], chisq = chisq_srce_temp, prob = prob_srce_temp ,yfit=yfit_Srce_temp, sigma=sigma_srce_temp)
;lineplot,alog10(dist_cm[a:b]), REFORM(srce[0,a:b])
;lineplot,alog10(dist_cm[a:b]), REFORM(yfit_srce[0,*])
a=0.
b=64.
;lineplot,alog10(dist_cm[a:b]),REFORM(kappa_cm2_g[6,a:b])

;reversing vectors due to problems with the fit later (20 04 2010 16:36) 
dist_cm=REVERSE(dist_cm)
kappa_cm2_g=REVERSE(kappa_cm2_g,2)
srce=REVERSE(srce,2)

;lineplot,dist_au[a:b],REFORM(10^kappa_cm2_g[6,a:b])
;lineplot,REFORM(10^kappa_cm2_g[6,a:b])

;result3= linfit(alog10(dist_cm[a:b]), kappa_cm2_g[6,a:b], chisq = chisq_srce_temp, prob = prob_srce_temp ,yfit=yfit_Srce_temp, sigma=sigma_srce_temp)

dist_rev=REVERSE(dist_cm[a:b])
rec=dist_rev
FOR I=0, (b-a) DO rec=result[0]+result[1]*alog10(dist_rev)
Result2 = POLY_FIT(alog10(dist_rev),rec, 1,yfit=yfit_kappa)
;lineplot,alog10(dist_cm[a:b]),REFORM(kappa_cm2_g[6,a:b])
;lineplot,alog10(dist_cm[a:b]),yfit_kappa

;fitting opacity

;lineplot,dist_cm[a:b],REFORM(10^kappa_cm2_g[6,a:b])
;lineplot,dist_cm[a:b],10^yfit_kappa
 xnodes=[ 12.7960 ,     13.0769  ,    13.7710    ,  14.4926    ,  15.1646 ,     15.7871    ,  16.3104    ,  16.8832] ;original
 ynodes=xnodes
line_norm,alog10(dist_cm[a:b]),REFORM(kappa_cm2_g[wavelength_ind,a:b]),ynorm,norm,xnodes,ynodes
 xnodes=[12.62, 12.66 ,     13.0769  ,    13.7710    ,  14.4926    ,  15.1646 ,     15.7871    ,  16.3104    ,  16.8832]
near_vec=xnodes
index_vec=xnodes
nxnodes=n_elements(xnodes)
FOR i=0, n_elements(xnodes) -1 DO BEGIN
near = Min(Abs(alog10(dist_cm) - xnodes[i]), index)
near_vec[i] = near
index_vec[i]=index
ENDFOR

;fits a cubic function in each interval
norder=3
ninterval=n_elements(xnodes) - 1
;ninterval=2
result_vec=dblarr(norder+1,ninterval)
;yfit_kappa_vec=dblarr(ninterval,)
yfit_Vec=0.
FOR i=0, ninterval-1 DO BEGIN
;print,i,index_vec[i],index_vec[i+1]-1
Result_fit_interval = SVDFIT(alog10(dist_cm[index_vec[i]:index_vec[i+1]-1]),REFORM(kappa_cm2_g[wavelength_ind,index_vec[i]:index_vec[i+1]-1]), norder+1,yfit=yfit_kappa_interval)
result_vec[*,i]=result_fit_interval
;print,yfit_kappa_interval,REFORM(kappa_cm2_g[wavelength_ind,index_vec[i]:index_vec[i+1]-1])
IF I EQ 0 THEN yfit_vec=[yfit_kappa_interval] ELSE yfit_vec=[yfit_vec,yfit_kappa_interval]
;print,yfit_vec
ENDFOR

;reconstruct fit vector from coefficients to test if the procedure is working
log_kappa_cm2_g_rec_from_fit=dblarr(n_elements(dist_cm[a:b]))
FOR I=0, n_elements(dist_cm[a:b]) -1 DO BEGIN

 IF  (alog10(dist_cm[a+i]) GE xnodes[0]) AND (alog10(dist_cm[a+i]) LT xnodes[1]) THEN BEGIN  
  log_kappa_cm2_g_rec_from_fit[i]= result_vec[0,0]+result_vec[1,0]*alog10(dist_cm[a+i])+result_vec[2,0]*alog10(dist_cm[a+i])^2+result_vec[3,0]*alog10(dist_cm[a+i])^3
 ENDIF ELSE BEGIN
  IF  (alog10(dist_cm[a+i]) GE xnodes[1]) AND (alog10(dist_cm[a+i]) LT xnodes[2]) THEN BEGIN  
   log_kappa_cm2_g_rec_from_fit[i]= result_vec[0,1]+result_vec[1,1]*alog10(dist_cm[a+i])+result_vec[2,1]*alog10(dist_cm[a+i])^2+result_vec[3,1]*alog10(dist_cm[a+i])^3
  ENDIF ELSE BEGIN
   IF  (alog10(dist_cm[a+i]) GE xnodes[2]) AND (alog10(dist_cm[a+i]) LT xnodes[3]) THEN BEGIN  
    log_kappa_cm2_g_rec_from_fit[i]= result_vec[0,2]+result_vec[1,2]*alog10(dist_cm[a+i])+result_vec[2,2]*alog10(dist_cm[a+i])^2+result_vec[3,2]*alog10(dist_cm[a+i])^3
   ENDIF ELSE BEGIN
    IF  (alog10(dist_cm[a+i]) GE xnodes[3]) AND (alog10(dist_cm[a+i]) LT xnodes[4]) THEN BEGIN  
     log_kappa_cm2_g_rec_from_fit[i]= result_vec[0,3]+result_vec[1,3]*alog10(dist_cm[a+i])+result_vec[2,3]*alog10(dist_cm[a+i])^2+result_vec[3,3]*alog10(dist_cm[a+i])^3
    ENDIF ELSE BEGIN  
     IF  (alog10(dist_cm[a+i]) GE xnodes[4]) AND (alog10(dist_cm[a+i]) LT xnodes[5]) THEN BEGIN  
      log_kappa_cm2_g_rec_from_fit[i]= result_vec[0,4]+result_vec[1,4]*alog10(dist_cm[a+i])+result_vec[2,4]*alog10(dist_cm[a+i])^2+result_vec[3,4]*alog10(dist_cm[a+i])^3
     ENDIF ELSE BEGIN     
      IF  (alog10(dist_cm[a+i]) GE xnodes[5]) AND (alog10(dist_cm[a+i]) LT xnodes[6]) THEN BEGIN  
       log_kappa_cm2_g_rec_from_fit[i]= result_vec[0,5]+result_vec[1,5]*alog10(dist_cm[a+i])+result_vec[2,5]*alog10(dist_cm[a+i])^2+result_vec[3,5]*alog10(dist_cm[a+i])^3
      ENDIF ELSE BEGIN          
       IF  (alog10(dist_cm[a+i]) GE xnodes[6])  THEN BEGIN  
        log_kappa_cm2_g_rec_from_fit[i]= result_vec[0,6]+result_vec[1,6]*alog10(dist_cm[a+i])+result_vec[2,6]*alog10(dist_cm[a+i])^2+result_vec[3,6]*alog10(dist_cm[a+i])^3
        ENDIF          
      ENDELSE
     ENDELSE
    ENDELSE
   ENDELSE 
  ENDELSE
 ENDELSE
 ENDFOR

xwindowsize=900.*1  ;window size in x
ywindowsize=460.*1  ; window size in y

set_plot,'ps'
!X.THICK=15
!Y.THICK=15
!P.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=8
device,filename='/Users/jgroh/temp/etc_mod111_john_fit_opacity_k_cm2_g_distance_cm_'+wavelength_str+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,dist_cm[a:b],REFORM(10^kappa_cm2_g[wavelength_ind,a:b]),xrange=[min(dist_cm[a:b])*0.80, max(dist_cm[a:b])*1.13],/ylog,/xlog,XTITLE='Distance from primary star (cm)', YTITLE=TEXTOIDL('Opacity \kappa (cm^2/g) at \lambda=') + wavelength_str,$
/nodata,xstyle=1,ystyle=1,Position=[0.12, 0.13, 0.98, 0.96]
plots,dist_cm[a:b],REFORM(10^kappa_cm2_g[wavelength_ind,a:b]),noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,dist_cm[index_vec[0]:index_vec[nxnodes-1]-1],10^yfit_vec,noclip=0,color=FSC_COLOR('red'),psym=1,symsize=2
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
!P.Color = fsc_color('black')

;lineplot,dist_cm[a:b],REFORM(10^kappa_cm2_g[wavelength_ind,a:b])
;lineplot,dist_cm[index_vec[0]:index_vec[nxnodes-1]-1],10^yfit_vec

;create latex file for opacity
print,'Fit of the opacity at lambda='+wavelength_str
FOR I=0, ninterval -1 DO BEGIN
print,xnodes[i],' & ', xnodes[i+1], ' & ', result_vec[0,i], ' & ', result_vec[1,i], ' & ', result_vec[2,i], ' & ', result_vec[3,i],  '\\'
ENDFOR

;fitting source function
  xnodes=[12.6199,      12.6577,      12.8114,      12.9434,      13.2699,      15.0882 ,     15.9498   ,   16.9184] ;original
; ynodes=xnodes
line_norm,alog10(dist_cm[a:b]),REFORM(srce[6,a:b]),ynorm,norm,xnodes,ynodes
 xnodes=[12.6199,      12.6577,      12.8114,      12.9434,      13.2699,      15.0882 ,     15.9498   ,   16.9184]
near_vec=xnodes
index_vec=xnodes
nxnodes=n_elements(xnodes)
FOR i=0, n_elements(xnodes) -1 DO BEGIN
near = Min(Abs(alog10(dist_cm) - xnodes[i]), index)
near_vec[i] = near
index_vec[i]=index
ENDFOR

;fits a cubic function in each interval
norder=3
ninterval=n_elements(xnodes) - 1
;ninterval=2
result_vec=dblarr(norder+1,ninterval)
;yfit_kappa_vec=dblarr(ninterval,)
yfit_Vec=0.
FOR i=0, ninterval-1 DO BEGIN
;print,i,index_vec[i],index_vec[i+1]-1
Result_fit_interval = SVDFIT(alog10(dist_cm[index_vec[i]:index_vec[i+1]-1]),REFORM(srce[wavelength_ind,index_vec[i]:index_vec[i+1]-1]), norder+1,yfit=yfit_srce_interval)
result_vec[*,i]=result_fit_interval
;print,yfit_srce_interval,REFORM(srce[wavelength_ind,index_vec[i]:index_vec[i+1]-1])
IF I EQ 0 THEN yfit_vec=[yfit_srce_interval] ELSE yfit_vec=[yfit_vec,yfit_srce_interval]
;print,yfit_vec
ENDFOR

xwindowsize=900.*1  ;window size in x
ywindowsize=460.*1  ; window size in y

set_plot,'ps'
!X.THICK=15
!Y.THICK=15
!P.THICK=6
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=8
device,filename='/Users/jgroh/temp/etc_mod111_john_fit_srce_function_erg_s_cm2_Hz_distance_cm_'+wavelength_str+'.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,dist_cm[a:b],REFORM(10^srce[wavelength_ind,a:b]),xrange=[min(dist_cm[a:b])*0.80, max(dist_cm[a:b])*1.13],/ylog,/xlog,XTITLE='Distance from primary star (cm)', YTITLE=TEXTOIDL('Source function S (erg/s/cm^2/Hz) at \lambda=') + wavelength_str,$
/nodata,xstyle=1,ystyle=1,Position=[0.12, 0.13, 0.98, 0.96]
plots,dist_cm[a:b],REFORM(10^srce[wavelength_ind,a:b]),noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,dist_cm[index_vec[0]:index_vec[nxnodes-1]-1],10^yfit_vec,noclip=0,color=FSC_COLOR('red'),psym=1,symsize=2
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
!P.Color = fsc_color('black')

;lineplot,dist_cm[a:b],REFORM(10^srce[wavelength_ind,a:b])
;lineplot,dist_cm[index_vec[0]:index_vec[nxnodes-1]-1],10^yfit_vec

;create latex file for source function
print,'Fit of the source function at lambda='+wavelength_str
FOR I=0, ninterval -1 DO BEGIN
print,xnodes[i],' & ', xnodes[i+1], ' & ', result_vec[0,i], ' & ', result_vec[1,i], ' & ', result_vec[2,i], ' & ', result_vec[3,i],  '\\'
ENDFOR

;FOR I=0, nlambda -1 DO PRINT,fit_srce[i,0],fit_srce[i,1]

END