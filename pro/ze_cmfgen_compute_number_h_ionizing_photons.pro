PRO ZE_CMFGEN_COMPUTE_NUMBER_H_IONIZING_PHOTONS,obs,nphot_hyd,nphot_hei,nphot_he2,lum_hyd,lum_hei,lum_he2,skip_obsread=skip_obsread,lobs=lobs,fobs=fobs,scale_lum=scale_lum,dist=dist
;computes number of ionizing photons for H, He I, and He 2
;can be easily adapted to compute lum and n_phot below a certain frequency
;adapted from CMFGEN plt_spec.f
;cross checked with CMFGEN against model '/Users/jgroh/ze_models/etacar_john/eta_companion_r5/obs/obs_fin'
;input is name of obs file with full path

;!P.Background = fsc_color('white')
C=299792000.

IF KEYWORD_SET(skip_obsread) THEN print,'Skip reading obs file and using input from EDDFACTOR output' ELSE BEGIN
  ZE_CMFGEN_READ_OBS,obs,lobs,fobs,num_rec
  ;first reverse order of vectors so that frequency is in ascending order
  fobs=REVERSE(fobs)
  lobs=REVERSE(lobs)
ENDELSE  
  
obs_freq=C/lobs*1D-05
nfreq=n_elements(obs_freq)

if keyword_set(scale_lum) then begin
  print,'luminosity scaled by ',scale_lum
  fobs=fobs*scale_lum
endif

if keyword_set(dist) then begin
  print,'luminosity scaled by distance',dist
  fobs=fobs*(dist^2)
endif

EDGE_HYD=3.28808662499619D0
EDGE_HEI=5.94520701882481D0
EDGE_HE2=13.1581564178623D0
index_edge_hyd=findel(EDGE_HYD,obs_Freq)
index_edge_hei=findel(EDGE_HEI,obs_Freq)
index_edge_he2=findel(EDGE_HE2,obs_Freq)

tot_lum=INT_TABULATED(obs_freq,fobs,/double)*312.7 ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun
print,' Total luminosity is:                  ',tot_lum

;for Hydrogen
nphot_hyd=47.2566+alog10(INT_TABULATED(obs_freq[index_edge_hyd:nfreq-1],fobs[index_edge_hyd:nfreq-1]/obs_freq[index_edge_hyd:nfreq-1],/double)) ; 47.2566 = DLOG10(4pi*(1kpc)**2*(1E-23)/h)
lum_hyd=INT_TABULATED(obs_freq[index_edge_hyd:nfreq-1],fobs[index_edge_hyd:nfreq-1])*312.7   ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun

print, 'Luminosity shortward of        ',lobs[index_edge_hyd],'A is:   ',lum_hyd
print, 'Log(#) of photons shortward of ',lobs[index_edge_hyd],'A is:   ',nphot_hyd

;for He I
nphot_hei=47.2566+alog10(INT_TABULATED(obs_freq[index_edge_hei:nfreq-1],fobs[index_edge_hei:nfreq-1]/obs_freq[index_edge_hei:nfreq-1])) ; 47.2566 = DLOG10(4pi*(1kpc)**2*(1E-23)/h)
lum_hei=INT_TABULATED(obs_freq[index_edge_hei:nfreq-1],fobs[index_edge_hei:nfreq-1])*312.7   ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun

print, 'Luminosity shortward of        ',lobs[index_edge_hei],'A is:   ',lum_hei
print, 'Log(#) of photons shortward of ',lobs[index_edge_hei],'A is:   ',nphot_hei

;for He II
nphot_he2=47.2566+alog10(INT_TABULATED(obs_freq[index_edge_he2:nfreq-1],fobs[index_edge_he2:nfreq-1]/obs_freq[index_edge_he2:nfreq-1])) ; 47.2566 = DLOG10(4pi*(1kpc)**2*(1E-23)/h)
lum_he2=INT_TABULATED(obs_freq[index_edge_he2:nfreq-1],fobs[index_edge_he2:nfreq-1])*312.7   ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun

print, 'Luminosity shortward of        ',lobs[index_edge_he2],'A is:   ',lum_he2
print, 'Log(#) of photons shortward of ',lobs[index_edge_he2],'A is:   ',nphot_he2


END