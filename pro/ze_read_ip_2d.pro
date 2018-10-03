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

PRO CREATE_P_FREQ_GRID,p,freq,hqw_at_rmax,NP,IPDYM,pgridip=pgridip,freqgridip=freqgridip,hqw_at_rmax_gridip=hqw_at_rmax_gridip
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

hqw_at_rmax_gridip=dblarr(IPDYM)
r=0.
for i=0., IPDYM-1. do begin

	hqw_at_rmax_gridip[i]=hqw_at_rmax[r]
	r=r+1.
	if (r eq NP) then begin
        r=0.
	endif

endfor
END
;--------------------------------------------------------------------------------------------------------------------------

PRO COMPUTE_LINE_PROFILE,pgridip,freqgridip,ip,HQW_AT_RMAX_gridip,dist,C,min,RAND,lineprofile=lineprofile,lambda_lineprofile=lambda_lineprofile
;Compute line profile by summing p.I(p) over p, for each lambda; this does not work, because
;it is an integral, and I have a very discrete p grid spacing. Has to be done in a finer p grid,
;using the griddedData. Now it is working! If using log p that has to be modified.

;define axis x,y,z
lineprofz=dblarr(RAND)
lineprofx=lineprofz
lineprofy=lineprofz

FOR i=0., RAND-1 DO BEGIN
;lineprofz[i] = ip[i+min]*pgridip[i+min]; p . I(p), OK !
lineprofz[i] = ip[i+min]*pgridip[i+min]*HQW_AT_RMAX_gridip[i+min] ; p . I(p),
lineprofx[i] = C/freqgridip[i+min]*1E-05 ;lambda [in angstroms]
;lineprofy[i] = pgridip[i+min]/6.96 ; impact parameter p [in Rsun]
lineprofy[i] = pgridip[i+min]/(6.96*214.08*dist) ;impact parameter p [in mas]
ENDFOR

;Create the set of Delaunay triangles for further regular gridding of the data. The variables "triangles" and "boundaryPts" are output 
;variables.

TRIANGULATE, lineprofx, lineprofy, lineproftriangles, lineprofboundaryPts

;gridSpace_Rsun=(lineprofy[1]-lineprofy[0])/20.
gridSpace_Rsun=0.001 ;gridspace in mas
; Grid the Z data, using the triangles.The variables "lambda_lineprofile" and "ip_lineprofile_rsun" are output variables. Set grid space by:
lineprofgridSpace = [0.04, gridSpace_Rsun] ;first value means spacing in lambda, second value means spacing in p in Rsun
lineprofgriddedData = TRIGRID(lineprofx, lineprofy, lineprofz, lineproftriangles, lineprofgridSpace, $
[MIN(lineprofx), MIN(lineprofy), MAX(lineprofx), 10], XGrid=lambda_lineprofile, YGrid=ip_lineprofile_rsun)
lambdasize=size(lambda_lineprofile)
lineprofile=lambda_lineprofile
for i=0., lambdasize[1]-1 do begin
        lineprofile[i]=TOTAL(lineprofgriddedData[i,*]) ;IF USING LINEAR P !!!!!!!!!!!	
endfor
t=size(lineprofgriddedData)
print,t
SET_PLOT,'X'
WINDOW,6,xsize=600,ysize=600,retain=2
plot, lambda_lineprofile, lineprofile/lineprofile[1], XTICKFORMAT='(F7.1)', xrange=[min(lambda_lineprofile),max(lambda_lineprofile)], $
yrange=[min(lineprofile),max(lineprofile/lineprofile[1])],xstyle=1, xtitle='lambda (Angstrom)', $
ytitle='Flux (arbitrary units)',title='Flux x wavelength'

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
; AG Car 395 Hbeta
NP=72.
NCF=2226.
; AG Car 373
;NP=72.
;NCF=246644.
;NCF=120644.
; AG Car 2D 369 g
NP=76.
NCF=510.

