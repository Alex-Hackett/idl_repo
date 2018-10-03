FUNCTION ZE_COMPUTE_MASS_FROM_DENSITY_STRUCTURE,den,radius,rmin=rmin,rmax=rmax,msun=msun
;integrates density to compute mass enclosed in a certain region
  if not keyword_set(rmin) then rmin=min(radius)
  if not keyword_set(rmax) then rmax=max(radius)
  ;mass=INT{4 pi r^2 rho dr}
  mass=4D0*!PI*int_tabulated(radius,den*radius^2,sort=1)
  print, 'Mass= ',mass
  return,mass
END