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
p=dblarr(NP-1)
freq=dblarr(NCF)
IPDYM=(NP-1)*NCF
ip=dblarr(IPDYM)

;create the p vector
for i=0., NP-2 do p[i]=data[i + (RECL*2) + 1]

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
	if (i eq m*(NP-1)) then begin
	t=t+3.
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

	if (r eq NP-1) then begin
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
	if (s eq NP-1.) then begin
        r=r+1.
	s=0.
	endif

endfor
END
;--------------------------------------------------------------------------------------------------------------------------

PRO COMPUTE_LINE_PROFILE,pgridip,freqgridip,ip,C,min,RAND,lineprofile=lineprofile,lambda_lineprofile=lambda_lineprofile
;Compute line profile by summing p.I(p) over p, for each lambda; this does not work, because
;it is an integral, and I have a very discrete p grid spacing. Has to be done in a finer p grid,
;using the griddedData. Now it is working! If using log p that has to be modified.

;define axis x,y,z
lineprofz=dblarr(RAND)
lineprofx=lineprofz
lineprofy=lineprofz

FOR i=0., RAND-1 DO BEGIN
lineprofz[i] = ip[i+min]*pgridip[i+min] ; p . I(p)
lineprofx[i] = C/freqgridip[i+min]*1E-05 ;lambda [in angstroms]
lineprofy[i] = pgridip[i+min]/6.96 ; impact parameter p [in Rsun]
ENDFOR

;Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output 
;variables.

TRIANGULATE, lineprofx, lineprofy, lineproftriangles, lineprofboundaryPts

; Grid the Z data, using the triangles.The variables "lambda_lineprofile" and "ip_lineprofile_rsun" are output variables. Set grid space by:
lineprofgridSpace = [0.4, 10.] ;first value means spacing in lambda, second value means spacing in p
lineprofgriddedData = TRIGRID(lineprofx, lineprofy, lineprofz, lineproftriangles, lineprofgridSpace, $
[MIN(lineprofx), MIN(lineprofy), MAX(lineprofx), MAX(lineprofy)], XGrid=lambda_lineprofile, YGrid=ip_lineprofile_rsun)
lambdasize=size(lambda_lineprofile)
lineprofile=lambda_lineprofile
for i=0., lambdasize[1]-1 do begin
        lineprofile[i]=TOTAL(lineprofgriddedData[i,*]) ;IF USING LINEAR P !!!!!!!!!!!	
endfor

WINDOW,6,xsize=600,ysize=600,retain=2
plot, lambda_lineprofile, lineprofile/lineprofile[0], XTICKFORMAT='(F7.1)', xrange=[min(lambda_lineprofile),max(lambda_lineprofile)], $
yrange=[min(lineprofile),max(lineprofile/lineprofile[0])],xstyle=1, xtitle='lambda (Angstrom)', $
ytitle='Flux (arbitrary units)',title='Flux x wavelength'

END
;--------------------------------------------------------------------------------------------------------------------------

PRO COMPUTE_FOURIER_TRANSFORM,pgridip,freqgridip,ip,C,min,RAND,norm_pmas_griddedData=norm_pmas_griddedData,pmas_griddedData=pmas_griddedData,$
				ftransform=ftransform,ftransfnorm=ftransfnorm,ftxaxis=ftxaxis,ftxvector=ftxvector,ftyvector=ftyvector

;Compute the fourier transform, i.e. visibility. First the data are interpolated in a regular grid.

;define axis x,y,z
ftz=dblarr(RAND)
ftx=ftz
fty=ftz

dist=2.3 ;distance in kpc


FOR i=0., RAND-1 DO BEGIN
ftz[i] = ip[i+min] ; intensity as a function of (p, lambda)
ftx[i] = C/freqgridip[i+min]*1E-05 ; lambda [in Angstroms]
fty[i] = 2.*pgridip[i+min]/(6.96*214.08*dist) ; diameter [in mas]. NOTE: if computing visibilities, we have to use the diameter, thus y=D !!
ENDFOR

; Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output
; variables.

TRIANGULATE, ftx, fty, fttriangles, ftboundaryPts

; Grid the Z data, using the triangles.The variables "xvector" and "yvector" are output variables. Set grid space by:
pmas_gridSpace = [0.7, 0.01] ;first value means spacing in lambda (in angstrom), second value means spacing in p (in mas)
pmas_griddedData = TRIGRID(ftx, fty, ftz, fttriangles, pmas_gridSpace,[MIN(ftx), 0., MAX(ftx), 100.], XGrid=ftxvector, YGrid=ftyvector)

s=size(ftxvector)
ys=size(ftyvector)

norm_pmas_griddedData=pmas_griddedData
ftransform=pmas_griddedData
fttemp=pmas_griddedData[1,*]
ftransfnorm=ftransform

