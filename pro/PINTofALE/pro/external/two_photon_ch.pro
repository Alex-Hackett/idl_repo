;+
;
; PROJECT:  CHIANTI
;
;       CHIANTI is an Atomic Database Package for Spectroscopic Diagnostics of
;       Astrophysical Plasmas. It is a collaborative project involving the Naval
;       Research Laboratory (USA), the University of Florence (Italy), the
;       University of Cambridge and the Rutherford Appleton Laboratory (UK). 
;
;
; NAME:
;	TWO_PHOTON
;
; PURPOSE:
;
;	Calculate the 2 photon continuum from a hot, low density plasma.
;
;       For the hydrogen isoelectronic sequence, A values
;             Parpia, F. A., and Johnson, W. R., 1982, Phys. Rev. A, 26, 1142.
;       and distribution function as a function of Z is taken from: 
;             Goldman, S.P. and Drake, G.W.F., 1981, Phys Rev A, 24, 183
;
;       For the helium isoelectronic sequence, A values are from:
;             Drake, G.W.F., 1986, Phys. Rev. A, 34, 2871
;       and the distribution function as a function of Z is taken from:
;             Drake, G.W.F., Victor, G.A., Dalgarno, A., 1969, Phys. 
;             Rev. A, 180, 25.
;       in this paper the distribution is only given up to Z=10 but  
;       extrapolation to higher Z appears to be OK.
;
;       Note that, unlike the freefree and freebound routines, two_photon 
;       requies the electron density to be specified. This is because there 
;       is a call to pop_solver
;
; CALLING SEQUENCE:
;
;       TWO_PHOTON,temperature, density, wavelength, intensity
;
;
; INPUTS:
;
;	TEMPERATURE   Temperature in degrees Kelvin, can be a 1D array
;
;       WAVELENGTH    Wavelengths in Angstroms.
;
;
; OPTIONAL INPUTS:
;
;       DENSITY       Electron density in cm^-3, can also be a 1D array 
;                     of the same size as Temperature. If there are several 
;                     temperatures specified but only one density, then 
;                     density is assumed the same at all temperatures.
;                     If not specified, then default densities of 10^10 
;                     electrons/cm^3 are assumed.
;
;       DEM_INT An array of same length as TEMP which contains the 
;               differential emission measure values at each temperature. 
;               The emissivity at each temperature is multiplied by the 
;               DEM value and the d(logT) value.
;	
; KEYWORD PARAMETERS:
;
;	NO_SETUP:   If the procedure setup_elements has already been called 
;                   then the keyword /no_setup should be set to avoid 
;                   repeating this step
;
;       MIN_ABUND:  If set, calculates the continuum only from those 
;                   elements which have an abundance greater than min_abund.  
;                   Can speed up the 
;                   calculations.  For example:
;                   abundance (H)  = 1.
;                   abundance (He) = 0.085
;                   abundance (C)  = 3.3e-4
;                   abundance (Si) = 3.3e-5
;                   abundance (Fe) = 3.9e-5
;
;       SUMT        If several temperatures have been specified, then /sumt 
;                   will sum the emissivities over the different 
;                   temperatures, giving an output INTENSITY that has the 
;                   same size as WAVELENGTH.
;
;       PHOTONS     If set the continuum emissivity is output in photon 
;                   units rather than erg units.
;
;       VERBOSE
; 
; OUTPUTS:
;
;	RAD         2 photon continuum intensity in units of
;                   10^-40 erg cm^3/s/sr/Angstrom  per unit emission measure 
;                   ( integral(N_H N_e dh) in cm^-5) if a DEM is not defined. 
;
;                   If DEM values are defined, it is assumed that they are given
;                   as N_H N_e dh/dT.  The units are 
;                   10^-40 erg/cm^2/s/sr/Angstrom 
;
;            If T is given as a 1-D array, then the output will be a 2-D array,
;            with one element for each temperature and wavelength 
;            (but also see SUMT).
;
;
;
; CALLS
;
;       POP_SOLVER, SETUP_ION, SETUP_ELEMENTS, READ_MASTERLIST,
;       CONVERTNAME
;
; COMMON BLOCKS:
;
;       ELEMENTS, ELVLC, WGFA, UPSILON, PROTON
;
; EXAMPLE:
;
;             > two_photon,1.e+6,3.e+10,wvl,int
;             > two_photon,1.e+6,3.e+10,wvl,int,min_abund=3.e-5
;             > two_photon,1.e+6,3.e+10,wvl,int,/no_setup
;
; PROGRAMMING NOTES
;
;    For He 2-photon decays, the distribution function is from Table II 
;    of Drake et al. (1969), except that the values have been divided by 
;    the A-value from Drake (1986).
;
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Dere
;	February 2001:  Version 1.0
;
;       Ver.2, 19-Dec-2001, Peter Young
;           Now allows an array of temperatures.
;           Added /SUMT keyword.
;           Added DEM_INT= optional input.
;           Switched to using spl_init & spl_interp for the spline fits.
;           Corrected a small bug.
;
;       Ver.3, 20-Dec-2001, Peter Young
;           Corrected a bug related to density indices.
;
;       Ver.4, 23-Apr-2002, Peter Young
;           Added /photons keyword.
;
;       Ver.5, 28-May-2002, Peter Young
;           Corrected way in which DEM_INT is handled.
;
;       V. 6, 28-May-2002, Giulio Del Zanna (GDZ)
;                   generalized directory concatenation to work for
;                   Unix, Windows  and VMS. 
;             Corrected the description of the  units and various
;             inaccuracies in the header.
;    
;       V.7, 14-Aug-02, GDZ
;             Added keyword VERBOSE
;
;       V.8,  4-Oct-2003, GDZ
;                  modified the input to POP_SOLVER, now it is dealt with an
;                  input structure.
;       V.PoA, 25-Feb-2004, LiWei Lin 
;             Commented common block out and 
;             Added _extra keyword
;             Added NeNh keyword to avoid calling proton dens 
;             Exchanged popsol() for pop_solver for PoA convenience. 
;               popsol() puts a_value in required 2D format while 
;               for pop_solver this is done in a mother CHIANTI routine 
;               e.g. ch_synthetic. 
;             Renamed routine two_photon_ch
;-
pro two_photon_ch,temperature,wvl,rad, no_setup=no_setup, $
               min_abund=min_abund, masterlist=masterlist, $
               sngl_ion=sngl_ion, sumt=sumt, dem_int=dem_int, $
               photons=photons, edensity=edensity, verbose=verbose,$ 
               abund=abund,ioneq=ioneq,ieq_logt=ieq_logt,_extra=e

