;+
; PROJECT     :  CHIANTI
;
;       CHIANTI is an Atomic Database Package for Spectroscopic Diagnostics of
;       Astrophysical Plasmas. It is a collaborative project involving the Naval
;       Research Laboratory (USA), the University of Florence (Italy), the
;       University of Cambridge and the Rutherford Appleton Laboratory (UK). 
;
; NAME
;
;     FREEFREE
;
; EXPLANATION
;
;     This routine computes the free-free continuum (bremsstrahlung) 
;     using the fitting formulae of Itoh et al. (ApJS 128, 125, 2000) 
;     and Sutherland (MNRAS 300, 321, 1998).
;
;     The Itoh et al. data are valid for smaller ranges for temperature 
;     and wavelength than Sutherland and so for points outside of their 
;     ranges we use the data of Sutherland.
;
; INPUTS
;
;    TEMP    Temperature (in K).
;
;    WVL     Wavelengths in angstroms. Can be a scalar or vector.
;
; OUTPUTS
;
;    INT     Free-free continuum intensity in units of 
;            10^-40 erg cm^3/s/sr/Angstrom  per unit emission measure 
;            [ integral(N_H N_e dh) in cm^-5 ] if a DEM is not defined. 
;
;            If DEM values are defined, it is assumed that they are given
;            as N_H N_e dh/dT.  The units are 10^-40 erg/cm^2/s/sr/Angstrom. 
;
;            If T is given as a 1-D array, then the output will be a 2-D array,
;            with one element for each temperature and wavelength 
;            (but also see SUMT).
;
; OPTIONAL INPUTS
;
;    DEM_INT An array of same length as TEMP which contains the 
;            differential emission measure values at each temperature. 
;            The emissivity at each temperature is multiplied by the 
;            DEM value and the d(logT) value.
;
;    MIN_ABUND This keyword allows the specification of a minimum abundance, 
;              such that any elements with an abundance (relative to 
;              hydrogen) less than MIN_ABUND will not be included in the 
;              calculation. E.g., MIN_ABUND=1e-5.
;
; KEYWORDS
;
;    NO_SETUP By default the routine asks the user which ion balance 
;             and abundance files to use via pop-up widgets. If 
;             /no_setup is used then this data is taken from the common 
;             block.
;
;    SUMT     The default is to output the intensity array as an array 
;             of size (nwvl x nT). Setting this keyword performs a sum 
;             over the temperatures to yield a vector of same size as 
;             the input wavelengths, thus producing the complete 
;             free-free spectrum.
;
;    PHOTONS  Gives output emissivity in photon units rather than ergs.
;
; CALLS
;
;    SUTHERLAND_CH, ITOH_CH
;
; COMMON BLOCKS
;
;    ELEMENTS
;
; PROGRAMMING NOTES
;
;    The Itoh fitting formula is only valid for (6.0 LE logT LE 8.5). 
;    For temperatures below this, we thus switch to the Sutherland 
;    fitting formula. There is very little (<1%) between the two at 
;    logT=6.
;
;    Itoh also has a constraint on the quantity u=hc/kTl (l=wavelength), 
;    such that (-4 LE log u LE 1.0). The upper limit corresponds to the 
;    continuum being cut-off prematurely at low wavelengths. E.g., for 
;    T=10^6 the cutoff is at 14.39 angstroms. For these low wavelengths 
;    we also use the Sutherland data to complete the continuum. Note that 
;    the continuum at these wavelengths is very weak
;
; MODIFICATION HISTORY
;
;    Ver.1, 5-Dec-2001, Peter Young
;         Completely revised to call the separate itoh.pro and 
;         sutherland.pro routines.
;
;    V. 2, 21-May-2002,  Giulio Del Zanna (GDZ),
;          Corrected the description of the  units.
;          Added verbose keyword and a printout.
;
;    V. 3, 22-May-2002,  Peter Young (PRY)
;          Added MIN_ABUND optional input.
;          Changed ioneq_t to ioneq_logt (GDZ).
;
;    V.PoA, 18-Feb-2005, LiWei Lin 
;          Commented common block out and 
;          Added _extra keyword
;          Rename routine freefree_ch
;          Edit calls to sutherland and itoh to sutherland_ch and itoh_ch
;-

PRO freefree_ch, temp, wvl, int, no_setup=no_setup, sumt=sumt, dem_int=dem_int, $
              photons=photons, min_abund=min_abund,  verbose=verbose,_extra=e

;COMMON elements,abund,abund_ref,ioneq,ioneq_logt,ioneq_ref

IF NOT keyword_set(no_setup) THEN BEGIN
   setup_elements
   no_setup=1
ENDIF

t1=systime(1)

temp=double(temp)
wvl=double(wvl)

IF n_elements(dem_int) NE 0 THEN BEGIN
   IF n_elements(dem_int) NE n_elements(temp) THEN BEGIN
      print,'%FREEFREE_CH: Warning, number of elements of DEM_INT must match'
      print,'  the number of temperatures. Freefree_Ch continuum not calculated.'
      return
   ENDIF
ENDIF
;
; For temperature below 10^6, the Sutherland data is used
;
ind=where(alog10(temp) LT 6.0)
IF ind[0] NE -1 THEN BEGIN
   temp1=temp[ind]
   IF n_elements(dem_int) NE 0 THEN dem1=dem_int[ind]
   sutherland_ch,temp1,wvl,int1,photons=photons, $
     dem_int=dem1,no_setup=1,min_abund=min_abund,_extra=e
   no_setup=1
ENDIF


ind=where(alog10(temp) GE 6.0)
IF ind[0] NE -1 THEN BEGIN
   temp2=temp[ind]
   IF n_elements(dem_int) NE 0 THEN dem2=dem_int[ind]
   itoh_ch,temp2,wvl,int_i,photons=photons, $
     dem_int=dem2,no_setup=1,min_abund=min_abundh,_extra=e 
   no_setup=1
                                ;
                                ; For wavelengths which lie outside Itoh's limits, use the Sutherland 
                                ; data
                                ;
   l_ind=where( alog10(wvl) LT alog10(1.439d8/min(temp2))-1.0 )
   IF l_ind[0] NE -1 THEN BEGIN
      sutherland_ch,temp2,wvl[l_ind],int_s,photons=photons, $
        dem_int=dem2,no_setup=1,min_abund=min_abund,_extra=e
      int2=int_i
      int2[l_ind,*]=int_s
      ind=where(int_i NE 0.)
      IF ind[0] NE -1 THEN int2[ind]=int_i[ind]
   ENDIF ELSE BEGIN
      int2=int_i
   ENDELSE
ENDIF


CASE 1 OF 
   n_elements(int1) EQ 0: int=int2
   n_elements(int2) EQ 0: int=int1
   ELSE: int=[[int1],[int2]]
ENDCASE

siz=size(int)

IF keyword_set(sumt) AND (siz[0] GT 1) THEN int=total(int,2)

IF keyword_set(verbose) THEN BEGIN 
   t2=systime(1)
   print,format='("% FREEFREE_CH: continuum calculated in ",f8.1," seconds")',t2-t1

;   Nh_Ne = proton_dens(alog10(temp),/hyd)
;   IF n_elements(temp) EQ 1 THEN $
;     print, 'Value of N_H/Ne =', Nh_NE ELSE $ 
;     print, 'Values of N_H/Ne =', Nh_NE
END  

END
