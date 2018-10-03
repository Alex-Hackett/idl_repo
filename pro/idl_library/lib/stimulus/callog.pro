;+
; $Id: callog.pro,v 1.1 1999/08/02 23:24:07 mccannwj Exp $
;
; NAME:
;     CALLOG
;
; PURPOSE:
;     Log RAS/CAL configuration to .FITS file header.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     callog
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;     .FITS output file
;
; COMMON BLOCKS:
;     A reference to 'COMMON gpib, devices', though not explicitly used.
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
;    Mon Aug  2 17:23:56 MDT 1999, <mccannwj@acs13>
;
;		Written, William Jon McCann.
;-

; _____________________________________________________________________________

FUNCTION have_gpib_devices

   COMMON gpib, devices

   IF N_ELEMENTS( devices ) GT 0 THEN return, 1b ELSE return, 0b
END 

; _____________________________________________________________________________


PRO callog_event, sEvent

   wChild = WIDGET_INFO( sEvent.top, /CHILD )
   wSibling = WIDGET_INFO( wChild, /SIBLING )
   WIDGET_CONTROL, wSibling, GET_UVALUE=sState, /NO_COPY

   WIDGET_CONTROL, sEvent.id, GET_UVALUE=uvalue
   IF N_ELEMENTS( uvalue ) LE 0 THEN uvalue=''

   IF N_ELEMENTS( sState ) GE 0 THEN BEGIN 
      IF sState.debug eq 1 THEN debug=1 ELSE debug=0
   ENDIF

   CASE STRUPCASE(uvalue) OF

      'ROOT': BEGIN
         struct_name = TAG_NAMES( sEvent, /STRUCTURE_NAME)

         IF STRUPCASE( struct_name ) EQ 'WIDGET_BASE' THEN BEGIN
            newx = sEvent.x - 50 > 10
            newy = sEvent.y - 50 > 10
            
            WIDGET_CONTROL, sState.wForm, SCR_YSIZE=newy ;, SCR_XSIZE=newx
         ENDIF

      END

      'MENU': BEGIN

         CASE sEvent.value OF

            'File.New': BEGIN
               
               sState.Filename = ''
               WIDGET_CONTROL, sState.wRoot, UPDATE=0
               WIDGET_CONTROL, /HOURGLASS
               FOR i=0, N_ELEMENTS( sState.aKeywords )-1 DO BEGIN
                  type = WIDGET_INFO( sState.wValues(i), /NAME )
                  IF type EQ 'TEXT' THEN $
                   WIDGET_CONTROL, sState.wValues(i), SET_VALUE=' '
                  IF type EQ 'DROPLIST' THEN BEGIN
                     WIDGET_CONTROL, sState.wForms(i), GET_UVALUE=options
                     WIDGET_CONTROL, sState.wValues(i), SET_VALUE=options
                  ENDIF 

               ENDFOR
               WIDGET_CONTROL, sState.wRoot, UPDATE=1
               WIDGET_CONTROL, sState.wMessage, SET_VALUE='new log.'

            END 

            'File.Open': BEGIN
               readname = PICKFILE( /READ, FILTER='*' )
               IF readname NE '' THEN BEGIN

               ENDIF
            END 

            'File.Save': BEGIN

               IF sState.Filename EQ '' THEN BEGIN

                  bdate = BIN_DATE( systime(0) )
                  year = bdate(0)
                  month = bdate(1)
                  day = bdate(2)
                  hour = bdate(3)
                  minute = bdate(4)
                  second = bdate(5)

                    ; day of year code "borrowed" from R.Sterner's ymd2dn.pro
                  monthdays = [0,31,59,90,120,151,181,212,243,273,304,334,366]
                  leap_year = (((year MOD 4) EQ 0) AND ((year MOD 100) NE 0)) $
                   OR ((year MOD 400) EQ 0) AND (month GE 3)
                  day_of_year = day+monthdays(month-1)+leap_year

                  defDir = sState.Path

                  defName = STRING( FORMAT='(A0,I4.4,I3.3,I2.2,I2.2,I2.2,A0)',$
                                    "rclog", year, day_of_year, hour, $
                                    minute, second, ".fits" )

               ENDIF ELSE defName = sState.Filename
               
               MKHDR, fitsHeader, ''

               FOR i=0, N_ELEMENTS( sState.aKeywords )-1 DO BEGIN

                  type = WIDGET_INFO( sState.wValues(i), /NAME )

                  IF type EQ 'TEXT' THEN BEGIN
                     WIDGET_CONTROL, sState.wValues(i), GET_VALUE=fvalue
                     WIDGET_CONTROL, sState.wForms(i), GET_UVALUE=ftype
                     IF N_ELEMENTS( ftype ) LE 0 THEN ftype = 'TEXT'
                  ENDIF

                  IF type EQ 'DROPLIST' THEN BEGIN
                     dlselect = WIDGET_INFO( sState.wValues(i), $
                                             /DROPLIST_SELECT )
                     WIDGET_CONTROL, sState.wForms(i), GET_UVALUE=options
                     fvalue = STRTRIM( options(dlselect), 2 )
                     ftype = 'TEXT'
                  ENDIF 

                  WIDGET_CONTROL, sState.wComments(i), GET_VALUE=fcomment
                  
                    ; convert types if necessary - defaults to string type
                  fvalue = STRTRIM( fvalue(0), 2 )
                  IF ftype EQ 'FLOAT' THEN fvalue = FLOAT(fvalue)
                  
                  fcomment = STRING( FORMAT='(1X,A)',STRTRIM(fcomment(0),2))

                  SXADDPAR, fitsHeader, sState.aKeywords(i), $
                   fvalue(0), fcomment(0)

               ENDFOR
               
               fitsData = 0
               version = FLOAT( STRMID( !VERSION.RELEASE, 0, 3 ) )

               IF version LT 5.0 THEN BEGIN
                  writename = PICKFILE( FILE=defName, PATH=defDir, /WRITE, $
                                        GROUP = sState.wRoot, $
                                        FILTER='*.fits', GET_PATH=writepath )
                  strFilename = writepath + writename(0)
               ENDIF ELSE BEGIN
                  writename = DIALOG_PICKFILE( FILE=defName, PATH=defDir, $
                                               /WRITE, GROUP = sState.wRoot, $
                                               FILTER='*.fits', $
                                               GET_PATH=writepath )
                  
                  IF writename EQ writepath THEN writename = ''
                  strFilename = writename(0)
               ENDELSE 

               junk = FINDFILE( writepath, COUNT=file_count )

               IF file_count GT 0 THEN BEGIN
                  IF writename(0) NE '' THEN BEGIN
                     WRITEFITS, strFilename, fitsData, fitsHeader
                     sState.Path = writepath
                     WIDGET_CONTROL, sState.wMessage, $
                      SET_VALUE='wrote ' + strFilename
                  ENDIF ELSE WIDGET_CONTROL, sState.wMessage, $
                   SET_VALUE='save cancelled: no files selected.'
   
               ENDIF ELSE BEGIN
                  WIDGET_CONTROL, sState.wMessage, $
                   SET_VALUE='save cancelled: path not found.'
               ENDELSE

            END

            'File.Exit': BEGIN
               WIDGET_CONTROL, sEvent.top, /DESTROY
            END

            'Functions.Retrieve data': BEGIN
               WIDGET_CONTROL, sState.wMessage, $
                SET_VALUE = "Retrieving data..."
               
               IF have_gpib_devices() GT 0 THEN BEGIN
                  WIDGET_CONTROL, /HOURGLASS
                  get_data, sData, /SCALED

                  WIDGET_CONTROL, sState.wMessage, $
                   SET_VALUE = "Populating fields..."
                  
                  WIDGET_CONTROL, /HOURGLASS
                  put_data, sData, sState
                  
                  WIDGET_CONTROL, sState.wMessage, $
                   SET_VALUE = "Done."
               ENDIF ELSE BEGIN
                  WIDGET_CONTROL, sState.wMessage, $
                   SET_VALUE = "No GPIB devices allocated."
               ENDELSE
            END 

            ELSE:

         ENDCASE

      END
      ELSE:

   ENDCASE

   IF WIDGET_INFO( wSibling, /VALID_ID ) EQ 1 THEN BEGIN
                    ; restore state information
      WIDGET_CONTROL, wSibling, SET_UVALUE=sState, /NO_COPY
   ENDIF

