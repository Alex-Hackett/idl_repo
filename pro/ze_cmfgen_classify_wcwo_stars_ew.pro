PRO ZE_CMFGEN_CLASSIFY_WCWO_STARS_EW,modelstr,spec_timestep,timesteps_available,allobsfinfiles,allobscontfiles,ew,SpType,$
                                  group=group,modal=modal,lmin=lmin,lmax=lmax,xrange=xrange,yrange=yrange
;routine to semi-automatically classify the spectra of O stars 
;at the moment reads the spectrum again and DO NOT return ew, only spectral type and lum class

if n_elements(lmin) LT 1 THEN lmin=1200.0
if n_elements(lmax) LT 1 THEN lmax=50000.0
if n_elements(xrange) LT 1 THEN xrange=[3900,6000]
if modelstr eq 'P060z14S0' THEN if spec_timestep lt 4000 THEN xrange=[3900,4800]

;find timestep closest to available timesteps
closest_timestep_available_index=findel(spec_timestep,timesteps_available)
closest_timestep_available=timesteps_available[closest_timestep_available_index]    

ZE_CMFGEN_CREATE_OBSNORM,allobsfinfiles[closest_timestep_available_index],allobscontfiles[closest_timestep_available_index],l,f,LMIN=lmin,LMAX=lmax

;measure ew of OVI 3811 and C IV 5808 to determine if it is a WC or WO 
wrest=3811
ze_line_eqwidth,l,f,wrest=3811.0,lineid='OVI 3811',results3811,wmin=wrest-200,wmax=wrest+200,fmin=0.13,group=group,/modal,/auto_Exit,title='OVI 3811'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
wrest=5808
ze_line_eqwidth,l,f,wrest=5808.0,lineid='CIV 5808',results5808,wmin=wrest-200,wmax=wrest+200,group=group,/modal,/auto_Exit,title='CIV 5808'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))

IF alog10(results3811[12]/results5808[12]) LT -1.5 THEN BEGIN
 ;it is a WC -- measure C III 5696 for primary classification and OIII-V 5590 for secondary classification
  wrest=5696
  ze_line_eqwidth,l,f,wrest=5696,lineid='CIII 5696',results5696,wmin=5600,wmax=5760,group=group,/modal,/auto_Exit,title='CIII 5696'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
  ;primary classification
  IF (alog10(results5808[12]/results5696[12]) GE 1.5) THEN SpType='WC4' ELSE $
  IF (alog10(results5808[12]/results5696[12]) LT 1.5 AND alog10(results5808[12]/results5696[12]) GE 1.1) THEN SpType='WC5' ELSE $
  IF (alog10(results5808[12]/results5696[12]) LT 1.1 AND alog10(results5808[12]/results5696[12]) GE 0.6) THEN SpType='WC6' ELSE $ 
  IF (alog10(results5808[12]/results5696[12]) LT 0.6 AND alog10(results5808[12]/results5696[12]) GE 0.1) THEN SpType='WC7' ELSE $    
  wrest=5590
  ze_line_eqwidth,l,f,wrest=5590,lineid='OIII-V 5590',results5590,wmin=5500,wmax=5700,fmin=0.13,group=group,/modal,/auto_Exit,title='OIII-V 5590'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
  ;secondary classification
  IF (alog10(results5696[12]/results5590[12]) LE -0.4) THEN SpType_sec='WC4' ELSE $
  IF (alog10(results5696[12]/results5590[12]) LT 0.5 AND alog10(results5696[12]/results5590[12]) GE -0.4) THEN SpType_sec='WC5' ELSE $
  IF (alog10(results5696[12]/results5590[12]) LT 0.7 AND alog10(results5696[12]/results5590[12]) GE 0.0) THEN SpType_sec='WC6' ELSE $ ;note that WC6 and WC5 overlap...
  IF (alog10(results5696[12]/results5590[12]) GE 0.1) THEN SpType_sec='WC7' ELSE $ 
  
  
  
  IF alog10(results5808[12]/results5696[12]) LT 0.1 THEN BEGIN
    ;it is a late WC (> WC8), measure C II 4267 as secondary criterium to define spectral type
    wrest=4267
    ze_line_eqwidth,l,f,wrest=4267,lineid='CII 4267',results4267,wmin=wrest-200,wmax=wrest+200,group=group,/modal,/auto_Exit,title='CII 4267'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
    IF (alog10(results5808[12]/results5696[12]) LT 0.1 AND alog10(results5808[12]/results5696[12]) GE -0.3) THEN SpType='WC8' ELSE $ 
    IF (alog10(results5808[12]/results5696[12]) LT -0.3 AND alog10(results5808[12]/results5696[12]) GE -0.7) THEN SpType='WC9' ELSE $ 
    IF (alog10(results5808[12]/results5696[12]) LT -0.7 AND alog10(results5808[12]/results5696[12]) GT -1.2) THEN SpType='WC10' ELSE $  
    IF (alog10(results5808[12]/results5696[12]) LE -1.2) THEN SpType='WC11' ELSE Sptype='Undefined'     
  ENDIF
ENDIF ELSE BEGIN
 ;it is a WO
  wrest=5590
  ze_line_eqwidth,l,f,wrest=5590,lineid='OIII-V 5590',results5590,wmin=5500,wmax=5700,fmin=0.13,group=group,/modal,/auto_Exit,title='OIII-V 5590'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
  ;primary classification
  IF (alog10(results3811[12]/results5590[12]) GE 1.1) THEN SpType='WO1' ELSE $
  IF (alog10(results3811[12]/results5590[12]) LT 1.1 AND alog10(results3811[12]/results5590[12]) GE 0.6) THEN SpType='WO2' ELSE $
  IF (alog10(results3811[12]/results5590[12]) LT 0.6 AND alog10(results3811[12]/results5590[12]) GE 0.25) THEN SpType='WO3' ELSE $ 
  IF (alog10(results3811[12]/results5590[12]) LT 0.25 AND alog10(results3811[12]/results5590[12]) GE -0.3) THEN SpType='WO4' ELSE SpType='Undefined'
 
  ;secondary classification
  IF (alog10(results3811[12]/results5808[12]) GE 0.2) THEN SpType_sec='WO1-2' ELSE $
  IF (alog10(results3811[12]/results5808[12]) LT 0.2 AND alog10(results3811[12]/results5808[12]) GE -1.0) THEN SpType_sec='WO3' ELSE $ 
  IF (alog10(results3811[12]/results5808[12]) LT -1.0 AND alog10(results3811[12]/results5808[12]) GE -1.5) THEN SpType_sec='WO4' ELSE SpType_sec='Undefined'
  
ENDELSE    

print,alog10(results3811[12]/results5590[12])
print,alog10(results3811[12]/results5808[12])


print,'Model_'+modelstr+'_timestep_'+strcompress(STRING(closest_timestep_available),/remove_all)+': ',SpType, ' 2nd_crit ',sptype_sec

END