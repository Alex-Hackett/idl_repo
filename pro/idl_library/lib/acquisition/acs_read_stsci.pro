;+
; $Id: acs_read_stsci.pro,v 1.1 2001/12/03 21:39:01 mccannwj Exp $
;
; NAME:
;     ACS_READ_STSCI
;
; PURPOSE:
;     Routine to read ACS data files (in STScI format)
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ACS_READ_STSCI, filename, header [, data, $
;               CHIP=, MESSAGE=, ROTATE=, /KEEP, /NO_ABORT,  $
;               /NODATA, /OVERSCAN, /RAW, /WAIT ]
; 
; INPUTS:
;     filename - name of file to read
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     CHIP      - number of the chip to read (0 = all, 1 or 2). default = 0
;     MESSAGE   - error message if /NO_ABORT used.
;     ROTATE    - rotate amplifier data into a matrix format as though
;                  one were look at the detector (default=1 rotate)
;                  to leave in raw coordinates use rotate=0 or /raw
;     /KEEP     - if image was compressed. do not delete the
;                  uncompressed version. 
;     /NO_ABORT - specifies routine to return instead of retall if
;                  error encountered.
;     /NODATA   - read the headers only and not the data
;     /OVERSCAN - subtract and remove overscan regions
;     /RAW      - do not rotate image
;     /WAIT     - block and wait for user to insert ARCDISK CDROM
;
; OUTPUTS:
;     header - image header
;
; OPTIONAL OUTPUTS:
;     data - data array
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     Uses the $$ pid variable of UNIX shells to construct a temporary
;     filename for uncompressed data.  Uses IDL_TMPDIR for temporary files.
;
; NOTES:
;     Input files may be gzipped (with extension .gz).
;
;     Really this routine should be a special case handled by ACS_READ
;     itself.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;     Clone of ACS_READ that supports STScI format data files.
;
;-

PRO acs_read_decompress_cleanup, path, original_filename, KEEP=keep, $
                                 SILENT=silent
   
   IF NOT KEYWORD_SET(keep) THEN BEGIN
      strSpawn = '/usr/bin/rm -f '+ path
   ENDIF ELSE BEGIN
      FDECOMP, original_filename, disk,dir,fname,ext
      IF ext[0] EQ 'gz' THEN new_filename = fname $
      ELSE new_filename = fname + '.' + ext
      strSpawn = '/usr/bin/mv '+path+' ./'+new_filename
      IF NOT KEYWORD_SET(silent) THEN $
       PRINT, 'Placing '+new_filename+' into current directory'
   ENDELSE
   SPAWN, strSpawn
END 

FUNCTION acs_read_stsci_decompress_file, filename, $
                                         MESSAGE=message, ERROR=error_code, $
                                         SILENT=silent

   IF NOT KEYWORD_SET(silent) THEN $
    PRINT,'ACS_READ_STSCI: decompressing file: '+filename
   fdecomp,filename,disk,dir,fname,ext
   temp_dir = GETENV('IDL_TMPDIR')
   temp_filename = temp_dir+'acs_read_stsci-$$.fits'
   SPAWN, 'gunzip -c ' + filename + ' > '+temp_filename, PID=pid, /SH
   temp_filename = temp_dir+'acs_read_stsci-'+STRTRIM(pid,2)+'.fits'
   filename = fname
   new_filename = temp_filename
   
   return, new_filename
END

FUNCTION acs_read_stsci_find_file, id, MESSAGE=message, ERROR=error_code, $
                                   WAIT=wait, SILENT=silent
   message = ''
   error_code = 0b
                    ; determine file name
   IF datatype(id) NE 'STR' THEN BEGIN
      message = 'ACS_READ_STSCI - invalid filename'
      error_code = 1
      return, ''
   ENDIF ELSE filename = id

   IF NOT KEYWORD_SET(silent) THEN $
    PRINT, 'searching for '+filename+'...'
                    ; First look in JDATA
   file_to_read = find_with_def(filename,'JDATA','.fits,.gz')
   
   return, file_to_read
