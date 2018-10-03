PRO ZE_BH05_READ_TAU_COMPUTE_TSTAR_FROM_VZ,tstar_pole,W,theta,tstar_out1
;theta=45. ;theta=co-latitude, 0=pole, 90=equator
;W=0.95 ;W=vrot/vcrit
;tstar_pole=37920.0; polar temp

;changes of Tstar as a function of latitude according to Von Zeipel 1924, ignorating oblateness 
Tstar_on_tpole= (1.D0-W^2* SIN(theta*!PI/180.)^2)^0.25
tstar_vz=tstar_pole*Tstar_on_tpole
tstar_out1=Tstar_on_tpole*tstar_pole

END