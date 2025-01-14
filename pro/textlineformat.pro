;+
; NAME:
;       TextLineFormat
;
; PURPOSE:
;
;       This is a utility program for taking a line of text and shortening
;       it to a defined maximum length. The result of the function is a string
;       array in which no line of text in the string array is longer than the maximum
;       length. The text is broken into "words" by white space. The algorithm is
;       modified slightly if there are LF (line feeds) in the text, or if any single
;       word in the text is too large to fit on a line.
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
;       formattedText = TextLineFormat(theText)
;
; INPUTS:
;
;       theText:   The line of text that is to be formatted.
;
; KEYWORDS:
;
;       LENGTH:    The maximum line length allowed in the resulting text array.
;                  Set to 60 characters by default. Lines greater than length
;                  can be permitted if Line Feeds (ASCII 10B) are found
;                  in the text or single words are too large to fit on a line.
;
; MODIFICATION HISTORY:
;
;       Written by David Fanning, June 2005.
;       Fixed a small problem with cumulative total not counting spaces between
;          words. Changed the default size to 60. DWF. 18 August 2005.
;       Added check for LF in text to accommodate reading netCDF file attributes. 
;           If LF are present, I break on these, and return. 15 Feb 2008. DWF.
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


FUNCTION TEXTLINEFORMAT, theText, LENGTH=length

   ; Error handling.
   Catch, theError
   IF theError NE 0 THEN BEGIN
      ok = Error_Message()
      RETURN, theText
   ENDIF

   ; Check arguments.
   IF N_Elements(theText) EQ 0 THEN Message, 'A line of text to format is required.'
   IF Size(theText, /N_Dimensions) NE 0 THEN Message, 'The text line argument must be a scalar variable.'
   IF N_Elements(length) EQ 0 THEN length = 60

   ; Make sure the text is not shorter than the maximum line length.
   IF StrLen(theText) LE length THEN RETURN, theText
   
   ; Are there any Line Feeds (ASCII value 10) in the text? If so, I am going to 
   ; assume the user did this intentionally, and split on these and return.
   testSplit = StrSplit(theText, String(10B), /Preserve_Null, /Extract)
   IF N_Elements(testSplit) GT 1 THEN BEGIN
        RETURN, testSplit
   ENDIF
   
   ; Set up formatted array and maxStrLen variable.
   formattedText = [theText]
   maxStrLen = StrLen(theText)

   ; Do until length of all strings are right.
   WHILE maxStrLen GT length DO BEGIN

      lastIndex = N_Elements(formattedText)-1

      ; Split the string at white space. First, get the length of each sub-string.
      void = StrSplit(formattedText[lastIndex], /Preserve_Null, Length=len)
      p = StrSplit(formattedText[lastIndex], /Preserve_Null, /Extract)

      ; Join the lines back together, increasing the size of the formatted
      ; text array by one each time.
      cumLen = Total(len+1, /Cumulative)
      cumLen[N_Elements(cumLen)-1] = cumLen[N_Elements(cumLen)-1] - 1
      index = Value_Locate(cumLen, length)
      IF index GE 0 THEN BEGIN
          formattedText[lastIndex] = StrJoin(p[0:index],' ')
          formattedText = [formattedText, StrJoin(p[index+1:*], ' ')]
      ENDIF
      
      ; The word might be too big to fit on the line. If so, it goes on
      ; the next line, and I continue.
      IF index LT 0 THEN BEGIN
          formattedText[lastIndex] = p[0]
          formattedText = [formattedText, StrJoin(p[1:*], ' ')]
      ENDIF
      
      maxStrLen = StrLen(formattedText[lastIndex + 1])

   ENDWHILE

   RETURN, formattedText

END