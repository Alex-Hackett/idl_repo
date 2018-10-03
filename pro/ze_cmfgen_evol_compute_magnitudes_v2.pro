PRO ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model,band,mstar,lstar,tstar,absolute_mag,Mbol,BC,lambdamod,fluxmod,$
  marcshr=marcshr,marcsweb=marcsweb,ebv=ebv,rv=rv,dm=dm,norm_factor=norm_factor,plot=plot,reload=reload,redshift=redshift,lambdain=lambdain,fluxin=fluxin,dist=dist,apparent_mag=apparent_mag
;assumes model names are in the standard conversion modelPXXXzYYSZ_Tmmmmmm_Liiiiii_logg4.322
;read passband from Chorizos (Maiz-Appelaniz)
;v2 computes using vega specrum as reference, as in Chorizos handbook
;works: has been cross tested againts the O star models from Martins et al. 2006

;Marcs models work OK, finally! THEY HAVE BEEN CROSS CALIBRATED AGAINST THE RESULTS FROM Van Dyk + 2011, AJ 143, 19, FOR THE MODEL Teff=3600, log g=0.0, vt=2km/s
;norm_factor is the factor to multiply the luminosity (i.e. flux)

rsuntokpc=1D0/(214.939469384*206264.81*1000.0)

IF n_elements(norm_factor) LT 1 THEN norm_factor=1d0
print,'normalization factor for flux= ',norm_factor
CASE band of

'U': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_u.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.055   ;form Maiz-Appelaniz Chorizos
END

'B': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_b.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.034   ;form Maiz-Appelaniz Chorizos
END

'V': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_v.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.026   ;form Maiz-Appelaniz Chorizos
END

'R': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_r.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.030   ;form Maiz-Appelaniz Chorizos
END

'I': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='bessell_i.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.017   ;form Maiz-Appelaniz Chorizos
END

'J': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='2mass_j.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=-0.021   ;form Maiz-Appelaniz Chorizos
END

'H': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='2mass_h.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.009   ;form Maiz-Appelaniz Chorizos
END

'Ks': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='2mass_ks.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F170W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f170w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END


'WFPC2_F300W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f300w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END


'WFPC2_F336W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f336w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F450W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f450w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F555W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f555w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F606W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f606w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'WFPC2_F814W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='wfpc2_f814w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'ACS_WFCF435W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='acswfc_f435w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'ACS_WFCF555W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='acswfc_f555w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'ACS_WFCF814W': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='acswfc_f814w.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'sdss_r': BEGIN

dir='/Users/jgroh/IDLWorkspace/Default/pro/chorizos/throughputs/'
passfile='sdss_r.dat'
readcol,dir+passfile,lambda,pass,/SILENT
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END

'ptf_r': BEGIN

dir='/Users/jgroh/Documents/'
passfile='ptf_r_transmission_ofek.txt' ;From Ofek 2012 PASP
readcol,dir+passfile,lambda,filter,QEstd, QEhr,  Atm, Sysstd,  Syshr,/SILENT ;
;assumes stardard CCD airmass 1.3 filter response
pass=Sysstd
passband=int_tabulated(lambda,pass) ; for V band from Appelaniz
zp=0.000   ;form Maiz-Appelaniz Chorizos
END



ENDCASE


IF KEYWORD_SET(MARCSWEB) THEN BEGIN
     dirmod='/Users/jgroh/marcs_models/MARCS_website/' 
     savedfile_lam='/Users/jgroh/temp/marcs_flx_wavelengths_vac.sav'
      IF (FILE_EXIST(savedfile_lam) eq 0) OR KEYWORD_SET(RELOAD) THEN BEGIN 
          READCOL,dirmod+'flx_wavelengths.vac',lambdamod
          save,lambdamod,filename=savedfile_lam
      ENDIF ELSE restore,savedfile_lam             
    ; model='s3600_g+0.0_m15._t05_st_z+0.00_a+0.00_c+0.00_n+0.00_o+0.00_r+0.00_s+0.00'
     savedfile_flx='/Users/jgroh/temp/'+model+'_flx.sav'
      IF (FILE_EXIST(savedfile_flx) eq 0) OR KEYWORD_SET(RELOAD) THEN BEGIN 
          READCOL,dirmod+model+'.flx',fluxmod
          save,fluxmod,filename=savedfile_flx
      ENDIF ELSE restore,savedfile_flx            
    spawn,'grep Luminosity '+dirmod+model+'.mod',result,/sh
    lstar=double(result)*norm_factor
    print,'Lstar= ',lstar
    spawn,'grep Teff '+dirmod+model+'.mod',result,/sh
    tstar=double(result)
    print,'Teff= ',tstar
    spawn,'grep Mass '+dirmod+model+'.mod',result,/sh
    mstar=double(result)
    print,'Mstar= ',mstar    
    ZE_COMPUTE_R_FROM_T_L,tstar/1e3,lstar,rstarmarcs
    print,'Reff= ', rstarmarcs
     
    
    ;scales fluxmod from stellar surface to 1kpc for later computing apparent mag ; reason: 1kpc is the default distance of CMFGEN models, so we don't need to change the distance of CMFGEN models later 
    ;do not have to multiply here by norm_factor since lstar has been already multiplied above, and so does rstarmarcs
    fluxmod=fluxmod*(rstarmarcs[0]*rsuntokpc)^2
    
    IF KEYWORD_SET(PLOT) THEN BEGIN
      LOADCT,0,/SILENT
      !P.Background=fsc_color('white')
      lineplot,lambdamod,fluxmod
    ENDIF
    
