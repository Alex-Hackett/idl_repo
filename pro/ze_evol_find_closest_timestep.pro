FUNCTION ZE_EVOL_FIND_CLOSEST_TIMESTEP,xvalue,yvalue,xarray,yarray
distance=SQRT((xvalue-xarray)^2 + (yvalue-yarray)^2)
min_distance=min(distance,close_timestep_index)   
RETURN,close_timestep_index
END