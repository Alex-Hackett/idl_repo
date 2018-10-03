;+
; $Id: acs_cr.pro,v 1.5 2001/08/17 18:11:12 lindler Exp $
;
; NAME:
;     ACS_CR
;
; PURPOSE:
;     Routine to combine ACS CCD images with cosmic ray removal using
;     routine CR_REJECT.
;
; CATEGORY:
;     ACS/Image
;
; CALLING SEQUENCE:
;     ACS_CR, list, h, data, err, eps, nused
; 
; INPUTS:
;     list - vector of observation id numbers or file names
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;   CHIP       - number of the WFC chip to process (1 or 2).  Default is to
;		 process both chips
;   OUTFILE    - name of output file to which to write results.
;                The default is to not write an output file.
;   READNOISE  - readnoise in electrons (default=4.5)
;   DISPLAY    - Flag.  If set, the routine will generate an
;                x-window display of the results
;   MULT_NOISE - Coefficient for multiplicative noise term -- helps
;                account for differing PSFs or subpixel image shifts.
;                default = (0.03)
;   VERBOSE    - If set, lots of output.
;   NSIG       - Rejection limit in units of pixel-to-pixel noise
;                (sigma) on each input image.  Can be specified as
;                an array, in which case the dimension gives the
;                maximum number of iterations to run.  
;                (Default = [8,6,4])
;   BIAS       - Set if combining biases (divides through by number
;                of images at end, since exposure time is 0).
;   DILATION   - Set to expand the cosmic rays around
;                the initially detected CR pixels.  The value gives
;                the width into which each CR pixel is expanded.
;                (Default = 0, no dilation)
;   DFACTOR    - Set to coefficient to be applied to error threshold
;                in region surrounding CRs if doing dilation.
;                (Default = 0.5 if dilation requested)
;   NOSKYADJUST- Set to disable adjusting the sky between the 
;                readouts for the CR rejection.  A non-sky-subtracted 
;                image is returned in either case.
;   NORMALIZE - set to normalized the exposure of the observations to the
;		 first observation using the median image values of the
;		 observation.  (i.e. the exposure time for the ith image
;		 will be adjusted to:
;		    exptime_i = exp_time_1*medain(image_i)/median(image_1)
;		 /NORMALIZE is intended for normalizing flat field observations
;		 to account for variation in the lamp intensity.  If 
;		/NORMALIZE is specified then /NOSKYADJUST is automatically
;		assumed.
;   NOCLEARMASK- By default, the mask of CR flags is reset before
;                every iteration, and a pixel that has been
;                rejected has a chance to get back in the game
;                if the average migrates toward its value.  If this
;                keyword is set, then any rejected pixel stays 
;                rejected in subsequent iterations.  Note that what 
;                stsdas.hst_calib.wfpc.crrej does is the same
;                as the default.  For this procedure, the default
;                was NOT to clear the flags, until 20 Oct. 1997.
;   NULL_VALUE - Value to use in resultant image for pixels where
;                all input values rejected.  Default=0
;
;     The following keywords control how the current guess at a CR-free
;     "check image" is recomputed on each iteration:
;
;       MEDIAN_LOOP  - If set, the check image for each iteration is
;                      the pixel-by-pixel median.  (Default is mean.)
;       MEAN_LOOP    - If set, the check image for each iteration is
;                      the pixel-by-pixel mean.  (Same as the default.)
;       MINIMUM_LOOP - If set, the check image for each iteration is
;                      the pixel-by-pixel minimum.  (Trivial case, mostly
;                      for testing.)
;
;     The following keywords allow the initial guess at a CR-free "check
;     image" to be of a different kind from the iterative guesses:
;
;       INIT_MED  - If set, the initial check image is
;                   the pixel-by-pixel median.  (Default is minimum.)
;       INIT_MEAN - If set, the initial check image is
;                   the pixel-by-pixel mean.  (Default is minimum.)
;       INIT_MIN  - If set, the initial check image is
;                   the pixel-by-pixel minimum.  (Same as the default.)
;
; OUTPUTS:
;     h - header for combined image
;     data - combined image (returned in electrons/not DN)
;     err - statistical error image
;     nused - number of pixels of component images used in each
;               pixel of "data" and "err"
;     eps - pixel-by-pixel data flags
;            61 - 1 pixel rejected from stack
;            62 - 2 pixels rej.
;            63 - 3 pixels rej.
;            64 - 4 pixels rej.
;            65 - 5 or more pixels rej.
;           239 - all pixels rej
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;   see CR_REJECT
;
; EXAMPLE:
;     1) Combine two images with id numbers id1 and id2 and return result as
;        image:
;	 ACS_CR, [id1,id2], header, image
;
;     2) Do the same, but display the results and write the output to file
;	 combine.fits:
;	 ACS_CR, [id1,id2], header, image, OUTFILE='combine.fits', /DISPLAY
;
; MODIFICATION HISTORY:
;     version 1.0 D. Lindler
;     version 1.1, Lindler, Jan 21, 1999, modified to not use saturated
;	pixels when at least one of the images has a non-saturated one.
;     version 1.2, Lindler, June 21, 2000, Added Chip Keyword  
;     version 1.3, McCann, Sept 15, 2000  - gain patched to gain*1.7 for
;                  WFC build B3, cleaned up, changed info header
;     version 1.4, Lindler, June 1, 2001, added call to acs_gain
;     version 1.5, Lindler, Added /NORMALIZE keyword input
;     version 1.6, Lindler, changed saturation limits to 75,000 for WFC and 
;				160,000 for HRC
;-
PRO ACS_CR, list, h, data, err, eps, nused, OUTFILE=outfile, $
            MULT_NOISE=mult_noise, NSIG=nsig,  $
            MEDIAN_LOOP=median_loop, MEAN_LOOP=mean_loop, $
            MINIMUM_LOOP=minimum_loop, INIT_MED=init_med, INIT_MIN=init_min, $
            INIT_MEAN=init_mean, BIAS=bias, $
            DILATION=dilation, DFACTOR=dfactor, VERBOSE=verbose, $
            DISPLAY=display, NOSKYADJUST=noskyadjust, MASK_CUBE=mask_cube, $
            NOCLEARMASK=noclearmask, NULL_VALUE=null_value, $
            READNOISE=readnoise, CHIP=CHIP, NORMALIZE = normalize

   VERSION = 1.5

   IF N_PARAMS(0) LT 1 THEN BEGIN
      PRINT, 'CALLING SEQUENCE: acs_cr,list,h,data,err,eps,nused'
      PRINT, 'KEYWORD INPUTS: outfile, mult_noise, nsig, median_loop, '
      PRINT, '                mean_loop, minimum_loop, init_med, init_min,'
      PRINT, '                init_mean, bias, dilation, dfactor,'
      PRINT, '                display, noskyadjust, noclearmask,'
      PRINT, '                null_value, verbose, mask_cube, normalize'	
      return
   ENDIF

   IF N_ELEMENTS(readnoise) EQ 0 THEN readnoise = 4.5
   IF N_ELEMENTS(mult_noise) EQ 0 THEN mult_noise = 0.03
   If keyword_set(normalize) then noskyadjust = 1
   IF N_ELEMENTS(dilation) EQ 0 THEN BEGIN
      dilation = 0
      dfactor = 0.0
   ENDIF
   IF (dilation NE 0) AND (N_ELEMENTS(dfactor) EQ 0) THEN dfactor = 0.5

   curwin = !D.WINDOW

