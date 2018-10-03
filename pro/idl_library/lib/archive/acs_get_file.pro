;+
; $Id: acs_get_file.pro,v 1.7 2002/03/02 22:01:08 mccannwj Exp $
;
; NAME:
;     ACS_GET_FILE
;
; PURPOSE:
;     Retrieve the data file associated with an ACS_LOG entry number
;     and copy into the current directory.
;
; CATEGORY:
;     JHU/ACS
;
; CALLING SEQUENCE:
;     ACS_GET_FILE, list [, /SDI, /NO_COPY]
; 
; INPUTS:
;     list - (ARRAY) ACS_LOG database entry number, or filename
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     AMOUNT  - (VARIABLE) set to a named variable to receive the
;                actual number of megabytes transferred.
;     COUNT   - (VARIABLE) set to a named variable to receive the
;                number of files transferred.
;     EXTENSION - (STRING) set file extension to look for [.fits,.fits.gz]
;     LIMIT   - (NUMBER) limit the transfer to specified number of
;                megabytes.
;     NO_COPY - (BOOL) don't copy anything.
;     PATH_SDI - (STRING) colon separated path of directories to
;                 search for SDI files (only used with /SDI)
;     SDI     - (BOOL) retrieve the raw SDI file.
;     SILENT  - (BOOL) suppress messages.
;     VERBOSE - (BOOL) be noisy.
;
; OUTPUTS:
;     file copied into current working directory.
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
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Tue May 25 12:18:11 1999, William Jon McCann
;       <mccannwj@acs13.+hst.nasa.gov>
;
;		written.
;
;-

PRO acs_get_file, list, SDI_FILE=sdi_file, NO_COPY=no_copy, $
                  SILENT=silent, VERBOSE=verbose, LIMIT=limit, $
                  COUNT=count, AMOUNT=total_amount, EXTENSION=extension, $
                  PATH_SDI=sdi_path

   IF N_PARAMS() LT 1 THEN BEGIN
      strMessage = 'usage: ACS_GET_FILE, list'
      MESSAGE, strMessage, /INFO, /NONAME
      return
   ENDIF

   IF N_ELEMENTS(limit) LE 0 THEN limit = !VALUES.D_INFINITY

   IF KEYWORD_SET( sdi_file ) THEN BEGIN      
      IF N_ELEMENTS(sdi_path) GT 0 THEN BEGIN
         path_list = STRSPLIT(sdi_path,':',ESCAPE='\',/EXTRACT)
      ENDIF ELSE BEGIN
         path_list = '/net/bigdog/usr/home/bigdog'+STRTRIM(INDGEN(12)+1,2)+$
          '/scidata/acsvu/archdir'
      ENDELSE
      file_path = path_list[0]
      FOR i=1,N_ELEMENTS(path_list)-1 DO $
       file_path = file_path + ',' + path_list[i]

      file_ext = '.SDI,.EDD,.EFS'
   ENDIF ELSE BEGIN
      file_path = 'JDATA'
      file_ext = '.fits,.fits.gz'
   ENDELSE
   IF N_ELEMENTS(extension) GT 0 THEN file_ext = extension[0]

   IF DATATYPE( list ) NE 'STR' THEN BEGIN
      DBOPEN, 'acs_log'
      DBEXT, list, 'ARCDISK', aArcdisk
      nentries = DB_INFO( 'ENTRIES', 0 )

      bad_items = WHERE( (list LT 1) OR (list GT nentries), bad_count )
      IF bad_count GT 0 THEN BEGIN
         strMessage = 'invalid entry number specified'
         MESSAGE, strMessage, /INFO
      ENDIF

      DBEXT, list, 'FILENAME', aFilename
      aFilename = STRTRIM( aFilename, 2 )

      IF KEYWORD_SET( sdi_file ) THEN $
       aFilename = STRMID( aFilename, 0, 15 )

   ENDIF ELSE aFilename = list

   total_amount = 0.0d
   FOR count=0l, N_ELEMENTS( aFilename ) - 1 DO BEGIN
retry_file:
      file_to_read = FIND_WITH_DEF( aFilename[count], file_path, file_ext )

      IF file_to_read EQ '' THEN BEGIN
         
         IF N_ELEMENTS( aArcdisk ) GT count THEN arcdisk = aArcdisk[count] $
         ELSE arcdisk = ''
         IF (arcdisk EQ '') OR KEYWORD_SET( sdi_file ) THEN BEGIN
            strMessage = 'Unable to find file: ' + aFilename[count]
            MESSAGE, strMessage, /INFO
            CONTINUE
            ;;return
         ENDIF ELSE BEGIN
                    ; Then look in JARCHIVE
            archpath = GETENV('JARCHIVE')
            IF archpath[0] NE '' THEN BEGIN
               arc_dir = STRMID(STRTRIM(arcdisk,2),11)
               arc_file = STRTRIM(archpath,2)+'/'+arc_dir+'/'+aFilename[count]+'.fits.gz'
               file_to_read = (FINDFILE(arc_file))[0]
            ENDIF

            IF (NOT KEYWORD_SET(no_copy)) AND (file_to_read EQ '') THEN BEGIN

               strMessage = "Insert CD: "+STRTRIM(arcdisk,2)+" and press a key to continue."
               PRINT, strMessage
               junk = GET_KBRD(1)
               GOTO, retry_file
            ENDIF
         ENDELSE

      ENDIF
      
      FDECOMP, file_to_read, disk, dir, fname, ext
      strCmd = '/bin/cp ' + STRTRIM(file_to_read,2) + ' .'
      
      OPENR, unit, file_to_read, /GET_LUN, ERROR=error_flag
      IF error_flag GT 0 THEN BEGIN
         PRINTF, -2, !ERR_STRING
         PRINTF, -2, 'error reading file: '+!ERROR_STATE.SYS_MSG
         return
      ENDIF 
      status = FSTAT( unit )
      FREE_LUN, unit
      number_mb = status.size / 1e6
      IF (total_amount + number_mb) GT limit THEN GOTO, exit
      total_amount = total_amount + number_mb
      IF KEYWORD_SET( verbose ) THEN BEGIN
         strMessage=STRING(FORMAT='("Copying ",D8.2," (",D8.2,") Mb")',$
                           number_mb, total_amount )
         MESSAGE, strMessage, /INFO, /NONAME
      ENDIF 

      IF NOT KEYWORD_SET( no_copy ) THEN BEGIN
         IF dir EQ '' THEN BEGIN
            strMessage = fname+'.'+ext + ' already exists.'
            MESSAGE, strMessage, /INFO
            GOTO, next_loop
         ENDIF

         SPAWN, strCmd
         strMessage = fname+'.'+ext + ' copied from directory '+ dir
         IF NOT KEYWORD_SET( silent ) THEN $
          MESSAGE, strMessage, /INFO, /NONAME
      ENDIF ELSE BEGIN
         strMessage = fname+'.'+ext + ' NOT copied from directory '+ dir
         IF NOT KEYWORD_SET( silent ) THEN $
          MESSAGE, strMessage, /INFO, /NONAME
      ENDELSE

next_loop:
   ENDFOR

exit:

   return
END
