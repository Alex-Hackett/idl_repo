FUNCTION READ_IPDATA_BIN,file,arrsize
data=DBLARR(1, arrsize)
OPENR, lun, file, /GET_LUN
READU, lun, data
RETURN,data
CLOSE,lun
END
;--------------------------------------------------------------------------------------------------------------------------

PRO WRITE_IPDATA_TXT,data_bin,file_txt
OPENW,2,file_txt
PRINTF,2,data_bin
CLOSE,2
END
;--------------------------------------------------------------------------------------------------------------------------

PRO READ_IP_P_FREQ_TXT,data,NP,NCF,RECL,p=p,freq=freq,ip=ip,lambda=lambda
;CONSTANTS
C=299792000.
;define 1D arrays
p=dblarr(NP)
freq=dblarr(NCF)
IPDYM=NP*NCF
ip=dblarr(IPDYM)

;create the p vector
for i=0., NP-1 do p[i]=data[i + (RECL*2)]

;create the frequency vector
startfreq=RECL*2.+2.*(NP+1) - 1.
n=0.
FOR i=0., NCF-1. do begin
  freq[i]=data[n + startfreq]
  n=n+NP+1.
ENDFOR

;create lambda vector
lambda=C/freq*1E-05

;create the I(p,nu) vector, working now!
startip=RECL*2.+(NP+1)
m=1.
t=-1.
FOR i=0., IPDYM-1 DO BEGIN
;FOR i=0., 300 DO BEGIN
  if (i eq m*NP) then begin
  t=t+2.
  m=m+1.

  endif else begin
  t=t+1.  
        endelse
   ip[i]=data[startip + t]   
ENDFOR
END
;--------------------------------------------------------------------------------------------------------------------------

PRO CREATE_P_FREQ_GRID,p,freq,NP,IPDYM,pgridip=pgridip,freqgridip=freqgridip
;creating grid vector pgridip
pgridip=dblarr(IPDYM)
r=0.
for i=0., IPDYM-1. do begin

  pgridip[i]=p[r]
  r=r+1.

  if (r eq NP) then begin
        r=0.
  endif

endfor

;creating grid vector freqgridip
freqgridip=dblarr(IPDYM)
r=0.
s=0.
for i=0., IPDYM-1. do begin

  freqgridip[i]=freq[r]
  s=s+1.
  if (s eq NP) then begin
        r=r+1.
  s=0.
  endif

endfor
END
;--------------------------------------------------------------------------------------------------------------------------

PRO COMPUTE_LINE_PROFILE,pgridip,freqgridip,ip,dist,C,min,RAND,lambda_val,lineprofile=lineprofile,lambda_lineprofile=lambda_lineprofile
;Compute line profile by summing p.I(p) over p, for each lambda; this does not work, because
;it is an integral, and I have a very discrete p grid spacing. Has to be done in a finer p grid,
;using the griddedData. Now it is working! If using log p that has to be modified.

;define axis x,y,z
lineprofz=dblarr(RAND)
lineprofx=lineprofz
lineprofy=lineprofz
FOR i=0., RAND-1 DO BEGIN
lineprofz[i] = ip[i+min]*pgridip[i+min]*2.*!PI/(dist^2) ; 2 . PI. p . I(p)/d^2, OK, see BH05 equation A1 !
lineprofx[i] = C/freqgridip[i+min]*1E-05 ;lambda [in angstroms]
;lineprofy[i] = pgridip[i+min]/6.96 ; impact parameter p [in Rsun]
lineprofy[i] = pgridip[i+min]/(6.96*214.08*dist) ;impact parameter p [in mas]
ENDFOR

;Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output 
;variables.

TRIANGULATE, lineprofx, lineprofy, lineproftriangles, lineprofboundaryPts

;gridSpace_Rsun=(lineprofy[1]-lineprofy[0])/20.
gridSpace_Rsun=0.01 ;gridspace in mas
; Grid the Z data, using the triangles.The variables "lambda_lineprofile" and "ip_lineprofile_rsun" are output variables. Set grid space by:
lineprofgridSpace = [0.74, gridSpace_Rsun] ;first value means spacing in lambda, second value means spacing in p in Rsun
lineprofgriddedData = TRIGRID(lineprofx, lineprofy, lineprofz, lineproftriangles, lineprofgridSpace, $
[MIN(lineprofx), MIN(lineprofy), MAX(lineprofx), 50], XGrid=lambda_lineprofile, YGrid=ip_lineprofile_rsun)
lambdasize=size(lambda_lineprofile)
lineprofile=lambda_lineprofile
help,ip_lineprofile_rsun,lineprofgriddedData
for i=0., lambdasize[1]-1 do begin
        lineprofile[i]=int_tabulated(ip_lineprofile_rsun*(6.96*214.08*dist),lineprofgriddedData[i,*],/DOUBLE) ;IF USING LINEAR P in mas!!!!!!!!!!!  converted to 10^10cm
endfor

SET_PLOT,'X'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
WINDOW,6,xsize=600,ysize=600,retain=2
res=12500.   ;resolving power
resang=lambda_val/res ;resolution in angstroms
ZE_SPEC_CNVL,lambda_lineprofile,lineprofile,resang,lambda_val,fluxcnvl=lineprofile
plot, lambda_lineprofile, lineprofile, XTICKFORMAT='(F7.1)', xrange=[min(lambda_lineprofile),max(lambda_lineprofile)], $
yrange=[min(lineprofile),max(lineprofile)],xstyle=1, xtitle='lambda (Angstrom)', $
ytitle='Flux (arbitrary units)',title='Flux x wavelength'

;plot to PS file
keywords = PSConfig(_Extra=PSWindow())
keywords.ysize=10.
keywords.bits_per_pixel=8.
keywords.xsize=keywords.ysize
keywords.ENCAPSULATED=1
keywords.filename='/Users/jgroh/temp/amber_agcar_brg_profile.eps'

set_plot,'ps'
   DEVICE, _EXTRA=keywords
