PRO PROKURUCZ
fname = 'f' + ['m15','m10','m05','p00'] + 'k2'
FOR k=0,3 DO BEGIN
 PRINT, 'Beginning ', + fname[k]
 READDATA, fname[k] + '.pck', v, /ONESTRING
 pos0 = WHERE(STRTRIM(v,2) EQ 'END', npos0)
 pos0 = pos0[0]
 IF npos0 NE 1 THEN STOP, 'Error pos0'
 pos1 = WHERE(STRMID(v,0,4) EQ 'TEFF',nmod0)
 wav0 = FLTARR(1221)
 FOR i=pos0+1,pos0+152 DO wav0[8*(i-pos0-1):8*(i-pos0-1)+7] = $
  FLOAT(STRSPLIT(STRCOMPRESS(STRTRIM(v[i],2)),/EXTRACT))
 wav0[8*152:8*152+4] = FLOAT(STRSPLIT(STRCOMPRESS(STRTRIM(v[pos0+153],2)),/EXTRACT))
 wav0 = 10.*wav0 ; De nm a Angstroms
 sign = 1*(STRMID(fname[k],1,1) EQ 'p') - 1*(STRMID(fname[k],1,1) EQ 'm')
 t0 = FLTARR(nmod0)
 g0 = FLTARR(nmod0)
 z0 = FLTARR(nmod0) + sign*FLOAT(STRMID(fname[k],2,2))/10.
 PRINT, 'Z = ', sign*FLOAT(STRMID(fname[k],2,2))/10.
 FOR i=0,nmod0-1 DO BEGIN
  aux   = STRSPLIT(STRCOMPRESS(STRTRIM(v[pos1[i]],2)),/EXTRACT)
  t0[i] = FLOAT(aux[1])
  g0[i] = FLOAT(aux[3])
 ENDFOR
 flux0 = FLTARR(nmod0,1221)
 FOR i=0,nmod0-1 DO BEGIN
  FOR j=pos1[i]+1,pos1[i]+152 DO flux0[i,8*(j-pos1[i]-1):8*(j-pos1[i]-1)+7] = FLOAT(STRMID(v[j],10*INDGEN(8),10))
  flux0[i,8*152:8*152+4] = FLOAT(STRMID(v[j],10*INDGEN(5),10))
 ;                                                      flux = erg/s/cm^2
  flux0[i,*] = 4.*!PI*flux0[i,*]                      ; From intensity to flux
  flux0[i,*] = 2.9979e10/(1.e-8*wav0)^2*flux0[i,*] ; From flux/Hz   to flux/cm
  flux0[i,*] = FLOAT(flux0[i,*]/1e8)                  ; From flux/cm   to flux/Angstrom (flam)
 ENDFOR
 pos = STRPOS(v[pos1[0]],'SDSC')
 IF k EQ 0 THEN BEGIN
  wav = wav0
  nmod   =   nmod0
  t      =      t0
  g      =      g0
  z      =      z0
  flux   =   flux0
  hdr    = 'COMMENT Kurucz models for Z=' + STRING(z0[0],FORMAT='(F5.2)') + ' ' + STRMID(v[pos1[0]],pos,999)
 ENDIF ELSE BEGIN
  IF MAX(ABS(wav-wav0)) GT 1.e-3 THEN STOP, 'Error in wav'
  nmod   =  nmod+nmod0 
  t      = [   t,   t0]
  g      = [   g,   g0]
  z      = [   z,   z0]
  flux   = [flux,flux0]
  hdr    = [hdr, $
	   'COMMENT                   Z=' + STRING(z0[0],FORMAT='(F5.2)') + ' ' + STRMID(v[pos1[0]],pos,999)]
 ENDELSE
ENDFOR  
hdr = [hdr, 'COMMENT      ']
hdr = ["NAME    = 'Kurucz models'           /", $
       "MODTYPE = 'Star'                    /", $
       "MODN    = " + STRING(nmod,FORMAT='(I5)'    ) + "                    /", $
       "PARN    =     3                     /", $
       "PAAN    =     0                     /", $
       "PASN    =     0                     /", $
       "WAVN    =  1221                     /", $
       "WAVUNIT = 'Angstrom'                /", $
       "PARNAME1= 'T'                       /", $
       "PARNAML1= 'Temperature'             /", $
       "PARUNIT1= 'K'                       /", $
       "PARLOG1 =     0                     /", $
       "PARMIN1 = " + STRING(MIN(t),FORMAT='(I5)'  ) + "                     /", $
       "PARMAX1 = " + STRING(MAX(t),FORMAT='(I5)'  ) + "                     /", $
       "PARNAME2= 'g'                       /", $
       "PARNAML2= 'Gravity'                 /", $
       "PARUNIT2= 'cgs'                     /", $
       "PARLOG2 =     1                     /", $
       "PARMIN2 = " + STRING(MIN(g),FORMAT='(F5.2)') + "                     /", $
       "PARMAX2 = " + STRING(MAX(g),FORMAT='(F5.2)') + "                     /", $
       "PARNAME3= 'Z'                       /", $
       "PARNAML3= 'Metallicity'             /", $
       "PARUNIT3= 'Solar units'             /", $
       "PARLOG3 =     1                     /", $
       "PARMIN3 = " + STRING(MIN(z),FORMAT='(F5.2)') + "                     /", $
       "PARMAX3 = " + STRING(MAX(z),FORMAT='(F5.2)') + "                     /", $
       hdr]
; flam for stellar models is flux at stellar surface
v = {wav:wav, v1:t, v2:g, v3:z, flam:flux}
MWRFITS, v, 'kurucz_orig.fits', hdr, /CREATE
STOP
END