;  to calculate the two photon radiation vs. wavelength (Angstroms)
;
;  units are ergs cm^3 s-1 str^-1 Ang^-1 per unit emission measure
;
;common elements,abund,abund_ref,ioneq,ieq_logt,ioneq_ref
;common elvlc,l1a,term,conf,ss,ll,jj,ecm,eryd,ecmth,erydth,eref
;COMMON wgfa, wavel,gf,a_value
;COMMON upsilon,splstr
;COMMON proton, pstr, pe_ratio

;-------------------------------------------------------------------
;{LL:      Begin PoA setup. Note that pe_ratio is now replaced 
;          by keyword nenh and is by default 0.83 if not set. Done 
;          to avoid reading in ioneq file.   
;-------------------------------------------------------------------
; if keyword_set(chline) then begin ; if keyword exists then parse
;     wavel  = chline.wvl  & gf = chline.gf & a_value = chline.a 
;     splstr = chline.splstr
;     pstr = chline.psplstr
;     ecm  = chline.ecmobs & ecmth = chline.ecmthr & jj = chline.j
; endif else begin ; if not then exit0
;    print, 'Need chline structure from rd_chianti()' 
;    return 
; endelse
 if not keyword_set(ne_nh) then pe_ratio = temperature-temperature + 0.83 


;-------------------------------------------------------------------
;LL:       End PoA setup 
;-------------------------------------------------------------------


if n_params(0) lt 3 then begin
  print,'   IDL> two_photon_ch,temperature,wavelength,intensity '
  print,'              [,/no_setup, min_abund= , dem_int= , /sumt '
  print,'               ,masterlist= , sngl_ion= , edensity= ]'
  return
endif

t1=systime(1)

kb=1.38062d-16   ;  erg deg-1
h=6.6262d-27
c=2.997925d+10
ryd=2.17992d-11  ; erg
factor=h*c/(4.*!pi)
rescale=1.d+40
;
;
temperature=double(temperature)
wvl=double(wvl)
nwvl=n_elements(wvl)
nt=n_elements(temperature)
;
rad=dblarr(nwvl,nt)
distr=dblarr(nwvl)

IF n_elements(edensity) EQ 0 THEN BEGIN
  edensity=1d10
  print,'% TWO_PHOTON_CH: EDENSITY not specified, assuming 10^10.'
ENDIF

IF n_elements(edensity) EQ 1 THEN edens=dblarr(nt)+edensity $
     ELSE edens=edensity

dem_tst=0
IF n_elements(dem_int) NE 0 THEN BEGIN
  IF n_elements(dem_int) NE nt THEN BEGIN
    print,'% TWO_PHOTON_CH: Warning, number of elements of DEM_INT must match the'
    print,'  number of temperatures. DEM_INT will not be included.'
    dem_arr=dblarr(nt) + 1.
  ENDIF ELSE BEGIN
;    IF nt EQ 1 THEN demfactor=1d0 ELSE demfactor=temperature*0.1/alog10(exp(1))
    demfactor=temperature*0.1/alog10(exp(1))
    dem_arr= dem_int*demfactor
  ENDELSE
ENDIF ELSE BEGIN
  dem_tst=1
  dem_arr=dblarr(nt) + 1.
ENDELSE



;  read master list of ions
;
if datatype(masterlist,2) gt 0 then begin
   mname=masterlist
endif else begin
mname=concat_dir(concat_dir(!xuvtop,'masterlist'), 'masterlist.ions')
endelse
;
if keyword_set(sngl_ion) then begin
   list=sngl_ion
endif else read_masterlist,mname,list
;
nlist=n_elements(list)
;
if not keyword_set(no_setup) then setup_elements
;
n_ioneq_t=n_elements(ieq_logt)


;
;   read in hydrogen sequence two photon data  *************
;
datafile=concat_dir(concat_dir(!xuvtop,'continuum'), 'hseq_2photon.dat')
;
openr,luw,datafile,/get_lun
;
y0=fltarr(17)
readf,luw,y0
;
z0=fltarr(4)
readf,luw,z0
;
nz=30
avalue=fltarr(nz)
asum=fltarr(nz)
psi0=fltarr(17,nz)  ;  psi is the 2 photon distribution function
;                      psi for H- and He-like are normalized differently
f1=fltarr(19)
i1=1
;
for iz=0,nz-1 do begin
   readf,luw,i1,f1
   avalue(iz)=f1(0)
   asum(iz)=f1(1)
   psi0(0,iz)=f1(2:*)
endfor
;
free_lun,luw
;
;   psi is properly normalized to give an integral of 2.0
;
;   finished reading in 2 photon data for hydrogen
;
;
;  ********  first go through for hydrogen   *******************************
;
for ilist=0,nlist-1 do begin
;
   gname=list(ilist)
   convertname,gname,iz,ion
;
;
hydrogentest = (iz-ion) eq 0
;
;
if hydrogentest then begin
;
;
   this_abund=abund(iz-1)
;
   if keyword_set(min_abund) then begin
        abundtest = this_abund gt min_abund
   endif else abundtest = this_abund gt 0.
;
if abundtest then begin
 ;
  this_ioneq=ioneq(*,iz-1,ion-1)
  
  ind_i=where(this_ioneq gt 0.,ngt)
  IF ngt GE 2 THEN BEGIN
    goodt=ieq_logt[ind_i]
    goodi=this_ioneq[ind_i]
   ;
    ltemp=alog10(temperature)
    t_ind=where( (ltemp GE min(goodt)) AND (ltemp LE max(goodt)) )
    IF t_ind[0] NE -1 THEN BEGIN
      y2=spl_init(goodt,alog10(goodi))
      ioneq1=spl_interp(goodt,alog10(goodi),y2,ltemp[t_ind])
      ioneq1=10.^ioneq1
      temps=temperature[t_ind]
    ENDIF ELSE BEGIN
      ioneq1=0.
    ENDELSE
  ENDIF ELSE BEGIN
    ioneq1=0.
  ENDELSE  
 ;
  ioneqtest=ioneq1[0] gt 0.
 ;
 ;
if ioneqtest then BEGIN
 ;
 ;     setup_ion,gname,-1,-1,wvlts,tlvl1,lvl2,wvl1,gf1,a_value1
 ;---------------------------------------------------------------
 ;{LL use rd_chianti instead of setup_ion}  
  chline= rd_chianti(iz,ion) & ecm = chline.ecmobs
 ;---------------------------------------------------------------
  wvl0=1.d+8/(ecm(1)-ecm(0))
  w_ind = where(wvl gt wvl0,wvltest)
 ;

  if wvltest gt 0 then begin

;-----------------------------------------------------------------
;{LL replaced with chline} 
;input = {gname:gname, jj:jj, ecm:ecm,ecmth:ecmth, $
; wvl:wvl, a_value:a_value, splstr:splstr, $
; pe_ratio:pe_ratio,prot_struc:pstr }
;-----------------------------------------------------------------
    y=wvl0/wvl[w_ind]

    y2=spl_init(y0,psi0[*,iz-1])
    distr=y*spl_interp(y0,psi0[*,iz-1],y2,y)/asum[iz-1]/wvl[w_ind]

    nt=n_elements(temps)
    FOR i=0,nt-1 DO BEGIN
;      pop_solver,input, temps[i],edens[t_ind[i]],pop
;--------------------------------------------------------------------
;{LL use popsol() instead of pop_solver} for PoA convenience} 
       pop = popsol(temps[i],1e15,chline,n_e=edens[t_ind[i]],_extra=e) 