plot, lambda_lineprofile, lineprofile, XTICKFORMAT='(F7.1)', xrange=[min(lambda_lineprofile),max(lambda_lineprofile)], $
yrange=[min(lineprofile),max(lineprofile)],xstyle=1, xtitle='lambda (Angstrom)', $
ytitle='Flux (arbitrary units)',title='Flux x wavelength'
device,/close_file
set_plot,'x'

END
;--------------------------------------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------------------------------------

PRO COMPUTE_LINE_PROFILE_V2,pgridip,freqgridip,ip,dist,C,min,RAND,lambda_val,lineprofile=lineprofile,lambda_lineprofile=lambda_lineprofile
;Compute line profile by summing p.I(p) over p, for each lambda; this does not work, because
;it is an integral, and I have a very discrete p grid spacing. Has to be done in a finer p grid,
;using the griddedData. Now it is working! If using log p that has to be modified.

;define axis x,y,z
lineprofz=dblarr(RAND)
lineprofx=lineprofz
lineprofy=lineprofz
FOR i=0., RAND-1 DO BEGIN
lineprofz[i] = ip[i+min]*pgridip[i+min] ; p . I(p), OK !
lineprofx[i] = C/freqgridip[i+min]*1E-05 ;lambda [in angstroms]
;lineprofy[i] = pgridip[i+min]/6.96 ; impact parameter p [in Rsun]
lineprofy[i] = pgridip[i+min]/(6.96*214.08*dist) ;impact parameter p [in mas]
ENDFOR

;Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output 
;variables.

TRIANGULATE, lineprofx, lineprofy, lineproftriangles, lineprofboundaryPts

;gridSpace_Rsun=(lineprofy[1]-lineprofy[0])/20.
gridSpace_Rsun=0.01 ;gridspace in mas
; Grid the Z data, using the triangles.The variables "lambda_lineprofile" and "ip_lineprofile_rsun" are output variables. Set grid space by:
lineprofgridSpace = [3.04, gridSpace_Rsun] ;first value means spacing in lambda, second value means spacing in p in Rsun
lineprofgriddedData = TRIGRID(lineprofx, lineprofy, lineprofz, lineproftriangles, lineprofgridSpace, $
[MIN(lineprofx), MIN(lineprofy), MAX(lineprofx), 200], XGrid=lambda_lineprofile, YGrid=ip_lineprofile_rsun)
lambdasize=size(lambda_lineprofile)
lineprofile=lambda_lineprofile
for i=0., lambdasize[1]-1 do begin
        lineprofile[i]=TOTAL(lineprofgriddedData[i,*]) ;IF USING LINEAR P !!!!!!!!!!! 
endfor
t=size(lineprofgriddedData)
print,t

SET_PLOT,'X'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
WINDOW,6,xsize=600,ysize=600,retain=2
res=12500.   ;resolving power
resang=lambda_val/res ;resolution in angstroms
ZE_SPEC_CNVL,lambda_lineprofile,lineprofile,resang,lambda_val,fluxcnvl=lineprofile
plot, lambda_lineprofile, lineprofile/lineprofile[10], XTICKFORMAT='(F7.1)', xrange=[min(lambda_lineprofile),max(lambda_lineprofile)], $
yrange=[min(lineprofile),max(lineprofile/lineprofile[10])],xstyle=1, xtitle='lambda (Angstrom)', $
ytitle='Flux (arbitrary units)',title='Flux x wavelength'

;plot to PS file
keywords = PSConfig(_Extra=PSWindow())
keywords.ysize=10.
keywords.bits_per_pixel=8.
keywords.xsize=keywords.ysize
keywords.ENCAPSULATED=1
keywords.filename='/Users/jgroh/temp/amber_agcar_brg_profile.eps'

set_plot,'ps'
   DEVICE, _EXTRA=keywords
plot, lambda_lineprofile, lineprofile/lineprofile[10], XTICKFORMAT='(F7.1)', xrange=[min(lambda_lineprofile),max(lambda_lineprofile)], $
yrange=[min(lineprofile),max(lineprofile/lineprofile[10])],xstyle=1, xtitle='lambda (Angstrom)', $
ytitle='Flux (arbitrary units)',title='Flux x wavelength'
device,/close_file
set_plot,'x'

END
;--------------------------------------------------------------------------------------------------------------------------
PRO COMPUTE_FOURIER_TRANSFORM,dist,pgridip,freqgridip,ip,C,min,RAND,norm_pmas_griddedData=norm_pmas_griddedData,pmas_griddedData=pmas_griddedData,$
        ftransform=ftransform,ftransfnorm=ftransfnorm,ftxaxis=ftxaxis,ftxvector=ftxvector,ftyvector=ftyvector,$ 
        ftya=ftya,ftxb=ftxb,ftza=ftza,ftbaseline=ftbaseline

;Compute the fourier transform, i.e. visibility. First the data are interpolated in a regular grid.

;define axis x,y,z
ftza=dblarr(RAND)
ftxb=ftza
ftya=ftza

FOR i=0., RAND-1 DO BEGIN
ftza[i] = ip[i+min] ; intensity as a function of (p, lambda), that's the correct way for Fourier TRansform
;ftza[i] = ip[i+min]*pgridip[i+min]*pgridip[i+min] ; playing just to produce image p.I(p) to compare with 2D code for debuggging
ftxb[i] = C/freqgridip[i+min]*1E-05 ; lambda [in Angstroms]
ftya[i] = pgridip[i+min]/(6.96*214.08*dist) ; in [mas]
;ftya[i] = pgridip[i+min]/(396.93) ; in [r/rstar]

ENDFOR

mas_to_rad=1./(206265.*1000.)
;ftya=ftya*mas_to_rad
;mas_to_m=6.96*214.08*dist*1e8
;trying to reverse the variables
;ftza=[reverse(ftza),ftza]
;ftya=[-1*reverse(ftya),ftya]
;ftxb=[reverse(ftxb),ftxb]

; Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output
; variables.

TRIANGULATE, ftxb, ftya, fttriangles, ftboundaryPts,tolerance=1e-10

;recommended values FOR ETACR :0.01,30 (greater than 30 and lower than 0.01 does not change anything FOR ETACAR, see xmgrace plot)
; Grid the Z data, using the triangles.The variables "xvector" and "yvector" are output variables. Set grid space by:

