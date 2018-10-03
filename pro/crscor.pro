;**********************************************************************
;+
;*NAME:
;    	CRSCOR        JUNE,1984
;
;*CLASS:
;    	Cross-correlation
;*PURPOSE:     
;
;    	To cross correlate two spectra and produce the velocity
;    	difference between them.
; 
;*CALLING SEQUENCE:
;     	CRSCOR,W1,F1,W2,F2,BEGL,ENDL,VDEL,DELV 
; 
;*PARAMETERS:
;     	W1,F1	(REQ) (I) (0) (S)
;             	Required wave and flux vector for first spectrum to be analyzed.
;
;     	W2,F2   (REQ) (I) (0) (S)
;             	Required wave and flux vector for 2ond spectrum to be analyzed.
;
;     	BEGL    (REQ) (I) (0) (F)
;             	Beginning wavelength for the cross-correlation, in the
;             	same units as the files to be correlated (default Angstroms)
;
;     	ENDL    (REQ) (I) (0) (F)
;             	Ending wavelength for the cross-correlation, in the same
;             	units as BEGL.
;
;     	VDEL    (REQ) (I) (0) (F)
;             	incremental velocity spacing of correlation function
;             	(8 - 10 km/sec is recommended for IUE high dispersion)
; 
;     	DELV    (REQ) (O) (0) (F)
;             	Required output parameter giving the velocity difference
;             	between the two spectra. Note, if more than one Gaussian 
;             	component is specified, only
;             	the first center value is output to DELV although all
;             	values are listed on the display)
; 
;*EXAMPLES:  
;
;     	CRSCOR,W1,F1,W2,F2,2680,2760,10,DELV
;         	cross correlates order 85 of LWR11326H with LWR7008H,
;         	producing the cross correlation function every 10 km/sec.
;  
;*INTERACTIVE INPUT:  
;
;     	The programs first presents the user with a graph of
;     	the two input files and notes whether either spectrum has
;     	been corrected for the earth + satellite velocity (applied to
;     	spectra processed after 10 Nov. 1981). It then computes the 
;     	normalized cross correlation function and displays 31 pts. over
;     	the interval +/- 15*VDEL. The user is then prompted with the 
;     	following options: 1) if a well-defined maximum is present the
;     	program can locate it automatically and determine its position
;     	by means of interpolation to zero in the first differences
;     	(finding the point of zero slope); 2) if it appears that a
;     	maximum exists outside the searched range, the range can be
;     	doubled and the function replotted; 3,4,..) if Gaussian fitting
;     	is desired, (e.g. if more than one real maximum appears present)
;     	then the cross-correlation function may be fit interactively
;     	with 1,2,.. components (as determined by GAUSSFIT). GAUSSFIT
;     	removes a constant baseline before fitting the Gaussians using
;     	the region outside the region specified by the user as the
;     	feature to be fitted.  The user indicates with the cursor the 
;     	approximate location and height of each component to be fit.
;
;
;*FILES USED:
;
;     	The two files specified in the calling sequence are read, but
;     	not altered. 
;
;*SUBROUTINES CALLED:
;
;    	LINFIT
;    	TABINV
;    	QUADTERP
;    	GAUSSFITS
;       XYREADS
;    	CRSTRIM - checks wavelength limits, extracts data between 
;    	          wavelength limits, and interpolates to a log wavelength
;    	          scale
;    	CRSPROD - computes a normalized cross-correlation function
;    	CRSMAX - determines maximum of cross-correlation function
; 
;*PROCEDURE: 
;
;     	While for most IUE applications the range (ENDL - BEGL) is
;     	much less than the wavelengths involved, it is more precise
;     	to find the shift in log lambda space instead of lambda directly
;     	(since dL/L = cnst). The two arrays of wavelengths and fluxes are
;     	interpolated using QUADTERP to a common set of equally spaced
;     	log lambda points, with spacing corresponding to a velocity VDEL
;     	at the midpoint wavelength (BEGL+ENDL)/2. The mean flux for each
;     	spectrum is subtracted from that flux array, and the resulting
;     	arrays of positive and negative values are shifted with respect
;     	to each other to find the sum of the products at each shift.
;     	The array of product sums vs. shift is normalized to become the
;     	'normalized cross-correlation function'. If the user wants to
;     	fit several Gaussians to the cross correlation function, 
;     	GAUSSFIT fits the heights, widths, and central velocities for the
;     	specified number of components. It also computes the standard 
;     	deviations of these parameters using the value computed from the
;     	baseline portion of the correlation function as the standard
;     	deviation of a single point. For correlation functions with
;     	a single well-defined maximum, the velocity shift can be 
;     	calculated automatically by a weighted least squares fit to the
;     	1st differences and interpolating to the point of zero slope.
;     	The weighting gives higher weight to points close to the midpoint
;     	of the correlation function.
;     	The output includes a plot of the cross correlation function,
;     	and the velocity shift determined from the maximum of the cross
;     	corrrelation function. If Gaussian fitting is used, the standard
;     	deviation of a single point is printed as are the values for
;     	the Gaussian parameters and their errors. A plot shows the data,
;     	the individual Gaussians, the sum of all components, and the
;     	deviations.
; 
;*NOTES: 
;
;     	When a Gaussian fit is made to the cross correlation
;     	function, GAUSSFITS uses the following symbols for output:
;     	        - histogram: data points
;     	        - solid line: the total fit, the sum of all Gaussian 
;     	                components and the baseline
;     	        - dots: individual Gaussian components
;     	        - plus signs: O-C deviations from the fit
;  
;     	  For images processed before 10 Nov. 1981, the user should
;     	determine the orbital velocity corrections (see VSUNSAT).
;     	Corrections may also be needed for velocity-like shifts due to
;     	IUE camera effects (see ASSESS).
;     	  If a reasonable amount of correlation exists between the 2
;     	spaectra, a well-defined maximum will be present, often
;     	Gaussian in character but often with asymmetrical wings and
;     	secondary inflections which may or may not have significance.
;     	Note: if a spectrum has a strong slope, this can distort the
;     	function relative to what would be obtained from spectral
;     	lines with a flat continuum; a procedure such as NORM should
;     	be used in this case before storing the file. 
;     	  The precise maximum of the function can be found either by
;     	fitting a Gaussian function in the vicinity of the peak or by
;     	locating the shift value for which the slope of the function
;     	is zero. It was found that the procedure using the
;     	first differences of the function, locates this value with
;     	a precision better than 0.1*VDEL or about 1 km/sec generally.
;  
;*MODIFICATION HISTORY:
;
;          Sept. 1981   S. Parsons    CSC   initial program, adapted from
;                                           a FORTRAN program by M. Slovak
;                                           of the University of Texas.
;          Apr.  1982   F.H. Schiffer GSFC  program brought into agreement
;                                           with RDAF standards
;          Jun.  1984   N.R. Evans    GSFC  to test, document, alter output,
;                                           permit fitting of the correlation
;                                           function by Gaussian(s), and to
;                                           determine the errors for fitting
;                                           parameters.
;      18  Jul.  1984   RWT           GSFC  replaced subroutine PLPARM with
;                                           call to PLTPARM, use LINFIT in
;                                           first difference calculation, and 
;                                           update documentation.
;       8  Aug.  1984   RWT           GSFC  modified to use new version of 
;                                           LINFIT.
;       8  Nov.  1985   RWT           GSFC  DIDL modifications, NELEMENTS,
;                                           FINDGEN, and indirect compilation
;      14  Mar.  1987   RWT           GSFC  VAX mods: add PARCHECK, use 
;                                           SET_XY, remove some EXTRACs
;      23  Sept. 1987   RWT           GSFC  compile RDAF version of GAUSSFIT,
;                                           not IDL user's library procedure
;                                           of the same name, and add listing
;                                           of procedure call.
;       8  Oct.  1987   CAG           GSFC  Alter GAUSSFIT call to GAUSSFITS,
;                                           to reflect change of procedure 
;                                           name. Convert BEGL and ENDL to
;                                           be floating point, and correct one
;                                           format statement. 
;      14  Oct.  1987   RWT           GSFC  remove subroutine NETVEL, and
;                                           compilation for PARCHECK.
;      16  Nov.  1987   RWT           GSFC  improve plot annotation.
;      19  Jan.  1988   RWT           GSFC  correct error for image numbers
;                                           larger than 32767.
;       5  May   1988   CAG           GSFC  add VAX RDAF-style prolog.
;      23  Aug   1989   RWT           GSFC  Unix mods.
;       4  Mar   1991  JKF/ACC    - moved to GHRS DAF (IDL Version 2)
;      15  JAN	 1993  JKF/ACC	  - removed parameters from OPLOT command.
;-
;**********************************************************************
pro crscor,w1,f1,w2,f2,begl,endl,vdel,delv
npar = n_params()
if npar eq 0 then begin
   print,' CRSCOR,W1,F1,W2,F2,BEGL,ENDL,VDEL,DELV
   retall & end
