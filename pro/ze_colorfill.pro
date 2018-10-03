PRO ze_colorfill, $
   Low=low, $ ; The lowest point on the x axis to fill.
   High=high,$  ; The highest point on the x axis to fill.
   ymin=ymin ,$      ; vector with the minimum fluxes
   ymax=ymax,$       ;vector with the maximum fluxes
   x=x,  $      ;vector with lambda values, the same for both ymin and ymax
   yvals=yvals           ;vector with fluxes
   ; Example:
   ;
   ;    IDL> ColorArea, Low=20, High=60

On_Error, 1

   ; Put your own data here, y = f(x).
;obsdir='/Users/jgroh/espectros/agcar/'
;model198car=obsdir+'198_car_ebv65r35.txt'
;ZE_READ_SPECTRA_COL_VEC,model198car,l198car,f198car


;x=l198car
;y=f198car
;ymin=f198car/1.5
;ymax=f198car*1.5
   ; Check for keywords.

IF N_Elements(low) EQ 0 THEN low = 0.25 * Max(x)
IF N_Elements(high) EQ 0 THEN high = 0.75 * Max(x)
IF low GT high THEN Message, 'LOW value is larger than HIGH value. Returning...'

   ; Set up program colors.

axisColor =    FSC_Color('green', !D.Table_Size-2)
background =   FSC_Color('charcoal', !D.Table_Size-3)
dataColor =    FSC_Color('yellow', !D.Table_Size-4)
fillColor =    FSC_Color('grey', !D.Table_Size-5)
outlineColor = FSC_Color('dark grey', !D.Table_Size-6)

   ; Set up a window.

;Window,2, XSize=950, YSize=850

   ; Plot the curve.

;Plot, x, y, Background=background, Color=axisColor, /NoData
;OPlot, x, y, Color=dataColor

   ; Make sure asked-for values are within the data range.

;low  = !X.CRange[0] > low  < !X.CRange[1]
;high = !X.CRange[0] > high < !X.CRange[1]

   ; Find the low and high Y values, as well as the low and high
   ; indices nearest those values.

indices = Value_Locate(x, [low, high])
lowIndex = indices[0]
highIndex = indices[1]

   ; Make sure the indices are between the low and high values.

IF x(lowIndex) LT low THEN lowIndex = lowIndex + 1
IF x(highIndex) GT high THEN highIndex = highIndex - 1

revx=reverse(x[lowIndex:highIndex])
revymax=reverse(ymax[lowIndex:highIndex])

   ; Create a polygon to fill.

xpoly = [low,        low,         x[lowIndex:highIndex], high,        revx]
ypoly = [ymax[lowIndex],ymin[lowIndex],ymin[lowIndex:highIndex],ymax[highIndex],revymax]

PolyFill, xpoly, ypoly, Color=fillColor
;PlotS, xpoly, ypoly, Color=outlineColor, Thick=2
;PolyFill, xpoly, ypoly, Color=fillColor

   ; Re-apply curve lines to repair Polyfill damage.

;Plot, x, y, Color=axisColor, /NoData, /NoErase
;OPlot, x, y, Color=dataColor, Thick=3

END
