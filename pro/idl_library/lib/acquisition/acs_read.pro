;+
; $Id: acs_read.pro,v 1.9 2002/03/12 18:05:46 mccannwj Exp $
;
; NAME:
;     ACS_READ
;
; PURPOSE:
;     Routine to read ACS raw data files
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ACS_READ, id, header [, data, hudl, udl, heng1, heng2, $
;               HSPT=HSPT, CHIP=, MESSAGE=, ROTATE=, /KEEP, /NO_ABORT,  $
;               /NODATA, /OVERSCAN, /RAW, /WAIT, /PRELAUNCH, /POSTLAUNCH ]
; 
; INPUTS:
;     id - file name or entry number in the ACS_LOG
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     CHIP      - number of the chip to read (0 = all, 1 or 2). default = 0
;     MESSAGE   - error message if /NO_ABORT used.
;     /KEEP     - if image was compressed. do not delete the
;                  uncompressed version. 
;     /NO_ABORT - specifies routine to return instead of retall if
;                  error encountered.
;     /NODATA   - read the headers only and not the data
;     /OVERSCAN - subtract and remove overscan regions
;     /RAW      - Place data in raw format (each amp placed at lower
;		left corner of the image quadrant
;     /PRELAUNCH - orient data to prelaunch format (amp A in lower left
;		corner)
;     /POSTLAUNCH - orient data in postlaunch format (amp a in upper left
;		corner)
;     ROTATE    - = 0 same as /raw
;		  = 1 same as /prelaunch
;		  = 2 same as /postlaunch
;
;         If orientation is no specified !prelaunch system variable is
;	  used.  If !prelaunch = 0 then the output is in the postlaunch
;	  orientation.  If !prelaunch = 1 then the output is in the prelaunch
;	  orientation.
;
;     /WAIT     - block and wait for user to insert ARCDISK CDROM
;     /PRELAUNCH - orient data to prelaunch format
;     HSPT - output _spt file header
; OUTPUTS:
;     header - image header
;
; OPTIONAL OUTPUTS:
;     d - data array
;     hudl - science header line (internal unique data log) header
;     udl - internal binary header array
;     heng1 - header for the first eng. data snapshot
;     heng2 - header for the second eng. data snapshot
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
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;     version 1  D. Lindler  July 23, 1998
;     17 Nov 1998 T.Beck  - now checks ARCDISK if file not found &
;          return message instructing use to insert appropriate CD.
;     27 Nov 1998 Lindler - no longer rotates target acq images.
;     3 Dec 1998 Lindler  - Modified to delete temp file when reading
;       header only.
;     9 Dec 1998 Lindler  - Modfiied to format 65536 word MIE memory
;       dumps as a 256 x 256 image (MAMA local rate check image)
;     28 Feb 1999 Lindler - added /NODATA keyword input
;     30 Sept 1999 McCann - added /WAIT keyword, some formatting.
;     Jun 2000 McCann     - rewrite to handle each detector separately.
;     Jan 2002, Lindler,  - modified for post-launch support
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

FUNCTION acs_read_decompress_file, filename, $
                                   MESSAGE=message, ERROR=error_code, $
                                   SILENT=silent

   IF NOT KEYWORD_SET(silent) THEN $
    PRINT,'ACS_READ: decompressing file: '+filename
   fdecomp,filename,disk,dir,fname,ext
   temp_dir = GETENV('IDL_TMPDIR')
   temp_filename = temp_dir+'acs_read-$$.fits'
   SPAWN, 'gunzip -c ' + filename + ' > '+temp_filename, PID=pid, /SH
   temp_filename = temp_dir+'acs_read-'+STRTRIM(pid,2)+'.fits'
   filename = fname
   new_filename = temp_filename
   
   return, new_filename
END

FUNCTION acs_read_find_file, id, MESSAGE=message, ERROR=error_code, $
                             WAIT=wait, SILENT=silent

   message = ''
   error_code = 0b
                    ; determine file name
   IF datatype(id) NE 'STR' THEN BEGIN
      dbopen,'acs_log'
      nentries = db_info('entries',0)
      IF (id LT 1) OR (id GT nentries) THEN BEGIN
         message = 'ACS_READ - invalid entry number specified'
         error_code = 1
         return, ''
      ENDIF
      filename = STRTRIM(dbval(id,'filename'), 2)+'.fits'
   ENDIF ELSE filename = id

find:
   IF NOT KEYWORD_SET(silent) THEN $
    PRINT, 'searching for '+filename+'...'
                    ; First look in JDATA
   file_to_read = find_with_def(filename,'JDATA','.fits,.gz')
   

   IF file_to_read EQ '' THEN BEGIN
      arcdisk = dbval(id,'ARCDISK')
      IF (arcdisk EQ '') THEN BEGIN
         message = 'ACS_READ: Unable to find file: '+filename
         error_code = 1
         return, ''
      ENDIF ELSE BEGIN
                    ; Then look in JARCHIVE
         archpath = GETENV('JARCHIVE')
         IF archpath[0] NE '' THEN BEGIN
            arc_dir = STRMID(STRTRIM(arcdisk,2),11)
            arc_file = STRTRIM(archpath,2)+'/'+arc_dir+'/'+filename+'.gz'
            file_to_read = (FINDFILE(arc_file))[0]
         ENDIF 

         IF file_to_read EQ '' THEN BEGIN
                    ; Then prompt for ARCDISK
            IF KEYWORD_SET(wait) THEN BEGIN
               strMessage = 'ACS_READ: Insert CD: ' + STRTRIM(arcdisk,2) + $
                " and press a key to continue ('q' to quit)..."
               PRINT, strMessage
               key = GET_KBRD(1)
               IF key EQ 'q' THEN BEGIN
                  message = 'ACS_READ: wait for '+STRTRIM(arcdisk,2)+' cancelled'
                  error_code = 1
                  return, ''
               ENDIF ELSE GOTO, find
            ENDIF ELSE BEGIN
               message = 'ACS_READ: Insert CD: '+STRTRIM(arcdisk,2) + $
                ' and try again'
               error_code = 1
               return, ''
            ENDELSE
         ENDIF
      ENDELSE
   ENDIF ELSE BEGIN
      IF NOT KEYWORD_SET(silent) THEN $
       PRINT, 'found in '+file_to_read
   ENDELSE 
   
   return, file_to_read
END 

PRO acs_read, id, h, d, hudl, udl, heng1, heng2, $
              CHIP=chip, ROTATE=rotate, OVERSCAN=overscan, $
              NO_ABORT=no_abort, MESSAGE=message, RAW=raw, KEEP=keep, $
              NODATA=nodata, WAIT=wait, SILENT=silent, PRELAUNCH = prelaunch, $
	      POSTLAUNCH = postlaunch, HSPT = hspt
	      
   IF N_PARAMS(0) LT 1 THEN BEGIN
      PRINT, 'Usage: ACS_READ, id, h, d, hudl, udl, heng1, heng2'
      PRINT, 'KEYWORD INPUTS: CHIP=, ROTATE=, /OVERSCAN, /NO_ABORT, ' + $
       'MESSAGE=, HSPT=, /RAW, /PRELAUNCH, /POSTLAUNCH, /KEEP, /NODATA'
      return
   ENDIF
;
; set defaults
;
   IF N_ELEMENTS(chip) EQ 0 THEN chip=0
   IF N_ELEMENTS(no_abort) EQ 0 THEN no_abort=0
   IF N_ELEMENTS(overscan) EQ 0 THEN do_overscan=0 else do_overscan=1
   IF N_ELEMENTS(keep) EQ 0 THEN keep=0
   IF N_ELEMENTS(rotate) EQ 0 THEN $
   	if !prelaunch eq 0 then rotate = 2 else rotate = 1
   IF KEYWORD_SET(raw) THEN rotate=0
   IF KEYWORD_SET(prelaunch) then rotate=1
   if KEYWORD_SET(postlaunch) then rotate=2

   original_filename = acs_read_find_file(id,WAIT=wait,SILENT=silent,$
                                          ERROR=error_code, MESSAGE=message)
   IF error_code NE 0 THEN GOTO, abort

   uncompress = 0   ; flag if data is to be uncompressed
   IF STRPOS(original_filename,'.gz') GT 0 THEN BEGIN
      file_to_read = acs_read_decompress_file(original_filename, $
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
; determine if pre or postlaunch data
;
   telescope = strtrim(sxpar(fcb.hmain,'telescop'),2)
   if telescope eq 'HST' then begin
   	post_launch = 1 
   	current_orientation = 2
     end else begin
        post_launch = 0
   	current_orientation = 0
   end
;
; read spt file for postlaunch data
;
  fits_read,fcb,d,h,/HEADER_ONLY
  if post_launch then begin
	    acs_read_spt,file_to_read,udl,hudl,heng1,heng2,hspt,no_spt
	    if sxpar(h,'BLEVCORR') eq 'COMPLETE' then do_overscan = 0
            if do_overscan and no_spt then begin
	        print,'ACS_READ: ERROR - Overscan correction neads _spt file'
		retall
	    end
	end else begin
	    no_spt = 0
   end
;
; Read data ------------------------------------------------------------------
;
   IF (N_PARAMS(0) LT 3) OR KEYWORD_SET(nodata) THEN goto,process_udl
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
            message = 'ACS_READ: Specified CHIP not found'
            GOTO, abort
         ENDIF
;
; determine extension version for each chip
;
	 if (chip2 eq 0) or (chip1 eq 0) then begin
	 	extver1 = 1
		extver2 = 1
	    end else begin
	    	if post_launch then begin
			extver1 = 2
			extver2 = 1
		    end else begin
		        extver1 = 1
			extver2 = 2
		end
	 end
	
                    ; read chip 1
         IF (chip1 EQ 1) AND (chip NE 2) THEN BEGIN
            fits_read,fcb,d,h,EXTNAME='SCI',extver=extver1
            amps_read = amp1
         ENDIF

                    ; read chip 2 only
         IF (chip EQ 2) THEN BEGIN
             fits_read,fcb,d,h,EXTNAME='SCI',EXTVER=extver2
             amps_read = amp2
         ENDIF

                    ; read both chips
         IF (chip EQ 0) AND (chip2 EQ 1) THEN BEGIN
            fits_read,fcb,d2,h,EXTNAME='SCI',EXTVER=extver2
            IF chip1 EQ 1 THEN BEGIN
               if post_launch then d = [[d2],[d]] else d = [[d],[d2]]
               sxaddpar,h,'chip',0 ;flag as both
            ENDIF ELSE d = TEMPORARY(d2)
            amps_read = amp1+amp2
         ENDIF
	 if post_launch then acs_read_hmod,h,hudl,heng1,heng2
                    ; Scale the data
         if post_launch eq 0 then d = d + (d LT 0)*65536.0
         sxaddpar,h,'ccdamp',amps_read

                    ; remove overscan
         IF do_overscan THEN begin
	        if current_orientation eq 2 then begin
		 	d = reverse(temporary(d),2)
			acs_unscramble,amps_read,d
			current_orientation = 0
		endif
	 	acs_overscan,h,d
	 ENDIF
                    ; rotate data to output orientation
	 if rotate eq 0 then begin
	 	if current_orientation eq 2 then begin
		 	d = reverse(temporary(d),2)
			acs_unscramble,amps_read,d
		endif
	 end
	 if rotate eq 1 then begin
	 	if current_orientation eq 0 then acs_unscramble,amps_read,d	
		if current_orientation eq 2 then d = reverse(temporary(d),2)
	 end
	 if rotate eq 2 then begin
	 	if current_orientation eq 0 then begin
			acs_unscramble,amps_read,d
		 	d = reverse(temporary(d),2)
		end
		if current_orientation eq 1 then d = reverse(temporary(d),2)
	 end

      END 

      'HRC': BEGIN
                    ; HRC DATA  ---------------------------------------------

         fits_read,fcb,d,h,EXTNAME='SCI'
         amps_read = amps
                    ; Scale the data
         if post_launch eq 0 then d = d + (d LT 0)*65536.0
	 if post_launch then acs_read_hmod,h,hudl,heng1,heng2
         sxaddpar,h,'ccdamp',amps_read

                    ; remove overscan
         IF do_overscan THEN begin
	        if current_orientation eq 2 then begin
		 	d = reverse(temporary(d),2)
			acs_unscramble,amps_read,d
			current_orientation = 0
		endif
	 	acs_overscan,h,d
	 ENDIF
                    ; rotate data to output orientation
	 if rotate eq 0 then begin
	 	if current_orientation eq 2 then begin
		 	d = reverse(temporary(d),2)
			acs_unscramble,amps_read,d
		endif
	 end
	 if rotate eq 1 then begin
	 	if current_orientation eq 0 then acs_unscramble,amps_read,d	
		if current_orientation eq 2 then d = reverse(temporary(d),2)
	 end
	 if rotate eq 2 then begin
	 	if current_orientation eq 0 then begin
			acs_unscramble,amps_read,d
		 	d = reverse(temporary(d),2)
		end
		if current_orientation eq 1 then d = reverse(temporary(d),2)
	 end

      END

      'SBC': BEGIN
                    ; MAMA DATA ---------------------------------------------

         fits_read,fcb,d,h,EXTNAME='SCI'

                    ; reformat local rate check images
         IF STRTRIM(sxpar(h,'obstype')) EQ 'MEMDUMP' THEN BEGIN
            IF (N_ELEMENTS(d) EQ 65536) AND $
             (STRTRIM(sxpar(h,'JQMDSRC')) EQ 'MIE') THEN $
             d = REFORM(d,256,256,/OVERWRITE)
         ENDIF
         d = d + (d LT 0)*65536.
	 if post_launch then acs_read_hmod,h,hudl,heng1,heng2
      END 

      ELSE: BEGIN
         message = 'ACS_READ: Unknown detector: '+detector
         GOTO, abort
      END

   ENDCASE

;
; Read UDL and Eng. Snapshot headers ----------------------------------------
;
process_udl:
   if (post_launch eq 0) and n_params(0) gt 3 then begin
   	    fits_read,fcb,udl,hudl,EXTNAME='UDL'
   	    fits_read,fcb,dd,heng1,EXTNAME='EDS',EXTLEV=1
   	    fits_read,fcb,dd,heng2,EXTNAME='EDS',EXTLEV=2
    end
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
   IF datatype(id) NE 'STR' THEN BEGIN
      dbopen,'acs_log'
      sxaddpar,h,'date-obs',dbval(id,'date-obs')
      sxaddpar,h,'time-obs',dbval(id,'time-obs')
      sxaddpar,h,'expstart',dbval(id,'expstart')
      sxaddpar,h,'entry',id,'ACS_LOG entry number'
   ENDIF
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
