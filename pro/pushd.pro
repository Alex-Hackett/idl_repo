; $Id: pushd.pro,v 1.11 2005/02/01 20:24:32 scottm Exp $
;
; Copyright (c) 1989-2005, Research Systems, Inc.  All rights reserved.
;       Unauthorized reproduction prohibited.

;+
; NAME:
;	PUSHD
;
; PURPOSE:
;	Push a directory onto the top of the directory stack maintained
;	by the PUSHD and POPD User Library procedures.
;
; CALLING SEQUENCE:
;	PUSHD, Dir
;
; INPUTS:
;	Dir:	The directory to change to. The current directory will
;		be pushed to the top of the directory stack.
;
; SIDE EFFECTS:
;	The current directory is pushed onto the directory stack.
;	It will be the next directory used by POPD.
;
; COMMON BLOCKS:
;	DIR_STACK:  Contains the stack.
;
; MODIFICATION HISTORY:
;	17, July, 1989, Written by AB, RSI.
;-
;
;
pro pushd,dir

COMMON DIR_STACK, DEPTH, STACK
on_error, 2		; Return to caller on error

if (n_elements(DEPTH) eq 0) then depth = 0
CD, dir, CURRENT=cwd

if (DEPTH eq 0) then STACK = [CWD] else STACK = [CWD, STACK]
DEPTH = DEPTH + 1
end
