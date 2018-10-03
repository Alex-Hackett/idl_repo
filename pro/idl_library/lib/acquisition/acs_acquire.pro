;+
; $Id: acs_acquire.pro,v 1.8 2001/04/27 15:21:09 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE
;
; PURPOSE:
;     Routine to acquire raw ACS data (packet files)
;
; CATEGORY:
;     ACS Data Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE, file, header, data, hudl, udl, heng1, heng2
; 
; INPUTS:
;     file - raw data packet file name
;
; OPTIONAL INPUTS:
;      
; KEYWORD INPUTS:
;     CHIP     - (NUMBER) read only specified chip number
;     ERROR    - (NUMBER) error status on exit (nonzero if an error occurred)
;     /LOG     - (BOOL) add data set to merged observing log.  If specified
;                  output fits files will be written and file names will
;                  have form fswxxx.fits, where xxx is the entry number
;                  in the merged log.  !priv must be 1 to execute with /log.
;     /NODATA  - (BOOL) set to only read headers
;     /NOWRITE - (BOOL) set to not write the FITS files
;                  default is nowrite=0 which writes the file.
;     NUMBER   - (NUMBER) specifies which observation to return when
;                  multiple exposures are in the same input file
;     OUTDIR   - (STRING) output directory to write FITS files in.
;     ROTATE   - (BOOL) rotate amplifier data into a matrix format as though
;                  one were looking at the detector (default is no rotation)
;                  note: rotation only effects the returned data
;                        array, not the data file.
;     /SWAP    - (BOOL) set if odd/even bytes in the input file are reversed.
;
; KEYWORD OUTPUTS:
;     ID1 - first log entry number acquired
;     ID2 - last log entry number acquired
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;     h     - header for last observation processed
;     data  - data for last observations processed
;     udl   - internal science data header with packet header and sync
;              words removed
;     heng1 - first engineering snapshot header
;     heng2 - second engineering snapshot header
;
; FILE OUTPUTS
;     The following FITS files will be written for each observation in the
;      input file.
;
;		<name>_<n>.fits		data array
;		<name>_<n>.ufits 	internal UDL vector
;	
;	where <name> is the input file name and <n> is the observation number
;	within the file.
;
; COMMON BLOCKS:
;     Defined in @ACS_ACQUIRE_COMMON and set up in ACS_ACQUIRE_SETUP
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
;     Written by D. Lindler   May. 1998
;     Version 2.0 D. Lindler Nov 27, 1998
;          modified to uncompress WFC data compressed onboard,
;          no longer addes 32768 to Target Acq data,
;          installed new tdfd.an file.
;          version 2.1 D. Lindler Dec 7, 1998, added reacquire option again.
;     version 2.2 D. Lindler Dec 15, 1998, added STUFF processing
;     version 2.3 D. Lindler Feb 17, 1999, added OTF compressed data support
;     version 2.4, Lindler, Feb 28, 1999, added stimulus_in and
;          environment keyword inputs. added id1 and id2 output
;          keyword parameters
;     version 2.5, McCann, 18 Nov 1999, added ROTATE keyword
;     version 2.6, McCann, 10 May 2000, fixed handling of data output
;                                       added CHIP keyword
;                                       added reindexing via DBINDEX
;     version 2.7, McCann, 25 Sep 2000, added ERROR keyword and 
;                                       changed RETALL to RETURN
;     version 2.8, McCann, 19 Feb 2001, added MONOHOMS stimulus log
;     version 2.9, McCann, 27 Apr 2001, once again handles memory dump data
;-
;----------------------------------------------------------------------------
PRO acs_acquire, file, h, data, hudl, udl, heng1, heng2, NOWRITE=nowrite, $
                 NUMBER=number, ROTATE=rotate, CHIP=chip, NODATA=nodata, $
                 LOG=log, INDIR=indir, OUTDIR=outdir, EXT_SOURCE=ext_source, $
                 COMMENT=comment, SWAP=swap, REACQUIRE=reacquire, $
                 STIMULUS_IN=stimulus_in, VERBOSE=verbose, $
                 ENVIRONMENT=environment, ID1=id1, ID2=id2, $
                 ERROR=error_flag

   error_flag = 0b
   VERSION = 2.9
                    ; common block setup by acs_acquire_setup