ENDIF ELSE IF KEYWORD_SET(MARCSHR) THEN BEGIN 
    dirmod='/Users/jgroh/marcs_models/'   
    model='M_s3200g0.0z0.0t2.0_a0.00c0.00n0.00o0.00r0.00s0.00'
    model='M_s3600g0.0z0.0t2.0_a0.00c0.00n0.00o0.00r0.00s0.00'
 ;   model='M_s4000g0.0z0.0t2.0_a0.00c0.00n0.00o0.00r0.00s0.00'
 ;   model='C_s35000g4.00z0.0t5.0_a0.00c0.00n0.00o0.00_Mdot-6.83Vinfty2500beta0.8finfty1vcl0' 
    IF strmid(model,0,1) EQ 'M' THEN spaces=19 ELSE spaces=14
    spawn,'grep luminosity '+dirmod+model+'_VIS.spec.flat'+'/'+model+'_VIS.spec.txt' ,result,/sh
    lstar_str=strmid(result,spaces,6)
    lstar=10^(float(lstar_str))*norm_factor
    print,'Lstar= ',lstar
    spawn,'grep "effective temperature" '+dirmod+model+'_VIS.spec.flat'+'/'+model+'_VIS.spec.txt' ,result,/sh
    tstar_str=strmid(result,spaces,6)
    tstar=float(tstar_str)
    print,'Teff= ',tstar
    spawn,'grep "mass     " '+dirmod+model+'_VIS.spec.flat'+'/'+model+'_VIS.spec.txt' ,result,/sh
    mstar_str=strmid(result,spaces,6)
    mstar=float(mstar_str)
    print,'Mstar= ',mstar    
    ZE_COMPUTE_R_FROM_T_L,tstar/1e3,lstar,rstarmarcs
    print,'Reff= ', rstarmarcs 
    savedfile_marcshr='/Users/jgroh/temp/'+model+'_lam_flx.sav'
    IF (FILE_EXIST(savedfile_marcshr) eq 0) OR KEYWORD_SET(RELOAD) THEN BEGIN 
        READCOL,dirmod+model+'_VIS.spec.flat'+'/'+model+'_VIS.spec',lambdamod,fluxmod
        save,lambdamod,fluxmod,filename=savedfile_marcshr
    ENDIF ELSE restore,savedfile_marcshr            
  
    ;CONCLUSION FROM 2012 Nov 22: FILE LOADED FROM POLLUX IS NOT FLAMBDA, IT IS FNU! 
    ;has to convert it to flambda from fnu, i.e. flambda = 3e18 * fnu / lambda^2
    ;for CMFGEN spectrum from the Pollux database, have to scale flux to flambda (since actually fnu is given) THIS HAS BEEN CROSS-CALIBRATED AGAINST THE RESULTS FROM MARTINS ET AL. 2006
    IF strmid(model,0,1) EQ 'C' THEN BEGIN
     print,'CMFGEN spectrum from the Pullux database: converting using fluxmod=3e18*fluxmod/lambdamod^2 '
     fluxmod=3e18*fluxmod/lambdamod^2
    ENDIF 
   
    ;scales fluxmod from stellar surface to 1kpc for later computing apparent mag ; reason: 1kpc is the default distance of CMFGEN models, so we don't need to change the distance of CMFGEN models later 
    fluxmod=fluxmod*norm_factor*(rstarmarcs[0]*rsuntokpc)^2
    
    IF KEYWORD_SET(PLOT) THEN BEGIN
      LOADCT,0,/SILENT
      !P.Background=fsc_color('white')
      lineplot,lambdamod,fluxmod
    ENDIF  
