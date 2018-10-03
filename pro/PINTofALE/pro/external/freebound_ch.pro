PRO freebound_ch, temp, wvl, int, sumt=sumt, photons=photons, $
               noverner=noverner, iz=iz, ion=ion, no_setup=no_setup, $
               min_abund=min_abund, dem_int=dem_int, verbose=verbose,$
               abund=abund,ioneq=ioneq,ieq_logt=ieq_logt,_extra=e
;+
; PROJECT:  CHIANTI
;
;      CHIANTI is an Atomic Database Package for Spectroscopic Diagnostics of
;      Astrophysical Plasmas. It is a collaborative project involving the Naval
;      Research Laboratory (USA), the University of Florence (Italy), the
;      University of Cambridge and the Rutherford Appleton Laboratory (UK). 
;
; NAME
;
;      FREEBOUND_CH
;
; EXPLANATION
;
;      Calculates the free-bound (radiative recombination) continuum.
;
; INPUTS
;
;      TEMP    Temperature in K (can be an array).
;
;      WVL     Wavelength in angstroms (can be an array).
;
; OUTPUTS
;
;      INT     Free-bound continuum intensity in units of 
;              10^-40 erg cm^3/s/sr/Angstrom per unit emission measure 
;              ( integral(N_H N_e dh) in cm^-5) if a DEM is not defined. 
;
;              If DEM values are defined, it is assumed that they are given
;              as N_H N_e dh/dT.  The units are 10^-40 erg/cm^2/s/srAngstrom 
;
;              If T is given as a 1-D array, then the output will be a 
;              2-D array, with one element for each temperature and 
;              wavelength (but also see SUMT).
;
; OPTIONAL INPUTS
;
;      DEM_INT The intensity array is multiplied by a DEM number for 
;              each temperature. DEM_INT needs to be of the same size 
;              as TEMPERATURE. It is needed for the synthetic spectrum 
;              routines.
;
;      IZ     Only calculate continuum for the element with atomic 
;             number IZ
;
;      ION    (To be used in conjunction with IZ.) Calculated continuum 
;             for a single ion (IZ, ION).
;
; KEYWORDS
;
;      NO_SETUP If the procedure setup_elements has already been called 
;               then the keyword /nosetup should be set to avoid 
;               repeating this step
;
;      MIN_ABUND If set, calculates the continuum only from those 
;                elements which have an abundance greater than 
;                min_abund.  Can speed up the calculations.  For 
;                example:
;                   abundance (H)  = 1.
;                   abundance (He) = 0.085
;                   abundance (C)  = 3.3e-4
;                   abundance (Si) = 3.3e-5
;                   abundance (Fe) = 3.9e-5
;
;      PHOTONS  The output spectrum is given in photon units rather 
;               than ergs.
;
;      SUMT     When a set of temperatures is given to FREEBOUND_CH, the 
;               default is to output INTENSITY as an array of size 
;               (nwvl x nT). With this keyword set, a summation over 
;               the temperatures is performed.
;
;      VERBOSE  Output information from FREEBOUND_CH.
;
; COMMON BLOCKS
;
;      ELEMENTS
;
; CALLS
;
;      FREEBOUND_ION, SETUP_ELEMENTS, READ_KLGFB, GET_IEQ
;
; HISTORY
;
;      Ver.1, 24-Jul-2002, Peter Young
;
;      Ver.2, 26-Jul-2002, Peter Young
;           revised call to freebound_ion; corrected ion fraction problem
;      Ver.PoA, 18-Feb-2005, LiWei Lin 
;          Commented common block out and 
;          Added _extra keyword
;          Rename routine freebound_ch
;           
;-

;COMMON elements,abund,abund_ref,ioneq,ioneq_logt,ioneq_ref


IF n_params() LT 3 THEN BEGIN
  print,'Use:  IDL> freebound_ch, temp, wvl, int [, /no_setup, /sumt, /noverner,'
  print,'                        /verbose, /photons, min_abund= , dem_int= , '
  print,'                        iz= , ion= ]'
  return
ENDIF


