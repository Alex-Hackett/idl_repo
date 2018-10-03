; This is program output_plot  March 2
; It is stored in /usr/local/lib/idl/lib/gris/output_plot.pro
; The program comes from the IDL reference manual page 3-4
; The program transfers the plot file to the plotter for output
;
PRO output_plot
DEVICE,/CLOSE
file ='idl.' + STRLOWCASE(!D.NAME)
cmd = 'lpr ' + file
SPAWN, cmd
RETURN
END
