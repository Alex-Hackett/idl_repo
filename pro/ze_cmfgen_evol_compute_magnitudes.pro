PRO ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES,dirmod,model,band,mstar,lstar,tstar,absolute_mag,Mbol,BC,marcs=marcs  
;assumes model names are in the standard conversion modelPXXXzYYSZ_Tmmmmmm_Liiiiii_loggz.zzz
;read passband from Chorizos (Maiz-Appelaniz)

;works only for the V band SOMETHING WRONG WITH THE OTHER BANDS, USE V2

;Marcs models not working correctly

;0.055 31 0.034 32 0.026 33 0.030 34 0.017

CASE band of

'U': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_u.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.770   ;from Bessel et al. 1998, table A2
zp=0.055   ;form Maiz-Appelaniz Chorizos
END

'B': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_b.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=-0.120   ;from Bessel et al. 1998, table A2
zp=0.034   ;form Maiz-Appelaniz Chorizos
END

'V': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_v.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.0   ;from Bessel et al. 1998, table A2
zp=0.026   ;form Maiz-Appelaniz Chorizos
END

'R': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_r.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.186   ;from Bessel et al. 1998, table A2
zp=0.030   ;form Maiz-Appelaniz Chorizos
END

'I': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_i.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.440   ;from Bessel et al. 1998, table A2
zp=0.017   ;form Maiz-Appelaniz Chorizos
END

ENDCASE

;computing V magnitudes
;V=-2.5 * log [Integral(Flambda*Rlambda*dlambda)/Integral(Rlambda*dlambda)]-21.1  from Bessel et al. 1998 MNRAS
;generalizing 
;mag_lambda = -2.5 log (f_lambda) - 21.100 - zp(f_lambda) ; zp (flambda)


IF KEYWORD_SET(MARCS) THEN BEGIN
    READCOL,'/Users/jgroh/marcs_models/flx_wavelengths.vac',lambdamod
    READCOL,'/Users/jgroh/marcs_models/'+model+'.flx',fluxmod
ENDIF ELSE BEGIN
    ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',lambdamod,fluxmod,num_rec2,/flam
ENDELSE
linterp,lambdamod,fluxmod,lambda,fluxmod_interp
fluxmod_interp_times_passband=fluxmod_interp*pass
fluxmod_total_band=int_tabulated(lambda,fluxmod_interp_times_passband)

apparent_mag=-2.5*alog10(fluxmod_total_band/passband) - 21.1 - zp ;using bessel
apparent_mag=-2.5*alog10(fluxmod_total_band/passband) - 21.1 + zp ;using maiz appelaniz

print,'model=',model
print,'m_'+band+'=',apparent_mag


;computing mabsv for a given distance and redenning parametesr
;IF KEYWORD_SET(MARCS) THEN 
d=1.0 ;in kpc, CMFGEN output is always normalized to 1 kpc


absolute_mag=apparent_mag-5.*alog10(d/0.01)

print,'M_'+band+'=',absolute_mag

;computing mbol for a given L
;lstar= 856258.0;in Lsun
mstar_str=strmid(model,1,3)
mstar=float(mstar_str)
print,'Mstar=',Mstar

tstar_str=strmid(strmid(model,0,strpos(model,'_L')),strpos(model,'_T')+2)
tstar=float(tstar_str)
print,'Tstar=',tstar

lstar_str=strmid(strmid(model,0,strpos(model,'_logg')),strpos(model,'_L')+2)
lstar=float(lstar_str)
print,'Lstar=',lstar

mbol=4.75 -2.5*alog10(lstar)
print,'Mbol=',mbol

;computing bc for a given absolute_mag and Mbol => attention output will be dependent on band used! (i.e., BC_B, BC_V, etc).
bc=mbol-absolute_mag
print,'BC_'+band+'=',bc
!P.Background = fsc_color('white')
END