;parcheck,npar,8,'crscor'
print,' '
print,' Generating plot of normalized interpolated flux vs. log lambda'
;
; force the beginning and end wavelengths to be floating point
;
begl=float(begl)
endl=float(endl)
;
; set km/s resolution
;
n1 = n_elements(w1)
n2 = n_elements(w2)
mi = fix(599586. * (endl - begl) / (begl + endl) / vdel +.5) + 1
rwlog = findgen(mi) * (alog10(endl) - alog10(begl)) / (mi-1)
;
; extract and interpolate data to log-lambda scale
;
jump=0
crstrim,begl,endl,w1,f1,n1,rwlog,ffir,m1,jump
crstrim,begl,endl,w2,f2,n2,rwlog,fsec,m2,jump
if jump eq 0 then begin                                 ;data satisfactory
;
; plot the results of the data extraction
;
   plot,rwlog,ffir/max(ffir)+0.6,psym=0,xstyle=1,ystyle=1,  $
	xrange=[rwlog(0),rwlog(mi-1)],yrange=[0.0,2.0]
   oplot,rwlog,fsec/max(fsec),psym=0	
   hpos = !d.x_ch_size
   vpos = !d.y_size - !d.y_ch_size
   vspace = 1.1 * !d.y_ch_size
   stf = '(t10,"(abscissa is log lambda -",f7.4,")")'
   st = string(format=stf,alog10(begl))
   xyouts,hpos,vpos-vspace,font=0,/device,st
   stf = '(1x,i4," points extracted from",i4," (file2), interpolated to")' 
   st = string(format=stf,m2,n2) 
   xyouts,hpos,vpos-2*vspace,font=0,/device,st
   stf = '(1x,i4," points in log lambda with spacing",e11.4)'
   st = string(format=stf,mi,rwlog(1))
   vpos = vpos - 3*vspace
   xyouts,hpos,vpos,font=0,/device,st