FOR i=0., s[1]-1 DO BEGIN
          norm_pmas_griddedData[i,*]=pmas_griddedData[i,*]/max(pmas_griddedData[i,*])
	  fttemp=pmas_griddedData[i,*]
	  fttempcom=complex(fttemp)
          ftransform[i,*]=ABS(fft(fttempcom))
          ftransfnorm[i,*]=ftransform[i,*]/max(ftransform[i,*])
ENDFOR

ftxaxis=(FINDGEN(ys[1])/(ys[1]*0.00001)) ;0.00001=spacing in arcsec of the pmas_griddedData

END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_I_MAS,ftxvector,ftyvector,norm_pmas_griddedData,lambda_val

near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)
WINDOW,2,xsize=600,ysize=600,retain=2
plot,ftyvector/2.,norm_pmas_griddedData[index,*],xrange=[0.,3.],xstyle=1,xtitle='distance (mas)',ytitle='Normalized Intensity',$
	title='Intensity as a function of radius at '+lambda_str+' Angstrom'
OPLOT,ftyvector/2.,norm_pmas_griddedData[index,*],PSYM=2
END
;--------------------------------------------------------------------------------------------------------------------------

PRO WRITE_I_MAS,ftxvector,ftyvector,norm_pmas_griddedData,lambda_val

near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)

OPENW,6,'/home/groh/hd316_i_mas.txt'
FOR I=0,t[1]-2 DO BEGIN
PRINTF,6,ftbaseline[i],ftransfnorm[index,i]
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
PLOT,ftxaxis,ftransfnorm[index,*],xrange=[0,100.],xstyle=1,xtitle='spatial frequency (1/arcsec)',ytitle='Visibility',$
	title='Visibility x Sp Freq at '+lambda_str+' Angstrom'
OPLOT,ftxaxis,ftransfnorm[index,*],Psym=2
END
;--------------------------------------------------------------------------------------------------------------------------

PRO PLOT_VIS_BASELINE,ftxvector,ftxaxis,ftransfnorm,lambda_val,ftbaseline=ftbaseline

near = Min(Abs(ftxvector - lambda_val), index)
;convert lambda float to a string
lambda_str=STRTRIM(STRING(lambda_val),1)
lambda_str=STRMID(lambda_str,0,16)
ftbaseline=ftxaxis*206265.*lambda_val*1e-10
WINDOW,3,xsize=600,ysize=600,retain=2
PLOT,ftbaseline,ftransfnorm[index,*],xrange=[0,150],xstyle=1,xtitle='Baseline (m)',ytitle='Visibility',$
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

lambda_val=21740.
ftbaseline=ftxaxis*206265.*lambda_val*1e-10
near = Min(Abs(ftbaseline - baseline_val), index)
;convert baseline float to a string
baseline_str=STRTRIM(STRING(baseline_val),1)
baseline_str=STRMID(baseline_str,0,16)
ftbaseline=ftxaxis*206265.*lambda_val*1e-10
WINDOW,4,xsize=600,ysize=600,retain=2
PLOT,ftxvector,ftransfnorm[*,index],xstyle=1,xtitle='Wavelength (A)',ytitle='Visibility',$
	title='Visibility x Wavelength for baseline='+baseline_str+'m',XTICKFORMAT='(F7.1)',YRANGE=[0,1]


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

