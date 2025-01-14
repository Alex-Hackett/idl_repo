;+
; NAME:
;   PSCONFIG
;
; PURPOSE:
;
;   This program is simply a function wrapper for the FSC_PSCONFIG
;   object program (fsc_psconfig__define.pro). It was written so
;   that it could serve as a drop-in replacement for the PS_FORM
;   program it replaces. It calls the object program's graphical
;   user interface as a modal widget and returns the DEVICE keywords
;   collected from the form in a form that is appropriate for
;   configuring the PostScript device.
;
;   It is now possible to call the program without a graphical user
;   interface, thus getting the default keywords directly. This is
;   appropriate for many applications. Use the NOGUI keyword when
;   you call the program. For example, like this:
;
;       Set_Plot, 'PS'
;       Device, _Extra=PSConfig(/NoGUI, Filename='myfilename.eps')
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
;   psKeywords = PSConfig()
;
; CATEGORY:
;
;   Configuring PostScript output.
;
; DOCUMENTATION:
;
;   Complete documentation for the FSC_PSCONFIG object, including
;   keyword and method descriptions, and example programs using the object
;   can be found on the Coyote's Guide to IDL Programming web page:
;
;     http://www.dfanning.com/programs/docs/fsc_psconfig.html
;
; INPUT:
;
;    psConfigObject -- An optional FSC_PSCONFIG object reference can be
;       passed as an argument to the function. The object is not destroyed
;       if passed in as an argument.
;
;       psConfigObject = Obj_New("FSC_PSCONFIG")
;       keywords = PSConfig(psConfigObject)
;
;    Having the object means that you have an on-going and current record
;    of exactly how your PostScript device is configured. Be sure to destroy
;    the object when you are finished with it.
;
; KEYWORDS:
;
;   NOGUI:   Setting this keyword returns the default keyword settings directly,
;            without allowing user interaction.
;
;   Any keyword accepted by the FSC_PSCONFIG object can be used with
;   this program. Here are a few of the most popular keywords.
;
;   Bits_per_Pixel - The number of image bits saved for each image pixel: 2, 4, or 8. The default is 8.
;   Color - Set this keyword to select Color PostScript output. Turned on by default.
;   DefaultSetup - Set this keyword to the "name" of a default style. Current styles (you can easily
;     create and add your own to the source code) are the following:
;
;       "System (Portrait)" - The normal "default" system set-up. Also, "System".
;       "System (Landcape)" - The normal "default" landscape system set-up.
;       "Centered (Portrait)" - The window centered on the page. Also, "Center" or "Centered".
;       "Centered (Landscape)" - The window centered on the landscape page. Also, "Landscape".
;       "Square (Portrait)" - A square plot, centered on the page.
;       "Square (Landscape)" - A square plot, centered on the landscape page.
;       "Figure (Small)" - A small encapsulated figure size, centered on page. Also, "Encapsulated" or "Encapsulate".
;       "Figure (Large)" - A larger encapsulated figure size, centered on page. Also, "Figure".
;       "Color (Portrait)" - A "centered" plot, with color turned on. Also, "Color".
;       "Color (Landscape)" - A "centered" landscape plot, with color turned on.
;
;   Directory - Set this keyword to the name of the starting directory. The current directory is used by default.
;   Encapsulate - Set this keyword to select Encapsulated PostScript output. Turned off by default.
;   European - Set this keyword to indicate "european" mode (i.e., A4 page and centimeter units). Turned off by default.
;   Filename - Set thie keyword to the name of the PostScript file. The default is "idl.ps".
;   Inches - Set this keyword to indicate sizes and offsets are in inches as opposed to centimeters. Set by European keyword by default.
;   Landscape - Set this keyword to select Landscape page output. Portrait page output is the default.
;   PageType - Set this keyword to the "type" of page. Possible values are:
;       "Letter" - 8.5 by 11 inches. (Default, unless the European keyword is set.)
;       "Legal" - 8.5 by 14 inches.
;       "Ledger" - 11 by 17 inches.
;       "A4" - 21.0 by 29.7 centimeters. (Default, if the European keyword is set.)
;   XOffset - Set this keyword to the X Offset. Uses "System (Portrait)" defaults. (Note: offset calculated from lower-left corner of page.)
;   XSize - Set this keyword to the X size of the PostScript "window". Uses "System (Portrait)" defaults.
;   YOffset - Set this keyword to the Y Offset. Uses "System (Portrait)" defaults. (Note: offset calculated from lower-left corner of page.)
;   YSize - Set this keyword to the Y size of the PostScript "window". Uses "System (Portrait)" defaults.
;
;   In addition, the following keywords can be used:
;
;   CANCEL -- An output keyword that will be set to 1 if the user
;   chooses the Cancel button on the form. It will be 0 otherwise.
;
;   FONTINFO -- Set this keyword is you wish to have font information
;   appear on the form. The default is to not include font information.
;
;   FONTTYPE -- Set this keyword to a named variable that will indicate
;   the user's preference for font type. Values will be -1 (Hershey fonts),
;   0 (hardware fonts), and 1 (true-type fonts). This keyword will always
;   return -1 unless the FONTINFO keyword has also been set.
;
;   GROUP_LEADER -- Set this keyword to a widget identifier of the widget
;   you wish to be a group leader for this program.
;
; EXAMPLE:
;
;   To have the user specify PostScript configuration parameters, use
;   the program like this:
;
;     keywords = PSConfig(Cancel=cancelled)
;     IF cancelled THEN RETURN
;     thisDevice = !D.Name
;     Set_Plot, 'PS'
;     Device, _Extra=keywords
;     Plot, findgen(11) ; Or whatever graphics commands you use.
;     Device, /Close_File
;     Set_Plot, thisDevice
;
; OTHER PROGRAMS NEEDED:
;
;   The following programs are required to run this one:
;
;     fsc_droplist.pro
;     fsc_fileselect.pro
;     fsc_inputfield.pro
;     fsc_plotwindow
;     fsc_psconfig__define.pro
;
; MODIFICATIONS:
;
;   Written by David W. Fanning, 31 January 2000.
;   Added NOGUI keyword to allow default keywords to be obtained without
;     user interaction. 11 Oct 2004. DWF.
;   Added CMYK option 24 August 2007. Requires LANGUAGE_LEVEL=2 printer. L. Anderson
;-
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright (c) 2000-2007 Fanning Software Consulting
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


