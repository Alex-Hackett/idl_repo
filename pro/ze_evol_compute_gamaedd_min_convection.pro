;PRO ZE_EVOL_COMPUTE_GAMAEDD_MIN_CONVECTION
;Eq. 5.86 from Maeder 2009
;GammaEdd > (1−β) * [32 − 24β] / [32−24β −3β^2]
;this computes the minimum value of GammaEdd for convection setting in; it depends mainly on beta, that is the ratio between Gas and total pressures
betagas=0.05
RHS=(1D0 - betagas) * (32 - 24*betagas) / (32 - 24*betagas - 3*betagas^2)
print,'GammaEdd(r) has to be larger than ',RHS
END