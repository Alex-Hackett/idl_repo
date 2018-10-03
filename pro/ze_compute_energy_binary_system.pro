FUNCTION ZE_COMPUTE_ENERGY_BINARY_SYSTEM,M1,M2,a
;M1 and M2 in Msun, a in AU
;Ebin is returned in erg
; E = −1/2 GM1M2/a
; reference: http://www.astro.sunysb.edu/lattimer/PHY521/binary.pdf

G=6.67d-8
Msuntog=1.9891d33
AUtocm=1.49597871d13

Ebin=-0.5d * G * M1 *Msuntog * M2 * Msuntog / (a * AUtocm)

return, Ebin
;print,'Ebin= ',Ebin, ' erg'
END