;
; loop on files
;
   nfiles = N_ELEMENTS(list)
   FOR ifile=0,nfiles-1 DO BEGIN
;
; read image
;
      acs_read, list(ifile), h, data, /OVERSCAN, CHIP=chip
      gain = sxpar(h,'CCDGAIN')>1
      detid = STRTRIM(sxpar(h,'detectid'))
      IF detid EQ 'B3' THEN BEGIN ;WFC build with unoptimized gain
         gain = gain*1.7
         PRINT, 'Gain mult. by 1.7 for WFC data obtained w/ build=', detid
         data = TEMPORARY(data)*gain
       END ELSE BEGIN
         acs_gain,h,data
      END
;
; get relevant header info and determine noise from first image
;
      IF ifile eq 0 then begin
         detector = STRTRIM(sxpar(h,'detector'))
         IF (detector NE 'HRC') AND (detector NE 'WFC') THEN BEGIN
            PRINT, 'ACS_CR: ERROR - detector must be HRC or WFC'
            RETALL
         ENDIF
;
; set up data cube and exptime vector
;
         s = SIZE(data) & ns = s(1) & nl = s(2)
         cube = FLTARR(ns,nl,nfiles)
         epscube = BYTARR(ns, nl, nfiles)
         exptime = FLTARR(nfiles)
         input_mask = BYTARR(ns,nl,nfiles)
      ENDIF 
      cube(0,0,ifile) = data
      exptime(ifile) = sxpar(h,'exptime')
;
; flag saturated data
;
      IF detector EQ 'WFC' THEN saturate = 75000 ELSE saturate = 160000	
      saturate = saturate<(65534*gain)
      input_mask(0,0,ifile) = data LT saturate
   ENDFOR           ; for ifile
