PRO ZE_CMFGEN_CLASSIFY_O_STARS_EW,modelstr,spec_timestep,timesteps_available,allobsfinfiles,allobscontfiles,ew,SpType,LumClass,$
                                  group=group,modal=modal,lmin=lmin,lmax=lmax,xrange=xrange,yrange=yrange
;routine to semi-automatically classify the spectra of O stars 
;at the moment reads the spectrum again

if n_elements(lmin) LT 1 THEN lmin=1200.0
if n_elements(lmax) LT 1 THEN lmax=50000.0
if n_elements(xrange) LT 1 THEN xrange=[3900,6700]
if modelstr eq 'P060z14S0' THEN if spec_timestep lt 4000 THEN xrange=[3900,4800]

;find timestep closest to available timesteps
closest_timestep_available_index=findel(spec_timestep,timesteps_available)
closest_timestep_available=timesteps_available[closest_timestep_available_index]    

ZE_CMFGEN_CREATE_OBSNORM,allobsfinfiles[closest_timestep_available_index],allobscontfiles[closest_timestep_available_index],l,f,LMIN=lmin,LMAX=lmax

;first measure ew of 4471 and 4542, remember that wrest are in vacuum since CMFGEN spectra are also in vacuum 
line_eqwidth,l,f,wrest=4473.0,lineid='He I 4471',results4471,wmin=4464.13,wmax=4481.00,fmin=0.37,fmax=1.06
line_eqwidth,l,f,wrest=4542.864,lineid='He II 4542',results4542,wmin=4515.13,wmax=4571.00,fmin=0.6,fmax=1.06

;now check if star is earlier than O7; if yes, luminosity indicator is He II 4686, so we do not measure HE I 4143 and Si IV 4088 
;spectral type classification following mathis 1988
logWprime=alog10(results4471[12]/results4542[12]) ; = log (EW(He I 4471)/EW(He II 4542)) 
IF (logWprime[i] LT 1.00 AND logWprime[i] GT 0.65) THEN SpType[i]='O9.7'
IF (logWprime[i] LT 0.65 AND logWprime[i] GT 0.45) THEN SpType[i]='O9.5'
IF (logWprime[i] LT 0.45 AND logWprime[i] GT 0.30) THEN SpType[i]='O9'    
IF (logWprime[i] LT 0.30 AND logWprime[i] GT 0.20) THEN SpType[i]='O8.5'
IF (logWprime[i] LT 0.20 AND logWprime[i] GT 0.10) THEN SpType[i]='O8'
IF (logWprime[i] LT 0.10 AND logWprime[i] GT 0.00) THEN SpType[i]='O7.5'
IF (logWprime[i] LT 0.00 AND logWprime[i] GT -0.10) THEN SpType[i]='O7'
IF (logWprime[i] LT -0.10 AND logWprime[i] GT -0.20) THEN SpType[i]='O6.5'        
IF (logWprime[i] LT -0.20 AND logWprime[i] GT -0.30) THEN SpType[i]='O6' 
IF (logWprime[i] LT -0.30 AND logWprime[i] GT -0.45) THEN SpType[i]='O5.5' 
IF (logWprime[i] LT -0.45 AND logWprime[i] GT -0.60) THEN SpType[i]='O5' 
IF (logWprime[i] LT -0.60 AND logWprime[i] GT -0.90) THEN SpType[i]='O4' 
IF (logWprime[i] LT -0.90) THEN SpType[i]='O3'   

;luminosity classification following mathis 1988, markova+11
IF (logWprime[i] LT -0.10) THEN BEGIN ;these are SpType < O7, so we measure only He 2 4686
      line_eqwidth,l,f,wrest=4687.02  ,lineid='He II 4686',results4686,wmin=4656.13,wmax=4716.00,fmin=0.6,fmax=1.3
      log4686=alog10(results4686[12])
      IF (log4686[i] GT -0.25) THEN LumClass[i]='V' ELSE LumClass[i]='III'
    ENDIF ELSE BEGIN ;these are SPType > 07, using the classification of Conti & Alschuler 1971; so we measure only He I 4143 and Si Iv 4088
      line_eqwidth,l,f,wrest=4144.93  ,lineid='He I 4143',results4143,wmin=4113.13,wmax=4173.00,fmin=0.6,fmax=1.3      
      line_eqwidth,l,f,wrest=4090.016  ,lineid='Si IV 4088',results4088,wmin=4058.13,wmax=4123.00,fmin=0.6,fmax=1.3
      logWdoubleprime=alog10(results4088[12]/results4143[12]) ;= log (EW(Si IV 4089)/EW(He I 4143)) 
      IF (logWdoubleprime[i] LT 0.10 AND logWdoubleprime[i] GT -0.20) THEN LumClass[i]='V'
      IF (logWdoubleprime[i] LT 0.30 AND logWdoubleprime[i] GT 0.10) THEN LumClass[i]='III'
      IF (logWdoubleprime[i] GT 0.30) THEN LumClass[i]='I'    
    ENDELSE



print,SpType, Lumclass


END