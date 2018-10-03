;+
; NAME:
;       WindowAvailable
;
; PURPOSE:
;
;       This function returns a 1 if the specified window index number is
;       currently open or available. It returns a 0 if the window is currently
;       closed or unavailable.
;
; AUTHOR:
;
;       FANNING SOFTWARE CONSULTING
;       David Fanning, Ph.D.
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: davidf@dfanning.com
;       Coyote's Guide to IDL Programming: http://www.dfanning.com
;
; CATEGORY:
;
;       Utilities
;
; CALLING SEQUENCE:
;
;       available = WindowAvaiable(windowIndexNumber)
;
; INPUTS:
;
;       windowIndexNumber:   The window index number of the window you wish to
;                            know is available or not.
;
; KEYWORDS:
;
;       None.
;
; NOTES:
;
;       The window vector obtained from the DEVICE command is not always the same length. It
;       is normally (on my machine) 65 elements long, but can be much longer if you have lots
;       of IDL windows open (by calling PickColorName, for example). But if no windows with 
;       index numbers greater than 65 are open, IDL shinks the larger vector to the smaller one
;       as part of its housekeeping operations, which means it happens on their timetable, not yours.
;       This can result in the user having "stale" index numbers greater than 65, but no larger vector
;       to check them against. I have modified the code to return a 0 in this case, assuming that
;       whatever window your index number points to is long gone. I have not experience any ill effects
;       by doing this, but I STRONGLY advice you to ALWAYS know what window you are drawing into
;       when you issue a graphics command.
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, June 2005.
;       Modified to return 0 if the window index number is larger than the number of elements
;             in the WINDOW_STATE array. 25 June 2008. DWF.
;-
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright 2005-2008 Fanning Software Consulting.
;
; This software is provided "as-is", without any express or
; implied warranty. In no event will the authors be held liable
; for any damages arising from the use of this software.
;
; Permission is granted to anyone to use this software for any
; purpose, including commercial applications, and to alter it and
; redistribute it freely, subject to the following restrictions:
;
; 1. The origin of this software must not be misrepresented; you must
;    not claim you wrote the original software. If you use this software
;    in a product, an acknowledgment in the product documentation
;    would be appreciated, but is not required.
;
; 2. Altered source versions must be plainly marked as such, and must
;    not be misrepresented as being the original software.
;
; 3. This notice may not be removed or altered from any source distribution.
;
; For more information on Open Source Software, visit the Open Source
; web site: http://www.opensource.org.
;
;###########################################################################

FUNCTION WindowAvailable, windowID

   ; Error handling.

Catch, theError
IF theError NE 0 THEN BEGIN
   Catch, /Cancel
   ok = Error_Message(Traceback=1)
   Print, 'Window ID: ', windowID
   RETURN, 0
ENDIF

   ; Get current window if window index number is unspecified.

IF N_Elements(windowID) EQ 0 THEN RETURN, 0
IF windowID LT 0 THEN RETURN, 0

   ; Default is window closed.

result = 0


CASE !D.Name OF

   'WIN': BEGIN
      Device, Window_State=theState
      IF N_Elements(theState) GT windowID THEN result = theState[windowID] ELSE result = 0
      END

   'X': BEGIN
      Device, Window_State=theState
      IF N_Elements(theState) GT windowID THEN result = theState[windowID] ELSE result = 0
      END

   'MAC': BEGIN
      Device, Window_State=theState
      IF N_Elements(theState) GT windowID THEN result = theState[windowID] ELSE result = 0
      END

   ELSE:
ENDCASE

RETURN, result
END