;pmas_gridSpace = [0.5, 0.01] ;first value means spacing in lambda (in angstrom), second value means spacing in p (in mas)
pmas_gridSpace = [1.0, 0.2] ;first value means spacing in lambda (in angstrom), second value means spacing in p (in r/rstar)
pmas_griddedData = TRIGRID(ftxb, ftya, ftza, fttriangles, pmas_gridSpace,[MIN(ftxb), 0, MAX(ftxb), 50.], XGrid=ftxvector, YGrid=ftyvector)

s=size(ftxvector)
ys=size(ftyvector)


norm_pmas_griddedData=pmas_griddedData
;normalize the Intensity distribution
FOR i=0., s[1]-2 DO BEGIN
  norm_pmas_griddedData[i,*]=pmas_griddedData[i,*]/max(pmas_griddedData[i,*])
ENDFOR


Nbas=40.  ; number of baseline points
maxbase=150. ; maximum baseline [m]

ftbaseline=FINDGEN(Nbas)*maxbase/Nbas
ftxaxis=ftbaseline
ftransform=dblarr(s[1]-1,Nbas)
ftransfnorm=ftransform

FOR i=0., s[1]-2. DO BEGIN
           FOR n=0, Nbas-1 DO BEGIN
     ftxaxis[n]=ftbaseline[n]/(206265.*ftxvector[i]*1e-10)     ;spatial frequency axis in [1/arcsec]
     ftransform[i,n]=0.
           FOR u=0,ys[1]-1 DO BEGIN
           k=norm_pmas_griddedData[i,u]*ftyvector[u]*BESELJ(2*3.141592*ftyvector[u]*mas_to_rad*ftbaseline[n]/(ftxvector[i]*1e-10),0)
           ftransform[i,n]=ftransform[i,n]+2*3.141592*k
     ENDFOR
          ENDFOR
ENDFOR

;normalizing an taking the ABS value of the Fourier transform for each wavelength
FOR i=0., s[1]-2. DO BEGIN
ftransfnorm[i,*]=ABS(ftransform[i,*]/max(ftransform[i,*]))
ENDFOR


;ftxaxis=FINDGEN(ys[1])
;ftxaxis=ftxaxis/(ys[1]*0.00001) ;0.00001=spacing in arcsec of the pmas_griddedData
END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_I_MAS,ftxvector,ftyvector,norm_pmas_griddedData,lambda_val

near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)
WINDOW,2,xsize=600,ysize=600,retain=2
plot,ftyvector,norm_pmas_griddedData[index,*],xrange=[0.,7.],xstyle=1,xtitle='distance (mas)',ytitle='Normalized Intensity',$
  title='Intensity as a function of radius at '+lambda_str+' Angstrom'
;OPLOT,ftyvector,norm_pmas_griddedData[index,*],PSYM=2
END
;--------------------------------------------------------------------------------------------------------------------------

PRO WRITE_I_MAS,ftxvector,ftyvector,norm_pmas_griddedData,lambda_val

t=size(ftyvector)
near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)

OPENW,6,'/home/groh/hd316_i_mas.txt'
FOR i=0.,t[1]-2. DO BEGIN
PRINTF,6,ftyvector[i],norm_pmas_griddedData[index,i]
ENDFOR
CLOSE,6
END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_VIS_SPATFREQ,ftxvector,ftxaxis,ftransfnorm,lambda_val

near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)
WINDOW,1,xsize=600,ysize=600,retain=2
PLOT,ftxaxis,ftransfnorm[index,*],xrange=[0,250.],xstyle=1,xtitle='spatial frequency (1/arcsec)',ytitle='Visibility',$
  title='Visibility x Sp Freq at '+lambda_str+' Angstrom'
OPLOT,ftxaxis,ftransfnorm[index,*],Psym=2
END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_VIS_BASELINE,ftxvector,ftxaxis,ftransfnorm,lambda_val,ftbaseline

near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)
WINDOW,3,xsize=600,ysize=600,retain=2
PLOT,ftbaseline,ftransfnorm[index,*],yrange=[0.,1],xrange=[0,150],xstyle=1,xtitle='Baseline (m)',ytitle='Visibility',$
  title='Visibility x Baseline at '+lambda_str+' Angstrom'
OPLOT,ftbaseline,ftransfnorm[index,*],Psym=2
END
;--------------------------------------------------------------------------------------------------------------------------

PRO WRITE_VIS_BASELINE,ftxvector,ftxaxis,ftransfnorm,lambda_val

t=size(ftxaxis)
near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)
ftbaseline=ftxaxis*206265.*lambda_val*1e-10

OPENW,5,'/home/groh/hd316_vis_base.txt'
FOR I=0,t[1]-2 DO BEGIN
PRINTF,5,ftbaseline[i],ftransfnorm[index,i]
ENDFOR
CLOSE,5
END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_VIS_LAMBDA,ftxvector,ftxaxis,ftransfnorm,baseline_val

lambda_val=21660.
ftbaseline=ftxaxis*206265.*lambda_val*1e-10
near = Min(Abs(ftbaseline - baseline_val), index)
;convert baseline float to a string
baseline_str=STRTRIM(STRING(baseline_val),1)
baseline_str=STRMID(baseline_str,0,16)

;convolve visibility to a given resolution in A?
res=12000.   ;resolving power
resang=lambda_val/res ;resolution in angstroms
ZE_SPEC_CNVL,ftxvector,ftransfnorm[*,index],resang,lambda_val,fluxcnvl=viscnvl

WINDOW,4,xsize=600,ysize=600,retain=2

;PLOT,ftxvector,ftransfnorm[*,index],xstyle=1,xtitle='Wavelength (A)',ytitle='Visibility',$
; title='Visibility x Wavelength for baseline='+baseline_str+'m',XTICKFORMAT='(F7.1)',YRANGE=[0,1]
PLOT,ftxvector,viscnvl,xstyle=1,xtitle='Wavelength (A)',ytitle='Visibility',$
  title='Visibility x Wavelength for baseline='+baseline_str+'m',XTICKFORMAT='(F7.1)',YRANGE=[0,1]