;---------------------------------------------------------------------
      IF keyword_set(photons) THEN BEGIN
        distr1=rescale/4d0/!pi*avalue[iz-1]*this_abund* $
             distr * $
             (ioneq1[i]*pop[1]/edens[t_ind[i]]) * dem_arr[t_ind[i]]
     ENDIF ELSE BEGIN
        distr1=rescale*factor*1d8*avalue[iz-1]*this_abund* $
             (distr/wvl[w_ind]) * $
             (ioneq1[i]*pop[1]/edens[t_ind[i]]) * dem_arr[t_ind[i]]
      ENDELSE
      rad[w_ind,t_ind[i]]=rad[w_ind,t_ind[i]]+distr1
    ENDFOR
   ;
  ENDIF                         ;  wvl test
;
endif  ;  ioneq test
;
endif  ;  abundance test
;
endif  ;  hydrogentest
;
endfor  ; ilist

t2=systime(1)

;
;  now go through for the  helium iso-electronic sequence
;
;
datafile=concat_dir(concat_dir(!xuvtop,'continuum'), 'heseq_2photon.dat')
;
openr,luw,datafile,/get_lun
;
y0=fltarr(41)
readf,luw,y0
;
nz=30
avalue=fltarr(nz)
psi0=fltarr(41,nz)
;
f1=fltarr(42)
i1=1
;
FOR iz=1,nz-1 DO BEGIN
  readf,luw,i1,f1
  avalue(iz)=f1(0)
  psi0(0,iz)=f1(1:*)