END 

PRO acs_read_stsci, id, h, d, $
                    CHIP=chip, ROTATE=rotate, OVERSCAN=overscan, $
                    NO_ABORT=no_abort, MESSAGE=message, RAW=raw, KEEP=keep, $
                    NODATA=nodata, WAIT=wait, SILENT=silent

   IF N_PARAMS(0) LT 1 THEN BEGIN
      PRINT, 'Usage: ACS_READ, id, h, d, hudl, udl, heng1, heng2'
      PRINT, 'KEYWORD INPUTS: CHIP=, ROTATE=, /OVERSCAN, /NO_ABORT, ' + $
       'MESSAGE=, /RAW, /KEEP, /NODATA'
      return
   ENDIF
;
; set defaults
;
   IF N_ELEMENTS(chip) EQ 0 THEN chip=0
   IF N_ELEMENTS(rotate) EQ 0 THEN rotate=1
   IF N_ELEMENTS(no_abort) EQ 0 THEN no_abort=0
   IF N_ELEMENTS(overscan) EQ 0 THEN overscan=0
   IF N_ELEMENTS(keep) EQ 0 THEN keep=0
   IF KEYWORD_SET(raw) THEN rotate=0

   original_filename = acs_read_stsci_find_file(id,WAIT=wait,SILENT=silent,$
                                          ERROR=error_code, MESSAGE=message)
   IF error_code NE 0 THEN GOTO, abort

   uncompress = 0   ; flag if data is to be uncompressed
   IF STRPOS(original_filename,'.gz') GT 0 THEN BEGIN
      file_to_read = acs_read_stsci_decompress_file(original_filename, $
                                                    SILENT=silent, $
                                                    ERROR=error_code, $
                                                    MESSAGE=message)
      uncompress = 1
   ENDIF ELSE BEGIN
      file_to_read = original_filename
   ENDELSE

   FITS_OPEN, file_to_read, fcb, NO_ABORT=no_abort, MESSAGE=message
   IF !ERR LT 0 THEN GOTO, abort
;
; get some header information
;
   detector = STRTRIM(sxpar(fcb.hmain,'detector'))
   amps = STRTRIM(sxpar(fcb.hmain,'ccdamp'))
;
; Read data ------------------------------------------------------------------
;
   IF (N_PARAMS(0) LT 3) OR KEYWORD_SET(nodata) THEN BEGIN
                    ;read header only?
      fits_read,fcb,d,h,/HEADER_ONLY
      GOTO, done
   ENDIF
