function AH_blackbody_flux, temperature,wavelengths, star_lumin, b_body_flux

;Alex Hackett
;Student Number: 15323791
;20/10/17
;Created for Assignment 2 of the JS Astrophysics Computational Lab
;This function determines the flux of a blackbody with a given temperature, at a given wavelength, in cgs
;Inputs are
; *temperature, the effective temperature of the star in kelvin, a scaler value
; *wavelength, the array of wavelengths that the flux is to be calculated for, in angstrom
;Outputs are
; * b_body_flux, the flux of the blackbody at the given wavelength and temperature, in cgs
;Calling order
; * b_body_flux = AH_blackbody_flux(temperature,wavelength)


;Defining constants in cgs
h = DOUBLE(6.6261e-27)
kb = DOUBLE(1.3806485279e-16)
c = DOUBLE(2.99792458e10)
;;converting wavelengths to cgs
;wave = wavelengths / double(1.e8)
;;Computing Intensity
;Intensity = ((2.*h*c^2.) / (wave^5.)) * 1./((exp((h*c)/(wave*kb*temperature)))-1.)
;
;;Converting intensity to flux
;b_body_flux_cgs = Intensity * !dpi
;
;;Convert back to erg/s/cm^-2/ang
;b_body_flux = b_body_flux_cgs * 1.E-8
;Since our blackbody has the same luminosity as the star, we must normalize the array of fluxes so the areas underneath the curves are equal

b_body_flux = PLANCK(wavelengths, temperature) * !DPI
;The integral of b_body_flux wrt wavelength must be equal to star_lumin
;Normalize b_body_flux
b_body_flux = b_body_flux * (star_lumin/(INT_TABULATED(wavelengths,b_body_flux)))
;Output the normalized flux
RETURN, b_body_flux

end
