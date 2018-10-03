;+
; NAME:
;       TheMonths
;
; PURPOSE:
;
;       This is a utility program for obtaining the months of the
;       year in various string formats. Primarily used for graphic
;       labeling and the like.
;
; AUTHOR:
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
;       Utilites
;
; CALLING SEQUENCE:
;
;       listOfMonths = theMonths()
;
; RETURN VALUE:
;
;       listOfMonths: The list of months as a string or string array,
;                     depending upon which keywords are set.
;
; INPUTS:
;
;       index:        The index of the month you are interested in
;                     returning. Integer from 1 to 12.
;
;  KEYWORDS:
;
;       ABBREVIATION: Set this keyword if you wish to return the months
;                     as a three letter abbreviation.
;
;       ALLCAPS:      Set this keyword if you wish to return the months
;                     in all capital letters. (Default is first letter
;                     capitalized.)
;
;       FIRSTLETTER:  Set this keyword to return just the first letter
;                     of the months.
;
;       LOWCASE:      Set this keyword to return all lowercase letters.
;
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, 8 Nov 2007.
;
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright © 2007 Fanning Software Consulting.
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

FUNCTION TheMonths, index, $
   FIRSTLETTER=firstletter, $
   ALLCAPS=allcaps, $
   ABBREVIATION=abbreviation, $
   LOWCASE=lowcase

   ON_ERROR, 2 ; Return to caller on error.

   ;; Was a month index passed in tothe program?
   IF N_Elements(index) NE 0 THEN monthIndex = (1 > index < 12) - 1

   ;; Define the months.
   months = ['January', 'February', 'March', 'April', 'May', 'June', $
             'July', 'August', 'September', 'October', 'November', 'December']

   allMonths = months
   IF Keyword_Set(firstletter) THEN allMonths = StrMid(months, 0, 1)
   IF Keyword_Set(abbreviation) THEN allMonths = StrMid(months, 0, 3)
   IF Keyword_Set(allcaps) THEN allMonths = StrUpCase(allMonths)
   IF Keyword_Set(lowcase) THEN allMonths = StrLowCase(allMonths)
   IF Keyword_Set(lowcase) AND Keyword_Set(allcaps) THEN $
      Message, 'Keywords LOWCASE and ALLCAPS are mutually exclusive.'

   ;; If an index was returned, return that month.
   ;; Otherwise return all the months.
   IF N_Elements(monthIndex) NE 0 THEN BEGIN
      RETURN, allMonths[monthIndex]
   ENDIF ELSE BEGIN
        RETURN, allMonths
   ENDELSE

END
