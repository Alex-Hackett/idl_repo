;+
; NAME:
;       MAP_PLOTS__DEFINE
;
; PURPOSE:
;
;       This object is a wrapper for the PLOTS routine in IDL. It provides a simple 
;       way to draw polygons or lines on images which use a MAPCOORD object to set up the map 
;       projection space. A map coordinate space must be in effect at the time the 
;       Draw method of this object is used. If you used MAP_PROJ_INIT to set up the
;       map coordinate space, then a map structure must be passed into the program with
;       the MAP_STRUCTURE keyword.
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
;       Graphics
;
; CALLING SEQUENCE:
;
;       plotObject = Obj_New('Map_PlotS')
;       Map_Set, /CYLINDRICAL
;       plotObject -> Draw
;       
; AUGUMENTS:
; 
;       parent:        The parent object.
;
; KEYWORDS:
;     
;  All of the following INIT keywords can be set and obtained using the SETPROPERTY and GETPROPERTY methods.
;  
;      CLIP:            The coordinates of a rectangle used to clip the graphics output. 
;                       The rectangle is specified as a vector of the form [X0, Y0, X1, Y1], 
;                       giving coordinates of the lower left and upper right corners, 
;                       respectively. The default clipping rectangle is the plot window set
;                       up by the MAPCOORD object.
; 
;      COLOR:           The name of the color to draw the grid lines in. Default: "charcoal".
;      
;      LINESTYLE:       Set this keyword to the type of linestyle desired. See Graphics Keywords in
;                       the on-line help for additional information. Default is 0, solid line.
; 
;      MAP_STRUCTURE:   A map projection structure (e.g., from MAP_PROJ_INIT) that allows the
;                       the coordinate conversion from Cartisian coordinates (otherwise known as
;                       UV coordinates) to longitude/latitude coordinates and visa versa.  
;                       
;      NOCLIP:          Set this keyword to surpress clipping of the plot. Set to 0 by default.
;      
;      PSYM:            The plotting symbol to use for the plot. Can use any symbol available in
;                       the Coyote Library routine SYMCAT. Set to 0 by default.
;                       
;      SYMSIZE:         Set this keyword to the size of symbols. Default is 1.0.
;      
;      T3D:             Set this graphics keyword if you wish to draw using the T3D transformation matrix.
;      
;      THICK:           The thickness of the lines. Set to 1.0 by default.
;        
;      ZVALUE:          Set this keyword to the ZVALUE where the output should be drawn. Set to 0 by default.
;        
;      UVCOORDS:        Set this keyword if the LONS and LATS are specified in UV coordinates, rather than
;                       longitude and latitude coordinates.
;
; DEPENDENCIES:
;
;       The following programs (at least) are required from the Coyote Library:
;
;                     http://www.dfanning.com/programs/error_message.pro
;                     http://www.dfanning.com/programs/fsc_color.pro
;                     http://www.dfanning.com/programs/symcat.pro
;
; MODIFICATION HISTORY:
;
;       Written by David W. Fanning, 9 January 2009.
;-
;
;******************************************************************************************;
;  Copyright (c) 2009, by Fanning Software Consulting, Inc.                                ;
;  All rights reserved.                                                                    ;
;                                                                                          ;
;  Redistribution and use in source and binary forms, with or without                      ;
;  modification, are permitted provided that the following conditions are met:             ;
;                                                                                          ;
;      * Redistributions of source code must retain the above copyright                    ;
;        notice, this list of conditions and the following disclaimer.                     ;
;      * Redistributions in binary form must reproduce the above copyright                 ;
;        notice, this list of conditions and the following disclaimer in the               ;
;        documentation and/or other materials provided with the distribution.              ;
;      * Neither the name of Fanning Software Consulting, Inc. nor the names of its        ;
;        contributors may be used to endorse or promote products derived from this         ;
;        software without specific prior written permission.                               ;
;                                                                                          ;
;  THIS SOFTWARE IS PROVIDED BY FANNING SOFTWARE CONSULTING, INC. ''AS IS'' AND ANY        ;
;  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES    ;
;  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT     ;
;  SHALL FANNING SOFTWARE CONSULTING, INC. BE LIABLE FOR ANY DIRECT, INDIRECT,             ;
;  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED    ;
;  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;         ;
;  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND             ;
;  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT              ;
;  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS           ;
;  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                            ;
;******************************************************************************************;
PRO Map_PlotS::Draw, _EXTRA=extrakeywords

    ; Error handling
    Catch, theError
    IF theError NE 0 THEN BEGIN
        Catch, /Cancel
        void = Error_Message()
        RETURN
    ENDIF
    
    ; You have to have data to plot. If not exit quietly.
    IF (N_Elements(*self.lons) EQ 0) OR (N_Elements(*self.lats) EQ 0) THEN RETURN
    
    ; If you have a map structure, then determine if the points to plot
    ; are in lat/lon or UV coordinate space. The MapCoord object sets up
    ; a UV coordinate space. The values to be plotted here are in lat/lon
    ; space, so they have to be converted to 
    IF Ptr_Valid(self.map_structure) THEN BEGIN
        IF self.uvcoords THEN BEGIN
            lons = *self.lons
            lats = *self.lats
        ENDIF ELSE BEGIN
            uv = MAP_PROJ_FORWARD(*self.lons, *self.lats, MAP_STRUCTURE=*self.map_structure)
            lons = Reform(uv[0,*])
            lats = Reform(uv[1,*])
        ENDELSE
     ENDIF ELSE BEGIN
        lons = *self.lons
        lats = *self.lats
    ENDELSE
    
    ; Accommodate SYMCAT symbols
    IF self.psym GE 0 THEN psym = SymCat(self.psym) ELSE psym = (-1) * SymCat(Abs(self.psym))
    
    ; If clip is not defined, then set it here.
    IF Total(self.clip) EQ 0 $
        THEN clip = [!X.CRange[0], !Y.CRange[0], !X.CRange[1], !Y.CRange[1]] $
        ELSE clip = self.clip

    ; Draw the lines or symbols.
    PlotS, lons, lats,  $
        CLIP=clip, $
        COLOR=FSC_COLOR(self.color), $
        LINESTYLE=self.linestyle, $
        NOCLIP=self.noclip, $
        PSYM=psym, $
        SYMSIZE=self.symsize, $
        T3D=self.t3d, $
        THICK=self.thick, $
        Z=self.zvalue

    ; Draw children?
    self -> CatAtom::Draw, _EXTRA=extrakeywords

