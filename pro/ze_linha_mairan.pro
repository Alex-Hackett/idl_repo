entrada = '/home/groh/plots_grace/rden1.txt'
OPENU, lun, entrada, /GET_LUN
line = ''
i = 0 & x = DBLARR(1000) & y = x

WHILE NOT EOF(lun) DO BEGIN

    READF, lun, line & i = i + 1

ENDWHILE

CLOSE, lun & FREE_LUN, lun
OPENU, lun, entrada, /GET_LUN

FOR j=0, i-1 DO BEGIN

    READF, lun, xi, yi
    x[j] = xi & y[j] = yi

ENDFOR

CLOSE, lun & FREE_LUN, lun

x = x(WHERE(x NE 0)) & y = y(WHERE(y NE 0)) & t = DINDGEN(MAX(x)-MIN(x))+MIN(x)

result = CSPLINE_MAIRAN(x, y, t)

WINDOW, 0, XSIZE=600, YSIZE=600, RETAIN=2
WSET, 0

PLOT, x, ALOG10(y), /NODATA
PLOTS, x, ALOG10(y), PSYM=2, SYMSIZE=1.5
PLOTS, t, ALOG10(result), PSYM=1, SYMSIZE=.1, COLOR=FSC_COLOR("RED")

END 
