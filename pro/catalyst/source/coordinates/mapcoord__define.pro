;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD__DEFINE
;
; PURPOSE:
;
;       The purpose of this object is to set up a map coordinate space for
;       for other objects. The program assumes you will use MAP_PROJ_INIT
;       to set up the map structure that is the basis for the map projection
;       space. Additionally, the program can accommodate up to 20 map overlay
;       objects. These are Catalyst objects that draw graphics in a map coordinate
;       data space (examples are MAP_OUTLINE and MAP_GRID in the Catalyst "graphics"
;       directory). The MAPCOORD object cannot, of course, draw map overlays. But,
;       the CatImage object is written in such a way that if a MAPCOORD object
;       is used to set up the data coordinate space, then if overlays are present
;       in the map object, each map overlay object will have its DRAW method called
;       in turn, in the order in which they are specified in the map overlay array.
;       See the keywords SET_MAP_OVERLAY and SET_MO_POSITION for details.
;
; AUTHORS:
;
;        FANNING SOFTWARE CONSULTING   BURRIDGE COMPUTING
;        1645 Sheely Drive             18 The Green South
;        Fort Collins                  Warborough, Oxon
;        CO 80526 USA                  OX10 7DN, ENGLAND
;        Phone: 970-221-0438           Phone: +44 (0)1865 858279
;        E-mail: davidf@dfanning.com   E-mail: davidb@burridgecomputing.co.uk
;
; CATEGORY:
;
;       Objects, Coordinates
;
; SYNTAX:
;
;       theObject = Obj_New("MAPCOORD")
;
; CATCOORDES:
;
;       CATCOORD
;       CATATOM
;       CATCONTAINER IDLITCOMPONENT
;       IDL_CONTAINER
;
; CLASS_STRUCTURE:
;
;   class = { MAPCOORD, $
;             INHERITS CATCOORD $
;             map_structure: Ptr_New(), $
;             overlays: ObjArr(20) $
;           }
;
; MESSAGES:
;
;   None.
;
; MODIFICATION_HISTORY:
;
;       Written by: David W. Fanning, 28 December 2008.
;       Modified the way the map overlays were handled to be more flexible. 9 January 2009. DWF.
;-
;*******************************************************************************************
;* Copyright (c) 2008-2009, jointly by Fanning Software Consulting, Inc.                   *
;* and Burridge Computing. All rights reserved.                                            *
;*                                                                                         *
;* Redistribution and use in source and binary forms, with or without                      *
;* modification, are permitted provided that the following conditions are met:             *
;*     * Redistributions of source code must retain the above copyright                    *
;*       notice, this list of conditions and the following disclaimer.                     *
;*     * Redistributions in binary form must reproduce the above copyright                 *
;*       notice, this list of conditions and the following disclaimer in the               *
;*       documentation and/or other materials provided with the distribution.              *
;*     * Neither the name of Fanning Software Consulting, Inc. or Burridge Computing       *
;*       nor the names of its contributors may be used to endorse or promote products      *
;*       derived from this software without specific prior written permission.             *
;*                                                                                         *
;* THIS SOFTWARE IS PROVIDED BY FANNING SOFTWARE CONSULTING, INC. AND BURRIDGE COMPUTING   *
;* ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE     *
;* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE          *
;* DISCLAIMED. IN NO EVENT SHALL FANNING SOFTWARE CONSULTING, INC. OR BURRIDGE COMPUTING   *
;* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL    *
;* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;    *
;* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND             *
;* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT              *
;* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS           *
;* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                            *
;*******************************************************************************************
;
;+
; NAME:
;       MAPCOORD::DRAW
;
; PURPOSE:
;
;       This method sets up the map coordinate system.
;
; SYNTAX:
;
;       theObject -> Draw
;
; ARGUMENTS:
;
;     None.
;
; KEYWORDS:
;
;       None.
;-
;*****************************************************************************************************
PRO MapCoord::Draw, _EXTRA=extra
 
    IF Ptr_Valid(self.map_projection) THEN BEGIN
        mapStruct = self -> SetMapProjection(*self.map_projection, _EXTRA=*self.map_projection_keywords)
    ENDIF
    self -> CATCoord::Draw
    
END