TRIANGULATE, x, y, circtriangles, circboundaryPts
circ_gridSpace = [0.01, 0.01] ; space in x and y directions [mas]
circ_griddedData = TRIGRID(x, y, intens2d, circtriangles, circ_gridSpace,[MIN(x), MIN(y), MAX(x), MAX(y)], XGrid=circxvector, YGrid=circyvector)


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
yrange=[min(circyvector),max(circyvector/2.)],xstyle=1,ystyle=1, xtitle='distance (mas)', $
ytitle='distance  (mas)', /NODATA, Position=[0.07, 0.08, 0.85, 0.95], $
title='Image at wavelength '+lambda_str+' Angstrom'
LOADCT, 22
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
AXIS,XAXIS=0,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,XTITLE='',XRANGE=[min(circxvector),max(circxvector)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=0,XRANGE=[min(circyvector),max(circyvector)],ycharsize=2
;AXIS,YAXIS=1,YSTYLE=1,COLOR=0,YRANGE=[min(circyvector),max(circyvector)],ycharsize=0
;AXIS,XAXIS=1,XTICKFORMAT='(F7.1)',XSTYLE=1,COLOR=0,YRANGE=[min(circyvector),max(circyvector)]
;;colorbar, COLOR=0, YTickV=[0,28,85,142,199,255],Range=[0,255], $
;;      YTickformat='colorbar_annotate', YMinor=0, DIVISIONS=5, /VERTICAL,$
;;      POSITION=[0.91, 0.08, 0.96, 0.95],/REVERSE
;tvlaser,BARPOS='no',FILENAME='/home/groh/idl.ps',$
 ; /NoPrint,XDIM=900,YDIM=900

END
;--------------------------------------------------------------------------------------------------------------------------



$MAIN CODE
;CONSTANTS
C=299792000.
;model-dependent values
;HD 316285 (MODEL 314 from rosella)
;NP=72.
;NCF=8050.
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
;W243 mod 5
;NP=72.
;NCF=6806.
;ggcar model 4 midi
;NP=72.
;NCF=13654.
;Zeta Pup model M4_jdh_lyrebird
;NP=75.
;NCF=8166.


RECL=NP*2.+2.
IPDYM=(NP-1)*NCF
;size of IPDATA array is ((NP+1)*NCF)+RECL*2+(NP+1)
arrsize=((NP+1)*NCF)+RECL*2+(NP+1)
;filename_ipdata_bin='/home/groh/ze_models/ztpup/M4_jdh_lyrebird/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/ggcar/4/IP_DATA_midi'
;filename_ipdata_bin='/home/groh/ze_models/HD316285/314_rosella/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/etacar_john/mod_97/obs/IP_DATA'
;filename_ipdata_bin='/home/groh/IP_DATA'
;filename_ipdata_bin='/home/groh/ipdata_fin_w9_5'
;filename_ipdata_bin='/home/groh/ze_models/2D_models/takion/hd45166/106_copy/8/IP_DATA_hd45_106copy_2D_8_0_58'
filename_ipdata_txt='/home/groh/teste_IP.txt'
;filename_ipdata_bin='/home/groh/ipdata_fin_w243_5'
filename_ipdata_bin='/home/groh/ze_models/etacar_john/mod_111/obs/IP_DATA'
;
;ipdata_txt=READ_IPDATA_BIN(filename_ipdata_bin,arrsize)
;WRITE_IPDATA_TXT,ipdata_txt,filename_ipdata_txt
READ_IP_P_FREQ_TXT,ipdata_txt,NP,NCF,RECL,p=p,freq=freq,ip=ip,lambda=lambda
;p[36]=p[35]+0.001
CREATE_P_FREQ_GRID,p,freq,NP,IPDYM,pgridip=pgridip,freqgridip=freqgridip

colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black

;now we can just select lambda start and end
lstart=21738.
lend=21746.
near = Min(Abs(lambda - lstart), index)
near2= Min(Abs(lambda - lend), index2)
min=(NP-1)*(index-1)
max=(NP-1)*(index2+2)
nlambda=index2+3-index
RAND=max-min
dist=2.3 ;distance in [kpc]

pmas=p/(6.96*214.08*dist)
;;using a uniform disc
;m=0.
;l=0.
;thre=35.
;
;print,'UD diameter is:'
;print, 2*pmas[thre]
;FOR i=min, max-1 DO BEGIN
;
;	WHILE m lt NP DO BEGIN
;		
;		IF m lt (thre*l) THEN BEGIN
;		ip[i+m+((NP-1)*l)]=1.0
;		m=m+1
;		ENDIF ELSE BEGIN
;		ip[i+m+((NP-1)*l)]=0.0
;		m=m+1
;		ENDELSE
;	ENDWHILE
;m=0.
;l=l+1.
;ENDFOR


;COMPUTE_LINE_PROFILE,pgridip,freqgridip,ip,C,min,RAND,lineprofile=lineprofile,lambda_lineprofile=lambda_lineprofile
COMPUTE_FOURIER_TRANSFORM,pgridip,freqgridip,ip,C,min,RAND,norm_pmas_griddedData=norm_pmas_griddedData,pmas_griddedData=pmas_griddedData,$
	  ftransform=ftransform,ftransfnorm=ftransfnorm,ftxaxis=ftxaxis,ftxvector=ftxvector,ftyvector=ftyvector

lambda_val=21740.0 ;lambda in angstroms for plots of I x radius and Visibility x spatial freq and Visibility x baseline
baseline_val=76.     ;baseline in meters for plots of Visibility x wavelength
PLOT_VIS_SPATFREQ,ftxvector,ftxaxis,ftransfnorm,lambda_val
PLOT_I_MAS,ftxvector,ftyvector,norm_pmas_griddedData,lambda_val
PLOT_VIS_BASELINE,ftxvector,ftxaxis,ftransfnorm,lambda_val,ftbaseline=ftbaseline
PLOT_VIS_LAMBDA,ftxvector,ftxaxis,ftransfnorm,baseline_val
;WRITE_VIS_LAMBDA,ftxvector,ftxaxis,ftransfnorm,baseline_val
;WRITE_VIS_BASELINE,ftxvector,ftxaxis,ftransfnorm,lambda_val
;PLOT_IMAGE_I_P_NORM_LAMBDA_MAS,norm_pmas_griddedData,ftxvector,ftyvector
;PLOT_IMAGE_I_P_NORM_MAS_CIRCULAR,norm_pmas_griddedData,ftxvector,ftyvector,lambda_val,intens2d=intens2d

END
