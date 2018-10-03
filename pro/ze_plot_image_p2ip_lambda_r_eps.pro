;--------------------------------------------------------------------------------------------------------------------------

PRO ZE_PLOT_IMAGE_P2IP_LAMBDA_R_EPS,ip,pgridip,freqgridip,NP,lambda,lstart,lend,rstar

C=299792000.

lstart_str=strcompress(string(lstart*1., format='(I05)'))
lend_str=strcompress(string(lend*1., format='(I05)'))

index=FINDEL(lstart,lambda)
index2=FINDEL(lend,lambda)
min=(NP)*(index-1)
max=(NP)*(index2+2)
nlambda=index2+3-index
RAND=max-min

;define axis x,y,z
ftza=dblarr(RAND)
ftxb=ftza
ftya=ftza

FOR i=0., RAND-1 DO BEGIN
ftza[i] = ip[i+min]*pgridip[i+min];/max(ip[i+min]);*pgridip[i+min];*pgridip[i+min] ; intensity as a function of (p, lambda)
ftxb[i] = C/freqgridip[i+min]*1E-05 ; lambda [in Angstroms]
;ftya[i] = pgridip[i+min]/rstar ; in rstar
ftya[i] = pgridip[i+min]/1.49e3 ; in AU

ENDFOR

mas_to_rad=1./(206265.*1000.)

; Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output
; variables.

TRIANGULATE, ftxb, ftya, fttriangles, ftboundaryPts

;recommended values FOR ETACR :0.01,30 (greater than 30 and lower than 0.01 does not change anything FOR ETACAR, see xmgrace plot)
; Grid the Z data, using the triangles.The variables "xvector" and "yvector" are output variables. Set grid space by:
;p2ip_gridSpace = [0.002, 0.1] ;first value means spacing in lambda (in angstrom), second value means spacing in p (in mas)
p2ip_gridSpace = [5., 1.5] ;first value means spacing in lambda (in angstrom), second value means spacing in p (in mas)
p2ip_griddedData = TRIGRID(ftxb, ftya, ftza, fttriangles, p2ip_gridSpace,[MIN(ftxb), 0, MAX(ftxb), 50], XGrid=ftxvector, YGrid=ftyvector)

s=size(ftxvector)
ys=size(ftyvector)

;normalize each lambda by max I ?
FOR i=0., s[1]-2 DO BEGIN
  p2ip_griddedData[i,*]=p2ip_griddedData[i,*]/max(p2ip_griddedData[i,*])

ENDFOR


help,p2ip_griddedData

a=min(p2ip_griddedData)
a=0
b=max(p2ip_griddedData)

img=bytscl(p2ip_griddedData,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img
;plotting in window
set_plot,'x'

!P.Background = fsc_color('white')
LOADCT,0
xwindowsize=1500.*1  ;window size in x
ywindowsize=300.*1  ; window size in y

;;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize ;original, working fine

LOADCT,42,/SILENT
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
wdelete,!d.window

xsize=xwindowsize
ysize=ywindowsize

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/img_pip_'+lstart_str+'_'+lend_str+'.eps',encapsulated=1,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches


!P.THICK=12
!X.THICK=16
!Y.THICK=16
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12
!Y.OMARGIN=[8,4]
ticklen = 10.
!x.ticklen = ticklen/ywindowsize
!y.ticklen = ticklen/xwindowsize
;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

tb=10


LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

xmin=min(ftxvector)
xmax=max(ftxvector)
print,xmin,xmax
plot, ftxvector, ftyvector/1., XTICKFORMAT='(I)', xrange=[xmin,xmax], $
yrange=[min(ftyvector),max(ftyvector/1.)],xstyle=1,ystyle=1, xtitle='Wavelength [Angstrom]', $
ytitle='Impact Parameter [AU]', /NODATA, Position=[0.05, 0.18, 0.96, 0.95],ycharsize=2,xcharsize=2

;linear colorbar
LOADCT, 42,/silent
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,charsize=2.0,$
POSITION=[0.97, 0.18, 0.98, 0.90]

tvimage,pic2, /Overplot

LOADCT,0,/SILENT
;draws axes, white tick marks
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XRANGE=[xmin,xmax],xcharsize=xc
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(ftyvector),max(ftyvector)],ycharsize=yc,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(ftyvector),max(ftyvector)],YTICKFORMAT='(A2)';ycharsize=0
;AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(ftyvector),max(ftyvector)]
 AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[xmin,xmax]
 
plots,[xmin,xmax],[23.4,23.4],linestyle=2,noclip=0,thick=tb+3.5,color=fsc_color('white')
plots,[xmin,xmax],[10.0,10.0],linestyle=2,noclip=0,thick=tb+3.5,color=fsc_color('white')
plots,[xmin,xmax],[5.0,5.0],linestyle=2,noclip=0,thick=tb+3.5,color=fsc_color('white')
plots,[xmin,xmax],[1.5,1.5],linestyle=2,noclip=0,thick=tb+3.5,color=fsc_color('white')

;;label horizontal lines
;xyouts,0.07,0.56,TEXTOIDL('\phi_{orb}=0.50'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=16
;xyouts,0.07,0.35,TEXTOIDL('\phi_{orb}=0.90'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=16
;xyouts,0.07,0.27,TEXTOIDL('\phi_{orb}=0.95'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=16
;xyouts,0.07,0.21,TEXTOIDL('\phi_{orb}=1.00'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=16

;xyouts,0.85,0.85,'c)',/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=12
xyouts,0.965,0.935,TEXTOIDL('p I(p)'),/NORMAL,color=fsc_color('black'),charsize=3.5,charthick=12


device,/close
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0

set_plot,'x'


END