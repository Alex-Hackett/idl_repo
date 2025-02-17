;+
; NAME:
;       VCOLORBAR
;
; FILENAME:
;
;       vcolorbar__define.pro
;
; PURPOSE:
;
;       The purpose of this program is to create a vertical
;       colorbar object to be used in conjunction with other
;       IDL 5 graphics objects.
;
; AUTHOR:
;
;       FANNING SOFTWARE CONSULTING
;       David Fanning, Ph.D.
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: davidf@dfanning.com
;       Coyote's Guide to IDL Programming: http://www.dfanning.com/
;
; CATEGORY:
;
;       IDL Object Graphics.
;
; CALLING SEQUENCE:
;
;       thisColorBar = Obj_New('VColorBar')
;
; REQUIRED INPUTS:
;
;       None.
;
; INIT METHOD KEYWORD PARAMETERS:
;
;       COLOR: A three-element array representing the RGB values of a color
;          for the colorbar axes and annotation. The default value is
;          white: [255,255,255].
;
;       NAME: The name associated with this object.
;
;       NCOLORS: The number of colors associated with the colorbar. The
;          default is 256.
;
;       MAJOR: The number of major tick divisions on the colorbar axes.
;          The default is 5.
;
;       MINOR: The number of minor tick marks on the colorbar axes.
;          The default is 4.
;
;       PALETTE: A palette object for the colorbar. The default palette
;           is a gray-scale palette object.
;
;       POSITION: A four-element array specifying the position of the
;           colorbar in the arbitary coordinate system of the viewplane
;           rectangle. The default position is [0.90, 0.10, 0.95, 0.90].
;
;       RANGE: The range associated with the colorbar axis. The default
;           is [0, NCOLORS].
;
;       TITLE: A string containing a title for the colorbar axis
;           annotation. The default is a null string.
;
; OTHER METHODS:
;
;       Clamp (Procedure): Given a two-element array in the data range of
;          the colorbar, the colorbar image is clamped to this range. In
;          other words, the range of colors is clamped to the specified
;          range. Values above or below the range in the colorbar are set to
;          the minimum and maximum range values, respectively.
;
;       GetProperty (Procedure): Returns colorbar properties in keyword
;          parameters as defined for the INIT method. Keywords allowed are:
;
;               COLOR
;               MAJOR
;               MINOR
;               NAME
;               PALETTE
;               POSITION
;               RANGE
;               TITLE
;               TRANSFORM
;
;       SetProperty (Procedure): Sets colorbar properties in keyword
;          parameters as defined for the INIT method. Keywords allowed are:
;
;               COLOR
;               NAME
;               MAJOR
;               MINOR
;               PALETTE
;               POSITION
;               RANGE
;               TITLE
;               TRANSFORM
;
; SIDE EFFECTS:
;
;       A VCOLORBAR object is created. The colorbar INHERITS IDLgrMODEL.
;       Thus, all IDLgrMODEL methods and keywords can also be used. It is
;       the model that is selected in a selection event, since the SELECT_TARGET
;       keyword is set for the model.
;
; RESTRICTIONS:
;
;       Requires NORMALIZE from Coyote Library:
;
;         http://www.dfanning.com/programs/normalize.pro
;
; EXAMPLE:
;
;       To create a colorbar object and add it to a plot view object, type:
;
;       thisColorBarObject = Obj_New('VColorBar')
;       plotView->Add, thisColorBarObject
;       plotWindow->Draw, plotView
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, 19 June 97.
;       Changed the optional "colorbarmodel" parameter to an
;           optional GETMODEL parameter. 26 June 97. DWF.
;       Fixed bug in the way the color palette was assigned. 13 Aug 97. DWF.
;       Added missing container object to self structure. 13 Aug 97. DWF.
;       Removed image model, which was a workaround for
;           broken 5.0 objects. 5 Oct 97. DWF
;       Fixed cleanup procedure to clean up ALL objects. 12 Feb 98. DWF.
;       Changed IDLgrContainer to IDL_Container to fix 5.1 problems. 20 May 98. DWF.
;       Modified colorbar to INHERIT an IDLgrModel object. This allows me to
;           add the colorbar to other models directly. 20 Sept 98. DWF.
;       Added NAME keyword to give the colorbar a name. 20 Sept 98. DWF.
;       Changed a reference to _Ref_Extra to _Extra. 27 Sept 98. DWF.
;       Fixed bug when adding a text object via the TEXT keyword. 9 May 99. DWF.
;       Fixed a bug with getting the text object via the TEXT keyword. 16 Aug 2000. DWF.
;       Added the TRANSFORM keyword to GetProperty and SetProperty methods. 16 Aug 2000. DWF.
;       Added RECOMPUTE_DIMENSIONS=2 to text objects. 16 Aug 2000. DWF.
;       Added a polygon object around the image object. This allows rotation in 3D space. 16 Aug 2000. DWF.
;       Removed TEXT keyword (which was never used) and fixed TITLE keyword. 8 Dec 2000. DWF.
;       Added ENABLE_FORMATTING keyword to title objects. 22 October 2001. DWF.
;       Added a CLAMP method. 18 November 2001. DWF.
;       Forgot to pass extra keywords along to the text widget. As a result, you couldn't
;          format tick labels, etc. Fixed this. Any keywords appropriate for IDLgrTick objects
;          are now available. 26 June 2002. DWF.
;       Fixed a problem with POSITION keyword in SetProperty method. 23 May 2003. DWF.
;       Removed NORMALIZE from source code. 29 Nov 2005. DWF.
;-
;
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright � 2000-2005 Fanning Software Consulting.
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


