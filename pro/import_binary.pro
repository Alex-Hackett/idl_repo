; $Id: import_binary.pro,v 1.15 2005/02/01 20:24:25 scottm Exp $
;
; Copyright (c) 1999-2005, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;  		IMPORT_BINARY
;
; PURPOSE:
;       This routine is a macro allowing the user to read in a binary
;		file and have the contents placed in the current scope as a
;		structure variable.
;
; CATEGORY:
;       Input/Output
;
; CALLING SEQUENCE:
;       IMPORT_BINARY
;
; OUTPUTS:
;	This procedure creates a structure variable and places it in the current
;	scope.  The variable is named 'filename_binary' where filename is the main
;	part of the file's name not using the extension.
;
; EXAMPLE:
;       IMPORT_BINARY
;
; MODIFICATION HISTORY:
; 	Written by:	Scott Lasica, July, 1999
;   Modified: CT, RSI, July 2000: moved varName out to IMPORT_CREATE_VARNAME
;-
;

PRO IMPORT_BINARY

	COMPILE_OPT hidden, strictarr

	catch,error_status
	if (error_status ne 0) then begin
		dummy = DIALOG_MESSAGE(!ERROR_STATE.msg, /ERROR, $
			TITLE='Import_Binary Error')
		return
	endif

   	if !version.os_family eq 'vms' then $
    	MESSAGE, /NONAME, 'IMPORT_BINARY is not available for VMS.'

	filename=DIALOG_PICKFILE(TITLE='Select a binary file to read.',/READ,$
		FILTER='*.*',/MUST_EXIST, GET_PATH=gp)
	if (filename eq '') then return

	templ = BINARY_TEMPLATE(filename, CANCEL=cancel)
	if (cancel) then return

	tempStr = READ_BINARY(filename, TEMPLATE=templ)

	;; Store the return variable into a var for the user
	varName = IMPORT_CREATE_VARNAME(filename, gp, '_binary')
	(SCOPE_VARFETCH(varName, /ENTER, LEVEL=-1)) = TEMPORARY(tempStr)

END
