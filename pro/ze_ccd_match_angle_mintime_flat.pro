PRO ZE_CCD_MATCH_ANGLE_MINTIME_FLAT,exposure_angle,exposure_time,flat_angle,flat_time,index_match_angle_mintime_flat
;routine to match a given exposure to a certain flat-field image based on fulfilling both of two criteria: 1) has to have the same ANGLE and 2) if more than two flat images fulfill criteria 1), then pick the flat image closest in time
;exposure_angle and exposure_time are scalars
;flat_angle and flat_time are vectors

;debug: print flat angle and exposure angle
print,'flat_angle',flat_angle
print,'exposure_angle',exposure_angle

;first find the indices where flat_angle and exposure_angle are the same
index_match_angle_flat=where(flat_angle EQ exposure_angle)

;compute subarray of flat times where flat_angle is the same as exposure_angle
flat_time_same_angle_as_exposure=flat_time(index_match_angle_flat)

;compute the absolute of minimum time interval between flat times and exposure times 
diff=min(abs(exposure_time-flat_time_same_angle_as_exposure),index_mintime_flat)
index_match_angle_mintime_flat=index_match_angle_flat[index_mintime_flat]

END