FUNCTION BitmapForButtonText, str

;; Return an RGB byte array (w, h, 3) suitable for use as the Value of a
;; Widget_Button to display the text given in parameter 'str'.

;; Example:
; wTLB0=Widget_Base(/Row,/Exclusive)
; wBtn1=Widget_Button(wTLB0,Value=BitmapForButtonText('1'))
; wBtn2=Widget_Button(wTLB0,Value=BitmapForButtonText('2'))
; Widget_Control,wTLB0,/Realize

;; Dick Jackson  /  D-Jackson Software Consulting  /  dick@d-jackson.com

;;    Find what font and colours to use by making a button widget

wTLB = Widget_Base()
wBtn = Widget_Button(wTLB)
font = Widget_Info(wBtn, /FontName)
sysColors = Widget_Info(wBtn, /System_Colors)
Widget_Control, wTLB, /Destroy

;;    Find how high the bitmap needs to be for ascenders and descenders
;;    (highest and lowest points of characters) in this font

Window, XSize=100, YSize=100, /Pixmap, /Free
Device, Set_Font=font
y0 = 15
XYOutS, 0, y0, 'Ay', /Device, Font=0    ; Test with high and low letters
bwWindow = TVRD()                       ; Black background, white text
WDelete, !D.Window
IF !Order EQ 1 THEN bwWindow = Reverse(bwWindow, 2) ; Handle !Order=1
whRowUsed = Where(Max(bwWindow, Dimension=1) NE 0)
minY = Min(whRowUsed, Max=maxY)

;;    Calculate sizes and starting position

border = 2                              ; Width of border around text
xSize = (Get_Screen_Size())[0]          ; Maximum width of button text
ySize = (maxY-minY+1) + border*2
x0 = border
y0 = border+(y0-minY)

;;    Make window, draw text, read back

Window, XSize=xSize, YSize=ySize, /Pixmap, /Free
Erase, Color=Total(sysColors.Face_3D * [1, 256, 65536L])
blankRGB = TVRD(True=3)
XYOutS, x0, y0, str, /Device, Font=0, $
        Color=Total(sysColors.Button_Text * [1, 256, 65536L])
textRGB = TVRD(True=3)
WDelete, !D.Window
text2D = Total(textRGB NE blankRGB, 3)
whereX = Where(Total(text2D, 2) NE 0, nWhereX)

;;    Prepare result

IF nWhereX EQ 0 THEN $                  ; Nothing visible:
   result = blankRGB[0, *, *] $         ;    Return one column
ELSE $                                  ; Else return width used plus
                                        ; border (plus two extra pixels
                                        ; to make Windows button look OK)
   result = textRGB[0:(whereX[nWhereX-1]+border+2) < (xSize-1), *, *]

;;    Compensate for reversal if !Order is 1

IF !Order EQ 1 THEN result = Reverse(result, 2)

Return, result

END