FUNCTION Normalize, range, Position=position

    ; This is a utility function to calculate the scale factor
    ; required to position a vector of specified range at a
    ; specific position given in normalized coordinates.

IF (N_Elements(position) EQ 0) THEN position = [0.0, 1.0]

scale = [((position[0]*range[1])-(position[1]*range[0])) / $
    (range[1]-range[0]), (position[1]-position[0])/(range[1]-range[0])]

RETURN, scale
END
;-------------------------------------------------------------------------


PRO VColorBar::Clamp, datarange

; This method clamps the data to a particular data range.

self->GetProperty, Range=currentRange

thisclamp = Bytscl(datarange, Max=currentRange[1], Min=currentRange[0])
bar = BytScl(Replicate(1B,10) # Bindgen(self.ncolors), Min=thisclamp[0], Max=thisclamp[1])
self.thisImage->SetProperty, Data=bar
END
;-------------------------------------------------------------------------



FUNCTION VColorBar::INIT, Position=position, $
    NColors=ncolors, Title=title, Palette=palette, $
    Major=major, Minor=minor, Range=range, Color=color, $
    _Extra=extra, Name=name

   ; Catch possible errors.

Catch, theError
IF theError NE 0 THEN BEGIN
   Catch, /Cancel
   ok = Dialog_Message(!Error_State.Msg)
   Message, !Error_State.Msg, /Informational
   RETURN, 0
ENDIF

   ; Initialize model superclass.

IF (self->IDLgrModel::Init(_EXTRA=extra) NE 1) THEN RETURN, 0

    ; Define default values for keywords, if necessary.

IF N_Elements(name) EQ 0 THEN name=''
IF N_Elements(color) EQ 0 THEN self.color = [255,255,255] $
   ELSE self.color = color
thisFont = Obj_New('IDLgrFont', 'Helvetica', Size=8.0)
self.thisFont = thisFont
IF N_Elements(title) EQ 0 THEN title=''

thisTitle = Obj_New('IDLgrText', title, Color=self.color, $
    Font=thisFont, Recompute_Dimensions=2, /Enable_Formatting, _Extra=extra)

IF N_Elements(ncolors) EQ 0 THEN self.ncolors = 256 $
   ELSE self.ncolors = ncolors
IF N_Elements(palette) EQ 0 THEN BEGIN
    red = (green = (blue = BIndGen(self.ncolors)))
    self.palette = Obj_New('IDLgrPalette', red, green, blue)
ENDIF ELSE self.palette = palette
IF N_Elements(range) EQ 0 THEN self.range = [0, self.ncolors] $
   ELSE self.range = range
IF N_Elements(major) EQ 0 THEN self.major = 5 $
   ELSE self.major = major
IF N_Elements(minor) EQ 0 THEN self.minor = 4 $
   ELSE self.minor = minor
IF N_Elements(position) EQ 0 THEN self.position = [0.90, 0.10, 0.95, 0.90] $
   ELSE self.position = position

    ; Create the colorbar image. Get its size.

bar = REPLICATE(1B,10) # BINDGEN(self.ncolors)
s = SIZE(bar, /Dimensions)
xsize = s[0]
ysize = s[1]

    ; Create the colorbar image object. Add palette to it.

thisImage = Obj_New('IDLgrImage', bar, Palette=self.palette)
xs = Normalize([0,xsize], Position=[0,1.])
ys = Normalize([0,ysize], Position=[0,1.])
thisImage->SetProperty, XCoord_Conv=xs, YCoord_Conv=ys

   ; Create a polygon object. Add the image as a texture map. We do
   ; this so the image can rotate in 3D space.

thisPolygon = Obj_New('IDLgrPolygon', [0, 1, 1, 0], [0, 0, 1, 1], [0,0,0,0], $
   Texture_Map=thisImage, Texture_Coord = [[0,0], [1,0], [1,1], [0,1]], color=[255,255,255])
self.thisPolygon = thisPolygon

    ; Scale the polygon into the correct position.

xs = Normalize([0,1], Position=[self.position(0), self.position(2)])
ys = Normalize([0,1], Position=[self.position(1), self.position(3)])
thispolygon->SetProperty, XCoord_Conv=xs, YCoord_Conv=ys

    ; Create scale factors to position the axes.

longScale = Normalize(self.range, Position=[self.position(1), self.position(3)])
shortScale = Normalize([0,1], Position=[self.position(0), self.position(2)])

    ; Create the colorbar axes. 1000 indicates this location ignored.

shortAxis1 = Obj_New("IDLgrAxis", 0, Color=self.color, Ticklen=0.025, $
    Major=1, Range=[0,1], /NoText, /Exact, XCoord_Conv=shortScale,  $
    Location=[1000, self.position(1), 0.001])
shortAxis2 = Obj_New("IDLgrAxis", 0, Color=self.color, Ticklen=0.025, $0.001
    Major=1, Range=[0,1], /NoText, /Exact, XCoord_Conv=shortScale,  $
    Location=[1000, self.position(3), 0.001], TickDir=1)

textAxis = Obj_New("IDLgrAxis", 1, Color=self.color, Ticklen=0.025, $
    Major=self.major, Minor=self.minor, Title=thisTitle, Range=self.range, /Exact, $
    YCoord_Conv=longScale, Location=[self.position(0), 1000, 0.001], _Extra=extra)
textAxis->GetProperty, TickText=thisText
thisText->SetProperty, Font=self.thisFont, Recompute_Dimensions=2

longAxis2 = Obj_New("IDLgrAxis", 1, Color=self.color, /NoText, Ticklen=0.025, $
    Major=self.major, Minor=self.minor, Range=self.range, TickDir=1, $
    YCoord_Conv=longScale, Location=[self.position(2), 1000, 0.001], /Exact)

    ; Add the parts to the colorbar model.

self->Add, shortAxis1
self->Add, shortAxis2
self->Add, textAxis
self->Add, longAxis2
self->Add, thisPolygon

   ; Assign the name.

self->IDLgrModel::SetProperty, Name=name, Select_Target=1

    ; Create a container object and put the objects into it.

thisContainer = Obj_New('IDL_Container')
thisContainer->Add, thisFont
thisContainer->Add, thisImage
thisContainer->Add, thisText
thisContainer->Add, thisTitle
thisContainer->Add, self.palette
thisContainer->Add, textAxis
thisContainer->Add, shortAxis1
thisContainer->Add, shortAxis2
thisContainer->Add, longAxis2

    ; Update the SELF structure.

self.thisImage = thisImage
self.thisFont = thisFont
self.thisText = thisText
self.textAxis = textAxis
self.shortAxis1 = shortAxis1
self.shortAxis2 = shortAxis2
self.longAxis2 = longAxis2
self.thisContainer = thisContainer
self.thisTitle = thisTitle

RETURN, 1
END
;-------------------------------------------------------------------------



PRO VColorBar::Cleanup

    ; Lifecycle method to clean itself up.

Obj_Destroy, self.thisContainer
self->IDLgrMODEL::Cleanup
END
;-------------------------------------------------------------------------



PRO VColorBar::GetProperty, Position=position, Text=text, $
    Title=title, Palette=palette, Major=major, Minor=minor, $
    Range=range, Color=color, Name=name, $
    Transform=transform, _Ref_Extra=extra

    ; Get the properties of the colorbar.

IF Arg_Present(position) THEN position = self.position
IF Arg_Present(text) THEN text = self.thisText
IF Arg_Present(title) THEN self.thisTitle->GetProperty, Strings=title
IF Arg_Present(palette) THEN palette = self.palette
IF Arg_Present(major) THEN major = self.major
IF Arg_Present(minor) THEN minor = self.minor
IF Arg_Present(range) THEN range = self.range
IF Arg_Present(color) THEN color = self.color
IF Arg_Present(name) THEN self->IDLgrMODEL::GetProperty, Name=name
IF Arg_Present(transform) THEN self->IDLgrMODEL::GetProperty, Transform=transform
IF Arg_Present(extra) THEN self->IDLgrMODEL::GetProperty, _Extra=extra

END
;-------------------------------------------------------------------------



PRO VColorBar::SetProperty, Position=position, $
    Title=title, Palette=palette, Major=major, Minor=minor, $
    Range=range, Color=color, Name=name, Transform=transform, _Extra=extra

    ; Set properties of the colorbar.

IF N_Elements(position) NE 0 THEN BEGIN
    self.position = position

        ; Move the image polygon into its new positon.

    xs = Normalize([0,1], Position=[position(0), position(2)])
    ys = Normalize([0,1], Position=[position(1), position(3)])
    self.thisPolygon->SetProperty, XCoord_Conv=xs, YCoord_Conv=ys

        ; Create new scale factors to position the axes.

    longScale = Normalize(self.range, $
       Position=[self.position(1), self.position(3)])
    shortScale = Normalize([0,1], $
       Position=[self.position(0), self.position(2)])

        ; Position the axes. 1000 indicates this position ignored.

    self.textaxis->SetProperty, YCoord_Conv=longScale, $
       Location=[self.position(0), 1000, 0]
    self.longaxis2->SetProperty, YCoord_Conv=longScale, $
       Location=[self.position(2), 1000, 0]
    self.shortAxis1->SetProperty, XCoord_Conv=shortScale, $
       Location=[1000, self.position(1), 0]
    self.shortAxis2->SetProperty, XCoord_Conv=shortScale, $
       Location=[1000, self.position(3), 0]

ENDIF
IF N_Elements(title) NE 0 THEN self.thisTitle->SetProperty, Strings=title
IF N_Elements(transform) NE 0 THEN self->IDLgrMODEL::SetProperty, Transform=transform
IF N_Elements(palette) NE 0 THEN BEGIN
    self.palette = palette
    self.thisImage->SetProperty, Palette=palette
ENDIF
IF N_Elements(major) NE 0 THEN BEGIN
    self.major = major
    self.textAxis->SetProperty, Major=major
    self.longAxis2->SetProperty, Major=major
END
IF N_Elements(minor) NE 0 THEN BEGIN
    self.minor = minor
    self.textAxis->SetProperty, Minor=minor
    self.longAxis2->SetProperty, Minor=minor
END
IF N_Elements(range) NE 0 THEN BEGIN
    self.range = range
    longScale = Normalize(range, $
       Position=[self.position(1), self.position(3)])
    self.textAxis->SetProperty, Range=range, YCoord_Conv=longScale
    self.longAxis2->SetProperty, Range=range, YCoord_Conv=longScale
ENDIF
IF N_Elements(color) NE 0 THEN BEGIN
    self.color = color
    self.textAxis->SetProperty, Color=color
    self.longAxis2->SetProperty, Color=color
    self.shortAxis1->SetProperty, Color=color
    self.shortAxis2->SetProperty, Color=color
    self.thisText->SetProperty, Color=color
ENDIF
IF N_Elements(name) NE 0 THEN self->IDLgrMODEL::SetProperty, Name=name
IF N_Elements(extra) NE 0 THEN BEGIN
   self->IDLgrMODEL::SetProperty, _Extra=extra
   self.textAxis->SetProperty, _Extra=extra
   self.thisTitle->SetProperty, _Extra=extra
ENDIF
END
;-------------------------------------------------------------------------



PRO VColorBar__Define

colorbar = { VCOLORBAR, $
             INHERITS IDLgrMODEL, $      ; Inherits the Model Object.
             Position:FltArr(4), $       ; The position of the colorbar.
             Palette:Obj_New(), $        ; The colorbar palette.
             thisImage:Obj_New(), $      ; The colorbar image.
             thisPolygon:Obj_New(), $    ; The image polygon.
             imageModel:Obj_New(), $     ; The colorbar image model.
             thisContainer:Obj_New(), $  ; Container for cleaning up.
             thisFont:Obj_New(), $       ; The annotation font object.
             thisText:Obj_New(), $       ; The bar annotation text object.
             thisTitle: Obj_New(), $     ; The title of the colorbar.
             textAxis:Obj_New(), $       ; The axis containing annotation.
             shortAxis1:Obj_New(), $     ; A short axis.
             shortAxis2:Obj_New(), $     ; A second short axis.
             longAxis2:Obj_New(), $      ; The other long axis.
             NColors:0, $                ; The number of colors in the bar.
             Major:0, $                  ; Number of major axis intervals.
             Minor:0, $                  ; Number of minor axis intervals.
             Color:BytArr(3), $          ; Color of axes and annotation.
             Range:FltArr(2) }           ; The range of the colorbar axis.

END
;-------------------------------------------------------------------------
