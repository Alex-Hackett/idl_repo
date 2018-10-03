;PRO ZE_BINARY_COMPUTE_WALL_ENHANCEMENT
DEG_TO_RAD=!PI/180.
;f_alpha = Omega/delta Omega = (1-cos(alpha))/(sin(alpha)*delta alpha)
alpha=57.0 ;opening angle in DEG
delta_alpha=3.6*2 ;wall angular thickness

f_alpha = (1.0-cos(alpha*DEG_TO_RAD))/(sin(alpha*DEG_TO_RAD)*delta_alpha*DEG_TO_RAD)
print,f_alpha
END