;plot to PS file
keywords = PSConfig(_Extra=PSWindow())
keywords.ysize=10.
keywords.bits_per_pixel=8.
keywords.xsize=keywords.ysize
keywords.ENCAPSULATED=1
keywords.filename='/Users/jgroh/temp/amber_agcar_hei206_vislambda_HRK.eps'

set_plot,'ps'
   DEVICE, _EXTRA=keywords
PLOT,ftxvector,viscnvl,xstyle=1,xtitle='Wavelength (A)',ytitle='Visibility',$
  title='Visibility x Wavelength for baseline='+baseline_str+'m',XTICKFORMAT='(F7.1)',YRANGE=[0,1]
device,/close_file
set_plot,'x'

END
;--------------------------------------------------------------------------------------------------------------------------

PRO WRITE_VIS_LAMBDA,ftxvector,ftxaxis,ftransfnorm,baseline_val

t=size(ftxvector)
lambda_val=20580.
ftbaseline=ftxaxis*206265.*lambda_val*1e-10
near = Min(Abs(ftbaseline - baseline_val), index)
;convert baseline float to a string
baseline_str=STRTRIM(STRING(baseline_val),1)
baseline_str=STRMID(baseline_str,0,16)
ftbaseline=ftxaxis*206265.*lambda_val*1e-10

OPENW,4,'/home/groh/hd316_vis_lambda.txt'
FOR I=0,t[1]-2 DO BEGIN
PRINTF,4,ftxvector[i],ftransfnorm[i,index]
ENDFOR
CLOSE,4

END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_IMAGE_I_P_NORM_LAMBDA_MAS,norm_pmas_griddedData,ftxvector,ftyvector