END

; _____________________________________________________________________________

PRO get_data, sData, SCALED=scaled

                    ; _____________________________________

                    ; Monochromator
                    ; _____________________________________

   wavelength_pos = ''
   wavelength_pos = read_device( 'monochrom', status, AXIS='wavelength', $
                                 SCALED=scaled )
   IF status NE 1 THEN wavelength_pos = !VALUES.F_NAN
   grating_pos = read_device( 'monochrom', status, AXIS='grating', $
                              SCALED=scaled )
   IF status NE 1 THEN grating_pos = !VALUES.F_NAN

   slit_pos = ''

                    ; _____________________________________

                    ; MOTION1 (Focus)
                    ; _____________________________________

   PRINTF, -2, FORMAT='(A,"...")', "Retrieving focus"
   REPEAT BEGIN
      focus_pos = read_device( 'motion1', status, AXIS='focus', SCALED=scaled )
      PRINTF, -2, FORMAT='(3X,"position:",1X,F,2X,"status:",1X,I3)',$
       focus_pos, status
   ENDREP UNTIL status NE 2
   IF status NE 1 THEN focus_pos = !VALUES.F_NAN
   PRINTF, -2, 'done.'
   
                    ; _____________________________________

                    ; MOTION2 (Tip)
                    ; _____________________________________

   PRINTF, -2, FORMAT='(A,"...")', "Retrieving tip"
   REPEAT BEGIN
      tip_pos = read_device( 'motion2', status, AXIS='TIP', SCALED=scaled )
      PRINTF, -2, FORMAT='(3X,"position:",1X,F,2X,"status:",1X,I3)',$
       tip_pos, status
   ENDREP UNTIL status NE 2
   IF status NE 1 THEN tip_pos = !VALUES.F_NAN
   PRINTF, -2, 'done.'

                    ; _____________________________________

                    ; MOTION3 (Tilt)
                    ; _____________________________________

   PRINTF, -2, FORMAT='(A,"...")', "Retrieving tilt"
   REPEAT BEGIN
      tilt_pos = read_device( 'motion3', status, AXIS='TILT', SCALED=scaled )
      PRINTF, -2, FORMAT='(3X,"position:",1X,F,2X,"status:",1X,I3)',$
       tilt_pos, status
   ENDREP UNTIL status NE 2
   IF status NE 1 THEN tilt_pos = !VALUES.F_NAN
   PRINTF, -2, 'done.'
   
                    ; _____________________________________

                    ; MOTION4 (Aperture)
                    ; _____________________________________

   PRINTF, -2, FORMAT='(A,"...")', "Retrieving aperture"
   REPEAT BEGIN
      aperture_pos = read_device( 'motion4', status, AXIS='APERTURE', $
                                  SCALED=scaled )
      PRINTF, -2, FORMAT='(3X,"position:",1X,F,2X,"status:",1X,I3)',$
       aperture_pos, status
   ENDREP UNTIL status NE 2
   IF status NE 1 THEN aperture_pos = !VALUES.F_NAN
   PRINTF, -2, 'done.'
   
                    ; _____________________________________

                    ; MOTION5 (Radiometer)
                    ; _____________________________________

   PRINTF, -2, FORMAT='(A,"...")', "Retrieving radiometer"
   REPEAT BEGIN
      radiometer_pos = read_device( 'motion5', status, AXIS='RADIOMETER', $
                                    SCALED=scaled )
      PRINTF, -2, FORMAT='(3X,"position:",1X,F,2X,"status:",1X,I3)',$
       radiometer_pos, status
   ENDREP UNTIL status NE 2
   IF status NE 1 THEN radiometer_pos = !VALUES.F_NAN
   PRINTF, -2, 'done.'
   
   aGratings = [ 'OUT', 'UV', 'VIS', 'IR' ]
   aGratingPos = [ 0.0, 1.0, 2.0, 3.0 ]
   aApertures = [ '2MIC', '4MIC', '100MIC', 'OPEN','LARGE']
   aAperturePos = [ 0.0, -5281.0, -1.0561e+4, -1.584e+4, -2.1117e+4 ]
   aRadiometers = [  "HOME","VPMT", "UVPMT", "OPEN","Diode1","Diode2" ]
   aRadiometerPos = [ 0.0, -8.0, -83.0, -145.0, -205.5, -259.5 ]

   IF (grating_pos GT 0) AND (grating_pos LT N_ELEMENTS( aGratings ) - 1) THEN $
    grating_name = aGratings( grating_pos ) $
   ELSE grating_name = 'OUT'
   