ENDFOR 
;
free_lun,luw



for ilist=0,nlist-1 do BEGIN
;
;    heliumtest=0
;    bits=str_sep(gname,'d')
;    IF n_elements(bits) EQ 1 THEN BEGIN
;      gname=list(ilist)
;      convertname,gname,iz,ion
;      IF (iz-ion EQ 1) THEN heliumtest=1
;    ENDIF

   bits=str_sep(gname,'d')
   IF n_elements(bits) EQ 1 THEN dielectronic=0 ELSE dielectronic=1

   gname=list(ilist)
   convertname,gname,iz,ion
   heliumtest=iz-ion EQ 1

if heliumtest then begin
;
;
   this_abund=abund(iz-1)
;
   if keyword_set(min_abund) then begin
        abundtest = this_abund gt min_abund
   endif else abundtest = this_abund gt 0.
;
if abundtest then begin
;
  this_ioneq=ioneq(*,iz-1,ion-1+dielectronic)
  
  ind_i=where(this_ioneq gt 0.,ngt)
  IF ngt GE 2 THEN BEGIN
    goodt=ieq_logt[ind_i]
    goodi=this_ioneq[ind_i]
   ;
    ltemp=alog10(temperature)
    t_ind=where( (ltemp GE min(goodt)) AND (ltemp LE max(goodt)) )
    IF t_ind[0] NE -1 THEN BEGIN
      y2=spl_init(goodt,alog10(goodi))
      ioneq1=spl_interp(goodt,alog10(goodi),y2,ltemp[t_ind])
      ioneq1=10.^ioneq1
      temps=temperature[t_ind]
    ENDIF ELSE BEGIN
      ioneq1=0.
    ENDELSE
  ENDIF ELSE BEGIN
    ioneq1=0.
  ENDELSE  
 ;
  ioneqtest=ioneq1[0] gt 0.
 ;
 ;
