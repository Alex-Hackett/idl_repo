PRO ZE_EVOL_PLOT_SPECTRUM_INTERAC_V1,modelstr,spec_timestep,timesteps_available,allobsfinfiles,allobscontfiles,group=group,modal=modal,lmin=lmin,lmax=lmax,xrange=xrange,yrange=yrange

if n_elements(lmin) LT 1 THEN lmin=1200.0
if n_elements(lmax) LT 1 THEN lmax=50000.0
if n_elements(xrange) LT 1 THEN xrange=[3900,6700]
if modelstr eq 'P060z14S0' THEN if spec_timestep lt 4000 THEN xrange=[3900,4800]

;find timestep closest to available timesteps
closest_timestep_available_index=findel(spec_timestep,timesteps_available)
closest_timestep_available=timesteps_available[closest_timestep_available_index]      

ZE_CMFGEN_CREATE_OBSNORM,allobsfinfiles[closest_timestep_available_index],allobscontfiles[closest_timestep_available_index],l,f,LMIN=lmin,LMAX=lmax

!P.Background = fsc_color('white')

    lineplot,l,f,title='Spectrum of '+modelstr+' timestep '+string(closest_timestep_available),xrange=xrange,yrange=yrange,xtitle='Wavelength (Angstrom)', ytitle='Normalized Flux',$
                       group=group;,/MODAL


END