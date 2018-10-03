FUNCTION ZE_COMPUTE_DISTANCE_SN_SHOCK_FRONT, hours,vel,rsun=rsun,cmfgen=cmfgen
;vel in km/s, time in hours ; d_shock returned in different units, default is cm
d_shock=hours*3600d0 * vel*1e5

if keyword_set(rsun) THEN d_shock=d_shock/(6.96e10) ELSE if keyword_set(cmfgen) THEN d_shock=d_shock/1e10 ELSE dumy=''

return,d_shock
END