if ioneqtest then BEGIN
 ;
 ; setup_ion,gname,-1,-1,wvltst,lvl1,lvl2,wvl1,gf1,a_value1
;---------------------------------------------------------------------
;{LL use rd_chianti instead of setup_ion}  
  chline= rd_chianti(iz,ion) & ecm = chline.ecmobs
;---------------------------------------------------------------------
  wvl0=1.d+8/(ecm(2)-ecm(0))
  w_ind = where(wvl gt wvl0,wvltest)
 ;
  if wvltest gt 0 then begin

;---------------------------------------------------------------------
;{LL replace with chline} 
; input = {gname:gname, jj:jj, ecm:ecm,ecmth:ecmth, $
; wvl:wvl, a_value:a_value, splstr:splstr, $
; pe_ratio:pe_ratio,prot_struc:pstr }
;---------------------------------------------------------------------
    y=wvl0/wvl[w_ind]

    y2=spl_init(y0,psi0[*,iz-1])
    distr=y*spl_interp(y0,psi0[*,iz-1],y2,y)/wvl[w_ind]

    nt=n_elements(temps)
    FOR i=0,nt-1 DO BEGIN
;      pop_solver, input, temps[i],edens[t_ind[i]],pop
;---------------------------------------------------------------------
;{LL use popsol() instead of pop_solver} for PoA convenience} 
       pop = popsol(temps[i],1e15,chline,n_e=edens[t_ind[i]],_extra=e) 
;---------------------------------------------------------------------
      IF keyword_set(photons) THEN BEGIN
        distr1=rescale/4d0/!pi*avalue[iz-1]*this_abund* $
             distr * $
             (ioneq1[i]*pop[2]/edens[t_ind[i]]) * dem_arr[t_ind[i]]
      ENDIF ELSE BEGIN
        distr1=rescale*factor*1d8*avalue[iz-1]*this_abund* $
             (distr/wvl[w_ind]) * $
             (ioneq1[i]*pop[2]/edens[t_ind[i]]) * dem_arr[t_ind[i]]
      ENDELSE
      rad[w_ind,t_ind[i]]=rad[w_ind,t_ind[i]]+distr1
    ENDFOR
   ;
  ENDIF                         ;  wvl test
ENDIF
;
endif  ;  abundance test
;
endif   ;  helium sequence test
;
endfor;  ilist

IF keyword_set(sumt) AND (n_elements(temperature) GT 1) THEN rad=total(rad,2)

t3=systime(1)

IF keyword_set(verbose) THEN $
print,format='("% TWO_PHOTON_CH: continuum calculated in ",f8.1," seconds")',t3-t1

end

