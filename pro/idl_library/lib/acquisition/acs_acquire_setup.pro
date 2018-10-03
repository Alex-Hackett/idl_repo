;+
; $Id: acs_acquire_setup.pro,v 1.4 2000/09/27 22:57:20 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_SETUP
;
; PURPOSE:
;     Routine to set up common block XX_ACS_ACQUIRE for ACS_ACQUIRE.  If
;     common block is already setup, the routine just returns.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_SETUP
; 
; INPUTS:
;     Input is read from the following files located in the path
;     defined by the JAUX environment variable.
;        JAUX/tdfd.txt       is read to obtain conversions to physical units.
;        JAUX/acs_ess.txt    contains snapshot descriptions
;        JAUX/acs_filter.txt contains filter names
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     ERROR - error status upon exit (nonzero if an error occurred)
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     xx_acs_acquire
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
;	version 1  DJL  May, 1998
;       26 Sep 2000 McCann - added ERROR keyword, removed STOP statements
;
;-
PRO acs_acquire_setup, ERROR=error_code
@acs_acquire_common.pro

   error_code = 0b
                    ; check to see if common block already populated
   IF N_ELEMENTS(position) GT 0 THEN return

                    ; set zero_time
   zero_time = 4147715878d0
   shpvals = FLTARR(5)
   shptime = 0.0d0
   shpfile = '        '

; read snapshot description from JAUX:acs_ess.txt ---------------------------
   ess_filename = find_with_def('acs_ess.txt','JAUX')
   IF ess_filename[0] EQ '' THEN BEGIN
      MESSAGE, 'ERROR: acs_ess.txt not found', /CONTINUE
      error_code = 1b
      return
   ENDIF 
   OPENR, unit, ess_filename, /GET_LUN, $
    ERROR=open_error
   IF (open_error NE 0) THEN BEGIN
      PRINTF, -2, !ERR_STRING
      error_code = 1b
      return
   ENDIF

   position = STRARR(1000)		
   ename = STRARR(1000)
   ecomments = STRARR(1000)
   bit1 = INTARR(1000)
   nbits = INTARR(1000)
   scale_factor = INTARR(1000)+1
   n = 0
   st = ''
   WHILE NOT EOF(unit) DO BEGIN
      READF, unit, st

      position(n) = gettok(st,' ')-1
      bit1(n) = gettok(st,' ')-1
      nbits(n) = gettok(st,' ')
      ename(n) = gettok(st,' ')
      ecomments(n) = STRTRIM(st,2)
      n = n+1
   ENDWHILE

                    ; add shp temperatures
   ename(n) = ['JHDETMP1','JHDETMP2','JWDETMP1','JWDETMP2','JMTUBET']
   position(n) = [-1,-1,-1,-1,-1]
   position = position(0:n+4)
   bit1 = bit1(0:n+4)
   nbits = nbits(0:n+4)
   ename = ename(0:n+4)
   ecomments = ecomments(0:n+4)
   scale_factor = scale_factor(0:n+4)
   FREE_LUN, unit
   
