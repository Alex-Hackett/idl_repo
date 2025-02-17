;+
; NAME:
;       IMAGE_DIMENSIONS
;
; PURPOSE:
;
;       The purpose of this function is to return the dimensions of the image,
;       and also to extract relevant image information via output keywords. The
;       function works only with 2D and 3D (24-bit) images.
;
; CATEGORY:
;
;       File I/O.
;
; AUTHOR:
;
;   FANNING SOFTWARE CONSULTING
;   David Fanning, Ph.D.
;   1645 Sheely Drive
;   Fort Collins, CO 80526 USA
;   Phone: 970-221-0438
;   E-mail: davidf@dfanning.com
;   Coyote's Guide to IDL Programming: http://www.dfanning.com/
;
; CALLING SEQUENCE:
;
;       dims = Image_Dimensions(image)
;
; RETURN VALUE:
;
;        An array containing the size of each dimension of the image. It is equivalent
;        to calling the SIZE function with the DIMENSIONS keyword set.
;
; INPUTS:
;
;       image:          The image variable from which information is to be obtained.
;
; OUTPUT KEYWORD PARAMETERS:
;
;       TRUEINDEX:      The position of the "true color" index in the return value. Is -1 for 2D images.
;
;       XINDEX:         The index (position) of the X dimension in the return value.
;
;       XSIZE:          The X size of the image.
;
;       YINDEX:         The index (position) of the Y dimension in the return value.
;
;       YSIZE:          The Y size of the image.
;
; COMMON_BLOCKS:
;       None.
;
; SIDE_EFFECTS:
;       None.
;
; RESTRICTIONS:
;
;       Only 8-bit and 24-bit images are allowed.
;
; EXAMPLE:
;
;       To load open a window of the appropriate size and display a 24-bit image:
;
;          dims = Image_Dimensions(image24, XSize=xsize, YSize=ysize, TrueIndex=trueindex)
;          Window, XSize=xsize, YSize=ysize
;          TV, TRUE=trueIndex
;
; MODIFICATION HISTORY:
;
;       Written by:  David W. Fanning, 5 March 2003.
;-
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright � 2003 Fanning Software Consulting
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
FUNCTION Image_Dimensions, image, $

; This function returns the dimensions of the image, and also
; extracts relevant information via output keywords. Works only
; with 2D and 3D (24-bit) images.

   XSize=xsize, $          ; Output keyword. The X size of the image.
   YSize=ysize, $          ; Output keyword. The Y size of the image.
   TrueIndex=trueindex, $  ; Output keyword. The position of the "true color" index. -1 for 2D images.
   XIndex=xindex, $        ; Output keyword. The position or index of the X image size.
   YIndex=yindex           ; Output keyword. The position or index of the Y image size.

On_Error, 2

   ; Get the number of dimensions and the size of those dimensions.

ndims = Size(image, /N_Dimensions)
dims =  Size(image, /Dimensions)

   ; Is this a 2D or 3D image?

IF ndims EQ 2 THEN BEGIN
   xsize = dims[0]
   ysize = dims[1]
   trueindex = -1
   xindex = 0
   yindex = 1
ENDIF ELSE BEGIN
   IF ndims NE 3 THEN Message, /NoName, 'Unknown image dimensions. Returning.'
   true = Where(dims EQ 3, count)
   trueindex = true[0]
   IF count EQ 0 THEN Message, /NoName, 'Unknown image type. Returning.'
   CASE true[0] OF
      0: BEGIN
         xsize = dims[1]
         ysize = dims[2]
         xindex = 1
         yindex = 2
         ENDCASE
      1: BEGIN
         xsize = dims[0]
         ysize = dims[2]
         xindex = 0
         yindex = 2
         ENDCASE
      2: BEGIN
         xsize = dims[0]
         ysize = dims[1]
         xindex = 0
         yindex = 1
         ENDCASE
   ENDCASE
ENDELSE
RETURN, dims
END