@acs_acquire_common.pro

                    ; if no parameters supplied, then write the
                    ; calling sequence
   IF N_PARAMS(0) EQ 0 THEN BEGIN
      PRINT, 'Usage: ACS_ACQUIRE, file, ' + $
       'h,data,hudl,udl,heng1,heng2'
      PRINT, 'KEYWORDS: ERROR, /NOWRITE, /LOG, /SWAP, OUTDIR, NUMBER'
      PRINT, '          /REACQUIRE, STIMULUS_IN, ENVIRONMENT, ID1, ID2'
      error_flag = 1b
      return
   ENDIF

                    ; Set up common block containing engineering
                    ; telemetry info
   acs_acquire_setup, ERROR=error_flag
   IF error_flag[0] NE 0 THEN return

                    ; get manual inputs
   fname = find_with_def('acs_setup.txt','JAUX')
   stimulus = ' '
   environ = ' '
   build = ['   ','   ','   ','   ']
   IF fname NE '' THEN BEGIN
      OPENR, unit, fname, /GET_LUN, ERROR=open_error
      IF (open_error NE 0) THEN BEGIN
         PRINTF, -2, !ERR_STRING
         error_flag = 1b
         GOTO, return
      ENDIF

      st = ' '
      READF, unit, st & stimulus = GETTOK(st,' ')
      READF, unit, st & environ = GETTOK(st,' ')
      FOR i=1,3 DO BEGIN
         READF, unit, st
         build(i) = GETTOK(st,' ')
      ENDFOR
      FREE_LUN, unit
   ENDIF ELSE BEGIN
      PRINT,'WARNING: No acs_setup.txt file found in JAUX'
   ENDELSE
   IF N_ELEMENTS(stimulus_in) GT 0 THEN stimulus = stimulus_in
   IF N_ELEMENTS(environment) GT 0 THEN environ = environment
   PRINT,' ----------------------------------------------------------'
   PRINT,' '
   PRINT,' Stimulus = ',stimulus,'  Environ= ',environ, ' Det Builds = ', $
    build[1],' ',build[2],' ',build[3]
   PRINT,' '
   PRINT,' ----------------------------------------------------------'
;
; for now the default is not to print FITS.FILE
;
   IF N_ELEMENTS(nowrite) eq 0 then nowrite=0
   IF N_ELEMENTS(number) eq 0 then number = 9999999 ; last one
   IF N_ELEMENTS(log) eq 0 then log = 0
   IF N_ELEMENTS(outdir) eq 0 then outdir = ''
   IF N_ELEMENTS(swap) eq 0 then swap = 0
;
; decompose input file name
;
   PRINT,' '
   PRINT,'PROCESSING FILE '+file
   fdecomp,file,disk,dir,name
;
; open raw packet file
;
   OPENR, unit, file, /GET_LUN, ERROR=open_error
   IF (open_error NE 0) THEN BEGIN
      PRINTF, -2, !ERR_STRING
      error_flag = 1b
      GOTO, return
   ENDIF 
   packet = INTARR(1024)
;
; initialization
;
   index = INDGEN(64,16) ;indices for 16 segments (64 words)
   index = REFORM(index(3:63,*)) ;indices with sync words removed
   index = index(11:975) ;indices with packet header removed
   iobs = 0         ;observation number within file
   extra = 0        ;extra packets at end of obs.
   fdecomp,file,disk,dir,name,ext
;
; loop on packets
;
   WHILE NOT EOF(unit) DO BEGIN
;
; read next packet
;
      readu,unit,packet
      IF swap then byteorder,packet
      byteorder,packet,/ntohs
      packet_header = packet(0:13)
      packet_data = packet(index) ; packet data without 
                    ; header or sync words
;
; check for SHP
;
      IF strupcase(ext) eq 'SHP' THEN BEGIN
         acs_acquire_shp, packet_header, packet_data
         shpfile = name+'.'+ext
         GOTO, return
      ENDIF
;
; check for internal UDL fill pattern
;
      IF MAX(ABS(packet_data(0:7)+21846)) eq 0 THEN BEGIN ;'AAAA' HEX
