;+
; NAME:
;      MAP_GSHHS_SHORELINE
;
; PURPOSE:
;
;      Uses files from the Globally Self-consistent Hierarchical High-resolution Shoreline
;      (GSHHS) data base to draw shorelines in the manner of MAP_CONTINENTS. In other words,
;      it is assumed that a map coordinate data space has been established prior to calling
;      this routine. See the example below. The GSHHS data files can be downloaded from this
;      location:
;
;         http://www.ngdc.noaa.gov/mgg/shorelines/gshhs.html
;
;      An article describing how to use this program can be found here.
;
;         http://www.dfanning.com/map_tips/gshhs.html
;
; AUTHOR:
;
;      FANNING SOFTWARE CONSULTING
;      David Fanning, Ph.D.
;      1645 Sheely Drive
;      Fort Collins, CO 80526 USA
;      Phone: 970-221-0438
;      E-mail: davidf@dfanning.com
;      Coyote's Guide to IDL Programming: http://www.dfanning.com
;
; CATEGORY:

;      Mapping Utilities
;
; CALLING SEQUENCE:
;
;      Map_GSHHS_Shoreline, filename
;
; ARGUMENTS:
;
;      filename:      The name of the GSHHS input file.
;
; KEYWORDS:
;
;      COLOR:         The name of the drawing color. By default, "WHITE".
;
;      FILL:          Set this keyword to draw filled outlines.
;
;      LAND_COLOR:    The name of the land color (for FILL). By default, "INDIAN RED".
;
;      LEVEL:         The polygon LEVEL. All polygons less than or equal to this value
;                     are drawn. 1-land, 2-lakes, 3-island in lake, 4-pond in island.
;                     By default, 2 (land and lake outlines).
;
;     MAP_PROJECTION: A map projection structure (from MAP_PROJ_INIT). If using a map projection
;                     structure, a map coordinate system must be set up for the entire display window.
;
;     MINAREA:        The minimum feature area. By default, 500 km^2.
;
;     OUTLINE:        Set this keyword to draw shorelines. Set by default if FILL=0.
;
;     WATER_COLOR:    The name of the water color. By default, "SKY BLUE".
;
; RESTRICTIONS:
;
;     Requires the following two programs from the Coyote Library:
;
;         http://www.dfanning.com/programs/error_message.pro
;         http://www.dfanning.com/programs/fsc_color.pro
;
; EXAMPLE:
;
;     Example using MAP_SET to set up the map coordinate space.
;
;         datafile = 'gshhs_h.b'
;         Window, XSize=500, YSize=350
;         pos = [0.1,0.1, 0.9, 0.8]
;         Map_Set, -25.0, 135.0, Position=pos, Scale=64e6, /Mercator, /NoBorder
;         Polyfill, [pos[0], pos[0], pos[2], pos[2], pos[0]], $
;                   [pos[1], pos[3], pos[3], pos[1], pos[1]], $
;                   /Normal, Color=FSC_Color('Almond')
;         Map_GSHHS_Shoreline, datafile, /Fill, Level=3, /Outline
;         XYOutS, 0.5, 0.85, 'Australia', Font=0, Color=FSC_Color('Almond'), $
;               /Normal, Alignment=0.5
;
;     Example using MAP_PROJ_INIT to set up the map coordinate space.
;
;         datafile = 'gshhs_h.b'
;         Window, XSize=500, YSize=350
;         Erase, Color=FSC_Color('IVORY')
;
;        ; Lambert Azimuthal Projection
;        map = Map_Proj_Init(111, Limit=[40, -95, 50, -75], $
;            Center_Lat=45, Center_Lon=-85)
;
;        ; Create a data coordinate space based on map positions.
;       Plot, map.uv_box[[0, 2]], map.uv_box[[1, 3]], Position=[0.1, 0.1, 0.90, 0.75], $
;          /NoData, XStyle=5, YStyle=5, /NoErase
;       Map_GSHHS_Shoreline, datafile, /Fill, Level=3, Map_Projection=map, $
;          Water='DODGER BLUE', NoClip=0
;       Map_Grid, /Label, /Box, Color=FSC_Color('CHARCOAL'), Map_Structure=map
;       Map_Continents, /USA, Map_Structure=map
;       XYOutS, 0.5, 0.85, 'Great Lakes Region', Font=0, Color=FSC_Color('CHARCOAL'), $
;         /Normal, Alignment=0.5
;
; MODIFICATION HISTORY:
;
;     Written by David W. Fanning, 5 February 2006.
;     Based on programs by Liam Gumley at ftp://ftp.ssec.wisc.edu/pub/gumley/IDL/gshhs/.
;-
;###########################################################################
;
; LICENSE
;
; This software is OSI Certified Open Source Software.
; OSI Certified is a certification mark of the Open Source Initiative.
;
; Copyright � 2006 Fanning Software Consulting
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
PRO Map_GSHHS_Shoreline, filename, $ ; The name of the GSHHS data file to open
   COLOR=color, $                    ; The name of the drawing color. By default, "WHITE".
   FILL=fill, $                      ; Set this keyword to draw filled outlines.
   LAND_COLOR=land_color, $          ; The name of the land color (for FILL). By default, "INDIAN RED".
   LEVEL=level, $                    ; The polygon LEVEL. All polygons less than or equal to this value
                                     ; are drawn. 1-land, 2-lakes, 3-island in lake, 4-pond in island.
                                     ; By default, 2 (land and lake outlines).
   MAP_PROJECTION=map_projection, $  ; A map projection structure (from MAP_PROJ_INIT).
   MINAREA=minarea, $                ; The minimum feature area. By default, 500 km^2.
   OUTLINE=outline, $                ; Set this keyword to draw shorelines. Set by default if FILL=0.
   WATER_COLOR=water_color, $        ; The name of the water color. By default, "SKY BLUE".
   _EXTRA=extra                      ; Any PLOTS or POLYFILL keywords are allowed.


   ; Error handling.
   Catch, theError
   IF theError NE 0 THEN BEGIN
      Catch, /Cancel
      void = Error_Message()
      IF N_Elements(lun) NE 0 THEN Free_Lun, lun
      RETURN
   ENDIF

   ; Default values.
   IF N_Elements(filename) EQ 0 THEN BEGIN
      filename = Dialog_Pickfile(Filter='*.b', Title='Select GSHHS File...')
      IF filename EQ "" THEN RETURN
   ENDIF
   IF Keyword_Set(fill) THEN temp_outline = 0 ELSE temp_outline = 1
   fill = Keyword_Set(fill)
   IF N_Elements(outline) EQ 0 THEN outline = temp_outline ELSE outline = Keyword_Set(outline)
   IF N_Elements(level) EQ 0 THEN level = 2 ELSE level = 1 > level < 4
   IF N_Elements(minArea) EQ 0 THEN minArea = 500.0 ; square kilometers.
   IF N_Elements(color) EQ 0 THEN color = 'WHITE'
   IF N_Elements(water_color) EQ 0 THEN water_color = 'SKY BLUE'
   IF N_Elements(land_color) EQ 0 THEN land_color = 'INDIAN RED'

   ; Open the GSHHS data file.
   OPENR, lun, filename, /Get_Lun, /Swap_If_Little_Endian

   ; Define the polygon header.
   header = { id: 0L, $        ; A unique polygon ID number, starting at 0.
              npoints: 0L, $   ; The number of points in this polygon.
              level: 0L, $     ; 1 land, 2 lake, 3 island-in-lake, 4 pond-in-island.
              west: 0L, $      ; West extent of polygon boundary in micro-degrees.
              east: 0L, $      ; East extent of polygon boundary in micro-degrees.
              south: 0L, $     ; South extent of polygon boundary in micro-degrees.
              north: 0L, $     ; North extent of polygon boundary in micro-degrees.
              area: 0L, $      ; The area of polygon in 1/10 km^2.
              version: 0L, $   ; Polygon version, always set to 3 in this version.
              greenwich: 0S, $ ; Set to 1 if Greenwich median is crossed by polygon.
              source: 0S }     ; Database source: 0 WDB, 1 WVS.

   ; Read the data and plot if required.
   WHILE (EOF(lun) NE 1) DO BEGIN

      ; Read the polygon header.
      READU, lun, header

      ; Get the polygon coordinates. Convert to lat/lon.
      polygon = LonArr(2, header.npoints, /NoZero)
      READU, lun, polygon
      lon = Reform(polygon[0,*] * 1.0e-6)
      lat = Reform(polygon[1,*] * 1.0e-6)

      ; Discriminate polygons based on header information.
      polygonLevel = header.level
      polygonArea = header.area * 0.1
      IF polygonLevel GT level THEN CONTINUE
      IF polygonArea LE minArea THEN CONTINUE

      ; If you have a MAP_PROJECTION structure, use it to warp LAT/LON coordinates.
      ; No point in displaying polygons that are completely outside plot
      ; area set up by a map projection (MAP_SET) or some other plotting
      ; command.
      IF N_Elements(map_projection) GT 0 THEN BEGIN

         xy = Map_Proj_Forward(lon, lat, MAP_STRUCTURE=map_projection)
         lon = Reform(xy[0,*])
         lat = Reform(xy[1,*])
      ENDIF

      xy = Convert_Coord(lon, lat, /Data, /To_Normal)
      check = ((xy[0,*] GE !X.Window[0]) AND (xy[0,*] LE !X.Window[1])) AND $
              ((xy[1,*] GE !Y.Window[0]) AND (xy[1,*] LE !Y.Window[1]))
      usePolygon = Max(check)

      IF usePolygon EQ 0 THEN CONTINUE

      ; Draw polygons. Outlines drawn with PLOTS, filled polygons drawn with
      ; POLYFILL. Assumes lat/lon data coordinate space and colors are set up.
      IF Keyword_Set(fill) THEN BEGIN

         IF (polygonLevel EQ 1) OR (polygonLevel EQ 3) THEN $
             POLYFILL, lon, lat, Color=FSC_Color(land_color), NoClip=0, _EXTRA=extra ELSE $
             POLYFILL, lon, lat, Color=FSC_Color(water_color), NoClip=0, _EXTRA=extra

      ENDIF ELSE BEGIN

         PLOTS, lon, lat, Color=FSC_Color(color), _EXTRA=extra

      ENDELSE

      ; Need outlines with a fill?
      IF Keyword_Set(fill) AND Keyword_Set(outline) THEN $
         PLOTS, lon, lat, Color=FSC_Color(color), _EXTRA=extra

   ENDWHILE
   Free_Lun, lun

END
