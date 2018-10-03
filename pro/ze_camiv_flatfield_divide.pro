PRO ZE_CAMIV_FLATFIELD_DIVIDE,science_array_sky_sub,nframes,flat_norm,science_array_sky_sub_flat

science_array_sky_sub_flat=science_array_sky_sub
  FOR I=0, nframes -1 DO science_array_sky_sub_flat[*,*,i]=science_array_sky_sub[*,*,i] / flat_norm


END