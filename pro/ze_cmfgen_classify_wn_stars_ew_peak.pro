PRO ZE_CMFGEN_CLASSIFY_WN_STARS_EW_PEAK,modelstr,spec_timestep,timesteps_available,allobsfinfiles,allobscontfiles,ew,SpType,$
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

;measure ew of He II 5411, He I 5875, N V 4604 and N III 4640 remember that wrest are in vacuum since CMFGEN spectra are also in vacuum 
ze_line_eqwidth,l,f,wrest=5413.03,lineid='He II 5413.03',results5411,wmin=5280,wmax=5990.,fmin=0.13,fmax=4.06,group=group,/modal,/auto_Exit,title='He II 5413.03'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
ze_line_eqwidth,l,f,wrest=5877.25,lineid='He I 5877.25',results5875,wmin=5280,wmax=5990.,fmin=0.13,fmax=4.06,group=group,/modal,/auto_Exit,title='He I 5877.25'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
ze_line_eqwidth,l,f,wrest=4605.03 ,lineid='N V 4605.03',results4604,wmin=4508,wmax=4658.,fmin=0.3,fmax=3.50,group=group,/modal,/auto_Exit,title='N V 4605.03'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))
ze_line_eqwidth,l,f,wrest=4641.94 ,lineid='N III 4641.93',results4640,wmin=4508,wmax=4658.,fmin=0.3,fmax=3.50,group=group,/modal,/auto_Exit,title='N III 4641.93'+'Model '+modelstr+' timestep '+strcompress(STRING(closest_timestep_available))

peak_continuum_He2_5411_over_He1_5875=results5411[8]/results5875[8]
peak_continuum_N5_4604_over_N3_4640=results4604[8]/results4640[8]

;spectral type classification following Smith+ 1996, MNRAS 281, 163

IF (results5875[8] LT 1.05) THEN SpType='WN2' ELSE $
IF (peak_continuum_He2_5411_over_He1_5875 GT 10) THEN SpType='WN3' ELSE $
IF (peak_continuum_He2_5411_over_He1_5875 GT 4 AND peak_continuum_He2_5411_over_He1_5875 LE 10 AND peak_continuum_N5_4604_over_N3_4640 GT 2) THEN SpType='WN4' ELSE $
IF (peak_continuum_He2_5411_over_He1_5875 GT 1.25 AND peak_continuum_He2_5411_over_He1_5875 LE 8 AND peak_continuum_N5_4604_over_N3_4640 GT 0.5 AND peak_continuum_N5_4604_over_N3_4640 LE 2) THEN SpType='WN5' ELSE $
IF (peak_continuum_He2_5411_over_He1_5875 GT 1.25 AND peak_continuum_He2_5411_over_He1_5875 LE 4 AND peak_continuum_N5_4604_over_N3_4640 GT 0.2 AND peak_continuum_N5_4604_over_N3_4640 LE 0.5) THEN SpType='WN6' ELSE $
IF (peak_continuum_He2_5411_over_He1_5875 GT 0.65 AND peak_continuum_He2_5411_over_He1_5875 LE 1.25) THEN SpType='WN7' ELSE $
IF (peak_continuum_He2_5411_over_He1_5875 GT 0.1 AND peak_continuum_He2_5411_over_He1_5875 LE 0.65) THEN SpType='WN8' ELSE $
IF (peak_continuum_He2_5411_over_He1_5875 LT 0.1) THEN SpType='WN9_or_later' ELSE SpType='Undefined'


print,'Model_'+modelstr+'_timestep_'+strcompress(STRING(closest_timestep_available),/remove_all)+' ',SpType

END