img=bytscl(norm_pmas_griddedData,MAX=max(norm_pmas_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img
;plotting in window
window,0,xsize=900,ysize=900,retain=2
plot, ftxvector, ftyvector/2., XTICKFORMAT='(F7.1)', xrange=[min(ftxvector),max(ftxvector)], $
yrange=[min(ftyvector),max(ftyvector/2.)],xstyle=1,ystyle=1, xtitle='lambda (Angstrom)', $
ytitle='distance  (mas)', /NODATA, Position=[0.07, 0.08, 0.85, 0.95],ycharsize=2,xcharsize=2
colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black
LOADCT, 22
tvimage,imginv, /Overplot
;linear colorbar
denconbetatrunc = [0.00, max(norm_pmas_griddedData)*.2, max(norm_pmas_griddedData)*.4, max(norm_pmas_griddedData)*.6, max(norm_pmas_griddedData)*.8,$
max(norm_pmas_griddedData)]
;logarithimic colorbar
;norm_pmas_griddedData=alog10(norm_pmas_griddedData)
;denconbetatrunc = [0.00, max(loggriddedData)*.2, max(loggriddedData)*.4, max(loggriddedData)*.6, max(loggriddedData)*.8,max(loggriddedData)]
colorbar, COLOR=colors.red,TICKNAMES=denconbetatrunc, FORMAT='(F7.1)', DIVISIONS=5, /VERTICAL, /RIGHT,$
POSITION=[0.86, 0.08, 0.88, 0.95]
LOADCT,0
AXIS,XAXIS=0,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,XTITLE='',XRANGE=[min(ftxvector),max(ftxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=0,ycharsize=2
;;colorbar, COLOR=0, YTickV=[0,28,85,142,199,255],Range=[0,255], $
;;      YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
;tvlaser,BARPOS='no',FILENAME='/home/groh/idl.ps',$
;  /NoPrint,XDIM=600,YDIM=600

END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_IMAGE_I_P_NORM_MAS_CIRCULAR,norm_pmas_griddedData,ftxvector,ftyvector,lambda_val,intens2d=intens2d

near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)

ys=size(ftyvector)
t=ys[1]

angles=120
phi=FINDGEN(angles)*(360./angles)
;creating matrix of size (2,ys[1]*angles) to store the pairs of (angles,NP) to further convert to x,y
polarcoord=dblarr(2,t*angles)
print,phi

;counters
l=0
r=1
m=0
s=1

for j=0., (t*angles-1) do begin ;running through all the lines of the matrix
  if j ge (t*r) then begin
    l=l+1
    r=r+1
  endif
  polarcoord(0,j)=phi[l]    ;positions polarcoord(0,*)=values of beta, working!!!
    
  polarcoord(1,j)=ftyvector[m]/2.         ;positions polarcoord(1,*)=values of r1, working!!!
  m=m+1
  if m gt (t-1) then begin
    m=0
  endif
endfor


;getting x,y coordinates, where 0,0 is center the center of the star.
rect_coord = CV_COORD(From_Polar=polarcoord, /To_Rect)
x=rect_coord(1,*)
y=rect_coord(0,*)

intens2d=DBLARR(t*angles)
l=0
m=1
FOR i=0., (t*angles)-1 DO BEGIN
  intens2d[i]=norm_pmas_griddedData[index,i-l]
  IF ((i+1)/m) ge t THEN BEGIN
        m=m+1
  l=i+1
  ENDIF
ENDFOR

TRIANGULATE, x, y, circtriangles, circboundaryPts,TOLERANCE=1E-11
circ_gridSpace = [0.01, 0.01] ; space in x and y directions [mas]
factor=0.2 ;factor to zoom OUT
circ_griddedData = TRIGRID(x, y, intens2d, circtriangles, circ_gridSpace,[MIN(x)*factor, MIN(y)*factor, MAX(x)*factor, MAX(y)*factor], XGrid=circxvector, YGrid=circyvector)


img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img
;plotting in window
window,10,xsize=900,ysize=900,retain=2
LOADCT,0
colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black
plot, circxvector, circyvector, ycharsize=2,xcharsize=2,XTICKFORMAT='(F7.1)', xrange=[min(circxvector),max(circxvector)], $
yrange=[min(circyvector),max(circyvector/1.)],xstyle=1,ystyle=1, xtitle='distance (mas)', $
ytitle='distance  (mas)', /NODATA, Position=[0.07, 0.08, 0.85, 0.95], $
title='Image at wavelength '+lambda_str+' Angstrom'
LOADCT, 13
tvimage,imginv, /Overplot
;linear colorbar
denconbetatrunc = [0.00, max(circ_griddedData)*.2, max(circ_griddedData)*.4, max(circ_griddedData)*.6, max(circ_griddedData)*.8,$
max(circ_griddedData)]
;logarithimic colorbar
;norm_pmas_griddedData=alog10(norm_pmas_griddedData)
;denconbetatrunc = [0.00, max(loggriddedData)*.2, max(loggriddedData)*.4, max(loggriddedData)*.6, max(loggriddedData)*.8,max(loggriddedData)]
colorbar, COLOR=colors.red,TICKNAMES=denconbetatrunc, FORMAT='(F7.1)', DIVISIONS=5, /VERTICAL, /RIGHT,$
POSITION=[0.86, 0.08, 0.88, 0.95]
LOADCT,0
;AXIS,XAXIS=0,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,XTITLE='',XRANGE=[min(circxvector),max(circxvector)],xcharsize=2
;AXIS,YAXIS=0,YSTYLE=1,COLOR=0,XRANGE=[min(circyvector),max(circyvector)],ycharsize=2

AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[-max(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),XRANGE=[-max(circyvector),max(circyvector)],ycharsize=2,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)],YTICKFORMAT='(A2)';ycharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),YRANGE=[-max(circyvector),max(circyvector)]

;AXIS,YAXIS=1,YSTYLE=1,COLOR=0,YRANGE=[min(circyvector),max(circyvector)],ycharsize=0
;AXIS,XAXIS=1,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,YRANGE=[min(circyvector),max(circyvector)]
;;colorbar, COLOR=0, YTickV=[0,28,85,142,199,255],Range=[0,255], $
;;      YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
;tvlaser,BARPOS='no',FILENAME='/home/groh/idl.ps',$
 ; /NoPrint,XDIM=900,YDIM=900
;draws grid lines through 0,0
PLOTS,[min(circxvector),max(circxvector)],[0,0],linestyle=1,color=fsc_color('white')
PLOTS,[0,0],[min(circyvector),max(circyvector)],linestyle=1,color=fsc_color('white')

END

;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_IMAGE_P2IP_LAMBDA_R_XWINDOW,ip,pgridip,freqgridip,NP,lambda,lstart,lend,rstar

C=299792000.

index=FINDEL(lstart,lambda)
index2=FINDEL(lend,lambda)
min=(NP)*(index-1)
max=(NP)*(index2+2)
nlambda=index2+3-index
RAND=max-min
help,index,index2,min,max,rand
;define axis x,y,z
ftza=dblarr(RAND)
ftxb=ftza
ftya=ftza

FOR i=0., RAND-1 DO BEGIN
ftza[i] = ip[i+min]*pgridip[i+min];/max(ip[i+min]);*pgridip[i+min];*pgridip[i+min] ; intensity as a function of (p, lambda)
ftxb[i] = C/freqgridip[i+min]*1E-05 ; lambda [in Angstroms]
ftya[i] = pgridip[i+min]/rstar ; in rstar
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
!P.Color = fsc_color('black')
window,8,xsize=1500,ysize=400,retain=2
LOADCT,0
plot, ftxvector, ftyvector/1., XTICKFORMAT='(F7.1)', xrange=[min(ftxvector),max(ftxvector)], $
yrange=[min(ftyvector),max(ftyvector/1.)],xstyle=1,ystyle=1, xtitle='lambda (Angstrom)', $
ytitle='distance  (r/rstar)', /NODATA, Position=[0.07, 0.08, 0.93, 0.95],ycharsize=2,xcharsize=2
LOADCT, 42
tvimage,imginv, /Overplot
;linear colorbar
denconbetatrunc = [0.00, max(p2ip_griddedData)*.2, max(p2ip_griddedData)*.4, max(p2ip_griddedData)*.6, max(p2ip_griddedData)*.8,$
max(p2ip_griddedData)]
;logarithimic colorbar
;norm_pmas_griddedData=alog10(norm_pmas_griddedData)
;denconbetatrunc = [0.00, max(loggriddedData)*.2, max(loggriddedData)*.4, max(loggriddedData)*.6, max(loggriddedData)*.8,max(loggriddedData)]
nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
;colorbar_ticknames_str = [number_formatter(0.00,decimals=nd), number_formatter(max(circ_griddedData)*.2,decimals=nd), number_formatter(max(circ_griddedData)*.4,decimals=nd),$
;number_formatter(max(circ_griddedData)*.6,decimals=nd), number_formatter(max(circ_griddedData)*.8,decimals=nd),number_formatter(max(circ_griddedData),decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,charsize=1.5,$
POSITION=[0.94, 0.08, 0.96, 0.95]

LOADCT,0
AXIS,XAXIS=0,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,XTITLE='lambda (Angstrom)',XRANGE=[min(ftxvector),max(ftxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=0,ycharsize=2,YTITLE='impact parameter [AU]'
;xyouts,830,870,TEXTOIDL('p^2 I(p)'),/DEVICE,color=fsc_color('black')
;xyouts,0.3,0.3,'test',/DEVICE,charsize=5
;;colorbar, COLOR=0, YTickV=[0,28,85,142,199,255],Range=[0,255], $
;;      YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
;tvlaser,BARPOS='no',FILENAME='/home/groh/idl.ps',$
;  /NoPrint,XDIM=600,YDIM=600

END

;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_IMAGE_P2IP_NORM_LAMBDA_R,ip,pgridip,freqgridip,C,min,max,RAND,rstar,lambda_lineprofile,lineprofile


;define axis x,y,z
ftza=dblarr(RAND)
ftxb=ftza
ftya=ftza

FOR i=0., RAND-1 DO BEGIN
ftza[i] = ip[i+min]*pgridip[i+min]; intensity as a function of (p, lambda)
ftxb[i] = C/freqgridip[i+min]*1E-05 ; lambda [in Angstroms]
ftya[i] = pgridip[i+min]/rstar ; in r/rstar

ENDFOR

mas_to_rad=1./(206265.*1000.)

; Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output
; variables.

TRIANGULATE, ftxb, ftya, fttriangles, ftboundaryPts

sp=0.005
;recommended values FOR ETACR :0.01,30 (greater than 30 and lower than 0.01 does not change anything FOR ETACAR, see xmgrace plot)
; Grid the Z data, using the triangles.The variables "xvector" and "yvector" are output variables. Set grid space by:
p2ip_gridSpace = [0.1, sp] ;first value means spacing in lambda (in angstrom), second value means spacing in p (in mas)
p2ip_griddedData = TRIGRID(ftxb, ftya, ftza, fttriangles, p2ip_gridSpace,[MIN(ftxb), 0, MAX(ftxb), 60], XGrid=ftxvector, YGrid=ftyvector)

s=size(ftxvector)
ys=size(ftyvector)

;norm_p2ip_griddedData=p2ip_griddedData/MAX(p2ip_griddedData)   ;normalized by the maximum value of p2Ip
;norm_p2ip_griddedData=p2ip_griddedData/0.001 
norm_p2ip_griddedData=p2ip_griddedData/(TOTAL(p2ip_griddedData[2,*])/100.) ;normalized by the total continuum flux! MUCH BETTER TO INTERPRET!

;print,TOTAL(p2ip_griddedData[2,*]*sp),lineprofile[2]
;normalize the p2Ip for each lambda if you want
;FOR i=0., s[1]-2 DO BEGIN
; norm_p2ip_griddedData[i,*]=p2ip_griddedData[i,*]/max(p2ip_griddedData[i,*])
;ENDFOR

norm_p2ip_griddedData=alog10(1.+norm_p2ip_griddedData)
img=bytscl(norm_p2ip_griddedData,MAX=max(norm_p2ip_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img
;plotting in window
set_plot,'x'

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
window,9,xsize=900,ysize=900,retain=0
LOADCT,0
plot, ftxvector, ftyvector, XTICKFORMAT='(F7.1)', xrange=[min(ftxvector),max(ftxvector)], $
yrange=[min(ftyvector),max(ftyvector)],xstyle=1,ystyle=1, xtitle='lambda (Angstrom)', $
ytitle='distance  (r/rstar)', /NODATA, Position=[0.07, 0.08, 0.85, 0.95],ycharsize=2,xcharsize=2
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 42
tvimage,imginv, /Overplot
;linear colorbar
denconbetatrunc = [0.00, max(norm_p2ip_griddedData)*.2, max(norm_p2ip_griddedData)*.4, max(norm_p2ip_griddedData)*.6, max(norm_p2ip_griddedData)*.8,$
max(norm_p2ip_griddedData)]
;logarithimic colorbar
;loggriddedData=alog10(p_pmas_griddedData)
;denconbetatrunc = [0.00, max(loggriddedData)*.2, max(loggriddedData)*.4, max(loggriddedData)*.6, max(loggriddedData)*.8,max(loggriddedData)]
colorbar, COLOR=fsc_color('black'),TICKNAMES=denconbetatrunc, FORMAT='(F5.3)', DIVISIONS=5, /VERTICAL, /RIGHT,$
POSITION=[0.86, 0.08, 0.88, 0.95]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=0,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,XTITLE='',XRANGE=[min(ftxvector),max(ftxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=0,ycharsize=2
;xyouts,830,870,TEXTOIDL('p I(p)'),/DEVICE,color=fsc_color('black')
;xyouts,0.3,0.3,'test',/DEVICE,charsize=5
;;colorbar, COLOR=0, YTickV=[0,28,85,142,199,255],Range=[0,255], $
;;      YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
;tvlaser,BARPOS='no',FILENAME='/home/groh/idl.ps',$
;  /NoPrint,XDIM=600,YDIM=600
If N_elements(lineprofile) GT 1 THEN oplot,lambda_lineprofile,3+lineprofile/lineprofile[0]
END
;--------------------------------------------------------------------------------------------------------------------------
PRO PLOT_IMAGE_P2IP_NORM_VEL_R,lambda_val,ip,pgridip,freqgridip,C,min,max,RAND,lambda_lineprofile,lineprofile,rstar

;define axis x,y,z
ftza=dblarr(RAND)
ftxb=ftza
ftya=ftza

FOR i=0., RAND-1 DO BEGIN
ftza[i] = ip[i+min]*pgridip[i+min]; intensity as a function of (p, lambda)
ftxb[i] = C/freqgridip[i+min]*1E-05 ; lambda [in Angstroms]
ftxb[i]= C/1000.*(ftxb[i]/lambda_val -1.)
ftya[i] = pgridip[i+min]/rstar ; in r/rstar

ENDFOR

mas_to_rad=1./(206265.*1000.)

; Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output
; variables.

TRIANGULATE, ftxb, ftya, fttriangles, ftboundaryPts

sp=0.005
;recommended values FOR ETACR :0.01,30 (greater than 30 and lower than 0.01 does not change anything FOR ETACAR, see xmgrace plot)
; Grid the Z data, using the triangles.The variables "xvector" and "yvector" are output variables. Set grid space by:
p2ip_gridSpace = [5, sp] ;first value means spacing in velocity (km/s), second value means spacing in p (in mas)
p2ip_griddedData = TRIGRID(ftxb, ftya, ftza, fttriangles, p2ip_gridSpace,[MIN(ftxb), 0., MAX(ftxb), 15.], XGrid=ftxvector, YGrid=ftyvector)

s=size(ftxvector)
ys=size(ftyvector)


;norm_p2ip_griddedData=p2ip_griddedData/MAX(p2ip_griddedData)   ;normalized by the maximum value of p2Ip
;norm_p2ip_griddedData=p2ip_griddedData/0.001 
norm_p2ip_griddedData=p2ip_griddedData/(TOTAL(p2ip_griddedData[2,*])/100.) ;normalized by the total continuum flux! MUCH BETTER TO INTERPRET!

;print,TOTAL(p2ip_griddedData[2,*]*sp),lineprofile[2]
;normalize the p2Ip for each lambda if you want
;FOR i=0., s[1]-2 DO BEGIN
; norm_p2ip_griddedData[i,*]=p2ip_griddedData[i,*]/max(p2ip_griddedData[i,*])
;ENDFOR

norm_p2ip_griddedData=alog10(1.+norm_p2ip_griddedData)
img=bytscl(norm_p2ip_griddedData,MAX=max(norm_p2ip_griddedData)); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
imginv=img
;plotting in window
window,19,xsize=900,ysize=900,retain=0
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, ftxvector, ftyvector, XTICKFORMAT='(F7.1)', xrange=[min(ftxvector),max(ftxvector)], $
yrange=[min(ftyvector),max(ftyvector)],xstyle=1,ystyle=1, xtitle='lambda (Angstrom)', $
ytitle='distance  (r/rstar)', /NODATA, Position=[0.07, 0.08, 0.85, 0.95],ycharsize=2,xcharsize=2
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 43
tvimage,imginv, /Overplot
;linear colorbar
denconbetatrunc = [0.00, max(norm_p2ip_griddedData)*.2, max(norm_p2ip_griddedData)*.4, max(norm_p2ip_griddedData)*.6, max(norm_p2ip_griddedData)*.8,$
max(norm_p2ip_griddedData)]
;logarithimic colorbar
;loggriddedData=alog10(p_pmas_griddedData)
;denconbetatrunc = [0.00, max(loggriddedData)*.2, max(loggriddedData)*.4, max(loggriddedData)*.6, max(loggriddedData)*.8,max(loggriddedData)]
colorbar, COLOR=fsc_color('black'),TICKNAMES=denconbetatrunc, FORMAT='(F5.3)', DIVISIONS=5, /VERTICAL, /RIGHT,$
POSITION=[0.86, 0.08, 0.88, 0.95]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=0,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,XTITLE='',XRANGE=[min(ftxvector),max(ftxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=0,ycharsize=2
xyouts,830,870,TEXTOIDL('p I(p)'),/DEVICE,color=fsc_color('black')
;xyouts,0.3,0.3,'test',/DEVICE,charsize=5
;;colorbar, COLOR=0, YTickV=[0,28,85,142,199,255],Range=[0,255], $
;;      YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
;tvlaser,BARPOS='no',FILENAME='/home/groh/idl.ps',$
;  /NoPrint,XDIM=600,YDIM=600
oplot,ZE_LAMBDA_TO_VEL(lambda_lineprofile,lambda_val),3+lineprofile/lineprofile[0]
END
;--------------------------------------------------------------------------------------------------------------------------


$MAIN CODE
;CONSTANTS
C=299792000.
;model-dependent values
;HD 316285 (MODEL 314 from rosella)
NP=72.
NCF=8050.
;AGCAR mod 271
;NP=72.
;NCF=3952.
;W9 model 5
;NP=72.
;NCF=6543.
;Eta Car john's model 97
;NP=75.
;NCF=63551.
;Eta Car john's model 111
NP=75.
NCF=63645.
;Eta Car groh model 43 halpha
NP=75.
NCF=2569.

;cont
NCF=1415

;W243 mod 5
;NP=72.
;NCF=6806.
;ggcar model 4 midi
;NP=72.
;NCF=13654.
;ggcar model 2 Kband
;NP=72.
;NCF=2561.
;Zeta Pup model M4_jdh_lyrebird
;NP=75.
;NCF=8166.
;HD45166 106_copy_mod8 2D
;NP=55.
;NCF=771.
; AG Car var_191regrid223_mdot8_222/ipdata_h4101
;NP=72.
;NCF=2226.
; AG Car 285 MIDI
;NP=72.
;NCF=10087.
; AG Car 280 MIDI
;NP=72.
;NCF=13218.
; AG Car 389 Hbeta
;NP=72.
;NCF=2229.
; AG Car 373
;NP=72.
;NCF=246644.
;NCF=120644.
; AG Car 421
;NP=70.
;NCF=235914.
;HD152408 2
;NP=60.
;NCF=4580.


; AG Car 2D 369 g
;NP=76.
;NCF=510.

;AGCAR 2D 389 a
;NP=76.
;NCF=614.


IPDYM=NP*NCF
RECL=NP*2.+2.
;size of IPDATA array is ((NP+1)*NCF)+RECL*2+(NP+1)
arrsize=((NP+1)*NCF)+RECL*2+(NP+1)
;filename_ipdata_bin='/home/groh/ze_models/ztpup/M4_jdh_lyrebird/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/ggcar/4/IP_DATA_midi'
;filename_ipdata_bin='/home/groh/ze_models/ggcar/2/IP_DATA'
;filename_ipdata_bin='//aux/pc20072a/jgroh/jgroh/ze_models/HD316285/314_rosella/IP_DATA'
;filename_ipdata_bin='/Users/jgroh/ze_models/agcar/421/obs2d/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/etacar_john/mod_97/obs/IP_DATA'
;filename_ipdata_bin='/home/groh/IP_DATA'
;filename_ipdata_bin='/home/groh/ipdata_fin_w9_5'
;filename_ipdata_bin='/home/groh/ze_models/2D_models/takion/hd45166/106_copy/8/IP_DATA_hd45_106copy_2D_8_0_58'
filename_ipdata_txt='/Users/jgroh/temp/teste_rtau.txt'
;filename_ipdata_bin='/home/groh/ipdata_fin_w243_5'
;filename_ipdata_bin='/Users/jgroh/ze_models/etacar_john/mod_111/obs/IP_DATA'
;filename_ipdata_bin='/Users/jgroh/ze_models/etacar/mod43_groh/obs/IP_DATA'
filename_ipdata_bin='/Users/jgroh/ze_models/etacar/mod43_groh/obs_compute_rtau_cont/RTAU_DATA'
;filename_ipdata_bin='/Users/jgroh/ze_models/hd152408/2/obs2d/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/agcar/var_191regrid223_mdot8_222/ipdata_h4101/IP_DATA'
;filename_ipdata_bin='/aux/pc244a/jgroh/ze_models/agcar/285/obs2/IP_DATA_285_8to13micron'
;filename_ipdata_bin='/aux/pc244a/jgroh/ze_models/agcar/200/obs_to_midi/IP_DATA_agc_200_8to13micron'
;filename_ipdata_bin='/aux/pc244a/jgroh/ze_models/etacar_john/mod_111/obs/IP_DATA'
;filename_ipdata_bin='/aux/pc20117a/jgroh/cmfgen_models/agcar/389/obshbetaip/IP_DATA'
;filename_ipdata_bin='/aux/pc20117a/jgroh/cmfgen_models/agcar/373/obs2d/IP_DATA'
;filename_ipdata_bin='/aux/pc20117a/jgroh/cmfgen_models/2D_models/agcar/389/a/IP_DATA'

ipdata_txt=READ_IPDATA_BIN(filename_ipdata_bin,arrsize)
WRITE_IPDATA_TXT,ipdata_txt,filename_ipdata_txt
READ_IP_P_FREQ_TXT,ipdata_txt,NP,NCF,RECL,p=p,freq=freq,ip=ip,lambda=lambda
;p[36]=p[35]+0.1
CREATE_P_FREQ_GRID,p,freq,NP,IPDYM,pgridip=pgridip,freqgridip=freqgridip

;colors = GetColor(/Load)
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

;now we can just select lambda start and end
lstart=200.
lend=1000.
lstart=800.
lend=2000.
lstart=6500.
lend=6700.
lstart=700.
lend=12000.
;lstart=2000.
;lend=3300.
;lstart=3300.
;lend=5800.
;lstart=5800.
;lend=9000.
;lstart=9000.
;lend=22750.
;lstart=20520.
;lend=20630.

index=FINDEL(lstart,lambda)
index2=FINDEL(lend,lambda)
min=(NP)*(index-1)
max=(NP)*(index2+2)
nlambda=index2+3-index
RAND=max-min
dist=2.3 ;distance in [kpc]

;FOR i=0., RAND-1 DO BEGIN
;ftz[i] = ip[i+min] ; intensity as a function of (p, lambda)
;lambdagridip[i] = C/freqgridip[i+min]*1E-05 ; lambda [in Angstroms]
;pmasgridip[i] = pgridip[i+min]/(6.96*214.08*dist) ; diameter [in mas]. NOTE: if computing visibilities, we have to use the diameter, thus y=D !!
;ENDFOR


pmas=p/(6.96*214.08*dist)
;;using a uniform disc (working, but with problems when interpolating ip in the p axis axis
;m=0.
;l=0.
;thre=36.

;
;print,'UD diameter is:'
;print, 2*pmas[thre]
;FOR i=min, max-1 DO BEGIN
;
; FOR m=0, NP-1 DO BEGIN
;   
;   IF m lt (thre) THEN BEGIN
;   ip[i+m+((NP-1)*l)]=1.0
;   
;   ENDIF ELSE BEGIN
;   ip[i+m+((NP-1)*l)]=0.0
;   
;   ENDELSE
; ENDFOR
;m=0.
;l=l+1.
;ENDFOR

lambda_val=21661.2 ;lambda in angstroms for plots of I x radius and Visibility x spatial freq and Visibility x baseline
;COMPUTE_LINE_PROFILE,pgridip,freqgridip,ip,dist,C,min,RAND,lambda_val,lineprofile=lineprofile,lambda_lineprofile=lambda_lineprofile
;COMPUTE_FOURIER_TRANSFORM,dist,pgridip,freqgridip,ip,C,min,RAND,norm_pmas_griddedData=norm_pmas_griddedData,pmas_griddedData=pmas_griddedData,$
;   ftransform=ftransform,ftransfnorm=ftransfnorm,ftxaxis=ftxaxis,ftxvector=ftxvector,ftyvector=ftyvector,ftya=ftya,ftxb=ftxb,ftza=ftza,ftbaseline=ftbaseline

rstar=465.
;rstar=695.
;rstar=713.
baseline_val=28.44     ;baseline in meters for plots of Visibility x wavelength
;PLOT_VIS_SPATFREQ,ftxvector,ftxaxis,ftransfnorm,lambda_val
;PLOT_I_MAS,ftxvector,ftyvector,norm_pmas_griddedData,lambda_val
;PLOT_VIS_BASELINE,ftxvector,ftxaxis,ftransfnorm,lambda_val,ftbaseline
;PLOT_VIS_LAMBDA,ftxvector,ftxaxis,ftransfnorm,baseline_val
;WRITE_I_MAS,ftxvector,ftyvector,norm_pmas_griddedData,lambda_val
;WRITE_VIS_LAMBDA,ftxvector,ftxaxis,ftransfnorm,baseline_val
;WRITE_VIS_BASELINE,ftxvector,ftxaxis,ftransfnorm,lambda_val
;PLOT_IMAGE_I_P_NORM_LAMBDA_MAS,norm_pmas_griddedData,ftxvector,ftyvector
;PLOT_IMAGE_I_P_NORM_MAS_CIRCULAR,norm_pmas_griddedData,ftxvector,ftyvector,lambda_val,intens2d=intens2d
;PLOT_IMAGE_P2IP_LAMBDA_R_XWINDOW,ip,pgridip,freqgridip,NP,lambda,lstart,lend,rstar
;ZE_PLOT_IMAGE_P2IP_LAMBDA_R_EPS,ip,pgridip,freqgridip,NP,lambda,lstart,lend,rstar
ZE_PLOT_IMAGE_RTAU_LAMBDA_P_EPS,ip,pgridip,freqgridip,NP,lambda,lstart,lend,rstar,rtau_griddedData,lambda_rtau,p_rtau
;PLOT_IMAGE_P2IP_NORM_LAMBDA_R,ip,pgridip,freqgridip,C,min,max,RAND,rstar;,lambda_lineprofile,lineprofile
;PLOT_IMAGE_P2IP_NORM_VEL_R,lambda_val,ip,pgridip,freqgridip,C,min,max,RAND,lambda_lineprofile,lineprofile,rstar

LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black') 
  ;line_norm,lambda_lineprofile,lineprofile,lineprofilen
END
