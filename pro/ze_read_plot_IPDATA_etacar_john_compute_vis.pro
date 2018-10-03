;CONSTANTS
C=299792000.


;size of IPDATA array is ((NP+1)*NCF)+RECL*2+(NP+1)
;NP=72.
NP=75.
;NCF=3952.
NCF=63551.
;RECL=146
RECL=NP*2.+2.
arrsize=((NP+1)*NCF)+RECL*2+(NP+1)
data=DBLARR(1, arrsize)


;OPENR, lun, '/home/groh/IP_DATA', /GET_LUN
;OPENR, lun, '/home/groh/ze_models/2D_models/takion/hd45166/106_copy/8/IP_DATA_hd45_106copy_2D_8_0_58', /GET_LUN
OPENR, lun, '/home/groh/ze_models/etacar_john/mod_97/obs/IP_DATA', /GET_LUN
OPENW,2,'/home/groh/teste_IP.txt'

;Read data.  
READU, lun, data 
  
;write to file
PRINTF,2,data

;define 1D arrays
p=dblarr(NP-1)
freq=dblarr(NCF)
IPDYM=(NP-1)*NCF
ip=dblarr(IPDYM)

;create the p vector
for i=0., NP-2 do p[i]=data[i + (RECL*2) + 1]

;create the frequency vector
startfreq=RECL*2.+2.*(NP+1) - 1.
n=0.
for i=0., NCF-1. do begin
	freq[i]=data[n + startfreq]
	n=n+NP+1.
endfor

;create lambda vector
lambda=C/freq*1E-05

;create the I(p,nu) vector, working now!
startip=RECL*2.+(NP+1)
m=1.
t=-1.
for i=0., IPDYM-1 do begin
	if (i eq m*(NP-1)) then begin
	t=t+3.
	m=m+1.

	endif else begin
	t=t+1.	
        endelse
   ip[i]=data[startip + t]	 
endfor


;Close the file.  
FREE_LUN, lun  
CLOSE,2

;creating grid vector pgridip
pgridip=ip
r=0.
for i=0., IPDYM-1. do begin

	pgridip[i]=p[r]
	r=r+1.

	if (r eq NP-1) then begin
        r=0.
	endif

endfor

;creating grid vector freqgridip
freqgridip=ip
r=0.
s=0.
for i=0., IPDYM-1. do begin

	freqgridip[i]=freq[r]
	s=s+1.
	if (s eq NP-1.) then begin
        r=r+1.
	s=0.
	endif

endfor

;appending surface_gridding


   ; Indexed color.

Device, Decomposed=0

;now we can just select lambda start and end
lstart=21500.
lend=21750.
near = Min(Abs(lambda - lstart), index)
near2= Min(Abs(lambda - lend), index2)
min=(NP-1)*(index-1)
max=(NP-1)*(index2+2)
nlambda=index2+3-index
RAND=max-min

z=dblarr(RAND)
x=z
y=z


for i=0., RAND-1 do begin
;z[i] = ip[i+min]*pgridip[i+min]
z[i] = ip[i+min]
x[i] = C/freqgridip[i+min]*1E-05
;y[i] = pgridip[i+min]/6.96
y[i] = pgridip[i+min]/(6.96*214.08*2.25) ;in mas, assuming d=2250 pc 
endfor

   ; Load colors. Use GETCOLOR from Coyote Library.

colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black

   ; Set the window size.

;WINDOWSIZE = 250

   ; Show the data points randomly distributed.

;Window, /Free, Title='XY Point Distribution', $
;   XSize=WINDOWSIZE, YSize=WINDOWSIZE, XPos=0, YPos=0
;Plot,x,y, Color=colors.green, /NoData, $
;   XRange=[0, Max(x)], YRange=[0, Max(y)]
;PlotS, x, y, PSym=1

   ; Create the set of Delaunay triangles. The variables
   ; "triangles" and "boundaryPts" are output variables.

Triangulate, x, y, triangles, boundaryPts

;   ; Display the triangles.
;
;s = Size(triangles, /Dimensions)
;num_triangles = s[1]
;Window, /Free, Title='Delanay Triangles', $
;   XSize=WINDOWSIZE, YSize=WINDOWSIZE, XPos=WINDOWSIZE + 10, YPos=0
;Plot, Findgen(41), Color=colors.green, /NoData, $
;   XRange=[0, Max(x)], YRange=[0, Max(y)]
;PlotS, x, y, PSym=1
;
;   ; Draw the triangles.
;
;FOR j=0,num_triangles-1 DO BEGIN
;    thisTriangle = [triangles[*,j], triangles[0,j]]
;    PlotS, x[thisTriangle], y[thisTriangle], Color=colors.beige
;ENDFOR

   ; Set the grid spacing. Here we want 0.01 in X and 0.05 in Y.