;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD::GETPROPERTY
;
; PURPOSE:
;
;       This method allows the user to obtain MAPCOORD properties. Be sure
;       you ALWAYS call the superclass GETPROPERTY method if you have extra
;       keywords!
;
; SYNTAX:
;
;       theObject -> GetProperty ...
;
; ARGUMENTS:
;
;     None.
;
; KEYWORDS:
;
;       GRID_OBJECT:    An object, such as MAP_GRID, for drawing map grid lines. This keyword is depreciated
;                       in favor of MAP_OVERLAY. If it is used, and if OVERLAY_POSITION is undefined,
;                       then OVERLAY_POSITION=1.
;       
;       LATLON_RANGES:  If this keyword is set, the XRANGE and YRANGE keywords are reported in units 
;                       of longitude and latitude, respectively, rather than the default UV coordinates.
;                       
;       MAP_OVERLAY:    Set this keyword to a named variable to return the object array containing map
;                       overlay objects. If you wish to return a specific map overlay object, then use the
;                       OVERLAY_POSITION keyword to select which object you wish to return.
; 
;       MAP_STRUCTURE:  A map projection structure (e.g., from MAP_PROJ_INIT) that allows the
;                       the coordinate conversion from Cartisian coordinates (otherwise known as
;                       UV coordinates) to longitude/latitude coordinates and visa versa.   
;
;       OUTLINE_OBJECT: An object, such as MAP_OUTLINE, for drawing map outlines. This keyword is depreciated
;                       in favor of MAP_OVERLAY. If it is used, and if OVERLAY_POSITION is undefined,
;                       then OVERLAY_POSITION=0.
;                       
;       OVERLAY_POSITION: Normally, if the MAP_OVERLAY keyword is used to obtain the map overlays, the
;                       entire map overlay array is returned. However, if you wish to obtain just one
;                       map overlay object, you can set this keyword to the index number of the object
;                       to return.
; 
;       POSITION:       A four-element array representing the position of the plot in the window.
;                       Use normalized coordinates (0 to 1) in this order: [x0, y0, x1, y1]. The
;                       default is [0,0,1,1].
;
;       XRANGE:         A two-element array representing the X range of the map projection in a 2D
;                       Cartesian (x,y) coordinate system, unless the LATLON_RANGES keyword is set.
;
;       YRANGE:         A two-element array representing the Y range of the map projection in a 2D
;                       Cartesian (x,y) coordinate system, unless the LATLON_RANGES keyword is set.
;
;     _REF_EXTRA:       Any keywords appropriate for the superclass GetProperty method.
;-
;*****************************************************************************************************
PRO MapCoord::GetProperty, $
    GRID_OBJECT=grid_object, $
    LATLON_RANGES=latlon_ranges, $
    MAP_STRUCTURE=map_structure, $
    OUTLINE_OBJECT=outline_object, $
    POSITION=position, $
    MAP_OVERLAY=map_overlay, $
    OVERLAY_POSITION=overlay_position, $
    XRANGE=xrange, $
    YRANGE=yrange, $
    _REF_EXTRA=extraKeywords

   @cat_pro_error_handler
   
   ; Make sure the map structure is up to date.
   IF Ptr_Valid(self.map_projection) THEN $
        map_structure = self -> SetMapProjection(*self.map_projection, _EXTRA=*self.map_projection_keywords) $
        ELSE map_structure = *self.map_structure
   
   position = self._position
   IF Arg_Present(xrange) THEN BEGIN
      IF Keyword_Set(latlon_ranges) THEN BEGIN
            llcoords = Map_Proj_Inverse(self._xrange, self._yrange, MAP_STRUCTURE=map_structure)
            xrange = Reform(llcoords[0,*])
      ENDIF ELSE xrange = self._xrange
   ENDIF
   IF Arg_Present(yrange) THEN BEGIN
      IF Keyword_Set(latlon_ranges) THEN BEGIN
            llcoords = Map_Proj_Inverse(self._xrange, self._yrange, MAP_STRUCTURE=map_structure)
            yrange = Reform(llcoords[1,*])
      ENDIF ELSE yrange = self._yrange
   ENDIF
   IF Arg_Present(grid_object) THEN BEGIN
        IF N_Elements(overlay_position) EQ 0 $
            THEN grid_object = self.overlays[1] $
            ELSE grid_object = self.overlays[overlay_position]
   ENDIF
   IF Arg_Present(outline_object) THEN BEGIN
        IF N_Elements(overlay_position) EQ 0 $
            THEN outline_object = self.overlays[0] $
            ELSE outline_object = self.overlays[overlay_position]
   ENDIF
   IF Arg_Present(map_overlay) THEN BEGIN
        IF N_Elements(overlay_position) EQ 0 $
            THEN map_overlay = self.overlays $
            ELSE map_overlay = self.overlays[overlay_position]
   ENDIF
   IF (N_ELEMENTS (extraKeywords) GT 0) THEN self -> CATCOORD::GetProperty, _EXTRA=extraKeywords

   self -> Report, /Completed