;
; print number of extra packets after last obs.
;
         IF extra gt 0 THEN BEGIN
            PRINT,STRTRIM(extra,2)+' additional undecoded '+ $
             'packets received'
            extra = 0
         end

         iobs = iobs + 1
         PRINT,'Reading Observation number '+STRTRIM(iobs,2)
;
; Process internal UDL 
;
         IF KEYWORD_SET( verbose ) THEN PRINT, FORMAT='($,A)', '  acquiring UDL...'
         acs_acquire_udl, packet_data, hudl, ERROR=error_flag
         IF error_flag[0] NE 0 THEN return

         IF KEYWORD_SET( verbose ) THEN PRINT, 'done.'
         outname = name+'_'+STRTRIM(iobs,2)+'.fits'
         sxaddpar, hudl, 'filename', name+'_'+STRTRIM(iobs,2)
         udl = packet_data
         line_count = packet_header(7)
         sxaddpar,hudl,'FPKTTIME', $
          acs_time(packet_header(8:10),0,0,zero_time), $
          'Internal UDL packet time'
;
; extract engineering snapshots
;
         IF KEYWORD_SET( verbose ) THEN PRINT, FORMAT='($,A)', '  acquiring EDS...'
         acs_acquire_eds, udl(255:255+349), heng1
         acs_acquire_eds, udl(605:605+349), heng2
         IF KEYWORD_SET( verbose ) THEN PRINT, 'done.'
;
; add additional information to header

         sxaddpar,hudl,'ACQ_VER',version, $
          'ACS_ACQUIRE version number',version
;
; create science image header
;
         IF KEYWORD_SET( verbose ) THEN PRINT, FORMAT='($,A)', '  acquiring header...'
         acs_acquire_header, hudl, heng1, heng2, h, ERROR=error_flag
         IF error_flag[0] NE 0 THEN return

         IF KEYWORD_SET( verbose ) THEN PRINT, 'done.'
;
; add manual information to the header
;
         sxaddpar,h,'stimulus',stimulus
         sxaddpar,h,'environ',environ
         idet = sxpar(hudl,'jqdetno')
         sxaddpar,h,'detectid',build(idet)
;
; add RAS/HOMS monochromator information
;
         IF STRUPCASE(stimulus) eq 'MONOHOMS' THEN BEGIN
            PRINT,'STIMULUS = MONOHOMS - looking for monochromator log file'
            acs_acquire_monohoms, h, ERROR=error_flag
            IF error_flag[0] NE 0 THEN return
         ENDIF
;
; add RASCAL information
;
         IF strupcase(stimulus) eq 'RASCAL' THEN BEGIN
            PRINT,'STIMULUS = RASCAL - looking for rascal file'
            acs_acquire_rascal, h, ERROR=error_flag
            IF error_flag[0] NE 0 THEN return
         ENDIF
;
; add STUFF header info
;
         IF strupcase(stimulus) eq 'STUFF' THEN BEGIN
            PRINT,'STIMULUS = STUFF - looking for STUFF file'
            acs_acquire_stuff, h, ERROR=error_flag
            IF error_flag[0] NE 0 THEN return
         ENDIF

         IF KEYWORD_SET(nodata) THEN BEGIN
            IF KEYWORD_SET(verbose) THEN PRINT, '  skipping image...'
            GOTO, done
         ENDIF 
         IF KEYWORD_SET(verbose) THEN PRINT, '  acquiring image...'
;
; extract the science data following the UDL
;
         error_flag = 0b
         acs_acquire_sci, unit, swap, hudl, h, line_count, raw_data, $
          ERROR=error_flag
         IF error_flag[0] NE 0 THEN return
