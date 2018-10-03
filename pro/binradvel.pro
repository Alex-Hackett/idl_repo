FUNCTION binradvel,phase,k=k,period=period,asini=asini,eccen=eccen, $
                   omega=xomega,gamma=gamma,degrees=degrees,t0=t0,t90=t90
;+
; NAME:
;         binradvel
;
;
; PURPOSE:
;         compute radial velocity of a binary system as a function of
;         orbital phase or time (if t0 or t90 are given)
;
;
; CATEGORY:
;         astronomy
;
;
; CALLING SEQUENCE:
;         vel=binradvel(phase,k=k,period=period,asini=asini,eccen=eccen, $
;                   omega=omega,gamma=gamma,degrees=degrees)
;
; INPUTS:
;          phase: array with the orbital phase points (from 0 to 1)
;                 for which the radial velocity is to be computed;
;                 if t0 or t90 are given: time in days (same time
;                 system as t0 or t90)
;
;          k    : velocity amplitude of the system
;          asini: value of a sin i in kilometers
;          period: orbital period, in days
;                 
;          NOTE: either k or  both, asini and period, must be given

;
;
; OPTIONAL INPUTS:
;          t0   : epoch of periastron (see above, description of "phase" argument)
;          t90  : epoch when mean longitude = 90 degrees 
;          omega: longitude of periastron (little omega; radians,
;                 default: 0.)
;          eccen: eccentricity (default: 0.)
;          gamma: systemic velocity (same units as k or in km/s; default:0.)
;
; KEYWORD PARAMETERS:
;          degrees: if set, angular arguments are in degrees instead
;                 of radian
;
; OUTPUTS:
;      the function returns the radial velocity as a function of the
;      phase in the units of k or of  asini/period 
;
;
; RESTRICTIONS:
;      * the eccentricity must be 0<=e<1
;      * only one of the arguments t0 and t90 is allowed
;
;
; PROCEDURE:
;      See chapter 3 of 
;         R.W. Hilditch, An Introduction to Close Binary Stars,
;         Cambridge Univ. Press, 2001
;
;
; EXAMPLE:
;
; Radial Velocity of HR7000
; (Hilditch, Fig. 3.27; Griffin et al., 1997, Fig. 2)
; npt=100
; phase=findgen(npt)/(npt-1)
; vel=binradvel(phase,k=21.68,gamma=-22.52,eccen=0.372,omega=306.5,/degrees)
;
; ; Show two orbits for clarity
; pp=[phase,1.+phase]
; vv=[vel,vel]
; plot,pp,vv,xtitle='Orbital Phase',ytitle='Radial Velocity [km/s]'
; xrange=!x.crange
; oplot,xrange,[0.,0.],linestyle=2
;
; MODIFICATION HISTORY:
;
; $Log: binradvel.pro,v $
; Revision 1.2  2005/02/18 21:41:23  wilms
; * added t0 and t90 arguments
;
; Revision 1.1  2002/09/09 14:52:04  wilms
; initial release
;
;-

  IF (n_elements(gamma) EQ 0) THEN gamma=0.
  IF (n_elements(eccen) EQ 0) THEN eccen=0.
  IF (n_elements(xomega) EQ 0) THEN xomega=0.

  omega=xomega
  IF (keyword_set(degrees)) THEN omega=omega*!DPI/180.

  IF (eccen LT 0. OR eccen GE 1.) THEN BEGIN 
      message,'Eccentricity must be between 0 and 1'
  ENDIF 

  IF ( n_elements(t0) NE 0  AND n_elements(t90) NE 0) THEN BEGIN 
      message,'Only one of t0 and t90 is allowed!'
  ENDIF 

  ;; radial velocity amplitude
  IF (n_elements(k) NE 0) THEN BEGIN 
      kampl=k
      IF (n_elements(asini) NE 0) THEN BEGIN 
          message,'Only one of k and asini keywords is allowed'
      ENDIF 
  ENDIF 

  ;; Amplitude
  IF (n_elements(kampl) EQ 0) THEN BEGIN 
      IF ( (n_elements(asini) EQ 0) OR (n_elements(period) EQ 0)) THEN BEGIN 
          message,'Need either k or asini and period'
      ENDIF 
      pseconds=period*86400d0
      kampl=2.*!dpi*asini/(pseconds*sqrt((1.-eccen)*(1.+eccen)))
  ENDIF 

  IF (n_elements(t0) NE 0 OR n_elements(t90) NE 0) THEN BEGIN 
      ;; compute mean anomaly from `phase' argument and t0/t90
      IF (n_elements(t90) NE 0) THEN BEGIN 
          ;; reduction t90 -> t0
          t0=t90+(omega - !dpi/2d0 )/(2d0*!dpi)  * period
      ENDIF 
      meananom=2.*!dpi* (phase-t0)/period
  ENDIF ELSE BEGIN 
      ;; Compute mean anomaly from orbital phase
      meananom=2.*!dpi*phase
  ENDELSE 

  ;; Now solve Kepler for each of the times
  eccanom=keplereq(meananom,eccen)

  ;; True anomaly from eccentric anomaly
  theta=2.*atan(sqrt((1.+eccen)/(1.-eccen))*tan(eccanom/2.))

  ;; Velocity amplitude
  vel=kampl*(cos(theta+omega)+eccen*cos(omega))+gamma

  return,vel
END 