FUNCTION PSConfig,                    $
   psObject,                          $ ; A FSC_PSCONFIG object. If psObject is present, all input keywords
                                        ; except Group_Leader and FontInfo are ignored.
   AvantGarde=avantgarde,             $ ; Set this keyword to select the AvantGarde font.
   Bits_per_Pixel=bits_per_pixel,     $ ; The number of image bits saved for each image pixel: 2, 4, or 8.
   Bold=bold,                         $ ; Set this keyword to select the Bold font style.
   BookStyle=book,                    $ ; Set this keyword to select the Book font style.
   Bkman=bookman,                     $ ; Set this keyword to select the Bookman font.
   Cancel=cancelled,                  $ ; This output keyword will be set to 1 if the user CANCELs. Set to 0 otherwise.
   Color=color,                       $ ; Set this keyword to select Color PostScript output.
   Courier=courier,                   $ ; Set this keyword to select the Courier font.
   CMYK=cmyk,                         $ ; Set this keyword to use CMYK colors instead of RGB. (Requires LANGUAGE_LEVEL=2 printer.)
   Debug=debug,                       $ ; Set this keyword to get traceback information when errors are encountered.
   DefaultSetup=defaultsetup,         $ ; Set this keyword to the "name" of a default style.
   Demi=demi,                         $ ; Set this keyword to select the Demi font style.
   Directory=directory,               $ ; Set thie keyword to the name of the starting directory. Current directory by default.
   Encapsulate=encapsulate,           $ ; Set this keyword to select Encapsulated PostScript output.
   European=european,                 $ ; Set this keyword to indicate "european" mode (i.e., A4 page and centimeter units).
   Filename=filename,                 $ ; Set this keyword to the name of the file. Default: 'idl.ps'
   FontInfo=fontinfo,                 $ ; Set this keyword if you want font information in the FSC_PSCONFIG GUI.
   FontSize=fontsize,                 $ ; Set this keyword to the font size. Between 6 and 36. Default is 12.
   FontType=fonttype,                 $ ; An input/output keyword that will have the FontType. Will be !P.Font unless FontInfo is selected.
   Group_Leader=group_leader,         $ ; The group leader of the PSConfig modal widget.
   Helvetica=helvetica,               $ ; Set this keyword to select the Helvetica font.
   Inches=inches,                     $ ; Set this keyword to indicate sizes and offsets are in inches as opposed to centimeters.
   Italic=italic,                     $ ; Set this keyword to select the Italic font style.
   Isolatin=isolatin,                 $ ; Set this keyword to select ISOlatin1 encoding.
   Landscape=landscape,               $ ; Set this keyword to select Landscape output.
   Light=light,                       $ ; Set this keyword to select the Light font style.
   Medium=medium,                     $ ; Set this keyword to select the Medium font style.
   Name=name,                         $ ; The "name" of the object.
   Narrow=narrow,                     $ ; Set this keyword to select the Narrow font style.
   NOGUI=nogui, $                     $ ; Return the default keywords directly, without user interaction.
   Oblique=oblique, $                 $ ; Set this keyword to select the Oblique font style.
   PageType=pagetype,                 $ ; Set this keyword to the "type" of page: 'Letter', 'Legal', 'Ledger', or 'A4'.
   Palatino=palatino,                 $ ; Set this keyword to select the Palatino font.
   Preview=preview,                   $ ; Set this keyword to select Preview mode: 0, 1, or 2.
   Schoolbook=schoolbook,             $ ; Set this keyword to select the Schoolbook font.
   Set_Font=set_font,                 $ ; Set this keyword to the name of a font passed to PostScript with Set_Plot keyword.
   Symbol=symbol,                     $ ; Set this keyword to select the Symbol font.
   Times=times,                       $ ; Set this keyword to select the Times font.
   TrueType=truetype,                 $ ; Set this keyword to select True-Type fonts.
   XOffset=xoffset,                   $ ; Set this keyword to the XOffset. (Note: offset calculated from lower-left corner of page.)
   XSize=xsize,                       $ ; Set this keyword to the X size of the PostScript "window".
   YOffset=yoffset,                   $ ; Set this keyword to the YOffset. (Note: offset calculated from lower-left corner of page.)
   YSize=ysize,                       $ ; Set this keyword to the Y size of the PostScript "window".
   ZapfChancery=zapfchancery,         $ ; Set this keyword to select the ZapfChancery font.
   ZapfDingbats=zapfdingbats            ; Set this keyword to select the ZapfDingbats font.