IPDYM=NP*NCF
RECL=NP*2.+2.
;size of IPDATA array is ((NP+1)*NCF)+RECL*2+(NP+1)
arrsize=((NP+1)*NCF)+RECL*2+(NP+1)
;filename_ipdata_bin='/home/groh/ze_models/ztpup/M4_jdh_lyrebird/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/ggcar/4/IP_DATA_midi'
;filename_ipdata_bin='/home/groh/ze_models/ggcar/2/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/HD316285/314_rosella/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/etacar_john/mod_97/obs/IP_DATA'
;filename_ipdata_bin='/home/groh/IP_DATA'
;filename_ipdata_bin='/home/groh/ipdata_fin_w9_5'
;filename_ipdata_bin='/home/groh/ze_models/2D_models/takion/hd45166/106_copy/8/IP_DATA_hd45_106copy_2D_8_0_58'
filename_ipdata_txt='/aux/pc244a/jgroh/temp/teste_IP.txt'
;filename_ipdata_bin='/home/groh/ipdata_fin_w243_5'
;filename_ipdata_bin='/home/groh/ze_models/etacar_john/mod_111/obs/IP_DATA'
;filename_ipdata_bin='/home/groh/ze_models/agcar/var_191regrid223_mdot8_222/ipdata_h4101/IP_DATA'
;filename_ipdata_bin='/aux/pc244a/jgroh/ze_models/agcar/285/obs2/IP_DATA_285_8to13micron'
;filename_ipdata_bin='/aux/pc244a/jgroh/ze_models/agcar/200/obs_to_midi/IP_DATA_agc_200_8to13micron'
;filename_ipdata_bin='/aux/pc244a/jgroh/ze_models/etacar_john/mod_111/obs/IP_DATA'
;filename_ipdata_bin='/aux/pc20117a/jgroh/cmfgen_models/agcar/395/obshbetaip/IP_DATA'
;filename_ipdata_bin='/aux/pc20117a/jgroh/cmfgen_models/agcar/373/obs2d/IP_DATA'
filename_ipdata_bin='/aux/pc20117a/jgroh/cmfgen_models/2D_models/agcar/369/g/IP_DATA'

ipdata_txt=READ_IPDATA_BIN(filename_ipdata_bin,arrsize)
WRITE_IPDATA_TXT,ipdata_txt,filename_ipdata_txt
READ_IP_P_FREQ_TXT,ipdata_txt,NP,NCF,RECL,p=p,freq=freq,ip=ip,lambda=lambda
;p[36]=p[35]+0.1
CREATE_P_FREQ_GRID,p,freq,hqw_at_rmax,NP,IPDYM,pgridip=pgridip,freqgridip=freqgridip,hqw_at_rmax_gridip=hqw_at_rmax_gridip

colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black

;now we can just select lambda start and end
lstart=4678.
lend=4696.5
near = Min(Abs(lambda - lstart), index)
near2= Min(Abs(lambda - lend), index2)
min=(NP)*(index-1)
max=(NP)*(index2+2)
nlambda=index2+3-index
RAND=max-min
dist=6.0 ;distance in [kpc]

pmas=p/(6.96*214.08*dist)

NDELTA_CG=25.
NDELTA_FG=25.
DELTA1=DBLARR(NDELTA_CG)
DELTA2=DBLARR(NDELTA_FG)
DELTA2_WGHTS=DBLARR(NDELTA_FG)
MU=DBLARR(NP)
HQW_AT_RMAX=DBLARR(NP)
R(1)=9.758894E+06
; Determine Delta1 and Delta2 angles
;
FOR i=0,NDELTA_CG-1 DO BEGIN
	  DELTA1(i)=0.D0+(i-0.D0)*(2.D0*ACOS(-1.D0))/(NDELTA_CG-1.D0)
ENDFOR	
FOR i=0,NDELTA_FG-1 DO BEGIN
	  DELTA2(I)=0.D0+(I-0.D0)*(2.D0*ACOS(-1.D0))/(NDELTA_FG-1.D0)
ENDFOR

;
; Determine integration weights over delta2
;
	DELTA2_WGHTS(*)=0.D0
	FOR I=0,NDELTA_FG-2 DO BEGIN
	  T1=0.5D0*(DELTA2(I+1)-DELTA2(I))
	  DELTA2_WGHTS(I)=DELTA2_WGHTS(I)+T1
	  DELTA2_WGHTS(I+1)=DELTA2_WGHTS(I+1)+T1
	ENDFOR
	T1=0.D0
	FOR I=0,NDELTA_FG-1 DO BEGIN
	  T1=T1+DELTA2_WGHTS(I)
	ENDFOR


;
; By definition, p * dp equals R**2 * mu * dmu. Integration over mu is
; more stable, and is to be preferred. To get better accuracy with the
; integration, NORDULUND weights will be used (Changed 11-Dec-1986).
;
	T1=R(1)*R(1)
	FOR LS=0,NP-1 DO BEGIN
	  MU(LS)=SQRT(T1-P(LS)*P(LS))/R(1)
	ENDFOR
	ZE_HWEIGHT,MU,NP,HQW_AT_RMAX
COMPUTE_LINE_PROFILE,pgridip,freqgridip,ip,HQW_AT_RMAX_gridip,dist,C,min,RAND,lineprofile=lineprofile,lambda_lineprofile=lambda_lineprofile

END
