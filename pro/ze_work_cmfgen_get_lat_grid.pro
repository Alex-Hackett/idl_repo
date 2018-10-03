;PRO ZE_WORK_CMFGEN_GET_LAT_GRID
N=199.
GRID=DBLARR(2*N-1)

  J=2*N-1
  GRID[*]=0.D0
  DN=N-1.
  MIN=0.0D0
  MAX=1.D0*ACOS(-1.D0)
  DEL=(MAX-MIN)/DN
  FOR I=0, J-1 DO BEGIN
    GRID[I]=MIN+DEL*(I-1)
  ENDFOR
  
  NB=23.
  b=dblarr(NB)
  FOR I=0,NB-1 DO BEGIN
    B(I)=0.D0+(I+0.D0)*(2.D0*ACOS(-1.D0))/(NB+0.D0)  ;for now don't assume top-bottom symmetry
  ENDFOR
  
  
END