;
; just one image?  
;
   IF nfiles EQ 1 THEN BEGIN
      PRINT, 'ACS_CR: Single observation supplied: no cosmic ray '+ $
       'removal done'
      nadds = FIX(data*0)+1
      eps = (data GE saturate) * 190b
      err = SQRT((data>0) + readnoise^2)
      GOTO,done
   ENDIF
;
; If all images are sat at a px, then use them all to maintain continuity
;
   allbad=TOTAL(input_mask,3) EQ 0
   FOR i=0,nfiles-1 DO input_mask(0,0,i) = allbad OR input_mask(*,*,i)
;
; Normalize exposure times using median data values if requested.
;
   if keyword_set(normalize) then begin
   	median0 = median(cube(*,*,0))
	for i=1,nfiles-1 do begin
		mediani = median(cube(*,*,i))
		exptime(i) = exptime(0)*mediani/median0
	end
   end
;
; combine readouts
;
   gain = 1
   cr_reject, cube, readnoise, 0.0, gain, mult_noise, data, err, nused, $
    NSIG=nsig, MEDIAN_LOOP=median_loop, MEAN_LOOP=mean_loop, $
    MINIMUM_LOOP=minimum_loop, INIT_MED=init_med, INIT_MIN=init_min, $
    INIT_MEAN=init_mean, EXPTIME=exptime, BIAS=bias, $
    DILATION=dilation, DFACTOR=dfactor, VERBOSE=verbose, $
    NOSKYADJUST=noskyadjust, NOCLEARMASK=noclearmask, $
    MASK_CUBE=mask_cube,NULL_VALUE=null_value,input_mask=input_mask
;
; construct data quality image
;
   eps = allbad*190b ;flag saturated pixels
   wnu = WHERE(nused LT nfiles, cwnu)
   IF cwnu GT 0 THEN eps(wnu) = eps(wnu) > (60 + ((nfiles-nused(wnu))<5))
   wnu0 = where(nused le 0, cwnu0)
   IF cwnu0 gt 0 then eps(wnu0) = eps(wnu0) > 239
   FOR i=0,nfiles-1 DO eps = eps > (epscube(*,*,i)*mask_cube(*,*,i))
   IF NOT arg_present(mask_cube) THEN mask_cube = 0
   epscube = 0
;
; add history to the header
;
   sxaddpar,h,'exptime',TOTAL(exptime)
   sxaddpar,h,'ccdgain',1,'Converted to electrons by ACS_CR'
   hist = STRARR(4)
   hist(0) = 'ACS_CR version '+STRING(version,'(F4.1)')+ $
    ': CCD Cosmic Ray Removal'
   hist(1) = '   '+STRTRIM(nfiles,2)+' images combined with CR_REJECT'
   hist(2) = '   '+STRTRIM(cwnu,2)+' pixels affected by CRs'
   hist(3) = '   '+STRTRIM(cwnu0,2)+' pixels for which all inputs rejected'
   sxaddhist,hist,h
   sxaddpar,h,'NCOMBINE',nfiles,'Number of CR-SPLITS combined'
   IF KEYWORD_SET(verbose) OR (!DUMP GT 0) THEN PRINT,hist
   for i=0,n_elements(list)-1 do sxaddpar,h,'image'+STRTRIM(i+1,2),list(i)	
;
; display results
;
   IF KEYWORD_SET(display) THEN BEGIN
      strlist = ''
      FOR ititle=0,n_elements(list)-1 DO $
       strlist = strlist+','+STRTRIM(list(ititle),2)
      null = gettok(strlist,',')
      nlout = 512
      nsout = 512
      WINDOW,curwin+1,XS=nsout*2,YS=nlout,TITLE='ACS_CR '+strlist
      TVSCL,ALOG10(frebin(data,nsout,nlout)>0.1),0
      TVSCL,frebin(FLOAT(nused LT nfiles),nsout,nlout),1
      PLOTS,[nsout,nsout],[0,nlout],/DEV
   ENDIF
;
; write file
;
done:
   IF N_ELEMENTS(outfile) GT 0 THEN BEGIN
      fits_open,outfile,fcb,/WRITE
      fits_write,fcb,data,h,EXTNAME='SCI',EXTVER=1,EXTLEVEL=1
      IF N_ELEMENTS(err) GT 1 THEN $
       fits_write,fcb,err,h,EXTNAME='ERR',EXTVER=1,EXTLEV=1
      IF N_ELEMENTS(eps) GT 1 THEN $
       fits_write,fcb,eps,h,EXTNAME='EPS',EXTVER=1,EXTLEV=1
      fits_close,fcb
   ENDIF
;
; return user to original window
;
   IF (curwin NE -1) THEN WSET, curwin
   return
END