IF n_elements(ion) NE 0 AND n_elements(iz) EQ 0 THEN BEGIN
  print,'%FREEBOUND_CH:  Error, please specify IZ when using ION'
  return
ENDIF

IF NOT keyword_set(no_setup) THEN BEGIN
  setup_elements
  no_setup=1
ENDIF

t1=systime(1)

IF n_elements(min_abund) EQ 0 THEN min_abund=0.

wvl=double(wvl)
temp=double(temp)
nt=n_elements(temp)
nwvl=n_elements(wvl)
int=dblarr(nwvl,nt)
ewvl=1d8/wvl

ident_wvl=make_array(nwvl,val=1.)
ident_t=make_array(nt,val=1.)

read_ip,!xuvtop+'/ip/chianti.ip',ionpot,ipref

read_klgfb,pe,klgfb
ksize=size(klgfb)
max_ngf=ksize(2)

IF NOT keyword_set(noverner) THEN BEGIN
  vdata=dblarr(10,465)
  dir=concat_dir(!xuvtop,'continuum')
  fname=concat_dir(dir,'verner_short.txt')
  openr,lun,fname,/get_lun
  readf,lun,vdata
  free_lun,lun
ENDIF


IF n_elements(iz) NE 0 THEN BEGIN
 ;
  ab=abund[iz-1]
  IF ab LT min_abund THEN GOTO,lbl2
  IF n_elements(ion) NE 0 THEN BEGIN
    ieq=get_ieq(temp,iz,ion+1,ioneq_logt=ieq_logt,ioneq_frac=ioneq)
    ip=ionpot[iz-1,ion-1]
    IF (total(ieq) NE 0.) THEN BEGIN
      freebound_ion,temp,wvl,int,iz,ion,ip=ip, $
           vdata=vdata,pe=pe,klgfb=klgfb,noverner=noverner
      int=int*ab*(ident_wvl#ieq)
    ENDIF
 ;
  ENDIF ELSE BEGIN
    FOR ion=1,iz DO BEGIN
      ieq=get_ieq(temp,iz,ion+1,ioneq_logt=ieq_logt,ioneq_frac=ioneq)
      ip=ionpot[iz-1,ion-1]
      IF total(ieq) NE 0. THEN BEGIN
        freebound_ion,temp,wvl,rad,iz,ion,ip=ip, $
             vdata=vdata,pe=pe,klgfb=klgfb,noverner=noverner
        rad=rad*ab*(ident_wvl#ieq)
        int=int+rad
      ENDIF
    ENDFOR
  ENDELSE
 ;
ENDIF ELSE BEGIN
 ;
  FOR iz=1,30 DO BEGIN
    ab=abund[iz-1]
    IF ab LT min_abund THEN GOTO,lbl1
    FOR ion=1,iz DO BEGIN
      ieq=get_ieq(temp,iz,ion+1,ioneq_logt=ieq_logt,ioneq_frac=ioneq)
      ip=ionpot[iz-1,ion-1]
      IF total(ieq) NE 0. THEN BEGIN
        freebound_ion,temp,wvl,rad,iz,ion,ip=ip, $
             vdata=vdata,pe=pe,klgfb=klgfb,noverner=noverner
        rad=rad*ab*(ident_wvl#ieq)
        int=int+rad
      ENDIF
    ENDFOR
    lbl1:
  ENDFOR
 ;
ENDELSE

lbl2:

IF n_elements(dem_int) NE 0 THEN BEGIN
  IF n_elements(dem_int) NE nt THEN BEGIN
    print,'%FREEBOUND_CH: Error, DEM_INT should have the same number of '+ $
         'elements as TEMP'
    return
  ENDIF
  demfactor=temp*0.1/alog10(exp(1))
  int=int* (ident_wvl # (dem_int*demfactor))
ENDIF

IF keyword_set(photons) THEN int=int*((wvl/1.9865d-8)#ident_t)

siz=size(int)
IF keyword_set(sumt) AND siz[0] EQ 2 THEN int=total(int,2)

t2=systime(1)

IF keyword_set(verbose) THEN $
  print,format='("% FREEBOUND_CH:  continuum calculated in ",f8.1," seconds")',t2-t1


END
