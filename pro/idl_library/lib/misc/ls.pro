;+
; NAME:
;	LS
;
; PURPOSE:
; 	This routine mimics the unix 'ls' command.
;
;INPUTS: 
;	filepath (optional): string of path to directory to be listed
;
;KEYWORDS:
;	OPTIONS: UNIX style options (ie l = long listing). see manual page
;	of ls for complete listing of options. Default is simple file list
;	with directories listed appended with slashes.
;
; HISTORY:
;	Written by:  T. Beck	ACC/GSFC   3 May 1994
;	PP/ACC  Nov. 12, 1997 Added filepath and options
;       W.McCann Dec 2000 - Added support for Windows
;-
;______________________________________________________________________________

PRO ls, filepath, OPTIONS=options

  CASE STRUPCASE(!VERSION.OS_FAMILY) OF
     'WINDOWS': command = 'dir '
     'UNIX': command = 'ls '
     ELSE: MESSAGE, 'Command not supported'
  ENDCASE

  IF N_ELEMENTS(options) GT 0 THEN BEGIN
     command = command + options + ' '
  ENDIF

  IF N_ELEMENTS(filepath) GT 0 THEN $
    command = command + filepath

  SPAWN, command, stdout, stderr, COUNT=count
  IF count GT 0 THEN BEGIN
     FOR i=0,count-1 DO PRINT, stdout[i]
  ENDIF ELSE BEGIN
     FOR i=0,N_ELEMENTS(stderr)-1 DO PRINT, stderr[i]
  ENDELSE

  return
END
