PRO ZE_CMFGEN_CLASSIFY_O_STARS_EW,modelstr,spec_timestep,timesteps_available,allobsfinfiles,allobscontfiles,ew,SpType,LumClass,$
                                  group=group,modal=modal,lmin=lmin,lmax=lmax,xrange=xrange,yrange=yrange
;routine to semi-automatically classify the spectra of O stars 
;at the moment reads the spectrum again and DO NOT return ew, only spectral type and lum class

if n_elements(lmin) LT 1 THEN lmin=1200.0
if n_elements(lmax) LT 1 THEN lmax=50000.0
if n_elements(xrange) LT 1 THEN xrange=[3900,6700]
if modelstr eq 'P060z14S0' THEN if spec_timestep lt 4000 THEN xrange=[3900,4800]

;find timestep closest to available timesteps
closest_timestep_available_index=findel(spec_timestep,timesteps_available)
closest_timestep_available=timesteps_available[closest_timestep_available_index]    

ZE_CMFGEN_CREATE_OBSNORM,allobsfinfiles[closest_timestep_available_index],allobscontfiles[closest_timestep_available_index],l,f,LMIN=lmin,LMAX=lmax

;first measure ew of 4471 and 4542, remember that wrest are in vacuum since CMFGEN spectra are also in vacuum 
ze_line_eqwidth,l,f,wrest=4473.0,lineid='He I 4473.00',results4471,wmin=4464.13,wmax=4481.00,fmin=0.37,fmax=1.06,group=group,/modal,/auto_Exit,title='Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
ze_line_eqwidth,l,f,wrest=4542.864,lineid='He II 4542.86',results4542,wmin=4515.13,wmax=4571.00,fmin=0.6,fmax=1.06,group=group,/modal,/auto_Exit,title='Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))

;now check if star is earlier than O7; if yes, luminosity indicator is He II 4686, so we do not measure HE I 4143 and Si IV 4088 
;spectral type classification following mathis 1988
logWprime=alog10(results4471[12]/results4542[12]) ; = log (EW(He I 4471)/EW(He II 4542)) 
IF (logWprime LT 1.00 AND logWprime GT 0.65) THEN SpType='O9.7' ELSE $
IF (logWprime LT 0.65 AND logWprime GT 0.45) THEN SpType='O9.5'  ELSE $
IF (logWprime LT 0.45 AND logWprime GT 0.30) THEN SpType='O9'    ELSE $
IF (logWprime LT 0.30 AND logWprime GT 0.20) THEN SpType='O8.5'  ELSE $
IF (logWprime LT 0.20 AND logWprime GT 0.10) THEN SpType='O8'    ELSE $
IF (logWprime LT 0.10 AND logWprime GT 0.00) THEN SpType='O7.5'  ELSE $
IF (logWprime LT 0.00 AND logWprime GT -0.10) THEN SpType='O7'   ELSE $
IF (logWprime LT -0.10 AND logWprime GT -0.20) THEN SpType='O6.5' ELSE $       
IF (logWprime LT -0.20 AND logWprime GT -0.30) THEN SpType='O6'    ELSE $
IF (logWprime LT -0.30 AND logWprime GT -0.45) THEN SpType='O5.5' ELSE $
IF (logWprime LT -0.45 AND logWprime GT -0.60) THEN SpType='O5' ELSE $
IF (logWprime LT -0.60 AND logWprime GT -0.90) THEN SpType='O4' ELSE $
IF (logWprime LT -0.90) THEN SpType='O3' ELSE SpType='Undefined'  

;luminosity classification following mathis 1988, markova+11
IF (logWprime LT -0.10) THEN BEGIN ;these are SpType < O7, so we measure only He 2 4686
      ze_line_eqwidth,l,f,wrest=4687.02  ,lineid='He II 4687.02',results4686,wmin=4656.13,wmax=4716.00,fmin=0.6,fmax=1.3,group=group,/modal,/auto_Exit,title='Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
      log4686=alog10(results4686[12])
      IF (log4686 GT -0.25) THEN LumClass='V' ELSE LumClass='III'
      IF results4686[12] LT 0 THEN LumClass='I'
ENDIF ELSE BEGIN ;these are SPType > 07, using the classification of Conti & Alschuler 1971; so we measure only He I 4143 and Si Iv 4088
      ze_line_eqwidth,l,f,wrest=4144.93  ,lineid='He I 4144.93',results4143,wmin=4113.13,wmax=4173.00,fmin=0.6,fmax=1.3,group=group,/moda,/auto_Exit ,title='Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
      ze_line_eqwidth,l,f,wrest=4090.016  ,lineid='Si IV 4090.01',results4088,wmin=4078.13,wmax=4103.00,fmin=0.2,fmax=1.3,group=group,/modal,/auto_Exit,title='Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
      logWdoubleprime=alog10(results4088[12]/results4143[12]) ;= log (EW(Si IV 4089)/EW(He I 4143)) 
      IF (logWdoubleprime LT 0.10 AND logWdoubleprime GT -0.20) THEN LumClass='V'
      IF (logWdoubleprime LT 0.30 AND logWdoubleprime GT 0.10) THEN LumClass='III'
      IF (logWdoubleprime GT 0.30) THEN LumClass='I' ELSE LumClass='Undefined'   
ENDELSE

print,'Model_'+modelstr+'_timestep_'+strcompress(STRING(closest_timestep_available),/remove_all)+' ',SpType, Lumclass

END