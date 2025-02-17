; $Id: time_test3.pro,v 1.1 1999/01/14 02:37:39 ali Exp $
;+
; NAME:
;	TIME_TEST3
;
; PURPOSE:
;	This is a wrapper on the procedure TIME_TEST3_INTERNAL contained
;	in the file time_test.pro. Please see that file for further
;	information. The reason for doing it this way is so that the
;	various time_test and graphics_test routines can stay in a single
;	file while still being easily callable.
;-


pro time_test3, filename, _REF_EXTRA=extra

  ; Get TIME_TEST.PRO compiled
  resolve_routine, 'time_test', /NO_RECOMPILE

  ; Run the test
  if (n_params() eq 1) then begin
      time_test3_internal, filename, _extra=extra
  endif else begin
      time_test3_internal, _extra=extra
  endelse
end