END ; -------------------------------------------------------------------------------------

    
PRO Map_PlotS::GetProperty, $
    LONS=lons, $
    LATS=lats, $
    CLIP=clip, $
    COLOR=color, $
    LINESTYLE=linestyle, $
    MAP_STRUCTURE=map_structure, $
    NOCLIP=noclip, $
    PSYM=psym, $
    SYMSIZE=symsize, $
    T3D=t3d, $
    THICK=thick, $
    UVCOORDS=uvcoords, $
    ZVALUE=zvalue, $
    _REF_EXTRA=extra

    ; Error handling
    Catch, theError
    IF theError NE 0 THEN BEGIN
        Catch, /Cancel
        void = Error_Message()
        RETURN
    ENDIF
    
    clip = self.clip
    color = self.color
    linestyle = self.linestyle
    noclip = self.noclip
    psym = self.psym
    symsize = self.symsize
    t3d = self.t3d
    thick = self.thick
    uvcoords = self.uvcoords
    zvalue = self.zvalue
    thick = self.thick
    lats = *self.lats
    lons = *self.lons
    map_structure = *self.map_structure
    
    IF N_Elements(extra) NE 0 THEN self -> CATATOM::GetProperty, _EXTRA=extra
    
END ; -------------------------------------------------------------------------------------

    
PRO Map_PlotS::SetProperty, $
    LONS=lons, $
    LATS=lats, $
    CLIP=clip, $
    COLOR=color, $
    LINESTYLE=linestyle, $
    MAP_STRUCTURE=map_structure, $
    NOCLIP=noclip, $
    PSYM=psym, $
    SYMSIZE=symsize, $
    T3D=t3d, $
    THICK=thick, $
    UVCOORDS=uvcoords, $
    ZVALUE=zvalue, $
    _EXTRA=extra

    ; Error handling
    Catch, theError
    IF theError NE 0 THEN BEGIN
        Catch, /Cancel
        void = Error_Message()
        RETURN
    ENDIF
    
    IF N_Elements(lons) NE 0 THEN *self.lons = lons
    IF N_Elements(lats) NE 0 THEN *self.lats = lats
    IF N_Elements(map_structure) NE 0 THEN *self.map_structure = map_structure

    IF N_Elements(clip) NE 0 THEN self.clip = clip
    IF N_Elements(color) NE 0 THEN self.color = color
    IF N_Elements(linestyle) NE 0 THEN self.linestyle = linestyle
    IF N_Elements(noclip) NE 0 THEN self.noclip = noclip
    IF N_Elements(psym) NE 0 THEN self.psym = psym
    IF N_Elements(symsize) NE 0 THEN self.symsize = symsize
    IF N_Elements(t3d) NE 0 THEN self.t3d = t3d
    IF N_Elements(thick) NE 0 THEN self.thick = thick
    IF N_Elements(zvalue) NE 0 THEN self.zvalue = zvalue

    IF N_Elements(extra) NE 0 THEN self -> CATATOM::SetProperty, _EXTRA=extra

