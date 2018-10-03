;+
; $Id: eval_doc.pro,v 1.4 2001/11/05 22:50:43 mccannwj Exp $
;
; NAME:
;     EVAL_DOC
;
; PURPOSE:
;     Print an image evaluation document for an ACS_LOG entry number.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     EVAL_DOC, entry [,/FILE, /BLANK]
; 
; INPUTS:
;     entry - ACS_LOG database entry number
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     FILE  - output document to a file: eval[entry].txt
;     BLANK - output a blank form
;
; OUTPUTS:
;     Print document to the screen
;
; OPTIONAL OUTPUTS:
;     Print document to a file (with /FILE keyword)
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Tue Feb 9 12:09:50 1999, William Jon McCann <mccannwj@acs10>
;
;		written.
;
;-

PRO eval_doc, entry, FILE = use_file, BLANK = use_blanks

   IF NOT KEYWORD_SET( use_blanks ) THEN BEGIN
   
      IF N_PARAMS() LT 1 THEN BEGIN
         MESSAGE, 'usage: eval_doc, entry', /CONTINUE, /NONAME
         return
      ENDIF
      
      DBOPEN, 'acs_log'
      ACS_READ, entry, /NODATA, header, data, hudl, udl, heng1, heng2, $
       /NO_ABORT
   ENDIF ELSE entry = '________'

   IF KEYWORD_SET( use_file ) THEN BEGIN

      IF KEYWORD_SET( use_blanks ) THEN filename = 'eval_blank.txt' $
      ELSE filename = 'eval_'+STRTRIM(entry,2)+'.txt'
      OPENW, eval_lun, filename, /GET_LUN, ERROR = open_error

      IF open_error EQ 1 THEN BEGIN
         MESSAGE, 'error: could not open file for writing: '+filename
         return
      ENDIF

   ENDIF ELSE BEGIN
      eval_lun = -1
   ENDELSE

                    ; =========================
                    ; ACS Image Evaluation Form
                    ; =========================
   underline_string = STRING( FORMAT='(80A1)',REPLICATE('_',80) )

   IF KEYWORD_SET( use_blanks ) THEN BEGIN
      date         = underline_string
      time         = underline_string
      sdi_filename = underline_string
      detector     = underline_string
   ENDIF ELSE BEGIN

      date         = DBVAL( entry, 'date-obs' )
      time         = DBVAL( entry, 'time-obs' )
      sdi_filename = DBVAL( entry, 'filename' )
      detector     = DBVAL( entry, 'detector' )
   ENDELSE

   strLine = STRING( FORMAT='(25X,A)', "ACS Image Evaluation Form" )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''
   PRINTF, eval_lun, underline_string
   PRINTF, eval_lun, ''
   PRINTF, eval_lun, ''

   strLine = STRING( FORMAT='("Entry: ",A5,2X,"Date: ",A10,2X,"Time: ",A11,2X,"Filename: ",A18)', $
                     STRTRIM(entry,2), date, time, sdi_filename )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

                    ; ===================
                    ; Image Information
                    ; ===================
   
   IF KEYWORD_SET( use_blanks ) THEN BEGIN
      obstype       = underline_string
      meb_side      = underline_string

      amp_selection = underline_string
      exposure_time = underline_string
      
      subarray = underline_string
      ccd_xsize = underline_string
      ccd_ysize = underline_string
      ccd_xcorner = underline_string
      ccd_ycorner = underline_string
      
      ccd_gain   = underline_string
      ccd_offset = underline_string

      rootname   = underline_string

      temp_tec   = underline_string
      temp_det1  = underline_string
      temp_det2  = underline_string
      temp_sbc   = underline_string
   ENDIF ELSE BEGIN
      obstype       = DBVAL( entry, 'obstype' )
      meb_side      = STRTRIM( DBVAL( entry, 'mebid' ), 2 )

      amp_selection = DBVAL( entry, 'ccdamp' )
      exposure_time = DBVAL( entry, 'exptime' )
      
      subarray = DBVAL( entry, 'subarray' )
      ccd_xsize = STRTRIM( DBVAL( entry, 'ccdxsiz' ), 2 )
      ccd_ysize = STRTRIM( DBVAL( entry, 'ccdysiz' ), 2 )
      ccd_xcorner = STRTRIM( DBVAL( entry, 'ccdxcor' ), 2 )
      ccd_ycorner = STRTRIM( DBVAL( entry, 'ccdycor' ), 2 )
      
      ccd_gain   = STRTRIM( DBVAL( entry, 'ccdgain' ), 2 )
      ccd_offset = STRTRIM( DBVAL( entry, 'ccdoff' ), 2 )

      rootname   = DBVAL( entry, 'rootname' )

      temp_tec   = STRTRIM( DBVAL( entry, 'ccdtempc' ), 2 )
      temp_det1  = STRTRIM( DBVAL( entry, 'ccdtemp1' ), 2 )
      temp_det2  = STRTRIM( DBVAL( entry, 'ccdtemp2' ), 2 )
      temp_sbc   = STRTRIM( DBVAL( entry, 'sbctemp' ), 2 )
   ENDELSE

   strLine = STRING( FORMAT='(A)', "Image Information" )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, FORMAT='(18A1)',REPLICATE('_',18)
   PRINTF, eval_lun, ''

   strFormat = '(3X,"Detector: ",A5,7X,"Type: ",A11,7X,"Side: ",A3)'
   strLine = STRING( FORMAT=strFormat, detector, obstype, meb_side )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

   strLine = STRING( FORMAT='(3X,"Amp Select: ",A5,5X,"Exposure Time: ",A10)',$
                     amp_selection, STRTRIM(exposure_time,2) )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

   strLine = STRING( FORMAT='(3X,A,1X,"(",A10,")")', $
                     "Subarray Location", STRTRIM(subarray,2) )
   PRINTF, eval_lun, strLine

   IF STRUPCASE(subarray) EQ 'FULL' THEN BEGIN
      strLine = STRING( FORMAT='(5X,A)', "FULL" )
   ENDIF ELSE BEGIN 
      strLine = STRING( FORMAT='(5X,"X Size: ",A4,3X,"Y Size: ",A4,3X,"X Corner: ",A4,3X,"Y Corner: ",A4)', $
                        ccd_xsize, ccd_ysize, ccd_xcorner, ccd_ycorner )
   ENDELSE
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

   strLine = STRING( FORMAT='(3X,"CCD Gain: ",A4,3X,"Offset: ",A4)', $
                     ccd_gain, ccd_offset )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

   strLine = STRING( FORMAT='(3X,"Rootname: ",A10)', rootname )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

   strLine = STRING( FORMAT='(3X,"TEC Setpoint: ",A8,3X,"Detector Temp1: ",A8,3X,"Temp2: ",A8)', $
                     temp_tec, temp_det1, temp_det2 )
   PRINTF, eval_lun, strLine

   strLine = STRING( FORMAT='(3X,"SBC Temp    : ",A8)', $
                     temp_sbc )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

                    ; =====================
                    ; Corrector Information
                    ; =====================


   IF KEYWORD_SET( use_blanks ) THEN BEGIN
      cor_foc = underline_string
      cor_inn = underline_string
      cor_out = underline_string
   ENDIF ELSE BEGIN 
      IF detector EQ 'WFC' THEN BEGIN
         cor_foc = STRTRIM( DBVAL( entry, 'wfocpos' ), 2 )
         cor_inn = STRTRIM( DBVAL( entry, 'winnpos' ), 2 )
         cor_out = STRTRIM( DBVAL( entry, 'woutpos' ), 2 )
      ENDIF ELSE BEGIN
         cor_foc = STRTRIM( DBVAL( entry, 'hfocpos' ), 2 )
         cor_inn = STRTRIM( DBVAL( entry, 'hinnpos' ), 2 )
         cor_out = STRTRIM( DBVAL( entry, 'houtpos' ), 2 )
      ENDELSE
   ENDELSE

   strLine = STRING( FORMAT='(A)', "Corrector Information" )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, FORMAT='(22A1)',REPLICATE('_',22)
   PRINTF, eval_lun, ''
   
   strLine = STRING( FORMAT='(3X,"Focus: ",A6,3X,"Inner: ",A6,3X,"Outer: ",A6)',$
                     cor_foc, cor_inn, cor_out )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

                    ; =====================
                    ; Filter Wheels
                    ; =====================

   IF KEYWORD_SET( use_blanks ) THEN BEGIN
      filter1_name = underline_string
      filter1_off = underline_string
      filter2_name = underline_string
      filter2_off = underline_string
      filter3_name = underline_string
      filter3_off = underline_string
   ENDIF ELSE BEGIN
      filter1_name = DBVAL( entry, 'filter1' )
      filter1_off  = STRTRIM( DBVAL( entry, 'fw1off' ), 2 )
      filter2_name = DBVAL( entry, 'filter2' )
      filter2_off  = STRTRIM( DBVAL( entry, 'fw2off' ), 2 )
      filter3_name = DBVAL( entry, 'filter3' )
      filter3_off  = STRTRIM( DBVAL( entry, 'fw3off' ), 2 )
   ENDELSE 

   strLine = STRING( FORMAT='(A)', "Filter Wheels" )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, FORMAT='(14A1)',REPLICATE('_',14)
   PRINTF, eval_lun, ''
   
   strLine = STRING( FORMAT='(3X,"Wheel1",5X,"Filter: ",A8,3X,"Offset: ",A4)',$
                     filter1_name, filter1_off )
   PRINTF, eval_lun, strLine
   strLine = STRING( FORMAT='(3X,"Wheel2",5X,"Filter: ",A8,3X,"Offset: ",A4)',$
                     filter2_name, filter2_off )
   PRINTF, eval_lun, strLine
   strLine = STRING( FORMAT='(3X,"SBC Wheel",2X,"Filter: ",A8,3X,"Offset: ",A4)', $
                     filter3_name, filter3_off )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

                    ; ======================
                    ; Internal Cal Lamps
                    ; ======================
   
   strLine = STRING( FORMAT='(A)', "Internal Lamps" )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, FORMAT='(15A1)',REPLICATE('_',15)
   PRINTF, eval_lun, ''

   IF KEYWORD_SET( use_blanks ) THEN BEGIN
      sclamp  = underline_string
      tlmpsel = underline_string
      clcsel  = underline_string
   ENDIF ELSE BEGIN
      sclamp  = DBVAL( entry, 'SCLAMP' )
      tlmpsel = STRTRIM( SXPAR( heng1, 'JTLMPSEL' ), 2 )
      clcsel  = STRTRIM( SXPAR( heng1, 'JCLCSEL' ), 2 )
   ENDELSE 
   
   strLine =STRING(FORMAT='(3X,"Lamp active: ",A10,3X,"T lamp select: ",A6,3X,"CLC select: ",A8)', $
                   sclamp, tlmpsel, clcsel )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, ''

                    ; ======================
                    ; Stimulus
                    ; ======================


   IF KEYWORD_SET( use_blanks ) THEN BEGIN
      stimulus = STRING( FORMAT='(10A1)', REPLICATE('_',10) )
   ENDIF ELSE BEGIN 
      stimulus = DBVAL( entry, 'stimulus' )
   ENDELSE

   strLine = STRING( FORMAT='("Stimulus Information",1X,"(",A0,")")', $
                     STRTRIM(stimulus,2) )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, FORMAT='(31A1)',REPLICATE('_',31)
   PRINTF, eval_lun, ''

   IF STRUPCASE( STRTRIM(stimulus,2) ) EQ 'STUFF' THEN BEGIN

      stuff_begin = DBVAL( entry, 'stftime1' )
      stuff_end   = DBVAL( entry, 'stftime2' )
      stuff_mode  = DBVAL( entry, 'stfmode' )
      stuff_aper  = DBVAL( entry, 'stftarg' )
      stuff_atten = DBVAL( entry, 'stfatten' )
      stuff_pmtpos= DBVAL( entry, 'radmeter' )
      stuff_lamp  = DBVAL( entry, 'lamp' )
      stuff_rad1  = DBVAL( entry, 'radsgnl1' )
      stuff_rad2  = DBVAL( entry, 'radsgnl2' )
      stuff_radt1 = DBVAL( entry, 'radtime1' )
      stuff_radt2 = DBVAL( entry, 'radtime2' )
      stuff_radi1 = DBVAL( entry, 'rad_i1' )
      stuff_radi2 = DBVAL( entry, 'rad_i2' )
      stuff_radv1 = DBVAL( entry, 'rad_v1' )
      stuff_radv2 = DBVAL( entry, 'rad_v2' )
      stuff_radhv1 = DBVAL( entry, 'rad_hv1' )
      stuff_radhv2 = DBVAL( entry, 'rad_hv2' )
      stuff_lampi1 = DBVAL( entry, 'lamp_i1' )
      stuff_lampi2 = DBVAL( entry, 'lamp_i2' )
      stuff_lampv1 = DBVAL( entry, 'lamp_v1' )
      stuff_lampv2 = DBVAL( entry, 'lamp_v2' )

      strLine = STRING( FORMAT='(3X,"Mode: ",9X,A15)', stuff_mode )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Lamp: ",2X,A15)', stuff_lamp )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Aperture: ",A25)', stuff_aper )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Attenuator: ",3X,A15)', stuff_atten )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Rad. Position:",A9)', stuff_pmtpos )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Time",11X,"Begin: ",A21,3X,"End: ",A21)',$
                        stuff_begin, stuff_end )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Radiometer",5X,"Begin: ",I8,3X,"End: ",I8)',$
                        stuff_rad1, stuff_rad2 )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Rad. Time",6X,"Begin: ",I8,3X,"End: ",I8)',$
                        stuff_radt1, stuff_radt2 )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Rad. Voltage",3X,"Begin: ",F8.4,3X,"End: ",F8.4)',$
                        stuff_radv1, stuff_radv2 )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Rad. HVoltage",2X,"Begin: ",F8.4,3X,"End: ",F8.4)',$
                        stuff_radhv1, stuff_radhv2 )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Rad. Current",3X,"Begin: ",F8.4,3X,"End: ",F8.4)',$
                        stuff_radi1, stuff_radi2 )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Lamp Voltage",3X,"Begin: ",F8.4,3X,"End: ",F8.4)',$
                        stuff_lampv1, stuff_lampv2 )
      PRINTF, eval_lun, strLine
      strLine = STRING( FORMAT='(3X,"Lamp Current",3X,"Begin: ",F8.4,3X,"End: ",F8.4)',$
                        stuff_lampi1, stuff_lampi2 )
      PRINTF, eval_lun, strLine


   ENDIF ELSE IF STRUPCASE( STRTRIM(stimulus,2) ) EQ 'RAS/CAL' THEN BEGIN

   ENDIF ELSE BEGIN
      PRINTF, eval_lun, ''
      PRINTF, eval_lun, ''
      PRINTF, eval_lun, ''
      PRINTF, eval_lun, ''
      PRINTF, eval_lun, ''
      PRINTF, eval_lun, ''

   ENDELSE 

                    ; ======================
                    ; Notes
                    ; ======================

   PRINTF, eval_lun, ''
   PRINTF, eval_lun, ''
   strLine = STRING( "Notes:" )
   PRINTF, eval_lun, strLine
   PRINTF, eval_lun, FORMAT='(7A1)',REPLICATE('_',7)
   PRINTF, eval_lun, ''


   IF KEYWORD_SET( use_file ) THEN FREE_LUN, eval_lun

END