END



;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD::GetMapProjection
;
; PURPOSE:
;
;       The purpose of this routine is to return a GCTP map projection that can be used to
;       produce a valid map structure. (Map structures are normally ephemeral in nature and
;       are valid only until the next MAP_PROJ_INIT call is made. (See the article at
;       http://www.dfanning.com/map_tips/ephemeral.html for more information.)
;
; SYNTAX:
;
;       object -> GetMapProjection, map_projection, map_keywords
;
; ARGUMENTS:
;
;       map_projection:   The name or reference number of the map projection desired.
;       
; KEYWORDS: 
;       
;       MAP_KEYWORDS:     A structure (if defined) of map projection keywords. Given the
;                         map_projection and the map_keywords, a program can call MAP_PROJ_INIT
;                         to directly acquire a map structure.
;
;-
;*****************************************************************************************************
PRO MapCoord::GetMapProjection, map_projection, MAP_KEYWORDS=map_keywords

   @cat_pro_error_handler
   
   IF Ptr_Valid(self.map_projection) THEN map_projection = *self.map_projection ELSE map_projection = ""
   IF Arg_Present(map_keywords) THEN BEGIN
      IF Ptr_Valid(self.map_projection_keywords) THEN map_keywords = *self.map_projection_keywords
   ENDIF
   
END



;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD::SETPROPERTY
;
; PURPOSE:
;
;       This method allows the user to set the MAPCOORD object's properties. Be sure
;       you ALWAYS call the superclass SETPROPERTY method if you have extra keywords!
;
;
; SYNTAX:
;
;       theObject -> SetProperty ...
;
; KEYWORDS:
; 
;       GRID_OBJECT:       An overlay object, such as MAP_GRID, for drawing map grid lines. The MAPCOORD 
;                          object cannot draw grids, but provides a logical place to store such
;                          an object. One advantage of storing the object here is that cleanup of
;                          the object is possible without the user having to do it themselves.
;                          This keyword is depreciated in favor of MAP_OVERLAY. If it is used,
;                          and the OVERLAY_POSITION keyword is not defined, then OVERLAY_POSITION
;                          is set to 1.
;                       
;       LATLON_RANGES:     If this keyword is set, the XRANGE and YRANGE keywords are assumed to
;                          be in units of longitude and latitude, respectively. The map structure returned
;                          from Map_Proj_Init will be used to convert these values to the appropriate UV
;                          coordinates for internal storage.
;                       
;       OUTLINE_OBJECT:    An overlay object, such as MAP_OUTLINE, for drawing map outlines. The MAPCOORD 
;                          object cannot draw outlines, but provides a logical place to store such
;                          an object. One advantage of storing the object here is that cleanup of
;                          the object is possible without the user having to do it themselves.
;                          This keyword is depreciated in favor of MAP_OVERLAY. If it is used,
;                          and the OVERLAY_POSITION keyword is not defined, then OVERLAY_POSITION
;                          is set to 0.
; 
;       PARENT:            An object reference of the parent object. If provided, the MAPCOORD object
;                          will add itself to the parent with the COORDS_OBJECT keyword to SETPROPERTY.
;                          The parent should be a subclassed CATDATAATOM object.
;
;       POSITION:          A four-element array representing the position of the plot in the window.
;                          Use normalized coordinates (0 to 1) in this order: [x0, y0, x1, y1]. The
;                          default is [0,0,1,1].
;                       
;       MAP_OVERLAY:       An object or object array of up to 20 overlay objects. An overlay object
;                          is an object that draws graphics in a map coordinate data space.
;                          
;                          Note: Overlay objects must be written with a DRAW method, and they must
;                          have a MAP_STRUCTURE keyword in a SetProperty method. When they are added
;                          to the MAPCOORD object, the MAPCOORD object will be made their parent
;                          (so they are not accidentally destroyed) and the SetProperty method will
;                          be called with the MAP_STRUCTURE keyword set equal to the MAPCOORD map structure.
;       
;       OVERLAY_POSITION:  A  scalar or vector with the same number of elements as MAP_OVERLAY.
;                          This keyword is used to tell IDL where to store the object in the overlay
;                          object array. It should be a number in the range of 0 to 19. If undefined,
;                          the overlay object array is searched for invalid objects, and the overlay
;                          object is stored at the lowest index containing an invalid object.
;
;       XRANGE:            A two-element array representing the X range of the map projection in a 2D
;                          Cartesian (x,y) coordinate system. These are sometimes called UV coordinates.
;                          If undefined, the longitude range of -180 to 180 is used with the map structure
;                          to create the XRANGE array.
;
;       YRANGE:            A two-element array representing the Y range of the map projection in a 2D
;                          Cartesian (x,y) coordinate system. These are sometimes called UV coordinates.
;                          If undefined, the latitude range of -90 to 90 is used with the map structure
;                          to create the YRANGE array.
;
;     _EXTRA:              Any keywords appropriate for the superclass SetProperty method.
;-
;*****************************************************************************************************
PRO MapCoord::SetProperty, $
    GRID_OBJECT=grid_object, $
    LATLON_RANGES=latlon_ranges, $
    OUTLINE_OBJECT=outline_object, $
    PARENT=parent, $
    POSITION=position, $
    MAP_OVERLAY=map_overlay, $
    OVERLAY_POSITION=overlay_position, $
    XRANGE=xrange, $
    YRANGE=yrange, $
    _EXTRA=extraKeywords
    
   @cat_pro_error_handler
   
   ; Make sure the map structure is up to date.
   IF Ptr_Valid(self.map_projection) THEN $
        map_structure = self -> SetMapProjection(*self.map_projection, _EXTRA=*self.map_projection_keywords) $
        ELSE map_structure = *self.map_structure

   IF N_Elements(parent) NE 0 THEN self -> CATCOORD::SetProperty, PARENT=parent
   IF N_Elements(position) NE 0 THEN self -> CATCOORD::SetProperty, POSITION=position
   IF N_Elements(xrange) NE 0 THEN BEGIN
      IF Keyword_Set(latlon_ranges) THEN BEGIN
        uvcoords = Map_Proj_Forward(xrange, [-5000,5000], MAP_STRUCTURE=map_structure)
        xrange = Reform(uvcoords[0,*])   
      ENDIF
      self -> CATCOORD::SetProperty, XRANGE=xrange
   ENDIF
   IF N_Elements(yrange) NE 0 THEN BEGIN
      IF Keyword_Set(latlon_ranges) THEN BEGIN
        uvcoords = Map_Proj_Forward([-5000,5000], yrange, MAP_STRUCTURE=map_structure)
        yrange = Reform(uvcoords[1,*])     
      ENDIF
      self -> CATCOORD::SetProperty, YRANGE=yrange
   ENDIF
   IF N_Elements(outline_object) NE 0 THEN BEGIN
   
        IF N_Elements(overlay_position) EQ 0 THEN thisPosition = 0 ELSE thisPosition = overlay_position
        self -> SetOverlay, outline_object, thisPosition, /OVERWRITE
        
   ENDIF 
   IF N_Elements(grid_object) NE 0 THEN BEGIN
   
        IF N_Elements(overlay_position) EQ 0 THEN thisPosition = 1 ELSE thisPosition = overlay_position
        self -> SetOverlay, grid_object, thisPosition, /OVERWRITE

   ENDIF 
   IF N_Elements(map_overlay) NE 0 THEN BEGIN
   
        count = N_Elements(overlay)
        IF count NE N_Elements(overlay_position) THEN Message, 'Number of map overlays does not match the number of overlay positions.'
        FOR j=0,count-1 DO BEGIN
            self -> SetOverlay, map_overlay[j], overlay_position[j]
        ENDFOR
   
   ENDIF
   
   IF (N_ELEMENTS(extraKeywords) GT 0) THEN self -> CATCOORD::SetProperty,  _EXTRA=extraKeywords
   
   self -> Report, /Completed

END


;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD::SetMapProjection
;
; PURPOSE:
;
;       The purpose of this routine is to define a GCTP map projection that can be used to
;       produce a valid map structure. (Map structures are normally ephemeral in nature and
;       are valid only until the next MAP_PROJ_INIT call is made. (See the article at
;       http://www.dfanning.com/map_tips/ephemeral.html for more information.)
;
; SYNTAX:
;
;       The parameters and arguments are identical to those listed for MAP_PROJ_INIT.
;
; ARGUMENTS:
;
;       map_projection:   The name or reference number of the map projection desired.
;
; KEYWORDS:
;
;       Any MAP_PROJ_INIT keyword can be used to set up the map projection.
;-
;*****************************************************************************************************
FUNCTION MapCoord::SetMapProjection, map_projection, _EXTRA=extraKeywords

   @cat_func_error_handler
   
   IF N_Elements(map_projection) EQ 0 THEN Message, 'Must specify the name or number of the map projection desired.'
   IF Ptr_Valid(self.map_projection) $
        THEN *self.map_projection = map_projection $
        ELSE self.map_projection = Ptr_New(map_projection)
   IF Ptr_Valid(self.map_projection_keywords) $
        THEN *self.map_projection_keywords = extraKeywords $
        ELSE self.map_projection_keywords = Ptr_New(extraKeywords)
        
    ; Call MAP_PROJ_INIT to get the map projection structure.
    map_structure = Map_Proj_Init(*self.map_projection, _EXTRA=*self.map_projection_keywords)
        
   RETURN, map_structure
END



;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD::SetOverlay
;
; PURPOSE:
;
;       This method is used to set a map overlay object into the storage array.
;
; SYNTAX:
;
;       self -> SetOverlay, overlayObject, overlayPosition
;
; ARGUMENTS:
;
;       overlayObject:     A map overlay object. (Required)
;       
;       overlayPostition:  The position of the overlay object in the array. (Optional)
;                          If undefined, the map overlay object is stored in the first open
;                          position in the overlay array.
;
; KEYWORDS:
;
;      OVERWRITE:          The default behavior is to throw an error if the user asks to store
;                          an overlay object in a location that already contains a valid overlay
;                          object. If this keyword is set, however, the object will be stored at
;                          the requested location without an error being generated.
;-
;*****************************************************************************************************
PRO MapCoord::SetOverlay, theObject, thePosition, OVERWRITE=overwrite

   @cat_pro_error_handler

   ; Required parameters.
   IF N_Elements(theObject) EQ 0 THEN Message, 'A map overlay object is a required parameter.'
   IF Obj_Isa(theObject, 'CATATOM') EQ 0 THEN Message, 'The map overlay object must be a subclassed CATATOM object.'
   
   ; Check for valid storage locations.
   validLocations = Where(Obj_Valid(self.overlays) EQ 0, count)
   IF N_Elements(thePosition) EQ 0 THEN BEGIN
      IF count EQ 0 THEN Message, 'The are no more map overlay positions available.'
      thePostion = validLocations[0]
   ENDIF
   
   ; Confine the position to valid values.
   thisPosition = 0 > thePosition < (N_Elements(self.overlays) - 1)
   
   ; Is the requested position an open position?
   void = Where(validLocations EQ thisPosition, posOpen)
   IF posOpen GT 0 THEN BEGIN
       self.overlays[thisPosition] = theObject
   ENDIF ELSE BEGIN
       IF Keyword_Set(overwrite) THEN BEGIN
           self.overlays[thisPosition] -> RemoveParent, self
           self.overlays[thisPosition] = theObject
       ENDIF ELSE Message, 'The requested overlay position ' + StrTrim(thisPostion) + ' is already taken.'
   ENDELSE
   
   ; Add self as parent to this object.
   theObject -> AddParent, self
   
   ; Make this map structure the map structure for the overlay object.
   theObject -> SetProperty, MAP_STRUCTURE=*self.map_structure
   
END



;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD::CLEANUP
;
; PURPOSE:
;
;       This is the MAPCOORD object class destructor method.
;
; SYNTAX:
;
;       Called automatically when the object is destroyed.
;
; ARGUMENTS:
;
;       None.
;
; KEYWORDS:
;
;      None.
;-
;*****************************************************************************************************
PRO MapCoord::CLEANUP

   @cat_pro_error_handler
   
   Ptr_Free, self.map_structure
   Ptr_Free, self.map_projection
   Ptr_Free, self.map_projection_keywords
   FOR j=0,19 DO BEGIN
     thisObject = self.overlays[j]
     IF Obj_Valid(thisObject) THEN thisObject -> RemoveParent, self
   ENDFOR
   Obj_Destroy, self.overlays
   
   self -> CATCOORD::CLEANUP ; Don't forget this line or memory leakage WILL occur!!!

   self -> Report, /Completed

END


;*****************************************************************************************************
;+
; NAME:
;       MAPCOORD::INIT
;
; PURPOSE:
;
;       This is the MAPCOORD object class initialization method
;
; SYNTAX:
;
;       Called automatically when the object is created.
;
; ARGUMENTS:
;
;       map_projection     The name or the reference number of a valid CGTP map projection. See
;                          the on-line documentation for MAP_PROJ_INIT for details.
;
; KEYWORDS:
;
;       Any keywords defined for MAP_PROJ_INIT are allowed. And, in addition to those, the following:
; 
;       GRID_OBJECT:       An overlay object, such as MAP_GRID, for drawing map grid lines. The MAPCOORD 
;                          object cannot draw grids, but provides a logical place to store such
;                          an object. One advantage of storing the object here is that cleanup of
;                          the object is possible without the user having to do it themselves.
;                          This keyword is depreciated in favor of MAP_OVERLAY. If it is used,
;                          and the OVERLAY_POSITION keyword is not defined, then OVERLAY_POSITION
;                          is set to 1.
;                       
;       LATLON_RANGES:     If this keyword is set, the XRANGE and YRANGE keywords are assumed to
;                          be in units of longitude and latitude, respectively. The map structure returned
;                          from Map_Proj_Init will be used to convert these values to the appropriate UV
;                          coordinates for internal storage.
;                       
;       OUTLINE_OBJECT:    An overlay object, such as MAP_OUTLINE, for drawing map outlines. The MAPCOORD 
;                          object cannot draw outlines, but provides a logical place to store such
;                          an object. One advantage of storing the object here is that cleanup of
;                          the object is possible without the user having to do it themselves.
;                          This keyword is depreciated in favor of MAP_OVERLAY. If it is used,
;                          and the OVERLAY_POSITION keyword is not defined, then OVERLAY_POSITION
;                          is set to 0.
; 
;       PARENT:            An object reference of the parent object. If provided, the MAPCOORD object
;                          will add itself to the parent with the COORDS_OBJECT keyword to SETPROPERTY.
;                          The parent should be a subclassed CATDATAATOM object.
;
;       POSITION:          A four-element array representing the position of the plot in the window.
;                          Use normalized coordinates (0 to 1) in this order: [x0, y0, x1, y1]. The
;                          default is [0,0,1,1].
;                       
;       MAP_OVERLAY:       An object or object array of up to 20 overlay objects. An overlay object
;                          is an object that draws graphics in a map coordinate data space.
;                          
;                          Note: Overlay objects must be written with a DRAW method, and they must
;                          have a MAP_STRUCTURE keyword in a SetProperty method. When they are added
;                          to the MAPCOORD object, the MAPCOORD object will be made their parent
;                          (so they are not accidentally destroyed) and the SetProperty method will
;                          be called with the MAP_STRUCTURE keyword set equal to the MAPCOORD map structure.
;       
;       OVERLAY_POSITION:  A  scalar or vector with the same number of elements as MAP_OVERLAY.
;                          This keyword is used to tell IDL where to store the object in the overlay
;                          object array. It should be a number in the range of 0 to 19. If undefined,
;                          the overlay object array is searched for invalid objects, and the overlay
;                          object is stored at the lowest index containing an invalid object.
;
;       XRANGE:            A two-element array representing the X range of the map projection in a 2D
;                          Cartesian (x,y) coordinate system. These are sometimes called UV coordinates.
;                          If undefined, the longitude range of -180 to 180 is used with the map structure
;                          to create the XRANGE array.
;
;       YRANGE:            A two-element array representing the Y range of the map projection in a 2D
;                          Cartesian (x,y) coordinate system. These are sometimes called UV coordinates.
;                          If undefined, the latitude range of -90 to 90 is used with the map structure
;                          to create the YRANGE array.
;
;       _EXTRA:            Any keywords appropriate for superclass INIT methods.
;-
;*****************************************************************************************************
FUNCTION MapCoord::INIT, map_projection, $
    GRID_OBJECT=grid_object, $
    LATLON_RANGES=latlon_ranges, $
    MAP_STRUCTURE=map_structure, $
    OUTLINE_OBJECT=outline_object, $
    PARENT=parent, $
    POSITION=position, $
    MAP_OVERLAY=map_overlay, $
    OVERLAY_POSITION=overlay_position, $
    XRANGE=xrange, $
    YRANGE=yrange, $
    ; Superclass keywords that must be defined here because of the way I have had to use _EXTRA
    ; keywords to pick up map projection keywords.
    AUTO_DESTROY=auto_destroy, $
    INDEXED=indexed, $
    MEMORY_MANAGEMENT=memory_management, $
    NAME=name, $
    NO_COPY=no_copy, $
    UVALUE=uvalue, $
    _EXTRA=extraKeywords

   ; Set up error handler and call superclass INIT method
   @cat_func_error_handler
   
   IF (N_Elements(map_projection) EQ 0) THEN BEGIN
        IF N_Elements(map_structure) EQ 0 THEN $
             Message, 'Must specify the name or number of the map projection desired.'
   ENDIF ELSE BEGIN
   
       ; Set up the map projection structure.
       map_structure = self -> SetMapProjection(map_projection, _EXTRA=extraKeywords)
   
   ENDELSE
   
   ; Need ranges?
   IF N_Elements(xrange) EQ 0 THEN xrange = map_structure.uv_box[[0,2]]
   IF N_Elements(yrange) EQ 0 THEN yrange = map_structure.uv_box[[1,3]]
   
   ; Are the ranges in lat/lon space?
   IF Keyword_Set(latlon_ranges) THEN BEGIN
      uvcoords = Map_Proj_Forward(xrange, yrange, MAP_STRUCTURE=map_structure)
      xrange = Reform(uvcoords[0,*])
      yrange = Reform(uvcoords[1,*])
   ENDIF

   ; Call the SUPERCLASS object INIT method.
   ok = self -> CATCOORD::INIT ($
        PARENT=parent, $
        POSITION=position, $
        XRANGE=xrange, $
        YRANGE=yrange, $
        AUTO_DESTROY=auto_destroy, $
        INDEXED=indexed, $
        MEMORY_MANAGEMENT=memory_management, $
        NAME=name, $
        NO_COPY=no_copy, $
        UVALUE=uvalue)
   IF ~ok THEN RETURN, 0
   
   ; Populate the object.
   self.map_structure = Ptr_New(map_structure)
   
   IF Obj_Valid(outline_object) THEN BEGIN
        outline_object -> AddParent, self
        outline_object -> SetProperty, MAP_STRUCTURE=*self.map_structure
        IF N_Elements(overlay_position) EQ 0 THEN thisPosition = 0 ELSE thisPosition = overlay_position
        self -> SetOverlay, outline_object, thisPosition
   ENDIF 

   IF Obj_Valid(grid_object) THEN BEGIN
        grid_object -> AddParent, self
        grid_object -> SetProperty, MAP_STRUCTURE=*self.map_structure
        IF N_Elements(overlay_position) EQ 0 THEN thisPosition = 1 ELSE thisPosition = overlay_position
        IF Obj_Valid(self.overlays[thisPosition]) $
            THEN self -> SetOverlay, grid_object $
            ELSE self -> SetOverlay, grid_object, thisPosition
   ENDIF 
   
   IF N_Elements(map_overlay) NE 0 THEN BEGIN
        count = N_Elements(overlay)
        IF count NE N_Elements(overlay_position) THEN Message, 'Number of map overlays does not match the number of overlay positions.'
        FOR j=0,count-1 DO BEGIN
            self -> SetOverlay, map_overlay[j], overlay_position[j]
        ENDFOR
   ENDIF
   
   ; Finished.
   self -> Report, /Completed
   RETURN, 1

END


;*****************************************************************************************************
;
; NAME:
;       MAPCOORD CLASS DEFINITION
;
; PURPOSE:
;
;       This is the structure definition code for the MAPCOORD object.
;
;*****************************************************************************************************
PRO MapCoord__DEFINE, class

   class = { MAPCOORD, $
             map_structure: Ptr_New(), $         ; The map projection structure.
             overlays: ObjArr(20), $             ; A storage location for map overlays.
             map_projection: Ptr_New(), $
             map_projection_keywords: Ptr_New(), $
             INHERITS CATCOORD $
           }

END


