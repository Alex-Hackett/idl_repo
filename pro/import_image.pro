; $Id: import_image.pro,v 1.14 2005/02/01 20:24:25 scottm Exp $
;
; Copyright (c) 1999-2005, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;  		IMPORT_IMAGE
;
; PURPOSE:
;       This routine is a macro allowing the user to read in an image
;		file and have the contents placed in the current scope as a
;		structure variable.
;
; CATEGORY:
;       Input/Output
;
; CALLING SEQUENCE:
;       IMPORT_IMAGE
;
; OUTPUTS:
;	This procedure creates a structure variable and places it in the current
;	scope.  The variable is named 'filename_image' where filename is the main
;	part of the file's name not using the extension.
;
; EXAMPLE:
;       IMPORT_IMAGE
;
; MODIFICATION HISTORY:
; 	Written by:	Scott Lasica, July, 1999
;   Modified: CT, RSI, July 2000: moved varName out to IMPORT_CREATE_VARNAME
;-
;

PRO IMPORT_IMAGE

	COMPILE_OPT hidden, strictarr

	catch,error_status
	if (error_status ne 0) then begin
		dummy = DIALOG_MESSAGE(!ERROR_STATE.msg, /ERROR, $
			TITLE='Import_Image Error')
		return
	endif

	void = DIALOG_READ_IMAGE(FILE=filename, QUERY=queryStr, IMAGE=image,RED=red,$
		GREEN=green, BLUE=blue, GET_PATH=gp)

	if (filename eq '') then return


	tempStr = {	IMAGE: image, $
				R: red, $
				G: green, $
				B: blue, $
				QUERY: queryStr $
			  }

	;; Store the return variable into a var for the user
	varName = IMPORT_CREATE_VARNAME(filename, gp, '_image')
	(SCOPE_VARFETCH(varName, /ENTER, LEVEL=-1)) = TEMPORARY(tempStr)

END