!P.Background = fsc_color('white')
C=299792000.


;compute luminosity
dirmod='/Users/jgroh/ze_models/SN_progenitor_grid/'
model='P120z14S0_model025926_T167648_L1784201_logg5.527'
obs=dirmod+model+'/obs/obs_fin'
ZE_CMFGEN_READ_OBS,obs,lobs,fobs,num_rec

;first reverse order of vectors so that frequency is in ascending order
fobs=REVERSE(fobs)
lobs=REVERSE(lobs)
obs_freq=C/lobs*1E-05
nfreq=n_elements(obs_freq)
factor=10.0

obs_Freqi=REBIN(obs_freq,nfreq*factor)
fobsi=REBIN(fobs,nfreq*factor)

obs_freqi=obs_freqi[0:(nfreq-1)*factor]
fobsi=fobsi[0:(nfreq-1)*factor]

tot_lum=INT_TABULATED(obs_freqi,fobsi)*312.7 ;312.7 = 4pi*(1kpc)**2*(1E+15)*(1E-23)/Lsun
print,' Total luminosity is:                  ',tot_lum

redshift=6.7
dist=lumdist(redshift, /silent) ;in Mpc
print, 'dist=      ',dist, ' Mpc'
dist_flux_factor=(dist/0.001)^2;

ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model,'V',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,redshift=redshift,norm_factor=5.7

;absolute_mag=apparent_mag-5.*alog10(d/0.01)

END