;
; determine if both chips were read
;

   CASE detector OF
      'WFC': BEGIN
                    ; WFC DATA  ---------------------------------------------

         chip1 = 0 & amp1 = ''
         chip2 = 0 & amp2 = ''
         IF STRPOS(amps,'A') GE 0 THEN BEGIN
            chip1 = 1 & amp1 = amp1 + 'A'
         ENDIF
         IF STRPOS(amps,'B') GE 0 THEN BEGIN
            chip1 = 1 & amp1 = amp1 + 'B'
         ENDIF
         IF STRPOS(amps,'C') GE 0 THEN BEGIN
            chip2 = 1 & amp2 = amp2 + 'C'
         ENDIF
         IF STRPOS(amps,'D') GE 0 THEN BEGIN
            chip2 = 1 & amp2 = amp2 + 'D'
         ENDIF
         IF ((chip EQ 1) AND (chip1 EQ 0)) OR $
          ((chip EQ 2) AND (chip2 EQ 0)) THEN BEGIN
            message = 'ACS_READ_STSCI: Specified CHIP not found'
            GOTO, abort
         ENDIF

                    ; read chip 1
         IF (chip1 EQ 1) AND (chip NE 2) THEN BEGIN
            fits_read,fcb,d,h,EXTNAME='SCI'
            amps_read = amp1
         ENDIF

                    ; read chip 2 only
         IF (chip EQ 2) THEN BEGIN
            IF (chip1 EQ 0) THEN fits_read,fcb,d,h,EXTNAME='SCI' $
            ELSE fits_read,fcb,d,h,EXTNAME='SCI', $
             EXTVER=2
            amps_read = amp2
         ENDIF

                    ; read both chips
         IF (chip EQ 0) AND (chip2 EQ 1) THEN BEGIN
            IF (chip1 EQ 0) THEN fits_read,fcb,d2,h,EXTNAME='SCI' $
            ELSE fits_read,fcb,d2,h,EXTNAME='SCI', $
             EXTVER=2
            IF chip1 EQ 1 THEN BEGIN
               d = [[d2],[d]]
               sxaddpar,h,'chip',0 ;flag as both
            ENDIF ELSE d = TEMPORARY(d2)
            amps_read = amp1+amp2
         ENDIF

                    ; SCI arrays are stored as reals (no scaling required)
         sxaddpar,h,'ccdamp',amps_read

                    ; remove overscan
         ;;XXXX FIX LATER
         ;;IF overscan THEN acs_overscan,h,d

                    ; At this point each amp is rotated correctly
                    ; So if the rotate=0 keyword is specified we
                    ; must explicitly scramble the array
         IF rotate EQ 0 THEN BEGIN
            acs_scramble,amps_read,d
            sxaddhist,'ACS_READ_STSCI - CCD Amps unrotated with ' + $
             'ACS_SCRAMBLE',h
         ENDIF ELSE d = ROTATE(TEMPORARY(d),7)

      END 

      'HRC': BEGIN
                    ; HRC DATA  ---------------------------------------------

         fits_read,fcb,d,h,EXTNAME='SCI'
         amps_read = amps

                    ; SCI arrays are stored as reals (no scaling required)
         sxaddpar,h,'ccdamp',amps_read

                    ; XXXX Does this work?
         IF STRTRIM(sxpar(h,'obstype')) NE 'TARG_ACQ' THEN BEGIN

                    ; remove overscan
            ;;XXXX FIX LATER
            ;;IF overscan THEN acs_overscan,h,d

                    ; rotate data
            IF rotate EQ 0 THEN BEGIN
               acs_scramble,amps_read,d
               sxaddhist,'ACS_READ_STSCI - CCD Amps unrotated with ' + $
                'ACS_SCRAMBLE',h
            ENDIF ELSE d = ROTATE(TEMPORARY(d),7)
         ENDIF
      END

      'SBC': BEGIN
                    ; MAMA DATA ---------------------------------------------

         fits_read,fcb,d,h,EXTNAME='SCI'

                    ; reformat local rate check images
                    ; XXXX Will this work?
         IF STRTRIM(sxpar(h,'obstype')) EQ 'MEMDUMP' THEN BEGIN
            IF (N_ELEMENTS(d) EQ 65536) AND $
             (STRTRIM(sxpar(h,'JQMDSRC')) EQ 'MIE') THEN $
             d = REFORM(d,256,256,/OVERWRITE)
         ENDIF

      END 

      ELSE: BEGIN
         message = 'ACS_READ: Unknown detector: '+detector
         GOTO, abort
      END

   ENDCASE

;
; Done
;
Done:
   fits_close,fcb
   IF uncompress THEN BEGIN
      acs_read_decompress_cleanup, file_to_read,original_filename,KEEP=keep,$
       SILENT=silent
   ENDIF 
;
; fix header date/time
;
   !ERR = 1
   return
;
; Abort
;
abort:
   IF no_abort THEN BEGIN
      !ERR = -1
      return
   ENDIF ELSE BEGIN
      !ERR = -1
      PRINT, message
      RETALL
   ENDELSE
END