;
; process raw data
;
         im_type = STRTRIM(sxpar(h,'jqimgtyp'),2)
         detector = STRTRIM(sxpar(h,'detector'),2)
         ccdamp = STRTRIM(sxpar(h,'ccdamp'),2)

         hchip1 = ['END      ']
         hchip2 = ['END      ']
         CASE detector OF

            'WFC': BEGIN
               s = size(raw_data) & nx = s(1) & ny = s(2)
               nx2 = nx/2 & ny2 = ny/2 & n2 = nx*ny/2 & n4 = n2/2
               IF (ccdamp EQ 'ABCD') THEN BEGIN
                  sxaddpar,hchip1,'CHIP',1
                  sxaddpar,hchip2,'CHIP',2
                  d1 = [REFORM(raw_data(0:n4-1),nx2,ny2), $
                        REFORM(raw_data(n4:n2-1),nx2,ny2)]
                  d2 = [REFORM(raw_data(n2:3*n4-1),nx2,ny2), $
                        REFORM(raw_data(3*n4:*),nx2,ny2)]
               ENDIF ELSE IF (ccdamp eq 'AC') or (ccdamp eq 'AD') or $
                (ccdamp eq 'BC') or (ccdamp eq 'BD') THEN BEGIN
                  sxaddpar,hchip1,'CHIP',1
                  sxaddpar,hchip2,'CHIP',2
                  d1 = REFORM(raw_data(0:n2-1),nx,ny2)
                  d2 = REFORM(raw_data(n2:*),nx,ny2)
               ENDIF ELSE IF (ccdamp eq 'C') or (ccdamp eq 'D') THEN BEGIN 
                  sxaddpar,hchip1,'CHIP',2
                  d1 = TEMPORARY(raw_data)
               ENDIF ELSE IF (ccdamp eq 'A') or (ccdamp eq 'B') THEN BEGIN
                  sxaddpar,hchip1,'CHIP',1
                  d1 = TEMPORARY(raw_data)
               ENDIF
            END 

            'HRC': BEGIN
               IF (ccdamp EQ 'ABCD') THEN BEGIN
                  s = size(raw_data) & nx = s[1] & ny = s[2]
                  nx2 = nx/2 & ny2 = ny/2 & n2 = nx*ny/2 & n4 = n2/2
                  d1 = [ [ REFORM(raw_data(0:n4-1),nx2,ny2), $
                           REFORM(raw_data(n4:n2-1),nx2,ny2) ], $
                         [ REFORM(raw_data(n2:3*n4-1),nx2,ny2), $
                           REFORM(raw_data(3*n4:*),nx2,ny2) ] ]
               ENDIF ELSE d1 = TEMPORARY(raw_data)
            END

            'SBC': BEGIN
               d1 = TEMPORARY(raw_data)
            END

            ELSE: BEGIN

               IF STRTRIM(sxpar(h,'OBSTYPE')) EQ 'MEMDUMP' THEN BEGIN
                  IF N_ELEMENTS(raw_data) LE 0 THEN BEGIN
                     MESSAGE, 'Memory dump has no data.', /CONTINUE
                     error_flag = 1b
                     GOTO, return
                  ENDIF
                  IF STRTRIM(sxpar(h,'JQMDSRC')) EQ 'MIE' THEN BEGIN
                     sxaddpar,h,'detector','SBC'
                     PRINT, 'MIE memory dump data'
                  ENDIF ELSE PRINT, 'Memory dump data'
                  d1 = TEMPORARY(raw_data)
               ENDIF ELSE BEGIN
                  MESSAGE, 'Unknown detector '+detector, /CONTINUE
                  error_flag = 1b
                  GOTO, return
               ENDELSE
            END 

         ENDCASE 

         IF N_ELEMENTS(d1) LE 1 THEN BEGIN
            PRINT, STRING(7b)+'No file written'
            GOTO, done
         ENDIF

         IF NOT KEYWORD_SET(nowrite) THEN BEGIN
                    ; write data to fits file
            PRINT,'writing FITS file '+outname
            fits_open, outdir+outname, fcb, /WRITE, /NO_ABORT, $
             MESSAGE=message
            IF !ERR LT 0 THEN BEGIN
               IF N_ELEMENTS(message) GT 0 THEN MESSAGE, message, /CONTINUE
               error_flag = 1b
               GOTO, return
            ENDIF

            fits_write, fcb, 0, h
                    ; write image data
            fits_write,fcb,d1,hchip1,EXTNAME='SCI',EXTVER=1
            IF N_ELEMENTS(d2) GT 2 THEN $
             fits_write,fcb,d2,hchip2,EXTNAME='SCI',EXTVER=2

                    ; write science header line and snapshots
            fits_write,fcb,udl,hudl,EXTNAME='UDL',EXTVER=1
            fits_write,fcb,0,heng1,EXTNAME='EDS',EXTVER=1,EXTLEV=1
            fits_write,fcb,0,heng2,EXTNAME='EDS',EXTVER=1,EXTLEV=2
            fits_close,fcb
         ENDIF