; since positions are negative the sense is reversed
   IF (aperture_pos NE !VALUES.F_NAN) THEN BEGIN 
      ahilimit = 0.9*aperture_pos+10
      alolimit = 1.1*aperture_pos-10

      apos = WHERE( (aAperturePos GT alolimit ) $
                    AND (aAperturePos LT ahilimit ), acount )
      IF acount LE 0 THEN Aperture = ' ' ELSE $
       Aperture = STRUPCASE(aApertures( apos(0) ))
   ENDIF ELSE Aperture = ' '

   rhilimit = 0.9*radiometer_pos+1
   rlolimit = 1.1*radiometer_pos-1
   rpos = WHERE( (aRadiometerPos GT rlolimit ) $
                 AND (aRadiometerPos LT rhilimit ), rcount )
   IF rcount LE 0 THEN Radiometer = ' ' ELSE $
    Radiometer = STRUPCASE(aRadiometers( rpos(0) ))

   
   sData = { RASCFOC: focus_pos, $
             TM2TIP: tip_pos, $
             TM2TILT: tilt_pos, $
             RASCAPER: Aperture, $
             RADMETER: Radiometer, $
             MONOWAVE: wavelength_pos * 10.0, $
             MONOGRTG: grating_name }
   
   HELP, /STR, sData

   return