ENDIF ELSE BEGIN
    savedfile_cmfgen='/Users/jgroh/temp/'+model+'_lam_flx.sav'
    IF (FILE_EXIST(savedfile_cmfgen) eq 0) OR KEYWORD_SET(RELOAD) THEN BEGIN 
        IF FILE_EXIST(dirmod+model+'/obs/obs_fin') THEN ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin',lambdamod,fluxmod,num_rec2,/flam ELSE BEGIN ;reading a CMFGEN model in Flambda; the flux of this model is at 1kpc
          ZE_CMFGEN_READ_OBS,dirmod+model+'/obs/obs_fin_10',lambdamod,fluxmod,num_rec2,/flam ;reading a CMFGEN model in Flambda; the flux of this model is at 1kpc
        ENDELSE
        save,lambdamod,fluxmod,filename=savedfile_cmfgen
    ENDIF ELSE restore,savedfile_cmfgen      
    fluxmod=fluxmod*norm_factor
ENDELSE

if N_elements(lambdain) GT 1 THEN BEGIN
   lambdamod=lambdain
   fluxmod=fluxin*norm_factor
ENDIF

IF KEYWORD_SET(EBV) THEN BEGIN
   if N_elements(rv) LT 0 THEN rv=3.1 
   fm_unred, lambdamod,fluxmod, ebv, fluxmodred, R_V = rv
   fluxmod=fluxmodred
ENDIF

;does redshift correctrion

IF n_elements(redshift) GT 0 THEN BEGIN 
dist=lumdist(redshift, /silent) ;in Mpc
print,'distance= ',dist, ' Mpc'
dist_flux_factor=(0.001/dist)^2;
fluxmod=fluxmod*dist_flux_factor
lambda_factor=1+redshift
lambdamod=lambdamod*lambda_Factor

ENDIF

linterp,lambdamod,fluxmod,lambda,fluxmod_interp
fluxmod_interp_times_passband_times_lambda=fluxmod_interp*pass*lambda
fluxmod_total_band=int_tabulated(lambda,fluxmod_interp_times_passband_times_lambda)


;vega spectrum
    ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/IDLWorkspace/Default/pro/chorizos/dat/vega_res.dat',lambdavega,fluxvega,num_recvega
    linterp,lambdavega,fluxvega,lambda,fluxvega_interp
    fluxvega_interp_times_passband_times_lambda=fluxvega_interp*pass*lambda
    fluxvega_total_band=int_tabulated(lambda,fluxvega_interp_times_passband_times_lambda)


IF N_elements(dist) LT 1 THEN d=1.0  ELSE d=dist ;in kpc, CMFGEN output is always normalized to 1 kpc; MARCS models have been scaled to 1kpc above
print,d
fluxmod_total_band=fluxmod_total_band/(d^2)

apparent_mag=-2.5*alog10(fluxmod_total_band/fluxvega_total_band) + zp

print,'model=',model
print,'Apparent magnitude at 1kpc:'
print,'m_'+band+'=',apparent_mag

;computing mabsv for dist
absolute_mag=apparent_mag-5.*alog10(d/0.01)

print,'M_'+band+'=',absolute_mag

if keyword_set(dm) THEN begin
   apparent_mag=absolute_mag+dm
   print,'Distance modulus provided: Dm= ', dm, ' , corresponding to d= ',10^(1d0+dm/5.)
   print,'m_'+band+'=',apparent_mag
endif
   

;computing mbol for a given L

IF (KEYWORD_SET(MARCSHR) OR KEYWORD_SET(MARCSWEB)) THEN print,'' ELSE BEGIN
   mstar_str=strmid(model,1,3)
   mstar=float(mstar_str)
   print,'Mstar=',Mstar

  tstar_str=strmid(strmid(model,0,strpos(model,'_L')),strpos(model,'_T')+2)
  tstar=float(tstar_str)
  print,'Tstar=',tstar

  lstar_str=strmid(strmid(model,0,strpos(model,'_logg')),strpos(model,'_L')+2)
  lstar=float(lstar_str)*norm_factor
  print,'Lstar=',lstar
ENDELSE

mbol=4.74 -2.5*alog10(lstar)
print,'Mbol=',mbol

;computing bc for a given absolute_mag and Mbol => attention output will be dependent on band used! (i.e., BC_B, BC_V, etc).
bc=mbol-absolute_mag
print,'BC_'+band+'=',bc
!P.Background = fsc_color('white')
END