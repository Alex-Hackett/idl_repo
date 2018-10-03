;colobar choice for model takion 6
;FUNCTION Colorbar_Annotate, axis, index, value
;   text = ['0','0.2', '0.6', '1.0', '1.4', '1.8'] ;using Max=1.8 and Min=0.0, Top=255
;   possibleval = [0, 28, 85, 142, 199, 255]
;   selection = Where(possibleval eQ value)
;   IF selection[0] EQ -1 THEN RETURN, "" ELSE $
;      RETURN, (text[selection])[0]
;   END

FUNCTION Colorbar_Annotate, axis, index, value
   text = ['0','0.2', '0.6', '1.0', '1.4', '1.8'] ;using Max=1.8 and Min=0.0, Top=255
   possibleval = [0, 28, 85, 142, 199, 255]
   selection = Where(possibleval eQ value)
   IF selection[0] EQ -1 THEN RETURN, "" ELSE $
      RETURN, (text[selection])[0]
   END

FUNCTION CNVLGAUSS, inarray, sigma, fwhm=fwhm

;if (keyword_defined(fwhm)) then begin
;  res = fwhm / 2.354
;endif else begin
;  res = sigma
;endelse

res=sigma

if (res eq 0) then return, inarray

; make the Gaussian
nx = round(res * 4) * 2 + 1  < ((size(inarray))[1] - 1)
ctr = nx / 2
x = findgen(nx) - ctr
k = 1.0 / (res * sqrt(2.*!pi)) * exp((-1./2) * (x / res)/2)

; convol it
cnvlarray = convol (inarray, k, total(k), /edge_truncate)

return, cnvlarray
END


;difference from v1: trying to create images showing the density contrast
close,/all

;OK, working and reading well RV_DATA!

;defines file RV_DATA
rv_data='/home/groh/ze_models/2D_models/takion/hd45166/106_copy/11/RV_DATA'
openu,2,rv_data     ; open file without writing

;set text string variables (scratch)
desc1=''
desc2=''

;find the values of ND and beta
readf,2,FORMAT='(1x,I,10x,A23)',ND,desc1
readf,2,FORMAT='(1x,I,10x,A22)',beta,desc2
N=ND*beta

;set vector sizes as ND
r1=dblarr(ND) & betaang=dblarr(beta) & radvel=dblarr(ND*beta) & azivel=radvel & betvel=radvel & dencon=radvel
denconbeta=dblarr(beta) & betadeg=betaang & denconrbeta=dblarr(ND,beta) & denconr=dblarr(ND)

;As long as the values of ND and beta are known, we can read out the rest of the file.
;Current format only valid for ND=40 and beta=11, will have to adjust the way to read RV_DATA
;        for other values of ND and beta.

readf,2,FORMAT='(A23)',desc1 ;those lines are reading blank or text values
readf,2,FORMAT='(A23)',desc1

