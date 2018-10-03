FUNCTION ZE_COMPUTE_RECOMBINATION_TIMESCALE,elecden,alpha=alpha
;computes hydrogen recombination timescale; electron density given in cm-3; returns reombination timescale in seconds
IF N_elements(alpha) GT 0 THEN alpharec=alpha ELSE alpharec=1.08e-13 
rectime=1/(elecden * alpharec)

return,rectime

END