END ; -------------------------------------------------------------------------------------


PRO Map_PlotS::CLEANUP

    Ptr_Free, self.lons
    Ptr_Free, self.lats
    Ptr_Free, self.map_structure
    
    self -> CatAtom::CLEANUP
END ; -------------------------------------------------------------------------------------


FUNCTION Map_PlotS::INIT, lons, lats, $
    CLIP=clip, $
    COLOR=color, $
    LINESTYLE=linestyle, $
    MAP_STRUCTURE=map_structure, $
    NOCLIP=noclip, $
    PSYM=psym, $
    SYMSIZE=symsize, $
    T3D=t3d, $
    THICK=thick, $
    UVCOORDS=uvcoords, $
    ZVALUE=zvalue, $
    _EXTRA=extra
    
    ; Error handling
    Catch, theError
    IF theError NE 0 THEN BEGIN
        Catch, /Cancel
        void = Error_Message()
        RETURN, 0
    ENDIF
    
    ; Initialize superclass object,
     ok = self -> CatAtom::INIT(parent, _EXTRA=extra) 
     IF ~ok THEN RETURN, 0

    ; Default values.
    SetDefaultValue, color, 'White'
    SetDefaultValue, linestyle, 0
    SetDefaultValue, noclip, 1
    SetDefaultValue, psym, 0
    SetDefaultValue, symsize, 1.0
    SetDefaultValue, t3d, 0
    SetDefaultValue, thick, 1.0
    SetDefaultValue, uvcoords, 0B
    SetDefaultValue, zvalue, 0.0
    IF N_Elements(clip) NE 0 THEN self.clip = clip
    self.color = color
    self.linestyle = linestyle
    self.noclip = noclip
    self.psym = psym
    self.symsize = symsize
    self.t3d = t3d
    self.thick = thick
    self.uvcoords = uvcoords
    self.zvalue = zvalue
    
    IF N_Elements(lons) EQ 0 $
        THEN self.lons = Ptr_New(/ALLOCATE_HEAP) $
        ELSE self.lons = Ptr_New(lons)
    
    IF N_Elements(lats) EQ 0 $
        THEN self.lats = Ptr_New(/ALLOCATE_HEAP) $
        ELSE self.lats = Ptr_New(lats)
    
    IF N_Elements(map_structure) EQ 0 $
        THEN self.map_structure = Ptr_New(/ALLOCATE_HEAP) $
        ELSE self.map_structure = Ptr_New(map_structure)
    
    RETURN, 1
    
END ; -------------------------------------------------------------------------------------


PRO Map_PlotS__DEFINE, class

    class = { MAP_PLOTS, $
              lons: Ptr_New(), $      
              lats: Ptr_New(), $   
              clip: DblArr(4),$   
              color: "", $
              linestyle: 0, $
              noclip: 0B, $
              symsize: 0.0, $
              thick: 0, $
              psym: 0, $
              t3d: 0B, $
              zvalue: 0.0, $
              uvcoords: 0B, $
              map_structure: Ptr_New(), $
              INHERITS CatAtom $
            }

END ; -------------------------------------------------------------------------------------