END

; _____________________________________________________________________________

PRO put_data, data, state, DEBUG=debug

   IF N_ELEMENTS( data ) LE 0 THEN BEGIN
      MESSAGE, 'usage: put_data, data, state', /INFO
      return
   ENDIF

   aTags = TAG_NAMES( data )
   
   FOR i=0, N_ELEMENTS( aTags )-1 DO BEGIN
      num = WHERE( state.aKeywords EQ aTags(i), ncount )

      type = WIDGET_INFO( state.wValues(num(0)), /NAME )

      IF type EQ 'TEXT' THEN $
       WIDGET_CONTROL, state.wValues(num(0)), SET_VALUE=STRTRIM( data.(i), 2 )
      IF type EQ 'DROPLIST' THEN BEGIN
          WIDGET_CONTROL, state.wForms(num(0)), GET_UVALUE=values

          dpos = WHERE( values EQ data.(i), dcount )

          IF dcount LE 0 then select = 0 ELSE select = dpos(0) 
          WIDGET_CONTROL, state.wValues(num(0)), SET_DROPLIST_SELECT=select
       ENDIF
   ENDFOR 

   return
END

; _____________________________________________________________________________


FUNCTION callog_get_format, VALUES=values

   keywords = [ 'RASCCHNL', $
                'RASCAPER', $
                'RASCFOC', $
                'TM2TIP', $
                'TM2TILT', $
                'RADMETER', $
                'RADSIGNL', $
                'LAMP', $
                'LAMP_I', $
                'FILTERA', $
                'FILTERB', $
                'FILTERC', $
                'FILTERD', $
                'FILTERE', $
                'FILTERF', $
                'FILTERX', $
                'POLANGLE', $
                'MONOWAVE', $
                'MONOGRTG', $
                'MONONSLT', $
                'MONOXSLT', $
                'HISTORY' ]

   vtypes = { RASCCHNL: 'STRING', $
              RASCAPER: 'STRING', $
              RASCFOC: 'FLOAT', $
              TM2TIP: 'FLOAT', $
              TM2TILT: 'FLOAT', $
              RADMETER: 'STRING', $
              RADSIGNL: 'FLOAT', $
              LAMP: 'STRING', $
              LAMP_I: 'FLOAT', $
              FILTERA: 'STRING', $
              FILTERB: 'STRING', $
              FILTERC: 'STRING', $
              FILTERD: 'STRING', $
              FILTERE: 'STRING', $
              FILTERF: 'STRING', $
              FILTERX: 'STRING', $
              POLANGLE: 'FLOAT', $
              MONOWAVE: 'FLOAT', $
              MONOGRTG: 'STRING', $
              MONONSLT: 'FLOAT', $
              MONOXSLT: 'FLOAT', $
              HISTORY: 'STRING' }

   wtypes = { RASCCHNL: 'DROPLIST', $
              RASCAPER: 'DROPLIST', $
              RASCFOC: 'TEXT', $
              TM2TIP: 'TEXT', $
              TM2TILT: 'TEXT', $
              RADMETER: 'DROPLIST', $
              RADSIGNL: 'TEXT', $
              LAMP: 'DROPLIST', $
              LAMP_I: 'TEXT', $
              FILTERA: 'DROPLIST', $
              FILTERB: 'DROPLIST', $
              FILTERC: 'DROPLIST', $
              FILTERD: 'DROPLIST', $
              FILTERE: 'DROPLIST', $
              FILTERF: 'DROPLIST', $
              FILTERX: 'DROPLIST', $
              POLANGLE: 'TEXT', $
              MONOWAVE: 'TEXT', $
              MONOGRTG: 'DROPLIST', $
              MONONSLT: 'TEXT', $
              MONOXSLT: 'TEXT', $
              HISTORY: 'TEXT' }

   comments = { RASCCHNL: 'RASCAL channel alignment', $
                RASCAPER: 'RASCAL aperture', $
                RASCFOC: 'RASCAL focus (microns)', $
                TM2TIP: 'RASCAL TM2 mirror tip position (degrees)', $
                TM2TILT: 'RASCAL TM2 mirror tilt position (degrees)', $
                RADMETER: 'radiometer selection', $
                RADSIGNL: 'radiometer signal', $
                LAMP: 'CDS lamp selection', $
                LAMP_I: 'CDS lamp current setting', $
                FILTERA: 'CDS filter wheel A selection', $
                FILTERB: 'CDS filter wheel B selection', $
                FILTERC: 'CDS filter wheel C selection', $
                FILTERD: 'CDS filter wheel D selection', $
                FILTERE: 'CDS filter wheel E selection', $
                FILTERF: 'CDS filter wheel F selection', $
                FILTERX: 'External filter selection', $
                POLANGLE: 'Polarizer angle (degrees); -1.=OUT', $
                MONOWAVE: 'Monochromator wavelength setting (Angstroms)', $
                MONOGRTG: 'Monochromator grating selection', $
                MONOXSLT: 'Monochromator entrance slit width (microns)', $
                MONONSLT: 'Monochromator exit slit width (microns)', $
                HISTORY: 'Comment' }

   values = { RASCCHNL: [ 'WFC' + STRTRIM( INDGEN(10), 2 ), $
                          'HRC-SBC' + STRTRIM( INDGEN(9)+1, 2 ) ], $
              RASCAPER: [ '4MIC', '2MIC', '100MIC', 'OPEN', 'LARGE' ], $
              RASCFOC: [' '], $
              TM2TIP: [' '], $
              TM2TILT: [' '], $
              RADMETER: [ 'OPEN', 'OUT', 'HOME', 'DIODE1', 'DIODE2', 'VPMT', 'UVPMT' ], $
              RADSIGNL: [' '], $
              LAMP: [ 'HENE', 'DEUT', 'QTH', 'HG', '810LSR', 'XELINE', 'PTCR-NE' ], $
              LAMP_I: [' '], $
              FILTERA: [ 'CLEAR', 'UVND1.0', 'UVND2.0' ], $
              FILTERB: [ 'CLEAR', 'UVND3.0', 'UVND0.5' ], $
              FILTERC: [ 'CLEAR', 'BLOCK', '122' ], $
              FILTERD: [ 'CLEAR', '145', 'VISND1.0' ], $
              FILTERE: [ 'CLEAR', '546', 'VISND0.2' ], $
              FILTERF: [ 'CLEAR', 'VISND0.5', '170' ], $
              FILTERX: [ 'CLEAR' ], $
              POLANGLE: [' '], $
              MONOWAVE: [' '], $
              MONOGRTG: [ 'OUT', 'UV', 'VIS', 'IR' ], $
              MONONSLT: [' '], $
              MONOXSLT: [' '], $
              HISTORY: [' '] }

   junk = { keyword: '', comment: '', vtype: '', wtype: '' }
   result = REPLICATE( junk, N_ELEMENTS( keywords ) )

   FOR i=0, N_ELEMENTS( keywords )-1 DO BEGIN

      cpos = WHERE( tag_names(comments) EQ keywords(i) )
      vtpos = WHERE( tag_names(vtypes) EQ keywords(i) )
      wtpos = WHERE( tag_names(wtypes) EQ keywords(i) )
      vpos = WHERE( tag_names(values) EQ keywords(i) )

      result(i).keyword = keywords(i)
      result(i).comment = comments.(cpos(0))
      result(i).vtype = vtypes.(vtpos(0))
      result(i).wtype = wtypes.(wtpos(0))

   ENDFOR

   return, result