; read tdfd.txt file containing telemetry conversion -------------------------
   tdfd_filename = find_with_def('tdfd.an','JAUX')
   IF tdfd_filename[0] EQ '' THEN BEGIN
      MESSAGE, 'ERROR: tdfd.an not found', /CONTINUE
      error_code = 1b
      junk = TEMPORARY(position)
      return
   ENDIF 
   OPENR, unit, tdfd_filename, /GET_LUN, $
    ERROR=open_error
   IF (open_error NE 0) THEN BEGIN
      PRINTF, -2, !ERR_STRING
      error_code = 1b
      return
   ENDIF

   st = ''
   f = strarr(50000)
   n = 0
   WHILE NOT EOF(unit) DO BEGIN
      READF, unit, st
      f(n) = st
      n = n+1
   ENDWHILE
   FREE_LUN, unit
   f = f(0:n-1)

                    ; extract list of names
   rectypes = STRMID(f,71,2)
   enames = STRTRIM(STRMID(f,0,8))
   first = WHERE(rectypes eq 'TM')
   enames = enames(first)

                    ; vectors for output conversion tables
   nitems = n_elements(ename) ;e.d. snapshot names
   conversion = strarr(10000) ;conversion tables and coef.
   convpos = intarr(nitems) ;positions in conversion table
   nout = 0         ;# of positions in conversion used

                    ; create output strarr containing the results

                    ; loop on telemetry items in engineering snapshot

   FOR k=0,nitems-1 DO BEGIN

                    ; initialization for unsupplied values
      comment = ''
      units = ''
      limits = 0
      tabletype = ''

                    ; find position in tdfd file
      pos = where(enames eq ename(k),npos)
      if npos eq 0 then goto,skip
      pos = pos(0)

                    ; loop on records
      i = first(pos)
      REPEAT BEGIN
         st = f(i)
         CASE rectypes(i) OF

                    ; TM record contains item name
            'TM' :

                    ; TI record contains description
            'TI' : comment = strtrim(strmid(st,8,62),2)

                    ; TC records contain polynomial coefficients or segments
            'TC' : BEGIN

                    ;    get units from first TC record
               units = STRTRIM(STRMID(st,8,62),2)

                    ;    get table type L or P from second record
               i=i+1 & st=f(i) ;get next record
               tabletype = strmid(st,4,1) ;L or P
               ntab = fix(strmid(st,5,2)) ;number of items
               if tabletype eq 'P' then ntab=ntab+1
               table = strarr(ntab) ;table 
               n = 0 ;table counter

                    ;    loop on continuation records to get table values
               i = i-1
               REPEAT BEGIN
                  i = i+1 & st=f(i) ;get next record
                  i1 = 7
                  WHILE (n lt ntab) and (i1 le 49) DO BEGIN
                     table(n) = strmid(st,i1,21)
                     i1 = i1 + 21
                     n = n+1
                  ENDWHILE
               ENDREP UNTIL STRMID(st,70,1) NE 'C'

                    ; convert to segment table or polynomial coefficients
               CASE tabletype OF
                  'P': coef = float(strmid(table,0,18)+'E' + $
                                    strmid(table,18,3))
                  'L': BEGIN
                     telem_val = long(strmid(table,0,10))
                     values = float(strmid(table,10,8)+'E' + $
                                    strmid(table,18,3))
                  END
                  ELSE: BEGIN
                     MESSAGE, 'Invalid TC record', /CONTINUE
                     error_code = 1b
                     return
                  END
               ENDCASE ; tabletype
            ENDCASE ; TC record

                    ; TD record contains range and value
            'TD' : BEGIN
               tabletype = 'R' ;range lookup
               table = strarr(100)
               n = 0
               i = i-1
               REPEAT BEGIN
                  i = i+1 & st=f(i) ;get next record
                  i1 = 8
                  WHILE (i1 LE 50) DO BEGIN
                     val = STRMID(st,i1,14)
                     IF STRTRIM(val) NE '' THEN BEGIN
                        table(n) = val
                        n = n+1
                     ENDIF
                     i1 = i1 + 14
                  ENDWHILE
               ENDREP UNTIL STRMID(st,70,1) NE 'C'

                    ; extract min, max, value
               table = table(0:n-1)
               mins = strmid(table,0,3)
               maxs = strmid(table,3,3)
               values = strmid(table,6,8)
            end
                    ; TL record contains limits
            'TL' : 
                    ; other records not supported
            ELSE: BEGIN
               MESSAGE, rectypes(i)+' record type not supported', /CONTINUE
               error_code = 1b
               return
            END 
         ENDCASE
         i = i+1
      ENDREP UNTIL rectypes(i) EQ 'BZ'

                    ; place results in conversion table
skip:
      IF units NE '' THEN ecomments(k) = '('+units+') '+ecomments(k)
      convpos(k) = nout
      conversion(nout) = tabletype
      nout = nout + 1
      CASE tabletype OF
         'P': BEGIN ; polynomial
            n = N_ELEMENTS(coef)
            conversion(nout) = STRTRIM(n,2)
            conversion(nout+1) = STRTRIM(coef,2)
            nout=nout+n+1
         END
         'L': begin ; interpolation table
            n = N_ELEMENTS(telem_val)
            conversion(nout) = STRTRIM(n,2)
            conversion(nout+1) = STRTRIM(telem_val,2)
            conversion(nout+n+1) = STRTRIM(values,2)
            nout = nout + 2*n + 1
         end
         'R': begin
            n = N_ELEMENTS(mins)
            conversion(nout) = STRTRIM(n,2)
            conversion(nout+1) = STRTRIM(mins,2)
            conversion(nout+n+1) = STRTRIM(maxs,2)
            conversion(nout+2*n+1) = STRTRIM(values,2)
            nout = nout + 3*n + 1
         END			
         ELSE:      ; no conversion
      ENDCASE
   ENDFOR           ; for k loop

                    ; set up filter table
   filter_filename = find_with_def('acs_filter.txt','JAUX')
   IF filter_filename[0] EQ '' THEN BEGIN
      MESSAGE, 'ERROR: acs_filter.txt not found', /CONTINUE
      error_code = 1b
      junk = TEMPORARY(position)
      return
   ENDIF 
   OPENR, unit, filter_filename, /GET_LUN, $
    ERROR=open_error
   IF (open_error NE 0) THEN BEGIN
      PRINTF, -2, !ERR_STRING
      error_code = 1b
      return
   ENDIF

   filter_wheel = INTARR(500)
   filter_number = INTARR(500)
   filter_name = STRARR(500)
   filter_wheel_pos = INTARR(500,3)
   n = 0
   wheel = 0
   st = ''
   WHILE NOT EOF(unit) DO BEGIN
      READF, unit, st
      filter_wheel(n) = gettok(st,' ')
      filter_number(n) = gettok(st,' ')
      filter_name(n) = gettok(st,' ')
      filter_wheel_pos(n,0) = gettok(st,' ') ;WFC
      filter_wheel_pos(n,1) = gettok(st,' ') ;HRC
      filter_wheel_pos(n,2) = gettok(st,' ') ;SBC
      n = n+1
   ENDWHILE
   filter_wheel = filter_wheel(0:n-1)
   filter_number = filter_number(0:n-1)
   filter_name = filter_name(0:n-1)
   filter_wheel_pos = filter_wheel_pos(0:n-1,*)
   FREE_LUN,unit

   return
END