On_Error, 2

IF N_Elements(psObject) EQ 0 THEN BEGIN
   psObject = Obj_New('FSC_PSCONFIG', $
      AvantGarde=avantgarde,             $
      Bits_per_Pixel=bits_per_pixel,     $
      Bold=bold,                         $
      BookStyle=book,                    $
      Bkman=bookman,                     $
      CMYK=cmyk,                         $
      Color=color,                       $
      Courier=courier,                   $
      Debug=debug,                       $
      DefaultSetup=defaultsetup,         $
      Demi=demi,                         $
      Directory=directory,               $
      Encapsulate=encapsulate,           $
      European=european,                 $
      Filename=filename,                 $
      FontSize=fontsize,                 $
      FontType=fonttype,                 $
      Helvetica=helvetica,               $
      Inches=inches,                     $
      Italic=italic,                     $
      Isolatin=isolatin,                 $
      Landscape=landscape,               $
      Light=light,                       $
      Medium=medium,                     $
      Name=name,                         $
      Narrow=narrow,                     $
      Oblique=oblique,                   $
      PageType=pagetype,                 $
      Palatino=palatino,                 $
      Preview=preview,                   $
      Schoolbook=schoolbook,             $
      Set_Font=set_font,                 $
      Symbol=symbol,                     $
      Times=times,                       $
      TrueType=truetype,                 $
      XOffset=xoffset,                   $
      XSize=xsize,                       $
      YOffset=yoffset,                   $
      YSize=ysize,                       $
      ZapfChancery=zapfchancery,         $
      ZapfDingbats=zapfdingbats )
      create = 1
ENDIF ELSE BEGIN
   type = Size(psObject, /Type)
   IF type NE 11 THEN BEGIN
      Message, 'Object Reference required as an argument'
   ENDIF
   create = 0
ENDELSE

   ; Call the GUI of the FSC_PSCONFIG object.

IF Keyword_Set(nogui) EQ 0 THEN $
   psObject->GUI, Group_Leader=group_leader, Cancel=cancelled, FontInfo=Keyword_Set(fontinfo)

   ; Get the PostScript device keywords, along with the font type information.

keywords = psObject->GetKeywords(FontType=fonttype)

   ; If this program created the psObject, destroy it. Otherwise leave it.

IF create THEN Obj_Destroy, psObject

   ; Return the PostScript device keywords.

RETURN, keywords
END ;----------------------------------------------------------------------