gridSpace = [0.4, 0.01] ;first value means spacing in lambda, second value means spacing in log p/R* 

   ; Grid the Z data, using the triangles.The variables "xvector"
   ; and "yvector" are output variables.
;[MIN(X), MIN(Y), MAX(X), MAX(Y)]
griddedData = TriGrid(x, y, z, triangles, gridSpace,[MIN(X), MIN(Y), MAX(X), 800.], $
   XGrid=xvector, YGrid=yvector)

;compute line profile by summing p.I(p) over p, for each lambda; this does not work, because
;it is an integral, and I have a very discrete p grid spacing. HAs to be done in a finer p grid,
;using the griddedData. Now it is working! If using log p that has to be modified.

ys=size(yvector)
s=size(xvector)
lineprofile=dblarr(s)
for i=0., s[1]-1 do begin
        lineprofile[i]=TOTAL(griddedData[i,*]) ;IF USING LINEAR P !!!!!!!!!!!	
endfor


;normalize griddedData
for i=0., s[1]-1 do begin
          print,max(griddedData[i,*])
          griddedData[i,*]=griddedData[i,*]/max(griddedData[i,*])
endfor

;compute the fourier transform of the gridded Data

f=griddedData
test=dblarr(s)
test2=griddedData[500,*]
;for i=0., s[1]-1 do begin
        ;  test[i]=griddedData[i,*]
;        ;  f=fft(griddedData[i,*])
;endfor

f=yvector	
f=ABS(fft(test2)) ;STILL NOT WORKING
ftxaxis=(FINDGEN(ys[1]-1)/(ys[1]*0.00001)) ;0.00001=spacing in arcsec


;;   ; Display the surface.
;;
;Window, /Free, Title='Initial Surface', $
;   XSize=WINDOWSIZE*1.5, YSize=WINDOWSIZE, XPos=0, YPos=WINDOWSIZE + 30
;Surface, griddedData, xvector, yvector, /NoData, $
;   Color=colors.green
;Surface, griddedData, xvector, yvector, XStyle=4, $
;   YStyle=4, ZStyle=4, /NoErase
;

;xsurface, griddedData,xvector, yvector, xtitle='freq',ytitle='log p (R*)',ztitle='p I(p)'

;see the results in ximage

;title='HD 45166 - Density contrast model 106_copy/6'
;xaxis='R (Rsun)'
;yaxis='z (Rsun)'
;ximage,griddedData,TITLE=title,XTITLE=xaxis,YTITLE=yaxis
loggriddedData=alog10(1+griddedData)
img=bytscl(griddedData,MAX=max(griddedData)); byte scaling the image for display purposes with tvimage
imginv=255b-img ;invert img
;plotting in window
window,0,xsize=600,ysize=600,retain=2
plot, xvector, yvector, XTICKFORMAT='(F7.1)', xrange=[min(xvector),max(xvector)], $
yrange=[min(yvector),max(yvector)],xstyle=1,ystyle=1, xtitle='lambda (Angstrom)', $
ytitle='log p/R*  (Rsun)', /NODATA, Position=[0.07, 0.08, 0.85, 0.95]
;plots, griddedData, COLOR=imginv,psym=2
LOADCT, 0
tvimage,imginv, /Overplot
;;oPlot, Findgen(41)
;;LOADCT,13
;linear colorbar
denconbetatrunc = [0.00, max(griddedData)*.2, max(griddedData)*.4, max(griddedData)*.6, max(griddedData)*.8,max(griddedData)]
;logarithimic colorbar
;denconbetatrunc = [0.00, max(loggriddedData)*.2, max(loggriddedData)*.4, max(loggriddedData)*.6, max(loggriddedData)*.8,max(loggriddedData)]
colorbar, COLOR=0,TICKNAMES=denconbetatrunc, FORMAT='(F4.3)', DIVISIONS=5, /VERTICAL, /RIGHT,$
POSITION=[0.86, 0.08, 0.88, 0.95],/REVERSE
;colorbar, COLOR=0, YTickV=[0,28,85,142,199,255],Range=[0,255], $
;      YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
tvlaser,BARPOS='no',FILENAME='/home/groh/idl.ps',$
  /NoPrint,XDIM=600,YDIM=600

window,1,xsize=600,ysize=600,retain=2
plot, xvector, lineprofile, XTICKFORMAT='(F7.1)', xrange=[min(xvector),max(xvector)], $
yrange=[min(lineprofile),max(lineprofile)],xstyle=1,ystyle=1, xtitle='lambda (Angstrom)', $
ytitle='Flux (arbitrary units)', Position=[0.07, 0.08, 0.85, 0.95]

END