;read values of r
l=ND
for j=0, 4 do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
r1[ND-l]=r2t
r1[ND-l+1]=r3t
r1[ND-l+2]=r4t
r1[ND-l+3]=r5t
r1[ND-l+4]=r6t
r1[ND-l+5]=r7t
r1[ND-l+6]=r8t
r1[ND-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of beta (i.e. angles)
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11)',r10t,r11t,r12t
betaang[0]=r2t
betaang[1]=r3t
betaang[2]=r4t
betaang[3]=r5t
betaang[4]=r6t
betaang[5]=r7t
betaang[6]=r8t
betaang[7]=r9t
betaang[8]=r10t
betaang[9]=r11t
betaang[10]=r12t

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the radial velocity as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
radvel[N-l]=r2t
radvel[N-l+1]=r3t
radvel[N-l+2]=r4t
radvel[N-l+3]=r5t
radvel[N-l+4]=r6t
radvel[N-l+5]=r7t
radvel[N-l+6]=r8t
radvel[N-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the azimuthal velocity as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
azivel[N-l]=r2t
azivel[N-l+1]=r3t
azivel[N-l+2]=r4t
azivel[N-l+3]=r5t
azivel[N-l+4]=r6t
azivel[N-l+5]=r7t
azivel[N-l+6]=r8t
azivel[N-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the beta velocity as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
betvel[N-l]=r2t
betvel[N-l+1]=r3t
betvel[N-l+2]=r4t
betvel[N-l+3]=r5t
betvel[N-l+4]=r6t
betvel[N-l+5]=r7t
betvel[N-l+6]=r8t
betvel[N-l+7]=r9t
l=l-8
endfor

readf,2,FORMAT='(A23)',desc1
readf,2,FORMAT='(A23)',desc1

;read values of the density contrast (in comparison with the spherical wind) as a function of r and beta
l=ND*beta
N=ND*beta
lim=1
lim=(ND*beta/8)-1
for j=0, lim do begin
readf,2,FORMAT='(1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11,1x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
dencon[N-l]=r2t
dencon[N-l+1]=r3t
dencon[N-l+2]=r4t
dencon[N-l+3]=r5t
dencon[N-l+4]=r6t
dencon[N-l+5]=r7t
dencon[N-l+6]=r8t
dencon[N-l+7]=r9t
l=l-8
endfor

close,2

;at the end of the reading we have r1, betaang, radvel, azivel, betvel and dencon with the quantities.

;compute density contrast as a function of betaang
i=0
for j=0,beta-1 do begin
denconbeta[j]=dencon[i]
i=i+40
endfor

;compute density contrast as a function of r
i=0
for j=0,ND-1 do begin
denconr[j]=dencon[j]/dencon[0]
i=i+11
endfor


;convert betaang to degrees, which is then stored in betadeg
betadeg=180*betaang/3.141593

;converting quantities to 2darrays to do surface plot

;creating matrix of size (2,ND*beta) to store the pairs of (beta,r1) to further convert to x,y
polarcoord=dblarr(2,ND*beta)
dencon3d=dblarr(3,ND*beta)

;counters
l=0
r=1
m=0
s=1

for j=0, (ND*beta-1) do begin ;running through all the lines of the matrix
  if j ge (ND*r) then begin
    l=l+1
    r=r+1
  endif
  polarcoord(0,j)=betaang[l]    ;positions polarcoord(0,*)=values of beta, working!!!
    
  polarcoord(1,j)=r1[m]         ;positions polarcoord(1,*)=values of r1, working!!!
  m=m+1
  if m gt (ND-1) then begin
    m=0
  endif
endfor

;getting x,y coordinates, where 0,0 is center the center of the star.
rect_coord = CV_COORD(From_Polar=polarcoord, /To_Rect)

;converting dencon to denconxy, as dencon is sorted in a polar grid
denconxy=dencon


;creating 3d density contrast
dencon3d(0,*)=rect_coord(0,*)
dencon3d(1,*)=rect_coord(1,*)
for i=0, ND*beta-1 do dencon3d(2,i)=denconxy[i]

;splitting 3d density contrast in x,y, z vectors - note that z vector alread exists (dencon)

x=dblarr(ND*beta)
y=x

;swapping x and y, as in CMFGEN pole=0 and eq=90. Doing this we can recover the usual alignment
x=rect_coord(1,*)
y=rect_coord(0,*)

;converting x and y from R(CMFGEN) to Rsun

x=x/6.96
y=y/6.96

;testing to check whether negative values of x,y are affecting the grid done later; the answer is YES (2007 Aug 03)! 
; OOPS NO! (2007 Nov 20) tryin to use the negative values, probably has to shift the image first
;therefore I am only using the positive values
;for j=0, ND*beta-1 do begin
;  if x(j) lt 0 then begin
;  x(j)=-1*x(j)
;  endif
;endfor

;for j=0, ND*beta-1 do begin
;  if y(j) lt 0 then begin
;  y(j)=-1*y(j)
;  endif
;endfor
;y=y+min(y)


;general plots, mainly for checking 
;velocity plots
;window,0,xsize=400,ysize=400,retain=2
;plot,xvector,y,psym=2,symsize=1.5,xtitle='log r (CMFGEN units)', ytitle='velocity (km/s)'
;plots,alog10(r2),v2,psym=2,symsize=0.5
;plots,alog10(rout),vout,color=255,psym=4,symsize=1.5

;appending surface_gridding


   ; Indexed color.

Device, Decomposed=0

;set z values to denconxy
z = denconxy
;z= [denconxy,denconxy]
;trying to reverse values to show the whole star (2007Nov20)
;x=[-1.*reverse(x),x]
;y=[-1.*reverse(y),y]   
;x=x+min(x)
;y=y+min(y)

; Load colors. Use GETCOLOR from Coyote Library.

colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black

   ; Set the window size.

;WINDOWSIZE = 250

;   ; Show the data points randomly distributed.
;
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

gridSpace = [0.1, 0.1]

   ; Grid the Z data, using the triangles.The variables "xvector"
   ; and "yvector" are output variables.

griddedData = TriGrid(x, y, z, triangles, gridSpace, [MIN(x),MIN(y), MAX(x), MAX(y)], $
   XGrid=xvector, YGrid=yvector)

;trying to get gridded data in a meaningful grid
;griddedData = TriGrid(x, y, z, triangles, NX=100, XGRID=r1, YGRID=r1)

;   ; Display the surface.
;
;Window, /Free, Title='Initial Surface', $
;   XSize=WINDOWSIZE*1.5, YSize=WINDOWSIZE, XPos=0, YPos=WINDOWSIZE + 30
;Surface, griddedData, xvector, yvector, /NoData, $
;   Color=colors.green
;Surface, griddedData, xvector, yvector, XStyle=4, $
;   YStyle=4, ZStyle=4, /NoErase

;   ; Display the smoothed surface.
;
;griddedData = TriGrid(x, y, z, triangles, gridSpace, XGrid=xvector, $
;   YGrid=yvector, /Quintic)
;Window, /Free, Title='Smoothed Surface', $
;   XSize=WINDOWSIZE*1.5, YSize=WINDOWSIZE, $
;   XPos=WINDOWSIZE*1.5 + 10, YPos=WINDOWSIZE + 30
;Surface, griddedData, xvector, yvector, /NoData, Color=colors.green
;Surface, griddedData, xvector, yvector, XStyle=4, $
;   YStyle=4, ZStyle=4, /NoErase
;
;   ; Display the extrapolated, smoothed surface.
;
;griddedData = TriGrid(x, y, z, triangles, gridSpace, XGrid=xvector, $
;   YGrid=yvector, /Quintic, Extrapolate=boundaryPts)
;Window, /Free, Title='Extrapolated Surface', $
;   XSize=WINDOWSIZE*1.5, YSize=WINDOWSIZE, $
;   XPos=2*WINDOWSIZE*1.5 + 20, YPos=WINDOWSIZE + 30
;Surface, griddedData, xvector, yvector, /NoData, Color=colors.green
;Surface, griddedData, xvector, yvector, XStyle=4, $
;   YStyle=4, ZStyle=4, /NoErase

;see the results in ximage

title='HD 45166 - Density contrast model 106_copy/6'
xaxis='R (Rsun)'
yaxis='z (Rsun)'
;ximage,griddedData,TITLE=title,XTITLE=xaxis,YTITLE=yaxis,yrange=[-40,40],xrange=[0,40]
img=bytscl(griddedData,MAX=1.8); byte scaling the image for display purposes with tvimage
imginv=255b-img ;invert img
;plotting in window
window,0,xsize=300,ysize=600,retain=2
;position with colorbar
;plot,xvector,yvector,XRANGE=[0,max(xvector)], yrange=[MIN(YVECTOR),MAX(YVECTOR)], xtitle='r (R!d!9n!3!n)', xstyle=1,ystyle=1, ytitle='z (Rsun)', /NODATA, Position=[0.05, 0.08, 0.85, 0.95]
;position with no colorbar
plot,xvector,yvector,XRANGE=[0,max(xvector)], yrange=[MIN(YVECTOR),MAX(YVECTOR)], xtitle='distance (R!d!9n!3!n)', xstyle=1,ystyle=1, ytitle='distance (R!d!9n!3!n)', /NODATA, Position=[0.27, 0.15, 0.97, 0.92], xcharsize=2,ycharsize=2
LOADCT, 0
tvimage,imginv, /Overplot
na=REPLICATE(' ', 5)
AXIS,XAXIS=0,XSTYLE=1,COLOR=0,XTITLE='',XRANGE=[0,max(xvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=0,YRANGE=[min(yvector),max(yvector)],ycharsize=2
AXIS,XAXIS=1,XSTYLE=1,COLOR=0,XRANGE=[0,max(xvector)],XTICKNAME=na
AXIS,YAXIS=1,YSTYLE=1,COLOR=0,YRANGE=[min(yvector),max(yvector)],ycharsize=2,YTICKNAME=na
LOADCT,0
xyouts,33,35,'model 8', alignment=0.5,orientation=0,charsize=2,COLOR=0
;oPlot, Findgen(41)
;LOADCT,13
denconbetatrunc = ['0.0','0.3', '0.6', '0.9', '1.2', '1.5', '1.8']
!P.Background = 255
window,2,xsize=60,ysize=400,retain=2
LOADCT,0
colorbar, COLOR=0, TICKNAMES=denconbetatrunc, DIVISIONS=6, /VERTICAL, /RIGHT,$
 POSITION=[0.04, 0.08, 0.34, 0.95],/REVERSE,charsize=2
tvlaser,BARPOS='no',FILENAME='/home/groh/papers_in_preparation_groh/hd45166/hd45_106copy_dencon_colorbar.ps',$
  /NoPrint,XDIM=60,YDIM=400
;colorbar, COLOR=0, YTickV=[0,58,85,142,199,255],Range=[0,255], YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
;tvlaser,BARPOS='no',FILENAME='/home/groh/papers_in_preparation_groh/hd45166/hd45_106copy_dencon_newmod8.ps',$
;  /NoPrint,XDIM=300,YDIM=600

;Device, Decomposed=0
;   Window,1, xsize=50,ysize=600, Title='Colorbar Annotation Example'
;   LoadCT, 0
;   Colorbar, XTickV=[0,28,85,142,199,255], Range=[0,255], $
;      XTickformat='colorbar_annotate', XMinor=0, Color=FSC_Color('White'), $
;       POSITION=[0.48, 0.08, 0.91, 0.95],/REVERSE, Font=0

;all working now! export figure as PS (not EPS) and use in latex
;\begin{figure} \rotatexbox{90}{...\includegraphics...}}

;trying to generate the whole image

; NAME:
;      CNVLGAUSS
;
; PURPOSE:
;      This function Gaussian smooths an array in it's first dimension
;
; CALLING SEQUENCE:
;      Result = CNVLGAUSS(inarray, sigma, fwhm=fwhm)
;
; INPUTS:
;      Inarray = Vector to be spread
;      Sigma =   Width of Gaussian
;
; KEYWORD:
;      FWHM = Used instead of sigma for Gaussian, Full Width at Half Maximum
;
; OUTPUT:
;      A 1D array that is smoothed according to a Gaussian
;
; PROCEDURE:
;      Create a Gaussian and convol it
;
; MODIFICATION HISTORY:
;      created April 19 2003 by John Dermody










end