;
; cross-correlate the data arrays
;
   vpos = vpos - vspace
   xyreads,hpos,vpos,inp,/device, $
      '--  type 1 (one) to proceed, 0 (zero) to end --'
   if inp eq 1 then begin ;correlation
      nspr = 15                                    ;initial size of correlation
      repeat begin                                 ;satisfactory correlation
        if inp eq 2 then begin                     ;double range
           nspr=nspr+nspr
           xyouts,hpos,vpos-vspace,font=0,/device,' doubling range '
           end  ; double range 
        crsprod,ffir,fsec,nspr,cross,crmin,crmax
        vspac=(indgen(n_elements(cross))-nspr) * 599586. *  $ 
	       (endl-begl)/(endl+begl)/(mi-1)
;
; plot results of correlation
;
       plot,vspac,cross,psym=6,xrange=[min(vspac),max(vspac)],  $
	     yrange=[-0.10,1.15]
       vpos = !d.y_size - !d.y_ch_size
       vpos = vpos - vspace
       stf = '(" min",e10.3,", max",e10.3)'
       stf2 = '("     wavelengths:",f7.1," to",f7.1,"A")'
       st = string(format=stf,crmin,crmax) + string(format=stf2,begl,endl)
       xyouts,hpos,vpos,font=0,/device,st
;
; get user's fitting preference
;
        st1 = ' -- type 1 (one) to proceed if maximum well defined -'
        st2 = ' -- type 2  to double the searched velocity range -'
        st3 = ' -- type (2+n)  to fit n gaussian components -' 
	vpos = vpos - vspace
        xyouts,hpos,vpos,font=0,/device,st1
        xyouts,hpos,vpos-vspace,font=0,/device,st2
        xyouts,hpos,vpos-2*vspace,font=0,/device,st3
	xyouts,hpos,vpos-3*vspace,font=0,/device,'?'
        xyreads,hpos,vpos-3*vspace,inp,/device
      end until inp ne 2 ;satisfactory correlaton
;
;     find maximum
;
     if inp ge 1 then begin    
	vpos = vpos - 4*vspace
        crsmax,cross,vspac,inp-2,delv,sigy,hpos,vpos
        if inp lt 4 then begin
          if sigy ne 0 then begin
             st = string(format='(1x,a,f7.2," km/s")', $ 
	     'standard deviation of a single point is',sigy)
	     vpos = vpos + vspace
             xyouts,hpos,vpos,font=0,/device,st
	     end
          st = string(format='(1x,a,f8.3," angstroms")', $
           'corresponding wavelength shift is',delv*(begl+endl)/599586.)
          xyouts,hpos,vpos-vspace,font=0,/device,st
          end
      end  ;find maximum
    end    ;correlation
  end      ;data satisfactory
  return
  end   ;crscor