END 

; _____________________________________________________________________________

PRO callog, GROUP_LEADER=group, DEBUG=debug, PATH=log_path

   IF NOT KEYWORD_SET( group ) THEN group = 0l
   IF NOT KEYWORD_SET( debug ) THEN debug = 0l

   IF N_ELEMENTS( log_path ) LE 0 THEN BEGIN
      CD, CURRENT=cwd
      log_path = cwd + '/logs'
   ENDIF 

   windowTitle = 'RASCAL Log'
   Version = 'Callog'
   MenuList = [ '1\File', '0\New', '0\Save', '2\Exit', $
                '1\Functions', '2\Retrieve data', $
                '1\Help', '2\About' ]

   aFormat = callog_get_format( VALUE=sValues )

   wRoot = WIDGET_BASE( GROUP_LEADER=group, UVALUE='ROOT', MBAR=menubar, $
                        /MAP, /COLUMN, TITLE=windowTitle, /TLB_SIZE_EVENTS )

   wMenuBar = CW_PDMENU( menubar, MenuList, UVALUE='MENU', /MBAR, $
                         /RETURN_FULL_NAME )

                    ; won't set in CW_PDMENU call above, a bug in IDL v4 ?
   WIDGET_CONTROL, wMenuBar, SET_UVALUE='MENU'

   wBase = WIDGET_BASE( wRoot, /COLUMN )

                    ; create form
   wForm = WIDGET_BASE( wBase, /SCROLL, /COLUMN, $
                        Y_SCROLL_SIZE=600, X_SCROLL_SIZE=650 )

   aKeywords = STRARR( N_ELEMENTS(aFormat) )
   wForms = REPLICATE( -1L, N_ELEMENTS( aFormat ) ) 
   wLabels = REPLICATE( -1L, N_ELEMENTS( aFormat ) )
   wValues = REPLICATE( -1L, N_ELEMENTS( aFormat ) )
   wComments = REPLICATE( -1L, N_ELEMENTS( aFormat ) ) 
   
                    ; ___________________________________________

                    ; beginning of form
                    ; ___________________________________________

                    ; in Base of droplist UVALUE=list of options
                    ; in Base of text UVALUE=type of entry

   FOR i=0, N_ELEMENTS( aFormat )-1 DO BEGIN

                    ; this is a hack because IDL versions prior to v5
                    ; do not have support for pointers
      vpos = WHERE( tag_names(sValues) EQ aFormat(i).keyword, vcount )
      IF vcount LE 0 THEN fvalue = '' ELSE fvalue = sValues.(vpos(0))
      fstruct = CREATE_STRUCT( aFormat(i), 'value', fvalue )

      aKeywords(i) = fstruct.keyword

      IF fstruct.wtype EQ 'TEXT' THEN BEGIN

         wForms(i) = WIDGET_BASE( wForm, /ROW, UVALUE=fstruct.vtype )

         label = STRING( FORMAT='(A10)', fstruct.keyword )

         wLabels(i) = WIDGET_LABEL( wForms(i), VALUE=label, XSIZE = 100, $
                                    /ALIGN_LEFT )

         wValues(i) = WIDGET_TEXT( wForms(i), UVALUE=' ', $
                                   VALUE=fstruct.value(0), $
                                   /EDIT, XSIZE=15, YSIZE=1 )

         comment = STRING( FORMAT='(8X, A45)', fstruct.comment )
         wComments(i) = WIDGET_LABEL( wForms(i), VALUE=comment, /ALIGN_LEFT )

      ENDIF

      IF fstruct.wtype EQ 'DROPLIST' THEN BEGIN

         wForms(i) = WIDGET_BASE( wForm, /ROW, UVALUE=fstruct.value )

         label = STRING( FORMAT='(A10)', fstruct.keyword )
         wLabels(i) = WIDGET_LABEL( wForms(i), VALUE=label, XSIZE = 100, $
                                    /ALIGN_LEFT )
         
         values = fstruct.value
         values(0) = STRING( FORMAT='(A15)', fstruct.value(0) )
         wValues(i) = WIDGET_DROPLIST( wForms(i), VALUE=values )

         comment = STRING( FORMAT='(3X, A45)', fstruct.comment )
         wComments(i) = WIDGET_LABEL( wForms(i), VALUE=comment, /ALIGN_LEFT )

      ENDIF 

   ENDFOR

                    ; ___________________________________________

                    ; end of form
                    ; ___________________________________________

   wMessage = WIDGET_TEXT( wBase, VALUE=Version, YSIZE=1 )

   WIDGET_CONTROL, wRoot, /REALIZE

   state = { wRoot: wRoot, $
             wBase: wBase, $
             wForm: wForm, $
             wMessage: wMessage, $
             wForms: wForms, $
             wLabels: wLabels, $
             wValues: wValues, $
             wComments: wComments, $
             aKeywords: aKeywords, $
             Filename: '', $
             Path: log_path, $
             debug: debug }


   WIDGET_CONTROL, wBase, SET_UVALUE=state, /NO_COPY

   XMANAGER, 'callog', wRoot

   return
END
