;+
; $Id: log_acsvu.pro,v 1.3 2000/08/03 19:05:56 mccannwj Exp $
;
; NAME:
;     LOG_ACSVU
;
; PURPOSE:
;     Log a science image into the ACSVU database server via RPC
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     LOG_ACSVU [, filename, COMMENT=, CHIP=, PATH=, /SILENT ]
; 
; INPUTS:
;     filename - (STRING/ARRAY) path to science data file
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     COMMENT  - (STRING) comment to be added to ACSVU database.
;     CHIP     - (STRING) chip name to be added to ACSVU database.
;     HOSTNAME - (STRING) host name of ACSVU server (default: bigdog).
;     PATH     - (STRING) default path in which to look for filename.
;     RPC_COMMAND - (STRING) optionally specify the location of the
;                    RPC command.
;     SILENT   - (BOOLEAN) operate quietly.
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     none.
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     IDLRPC process must be running on HOSTNAME with
;     ACSVU_ARCHIVE_FILE in the IDL_PATH.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;    Mon Mar 29 16:44:45 1999, William Jon McCann
;    <mccannwj@acs13.+hst.nasa.gov>
;
;		written.
;
;-

PRO log_acsvu, filename, COMMENT=comment, CHIP=chip, SILENT=silent, $
               HOSTNAME=hostname, DEBUG=debug, PATH=path, $
               RPC_CMD=rpc_command

   IF N_ELEMENTS(path) LE 0 THEN $
    path = '/net/bigdog/usr/home/bigdog1/scidata/images/incoming/'
   IF N_ELEMENTS(rpc_command) LE 0 THEN $
    rpc_command = '/acs/data1/misc/log_tools/rpc/rmtcmd'

   IF N_ELEMENTS( hostname ) LE 0 THEN hostname = 'bigdog'

   IF N_ELEMENTS( filename ) LE 0 THEN BEGIN
      strTitle = 'Select a file to log into ACSVU'

                    ; get current date for default data filter
      time_zone = TIMEZONE()
      strDate = LONG( DATE_CONV( !STIME ) - time_zone/24.0 ) 
                    ; chop down year to two digits (since Y2K
                    ; date_conv update
      strDate = STRMID( STRTRIM( strDate, 2 ), 2, 50 )
      file_filter = 'CSIJ' + strDate + '*.SDI'

      file = DIALOG_PICKFILE( TITLE=strTitle, $
                              PATH=path, FILTER=file_filter, $
                              /MUST_EXIST, /MULTIPLE )
      IF file[0] EQ '' THEN RETURN ELSE filename = STRMID(file, 11)
   ENDIF

   IF N_ELEMENTS(comment) THEN strComment = ",COMMENT='"+comment+"'" $
   ELSE strComment = ''
   IF N_ELEMENTS(chip) THEN strChip = ",CHIP='"+chip+"'" $
   ELSE strChip = ''

   FOR i=0, N_ELEMENTS(filename)-1 DO BEGIN
      pos = STRPOS(STRUPCASE(filename[i]),'.SHP')
      IF pos[0] EQ -1 THEN BEGIN
         strFormat = "('z=acsvu_archive_file(',1H',A,1H',A,A,')')"
         strIDLCmd = STRING(FORMAT=strFormat, filename[i], $
                            strComment, strChip)
         IF KEYWORD_SET(debug) THEN PRINT, strIDLCmd
         strSpawnCmd = rpc_command + " -m "+hostname+' "'+strIDLCmd+'"'
         IF KEYWORD_SET(debug) THEN PRINT, strSpawnCmd
         strPrint = 'logging '+filename[i]+' into ACSVU'
         IF NOT KEYWORD_SET(silent) THEN PRINT, strPrint
         SPAWN, strSpawnCmd, spawn_results
      ENDIF
   ENDFOR 

END 
