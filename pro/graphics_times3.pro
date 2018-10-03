; $Id: graphics_times3.pro,v 1.1 1999/01/14 02:37:30 ali Exp $
;+
; NAME:
;	GRAPHICS_TIMES3
;
; PURPOSE:
;	This is a wrapper on the procedure GRAPHICS_TIMES3_INTERNAL contained
;	in the file time_test.pro. Please see that file for further
;	information. The reason for doing it this way is so that the
;	various time_test and graphics_test routines can stay in a single
;	file while still being easily callable.
;-


pro graphics_times3, filename

  ; Get TIME_TEST.PRO compiled
  resolve_routine, 'time_test', /NO_RECOMPILE

  ; Run the test
  if (n_params() eq 1) then begin
      graphics_times3_internal, filename
  endif else begin
      graphics_times3_internal
  endelse
end