;
; Define the data array
;
         IF (N_ELEMENTS(d2) LE 2) THEN BEGIN
            data = TEMPORARY(d1)
         ENDIF ELSE BEGIN
            IF N_ELEMENTS( chip ) GT 0 THEN BEGIN
               ccdamp_array=BYTE(STRTRIM(STRUPCASE(SXPAR(h, 'ccdamp')), 2))
               CASE chip OF
                  1: BEGIN
                     d2 = 0b
                     data = TEMPORARY( d1 )
                     amp_i = WHERE( (ccdamp_array EQ 65b) OR $
                                    (ccdamp_array EQ 66b) )
                     amps_read = STRING(ccdamp_array[amp_i])
                  END
                  2: BEGIN
                     d1 = 0b
                     amp_i = WHERE( (ccdamp_array EQ 67b) OR $
                                    (ccdamp_array EQ 68b) )
                     amps_read = STRING(ccdamp_array[amp_i])
                     data = TEMPORARY( d2 )
                  END
                  ELSE: BEGIN
                     data = [[TEMPORARY(d1)],[TEMPORARY(d2)]]
                  END 
               ENDCASE 
            ENDIF ELSE data = [[TEMPORARY(d1)],[TEMPORARY(d2)]]
         ENDELSE 
;
; if /log, update the data base
;
;
; open data base if /log 
;
         IF log THEN BEGIN
            IF !PRIV LT 2 THEN BEGIN
               PRINT,'!PRIV must be 2 or greater to update acs_log'
               error_flag = 1b
               return
            ENDIF
            dbopen,'acs_log',1
            dbrd,0,entry ;get blank entry
            acs_acquire_log, h, hudl, data, entry, ERROR=error_flag
            IF error_flag[0] NE 0 THEN return

            IF keyword_set(reacquire) THEN BEGIN
               filename = STRTRIM(sxpar(h,'filename'))
               dbext,-1,'filename',filenames
               good = WHERE(STRTRIM(filenames) EQ filename,ngood)
               IF ngood eq 0 THEN BEGIN
                  PRINT,'ACS_ACQUIRE - ERROR attempting to ' + $
                   'reacquire file not in log'
                  error_flag = 1b
                  return
               endif
               dbput,'entry',good[0]+1,entry
               DBWRT, entry, 0
               PRINT,'ENTRY',good[0]+1,' updated in ACS_LOG'
            ENDIF ELSE BEGIN
               DBWRT, entry, 0, 1 
               PRINT,'ENTRY',dbval(entry,'entry'), + $
                '  added to ACS_LOG'
            ENDELSE
            enum = dbval(entry,'entry')
            IF N_ELEMENTS(first_entry) EQ 0 THEN first_entry=enum
                    ; reindex database
            dbindex
            dbclose
         ENDIF 
      ENDIF ELSE BEGIN
         extra = extra + 1 ;extra packet
      ENDELSE
      done:  IF iobs EQ number THEN GOTO, completely_done

   ENDWHILE

completely_done:
;
; update sms times in the headers
;
   IF N_ELEMENTS(first_entry) GT 0 THEN BEGIN
      id1 = first_entry
      id2 = enum
      acs_fix_sms_times,id1,id2
   ENDIF
;
; print number of extra packets after last obs.
;
   IF extra gt 0 THEN BEGIN
      PRINT,STRTRIM(extra,2)+' additional unneeded packets received'
      extra = 0
   ENDIF

   IF (N_ELEMENTS(h) GT 4) AND (N_ELEMENTS(data) GT 2) THEN BEGIN
      IF ( STRTRIM(SXPAR(h,'obstype'),2) NE 'TARG_ACQ') THEN BEGIN
                    ; rotate data
         IF KEYWORD_SET( rotate ) THEN BEGIN
            IF N_ELEMENTS( amps_read ) LE 0 THEN $
             amps_read = STRTRIM( SXPAR( h, 'ccdamp' ), 2 )
            HELP, amps_read
            acs_unscramble, amps_read, data
            sxaddhist, 'ACS_ACQUIRE - CCD Amps rotated with ' + $
             'ACS_UNSCRAMBLE', h
         ENDIF
      ENDIF
   ENDIF
return:
   FREE_LUN, unit
   return
END 
