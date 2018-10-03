;PRO ZE_BINARY_STAR_COMPUTE_ALL_QUANTITIES
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

DEG2RAD=!DPI/180D0
RAD2DEG=180D0/!DPI
MP=90.
MS=30.
P=2022.7/365. ;period in yers
a=ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P(MP,MS,P)

phi_min=0.
phi_max=1.
phi_step=0.001
phi_size=(phi_max-phi_min)/phi_step + 1.
phi_vector=fltarr(phi_size)
FOR I=0, phi_size -1 DO phi_vector[i]=phi_min+(phi_step*i)

;inputs, all angles in degrees
omega=255.0D
phi_zeropoint=(90.0D - omega)/360.0D ;changed by J Groh 2011 Apr 07 12:55
e=0.9D
inc=41.0D

;following the book by J. Kallrath, E.F. Milone, Eclipsing Binary Stars: Modeling and Analysis, Astronomy  and Astrophysics Library, DOI 10.1007/978-1-4419-0699-1 3,

; true anomaly of conjunction measured from the ascending node (3.1.30)
true_anom_c=90.0-omega 

;Computing the eccentric anomaly, Ec, by (3.1.27) 
ecc_anom_c=2.*ATAN(TAN(true_anom_c*DEG2RAD/2.0)*SQRT((1+e)/(1-e)))*RAD2DEG

;Computing Mean anomaly of conjunction measured from the ascending node, M_c, form Kepler's equation (3.1.28)
M_c=(ecc_anom_c*DEG2RAD-(e*SIN(ecc_anom_c*DEG2RAD)))*RAD2DEG

;compute the phase phi_per of periastron passage relative to conjunction according to (3.1.29),
phi_periastron=1-(M_c/360.0)

;From that we derive the phase, phi_c, of conjunction relative to the adopted zero point of phase, phi_zeropoint :
phi_c= ((M_c+omega-90.0)/360.0)+phi_zeropoint

;computing phase of periastron passage relative to the adopted zero point of phase; the 0.75 term accounts for ω being measured from the ascending node (270deg from conjunction).
phi_per_zero=omega/360.0 + 0.75+ phi_zeropoint

;mean anomaly for a vector of phases
M_vector=360.0*(phi_vector-phi_per_zero)

;eccentric anomaly for a vector of phases
eccanom_vector=keplereq(M_vector*DEG2RAD,e)*RAD2DEG

;(true) phase angle
phase_angle_vector=eccanom_vector+omega-90.0

j= ASIn((COS(phase_angle_vector*DEG2RAD)*SIN(inc*DEG2RAD)))*RAD2DEG
k=ACOS(COS(inc*DEG2RAD)*COS(phase_angle_vector*DEG2RAD))*RAD2DEG
print,'j (in deg) at phi=0.5 is ', j[499]
;lineplot,phi_vector,j
END