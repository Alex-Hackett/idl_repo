FUNCTION PROFIL,DL,DLo,FWHM,dim,phase
PROF=dim*1./SQRT(2.*!PI*FWHM^2./(4.*ALOG(2.)))*EXP(-4.*ALOG(2.)*(DL-DLo)^2./(FWHM^2.))
PROF=0.5*phase*PROF/MAX(PROF)
RETURN,PROF
END

PRO FILM_DATA

set_plot,'x'
device,retain=2
velocityM=-250. ; ATTENTION verifier la compatibilite avec lambda1 & lambda2
velocityP=250.
RES_lambda=0.05 ; in A
RES_phase=0.02 
;REF=1.0 ; 987922
Nbx=(-velocityM+velocityP)/RES_lambda+1
SpSig=DBLARR(Nbx,10,6)
SpMoy=DBLARR(Nbx,10,6)
VarMoy=DBLARR(Nbx,10,6)
print,'nbx',nbx
;------------------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------ETOILES
;------------------------------------------------------------------------------------------------------------------------------------------------

HD=STRARR(10)
REFmax=DBLARR(10)
REFmin=DBLARR(10)
P_stars=DBLARR(10)
Vgamma=DBLARR(10)
Band=STRARR(6)
lambda1=DBLARR(6)
lambda2=DBLARR(6)
lambdaRAIE=DBLARR(6)
MAXplot=DBLARR(6)
MINplot=DBLARR(6)
MAXplot(*)=-100000.0
MINplot(*)=100000.0
DiffFWHM=DBLARR(10,6)
eDiffFWHM=DBLARR(10,6)
eDiffFWHM(*,*)=0.01


Profondeur=DBLARR(150,10,6)
VRm=DBLARR(150,10,6)
AsyFWHM=DBLARR(150,10,6)
FWHM=DBLARR(150,10,6)
maxflux=DBLARR(150,10,6)
eProfondeur=DBLARR(150,10,6)
eVRm=DBLARR(150,10,6)
eAsyFWHM=DBLARR(150,10,6)
eFWHM=DBLARR(150,10,6)
eProfondeur(*,*,*)=0.01
eVRm(*,*,*)=0.01
eAsyFWHM(*,*,*)=0.01
eFWHM(*,*,*)=0.01
NBnom=DBLARR(10)

REFmax(0)=1.0 ;      R TrA
REFmax(1)=1.0 ;     SCru
REFmax(2)=1.0 ;    Y Sgr
REFmax(3)=1.0 ;    X Sgr
REFmax(4)=1.0 ;   BD
REFmax(5)=1.0 ;   ZG
REFmax(6)=1.0 ;   YO
REFmax(7)=1.2 ;   RZV
REFmax(8)=1.2  ; l Car
REFmax(9)=1.2 ;  RSP

REFmin(0)=0.1 ;      R TrA
REFmin(1)=0.1 ;     SCru
REFmin(2)=0.1 ;    Y Sgr
REFmin(3)=0.1 ;    X Sgr
REFmin(4)=0.2 ;   BD
REFmin(5)=0.2 ;   ZG
REFmin(6)=0.1 ;   YO
REFmin(7)=0.2 ;   RZV
REFmin(8)=0.2  ; l Car
REFmin(9)=0.2 ;  RSP


HD(0)="hd135592" ;      R TrA
HD(1)="hd112044" ;     SCru
HD(2)="hd168608" ;    Y Sgr
HD(3)="hd161592" ;    X Sgr
HD(4)="hd037350" ;   BD
HD(5)="hd052973" ;   ZG
HD(6)="hd162714" ;   YO
HD(7)="hd073502" ;   RZV
HD(8)="hd084810"  ; l Car
HD(9)="hd068860" ;  RSP


;Band(0)="npv_film.dat"  ; ATTENTION ARNAQUE
Band(0)="npu_film.dat"  ; 
; Band(1)="npv_film.dat"  ; ATTENTION ARNAQUE
Band(1)="npu_film.dat"  ; 
Band(2)="npv_film.dat"
Band(3)="nph_film.dat"
;Band(3)="npx_film.dat"
Band(4)="npu_film.dat"
Band(5)="npw_film.dat"

P_stars(0)=3.38925  ;RT
P_stars(1)=4.68976  ;SC
P_stars(2)=5.77338  ;YS
P_stars(3)=7.01281 ;    X Sgr
P_stars(4)=9.84262   ;BD
P_stars(5)=10.14960   ;ZG
P_stars(6)=17.12520  ;   YO
P_stars(7)=20.40020  ;RZV
P_stars(8)=35.551341 ;LC
P_stars(9)=41.51500   ;RSP

Vgamma(0)=-13.2   ;RT
Vgamma(1)=-7.1     ;SC
Vgamma(2)=-2.5    ;YS
Vgamma(3)=-13.7   ;X Sgr
Vgamma(4)=7.4     ;BD
Vgamma(5)=6.9     ;ZG
Vgamma(6)=-6.6    ;YO
Vgamma(7)=24.1   ;RZV
Vgamma(8)=3.6   ;LC
Vgamma(9)=22.1  ;RSP

lambda1(0)=4090.
lambda1(1)=4340.
lambda1(2)=4850.
lambda1(3)=6545.
;lambda1(3)=6020.
lambda1(4)=3905.
lambda1(5)=5885.

lambda2(0)=4102.
lambda2(1)=4350.
lambda2(2)=4900.
lambda2(3)=6595.
;lambda2(3)=6030.
lambda2(4)=3995.
lambda2(5)=5895.

lambdaRAIE(0)=4101.734   ;Hdelta (U)
lambdaRAIE(1)=4340.513   ;Hgamma (U)
lambdaRAIE(2)=4861.323   ;Hbeta (V) 
lambdaRAIE(3)=6562.797   ;Halpha (Y)
;lambdaRAIE(3)=6024.058
lambdaRAIE(4)=3933.663   ;CaII h&k (U)
lambdaRAIE(5)=5889.5   ;NaI doublet (W)

; lambda1(0)=4100.5
; lambda1(1)=4339.9
; lambda1(2)=4860.75
; lambda1(3)=6330.0
; 
; lambda2(0)=4102.5
; lambda2(1)=4341.0
; lambda2(2)=4863.0
; lambda2(3)=6345.0
; 
; lambdaRAIE(0)=4101.734   ;Hdelta U
; lambdaRAIE(1)=4340.513   ;Hgamma U
; lambdaRAIE(2)=4861.323   ;Hbeta V 
; lambdaRAIE(3)=6336.824   ;Halpha Y

cl=299792.458  ;km.s-1
fac=0.

;Load colors. Use GETCOLOR from Coyote Library.
colors = GetColor(/Load)
!P.Background = colors.white
!P.Color = colors.black
LOADCT, 4

FOR star=0, 9 DO BEGIN       
READCOL,STRCOMPRESS('../../'+HD(star)+'/'+Band(3)), F='A,D',nom,phase  ;<------------------------------------------------
PRINT,'lecture fichier:',STRCOMPRESS('../../'+HD(star)+'/data/'+nom(0)+'.dat')
Nb=N_ELEMENTS(nom)
NBnom(star)=Nb
PRINT,star,Nb
ENDFOR

phase0=DBLARR(NBnom(0)+NBnom(0)+1)
phase1=DBLARR(NBnom(1)+NBnom(1)+1)
phase2=DBLARR(NBnom(2)+NBnom(2)+1)
phase3=DBLARR(NBnom(3)+NBnom(3)+1)
phase4=DBLARR(NBnom(4)+NBnom(4)+1)
phase5=DBLARR(NBnom(5)+NBnom(5)+1)
phase6=DBLARR(NBnom(6)+NBnom(6)+1)
phase7=DBLARR(NBnom(7)+NBnom(7)+1)
phase8=DBLARR(NBnom(8)+NBnom(8)+1)
phase9=DBLARR(NBnom(9)+NBnom(9)+1)

OPENW,1,"Long_period_line_depth.dat",WIDTH=2000.
FOR star=0, 9 DO BEGIN       
FOR raie=2,3 DO BEGIN                        ;<------------------------------------------------

;-------------LECTURE DE LA LISTE DE FICHIER
READCOL,STRCOMPRESS('../../'+HD(star)+'/'+Band(raie)), F='A,D',nom,phase           ;<------------------------------------------------
PRINT,'lecture fichier:',STRCOMPRESS('../../'+HD(star)+'/data/'+nom(4)+'.dat')

;-------------POUR SAVOIR LE PREMIER LAMBDA 
READCOL,STRCOMPRESS('../../'+HD(star)+'/data/'+nom(0)+'.dat'), lambda,flux,NUMLINE=10
lambdaN0=lambda(0)


;PRINT,'lecture fichier:',STRCOMPRESS('../../'+HD(star)+'/data/'+nom(0)+'.dat')
;PRINT,'Nombre de ligne SKIPLINE:',LONG((lambda1-lambdaN0)*100)
;PRINT,'Nombre de ligne NUMLINE:',LONG((lambda2-lambda1)*100)

;-------------RECUPERATION DES LAMBDAS POUR UNE ETOILE DONNEE
READCOL,STRCOMPRESS('../../'+HD(star)+'/data/'+nom(0)+'.dat'),F='A,D', lambda,flux,SKIPLINE=LONG((lambda1(raie)-lambdaN0)*100),NUMLINE=LONG((lambda2(raie)-lambda1(raie))*100),/SILENT

Nb=N_ELEMENTS(nom)
Nb2=N_ELEMENTS(lambda)

X=DBLARR((Nb+Nb+1)*Nb2)
Y=DBLARR((Nb+Nb+1)*Nb2)
Z=DBLARR((Nb+Nb+1)*Nb2)

FOR i=0,Nb-1+Nb+1 DO BEGIN
IF (i GE Nb-1+Nb) THEN BEGIN
READCOL,STRCOMPRESS('../../'+HD(star)+'/data/'+nom(0)+'.dat'),F='A,D', lambda,flux,SKIPLINE=LONG((lambda1(raie)-lambdaN0)*100),NUMLINE=LONG((lambda2(raie)-lambda1(raie))*100),/SILENT
maxflux(i,star,raie)=MAX(flux)
Profondeur(i,star,raie)=MIN(flux)
X(i*Nb2:(i+1)*Nb2-1)=(lambda(*)-lambdaRAIE(raie))*cl/lambdaRAIE(raie)-Vgamma(star)
FOR j=0, Nb2-1 DO BEGIN
Y(i*Nb2+j)=2.0+phase(0)
ENDFOR
Z(i*Nb2:(i+1)*Nb2-1)=flux(*);-PROFIL(lambda-Vgamma(star)*lambdaRAIE(raie)/cl,lambdaRAIE(raie),0.25,Nb2,phase(0))
CASE star OF 
0 :  phase0(i)=2.0+phase(0)
1 :  phase1(i)=2.0+phase(0)
2 :  phase2(i)=2.0+phase(0)
3 :  phase3(i)=2.0+phase(0)
4 :  phase4(i)=2.0+phase(0)
5 :  phase5(i)=2.0+phase(0)
6 :  phase6(i)=2.0+phase(0)
7 :  phase7(i)=2.0+phase(0)
8 :  phase8(i)=2.0+phase(0)
9 :  phase9(i)=2.0+phase(0)
ENDCASE
ENDIF ELSE BEGIN
IF (i GE Nb) THEN BEGIN
READCOL,STRCOMPRESS('../../'+HD(star)+'/data/'+nom(i-Nb)+'.dat'),F='A,D', lambda,flux,SKIPLINE=LONG((lambda1(raie)-lambdaN0)*100),NUMLINE=LONG((lambda2(raie)-lambda1(raie))*100),/SILENT
maxflux(i,star,raie)=MAX(flux)
Profondeur(i,star,raie)=MIN(flux)
X(i*Nb2:(i+1)*Nb2-1)=(lambda(*)-lambdaRAIE(raie))*cl/lambdaRAIE(raie)-Vgamma(star)
FOR j=0, Nb2-1 DO BEGIN
Y(i*Nb2+j)=1.0+phase(i-Nb)
ENDFOR
Z(i*Nb2:(i+1)*Nb2-1)=flux(*);-PROFIL(lambda-Vgamma(star)*lambdaRAIE(raie)/cl,lambdaRAIE(raie),0.25,Nb2,phase(i-Nb))
CASE star OF 
0 :  phase0(i)=1.0+phase(i-Nb)
1 :  phase1(i)=1.0+phase(i-Nb)
2 :  phase2(i)=1.0+phase(i-Nb)
3 :  phase3(i)=1.0+phase(i-Nb)
4 :  phase4(i)=1.0+phase(i-Nb)
5 :  phase5(i)=1.0+phase(i-Nb)
6 :  phase6(i)=1.0+phase(i-Nb)
7 :  phase7(i)=1.0+phase(i-Nb)
8 :  phase8(i)=1.0+phase(i-Nb)
9 :  phase9(i)=1.0+phase(i-Nb)
ENDCASE
ENDIF ELSE BEGIN
READCOL,STRCOMPRESS('../../'+HD(star)+'/data/'+nom(i)+'.dat'),F='A,D', lambda,flux,SKIPLINE=LONG((lambda1(raie)-lambdaN0)*100),NUMLINE=LONG((lambda2(raie)-lambda1(raie))*100),/SILENT
maxflux(i,star,raie)=MAX(flux)
Profondeur(i,star,raie)=MIN(flux)
X(i*Nb2:(i+1)*Nb2-1)=(lambda(*)-lambdaRAIE(raie))*cl/lambdaRAIE(raie)-Vgamma(star)
FOR j=0, Nb2-1 DO BEGIN
Y(i*Nb2+j)=phase(i)
ENDFOR
Z(i*Nb2:(i+1)*Nb2-1)=flux(*);-PROFIL(lambda-Vgamma(star)*lambdaRAIE(raie)/cl,lambdaRAIE(raie),0.25,Nb2,phase(i))
CASE star OF 
 0 :  phase0(i)=  phase(i)
1 :  phase1(i)=  phase(i)
2 :  phase2(i)=  phase(i)
3 :  phase3(i)=  phase(i)
4 :  phase4(i)=  phase(i)
5 :  phase5(i)=  phase(i)
6 :  phase6(i)=  phase(i)
7 :  phase7(i)=  phase(i)
8 :  phase8(i)=  phase(i)
9 :  phase9(i)=  phase(i)
ENDCASE
ENDELSE
ENDELSE

;----------------------------------------
; Nprof1=Nb2   
;      indice1=0.
;      X1=DBLARR(Nprof1)
;      Y1=DBLARR(Nprof1)
;      Niveau1=DBLARR(Nprof1)
; 	    FOR k=0,Nprof1-1 DO BEGIN
; 	    X1(k)=lambda(indice1+k)
; 	    Y1(k)=flux(indice1+k)
; 	    ENDFOR 
; Y1b=1.0 
; Continu=DBLARR(Nprof1)
; Continu(*)=Y1b

; q=Xmincdg
; 	     WHILE  ((Continu(q)-Y1(q)) GE 0.5) DO BEGIN
; 	     q=q-1 
; 	     ENDWHILE
; 	     Xgcdg=q
; p=Xmincdg
; 	     WHILE  ((Continu(p)-Y1(p)) GE 0.5) DO BEGIN
; 	     p=p+1
; 	     ENDWHILE
; 	     Xdcdg=p
; FACTEUR=1. 
;       FWHM_grossier=p-q
;       Nprofcdg=FWHM_grossier*FACTEUR
;  Nprofcdg=50.
;      Xcdg=DBLARR(Nprofcdg)
;      Ycdg=DBLARR(Nprofcdg)
; 	    FOR k=0,Nprofcdg-1 DO BEGIN
; 	    Xcdg(k)=X1(Xgcdg+k)
; 	    Ycdg(k)=Y1(Xgcdg+k)+(1.-Continu(0))	          
; 	    ENDFOR 

;  VRm(i,star,raie)=(X1(Xmin)-lambdaRAIE(raie))*cl/lambdaRAIE(raie)
; FWHM(i,star,raie)=X1(p)-X1(q)
; AsyFWHM(i,star,raie)=(ABS(X1(q)-X1(Xmincdg))-ABS(X1(p)-X1(Xmincdg)))/FWHM(i,star,raie)*100.

CASE star OF 
 0 :  PRINT,i,phase0(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 1 :  PRINT,i,phase1(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 2 :  PRINT,i,phase2(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 3 :  PRINT,i,phase3(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 4 :  PRINT,i,phase4(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 5 :  PRINT,i,phase5(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 6 :  PRINT,i,phase6(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 7 :  PRINT,i,phase7(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 8 :  PRINT,i,phase8(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 9 :  PRINT,i,phase9(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
ENDCASE


CASE star OF 
 0 :  PRINTF,1,i,phase0(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 1 :  PRINTF,1,i,phase1(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 2 :  PRINTF,1,i,phase2(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 3 :  PRINTF,1,i,phase3(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 4 :  PRINTF,1,i,phase4(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 5 :  PRINTF,1,i,phase5(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 6 :  PRINTF,1,i,phase6(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 7 :  PRINTF,1,i,phase7(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 8 :  PRINTF,1,i,phase8(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
 9 :  PRINTF,1,i,phase9(i),star,raie,Profondeur(i,star,raie),VRm(i,star,raie),FWHM(i,star,raie),AsyFWHM(i,star,raie),maxflux(i,star,raie)
ENDCASE




IF Profondeur(i,star,raie) GT MAXplot(0) THEN MAXplot(0)=MAX(Profondeur(i,star,raie))
IF VRm(i,star,raie) GT MAXplot(1) THEN MAXplot(1)=MAX(VRm(i,star,raie)) 
IF FWHM(i,star,raie) GT MAXplot(2) THEN MAXplot(2)=MAX(FWHM(i,star,raie))
IF AsyFWHM(i,star,raie) GT MAXplot(3) THEN MAXplot(3)=MAX(AsyFWHM(i,star,raie))
IF Profondeur(i,star,raie) LT MINplot(0) THEN MINplot(0)=MIN(Profondeur(i,star,raie))
IF VRm(i,star,raie) LT MINplot(1) THEN MINplot(1)=MIN(VRm(i,star,raie)) 
IF FWHM(i,star,raie) LT MINplot(2) THEN MINplot(2)=MIN(FWHM(i,star,raie))
IF AsyFWHM(i,star,raie) LT MINplot(3) THEN MINplot(3)=MIN(AsyFWHM(i,star,raie))
ENDFOR


   ; Create the set of Delaunay triangles. The variables
   ; "triangles" and "boundaryPts" are output variables.

Triangulate, x, y, triangles, boundaryPts

gridSpace = [RES_lambda, RES_phase]  ;first value means spacing in lambda, second value means spacing in phase
 ; Grid the Z data, using the triangles.The variables "xvector"
 ; and "yvector" are output variables.

griddedData = TriGrid( x,y, z, triangles, gridSpace,[velocityM, MIN(Y), velocityP, MAX(Y)], XGrid=xvector, YGrid=yvector)
PRINT,'Max de l''image', MAX(griddedData)
;REF=max(griddedData)
nbyvector=N_ELEMENTS(yvector)
nbxvector=N_ELEMENTS(xvector)
;spectremoy=TOTAL(griddedData(*,0:FIX(nbyvector/2.)),2)
spectremoy=TOTAL(griddedData,2)

print,'nbxvector',nbxvector
; spectremoy=spectremoy/FIX(nbyvector/2.)
spectremoy=spectremoy/nbyvector
VAR=DBLARR(nbxvector)
VAR(*)=0.
pipo=DBLARR(nbxvector,nbyvector)
;FOR nbyv=0, FIX(nbyvector/2.) DO BEGIN
FOR nbyv=0, nbyvector-1 DO BEGIN
pipo(*,nbyv)=griddedData(*,nbyv)/spectremoy(*)
VAR(*)=VAR(*)+(griddedData(*,nbyv)-spectremoy(*))^2.
; rien=MIN(griddedData(*,nbyv),indice)
;  VRm(nbyv,star,raie)=xvector(indice)
ENDFOR



SpMoy(*,star,raie)=spectremoy(*)
;SpSig(*,star,raie)=SQRT(VAR(*)/FIX(nbyvector/2.))
SpSig(*,star,raie)=SQRT(VAR(*)/(nbyvector-1.))
VarMOY(*,star,raie)=TOTAL(pipo,2)/nbyvector

;WINDOW,0
;!P.MULTI=[0,1,3]
;PRINT,star,raie
;PLOT,xvector,SpMoy(*,star,raie)
;PLOT,xvector,SpSig(*,star,raie)
;PLOT,SpMoy(*,star,raie),SpSig(*,star,raie)
;WAIT,1

REF2=max(pipo)
;image=bytscl(griddedData,MAX=REF); byte scaling the image for display purposes with tvimage
image=griddedData
;image=bytscl(griddedData,MIN=REFmin(star),MAX=REFmax(star))
imagemoy=bytscl(pipo,MAX=REF2)

IF (raie EQ 0) THEN BEGIN
CASE star OF 
	0 : imageRT_Hdelta=image
        1: imageSC_Hdelta=image 
	2: imageYS_Hdelta=image
	3: imageXS_Hdelta=image
	4: imageBD_Hdelta=image
	5: imageZG_Hdelta=image
	6: imageYO_Hdelta=image
	7: imageRZV_Hdelta=image
	8: imageLC_Hdelta=image
	9: imageRSP_Hdelta=image
ENDCASE
CASE star OF 
	0: griddedDataRT_Hdelta=griddedData
        1: griddedDataSC_Hdelta=griddedData 
	2: griddedDataYS_Hdelta=griddedData
	3: griddedDataXS_Hdelta=griddedData
	4: griddedDataBD_Hdelta=griddedData
	5: griddedDataZG_Hdelta=griddedData
	6: griddedDataYO_Hdelta=griddedData
	7: griddedDataRZV_Hdelta=griddedData
	8: griddedDataLC_Hdelta=griddedData
	9: griddedDataRSP_Hdelta=griddedData
ENDCASE
CASE star OF 
	0 : xvectorRT_Hdelta=xvector
        1: xvectorSC_Hdelta=xvector
	2: xvectorYS_Hdelta=xvector
	3: xvectorXS_Hdelta=xvector
	4: xvectorBD_Hdelta=xvector
	5: xvectorZG_Hdelta=xvector
	6: xvectorYO_Hdelta=xvector
	7: xvectorRZV_Hdelta=xvector
	8: xvectorLC_Hdelta=xvector
	9: xvectorRSP_Hdelta=xvector
ENDCASE
CASE star OF 
	0 : yvectorRT_Hdelta=yvector
        1: yvectorSC_Hdelta=yvector
	2: yvectorYS_Hdelta=yvector
	3: yvectorXS_Hdelta=yvector
	4: yvectorBD_Hdelta=yvector
	5: yvectorZG_Hdelta=yvector
	6: yvectorYO_Hdelta=yvector
	7: yvectorRZV_Hdelta=yvector
	8: yvectorLC_Hdelta=yvector
	9: yvectorRSP_Hdelta=yvector
ENDCASE
CASE star OF 
	0 : imagemoyRT_Hdelta=imagemoy
        1:  imagemoySC_Hdelta=imagemoy
	2:  imagemoyYS_Hdelta=imagemoy
	3:  imagemoyXS_Hdelta=imagemoy
	4:  imagemoyBD_Hdelta=imagemoy
	5:  imagemoyZG_Hdelta=imagemoy
	6:  imagemoyYO_Hdelta=imagemoy
	7:  imagemoyRZV_Hdelta=imagemoy
	8:  imagemoyLC_Hdelta=imagemoy
	9:  imagemoyRSP_Hdelta=imagemoy
ENDCASE
ENDIF

IF (raie EQ 1) THEN BEGIN
CASE star OF 
	0 : imageRT_Hgamma=image
        1: imageSC_Hgamma=image
	2: imageYS_Hgamma=image
	3: imageXS_Hgamma=image
	4: imageBD_Hgamma=image
	5: imageZG_Hgamma=image
	6: imageYO_Hgamma=image
	7: imageRZV_Hgamma=image
	8: imageLC_Hgamma=image
	9: imageRSP_Hgamma=image
ENDCASE
CASE star OF 
	0: griddedDataRT_Hgamma=griddedData
        1: griddedDataSC_Hgamma=griddedData 
	2: griddedDataYS_Hgamma=griddedData
	3: griddedDataXS_Hgamma=griddedData
	4: griddedDataBD_Hgamma=griddedData
	5: griddedDataZG_Hgamma=griddedData
	6: griddedDataYO_Hgamma=griddedData
	7: griddedDataRZV_Hgamma=griddedData
	8: griddedDataLC_Hgamma=griddedData
	9: griddedDataRSP_Hgamma=griddedData
ENDCASE
CASE star OF 
	0 : xvectorRT_Hgamma=xvector
        1: xvectorSC_Hgamma=xvector
	2: xvectorYS_Hgamma=xvector
	3: xvectorXS_Hgamma=xvector
	4: xvectorBD_Hgamma=xvector
	5: xvectorZG_Hgamma=xvector
	6: xvectorYO_Hgamma=xvector
	7: xvectorRZV_Hgamma=xvector
	8: xvectorLC_Hgamma=xvector
	9: xvectorRSP_Hgamma=xvector
ENDCASE
CASE star OF 
	0 : yvectorRT_Hgamma=yvector
        1: yvectorSC_Hgamma=yvector
	2: yvectorYS_Hgamma=yvector
	3: yvectorXS_Hgamma=yvector
	4: yvectorBD_Hgamma=yvector
	5: yvectorZG_Hgamma=yvector
	6: yvectorYO_Hgamma=yvector
	7: yvectorRZV_Hgamma=yvector
	8: yvectorLC_Hgamma=yvector
	9: yvectorRSP_Hgamma=yvector
ENDCASE
CASE star OF 
	0 : imagemoyRT_Hgamma=imagemoy
        1:  imagemoySC_Hgamma=imagemoy
	2:  imagemoyYS_Hgamma=imagemoy
	3:  imagemoyXS_Hgamma=imagemoy
	4:  imagemoyBD_Hgamma=imagemoy
	5:  imagemoyZG_Hgamma=imagemoy
	6:  imagemoyYO_Hgamma=imagemoy
	7:  imagemoyRZV_Hgamma=imagemoy
	8:  imagemoyLC_Hgamma=imagemoy
	9:  imagemoyRSP_Hgamma=imagemoy
ENDCASE
ENDIF
 
IF (raie EQ 2) THEN BEGIN
CASE star OF 
	0 : imageRT_Hbeta=image
        1: imageSC_Hbeta=image
	2: imageYS_Hbeta=image
	3: imageXS_Hbeta=image
	4: imageBD_Hbeta=image
	5: imageZG_Hbeta=image
	6: imageYO_Hbeta=image
	7: imageRZV_Hbeta=image
	8: imageLC_Hbeta=image
	9: imageRSP_Hbeta=image
ENDCASE
CASE star OF 
	0: griddedDataRT_Hbeta=griddedData
        1: griddedDataSC_Hbeta=griddedData 
	2: griddedDataYS_Hbeta=griddedData
	3: griddedDataXS_Hbeta=griddedData
	4: griddedDataBD_Hbeta=griddedData
	5: griddedDataZG_Hbeta=griddedData
	6: griddedDataYO_Hbeta=griddedData
	7: griddedDataRZV_Hbeta=griddedData
	8: griddedDataLC_Hbeta=griddedData
	9: griddedDataRSP_Hbeta=griddedData
ENDCASE
CASE star OF 
	0 : xvectorRT_Hbeta=xvector
        1: xvectorSC_Hbeta=xvector
	2: xvectorYS_Hbeta=xvector
	3: xvectorXS_Hbeta=xvector
	4: xvectorBD_Hbeta=xvector
	5: xvectorZG_Hbeta=xvector
	6: xvectorYO_Hbeta=xvector
	7: xvectorRZV_Hbeta=xvector
	8: xvectorLC_Hbeta=xvector
	9: xvectorRSP_Hbeta=xvector
ENDCASE
CASE star OF 
	0 : yvectorRT_Hbeta=yvector
        1: yvectorSC_Hbeta=yvector
	2: yvectorYS_Hbeta=yvector
	3: yvectorXS_Hbeta=yvector
	4: yvectorBD_Hbeta=yvector
	5: yvectorZG_Hbeta=yvector
	6: yvectorYO_Hbeta=yvector
	7: yvectorRZV_Hbeta=yvector
	8: yvectorLC_Hbeta=yvector
	9: yvectorRSP_Hbeta=yvector
ENDCASE
CASE star OF 
	0 : imagemoyRT_Hbeta=imagemoy
        1:  imagemoySC_Hbeta=imagemoy
	2:  imagemoyYS_Hbeta=imagemoy
	3:  imagemoyXS_Hbeta=imagemoy
	4:  imagemoyBD_Hbeta=imagemoy
	5:  imagemoyZG_Hbeta=imagemoy
	6:  imagemoyYO_Hbeta=imagemoy
	7:  imagemoyRZV_Hbeta=imagemoy
	8:  imagemoyLC_Hbeta=imagemoy
	9:  imagemoyRSP_Hbeta=imagemoy
ENDCASE
ENDIF

IF (raie EQ 3) THEN BEGIN
CASE star OF 
	0 : imageRT_Halpha=image
        1: imageSC_Halpha=image 
	2: imageYS_Halpha=image
	3: imageXS_Halpha=image
	4: imageBD_Halpha=image
	5: imageZG_Halpha=image
	6: imageYO_Halpha=image
	7: imageRZV_Halpha=image
	8: imageLC_Halpha=image
	9: imageRSP_Halpha=image
ENDCASE
CASE star OF 
	0: griddedDataRT_Halpha=griddedData
        1: griddedDataSC_Halpha=griddedData 
	2: griddedDataYS_Halpha=griddedData
	3: griddedDataXS_Halpha=griddedData
	4: griddedDataBD_Halpha=griddedData
	5: griddedDataZG_Halpha=griddedData
	6: griddedDataYO_Halpha=griddedData
	7: griddedDataRZV_Halpha=griddedData
	8: griddedDataLC_Halpha=griddedData
	9: griddedDataRSP_Halpha=griddedData
ENDCASE
CASE star OF 
	0 : xvectorRT_Halpha=xvector
        1: xvectorSC_Halpha=xvector
	2: xvectorYS_Halpha=xvector
	3: xvectorXS_Halpha=xvector
	4: xvectorBD_Halpha=xvector
	5: xvectorZG_Halpha=xvector
	6: xvectorYO_Halpha=xvector
	7: xvectorRZV_Halpha=xvector
	8: xvectorLC_Halpha=xvector
	9: xvectorRSP_Halpha=xvector
ENDCASE
CASE star OF 
	0 : yvectorRT_Halpha=yvector
        1: yvectorSC_Halpha=yvector
	2: yvectorYS_Halpha=yvector
	3: yvectorXS_Halpha=yvector
	4: yvectorBD_Halpha=yvector
	5: yvectorZG_Halpha=yvector
	6: yvectorYO_Halpha=yvector
	7: yvectorRZV_Halpha=yvector
	8: yvectorLC_Halpha=yvector
	9: yvectorRSP_Halpha=yvector
ENDCASE
CASE star OF 
	0 : imagemoyRT_Halpha=imagemoy
        1:  imagemoySC_Halpha=imagemoy
	2:  imagemoyYS_Halpha=imagemoy
	3:  imagemoyXS_Halpha=imagemoy
	4:  imagemoyBD_Halpha=imagemoy
	5:  imagemoyZG_Halpha=imagemoy
	6:  imagemoyYO_Halpha=imagemoy
	7:  imagemoyRZV_Halpha=imagemoy
	8:  imagemoyLC_Halpha=imagemoy
	9:  imagemoyRSP_Halpha=imagemoy
ENDCASE
ENDIF

IF (raie EQ 4) THEN BEGIN
CASE star OF 
	0 : imageRT_HCa2=image
        1: imageSC_HCa2=image
	2: imageYS_HCa2=image
	3: imageXS_HCa2=image
	4: imageBD_HCa2=image
	5: imageZG_HCa2=image
	6: imageYO_HCa2=image
	7: imageRZV_HCa2=image
	8: imageLC_HCa2=image
	9: imageRSP_HCa2=image
ENDCASE
CASE star OF 
	0 : xvectorRT_HCa2=xvector
        1: xvectorSC_HCa2=xvector
	2: xvectorYS_HCa2=xvector
	3: xvectorXS_HCa2=xvector
	4: xvectorBD_HCa2=xvector
	5: xvectorZG_HCa2=xvector
	6: xvectorYO_HCa2=xvector
	7: xvectorRZV_HCa2=xvector
	8: xvectorLC_HCa2=xvector
	9: xvectorRSP_HCa2=xvector
ENDCASE
CASE star OF 
	0 : yvectorRT_HCa2=yvector
        1: yvectorSC_HCa2=yvector
	2: yvectorYS_HCa2=yvector
	3: yvectorXS_HCa2=yvector
	4: yvectorBD_HCa2=yvector
	5: yvectorZG_HCa2=yvector
	6: yvectorYO_HCa2=yvector
	7: yvectorRZV_HCa2=yvector
	8: yvectorLC_HCa2=yvector
	9: yvectorRSP_HCa2=yvector
ENDCASE
CASE star OF 
	0 : imagemoyRT_HCa2=imagemoy
        1:  imagemoySC_HCa2=imagemoy
	2:  imagemoyYS_HCa2=imagemoy
	3:  imagemoyXS_HCa2=imagemoy
	4:  imagemoyBD_HCa2=imagemoy
	5:  imagemoyZG_HCa2=imagemoy
	6:  imagemoyYO_HCa2=imagemoy
	7:  imagemoyRZV_HCa2=imagemoy
	8:  imagemoyLC_HCa2=imagemoy
	9:  imagemoyRSP_HCa2=imagemoy
ENDCASE
ENDIF

IF (raie EQ 5) THEN BEGIN
CASE star OF 
	0 : imageRT_HNa1=image
        1: imageSC_HNa1=image
	2: imageYS_HNa1=image
	3: imageXS_HNa1=image
	4: imageBD_HNa1=image
	5: imageZG_HNa1=image
	6: imageYO_HNa1=image
	7: imageRZV_HNa1=image
	8: imageLC_HNa1=image
	9: imageRSP_HNa1=image
ENDCASE
CASE star OF 
	0 : xvectorRT_HNa1=xvector
        1: xvectorSC_HNa1=xvector
	2: xvectorYS_HNa1=xvector
	3: xvectorXS_HNa1=xvector
	4: xvectorBD_HNa1=xvector
	5: xvectorZG_HNa1=xvector
	6: xvectorYO_HNa1=xvector
	7: xvectorRZV_HNa1=xvector
	8: xvectorLC_HNa1=xvector
	9: xvectorRSP_HNa1=xvector
ENDCASE
CASE star OF 
	0 : yvectorRT_HNa1=yvector
        1: yvectorSC_HNa1=yvector
	2: yvectorYS_HNa1=yvector
	3: yvectorXS_HNa1=yvector
	4: yvectorBD_HNa1=yvector
	5: yvectorZG_HNa1=yvector
	6: yvectorYO_HNa1=yvector
	7: yvectorRZV_HNa1=yvector
	8: yvectorLC_HNa1=yvector
	9: yvectorRSP_HNa1=yvector
ENDCASE
CASE star OF 
	0 : imagemoyRT_HNa1=imagemoy
        1:  imagemoySC_HNa1=imagemoy
	2:  imagemoyYS_HNa1=imagemoy
	3:  imagemoyXS_HNa1=imagemoy
	4:  imagemoyBD_HNa1=imagemoy
	5:  imagemoyZG_HNa1=imagemoy
	6:  imagemoyYO_HNa1=imagemoy
	7:  imagemoyRZV_HNa1=imagemoy
	8:  imagemoyLC_HNa1=imagemoy
	9:  imagemoyRSP_HNa1=imagemoy
ENDCASE
ENDIF

ENDFOR
ENDFOR

SAVE,filename="FILM.dat"
SAVE, imageRT_Hdelta, imageSC_Hdelta, imageYS_Hdelta, imageXS_Hdelta, imageBD_Hdelta, imageZG_Hdelta, imageYO_Hdelta, imageRZV_Hdelta, imageLC_Hdelta, imageRSP_Hdelta, imageRT_Hbeta, imageSC_Hbeta, imageYS_Hbeta,imageXS_Hbeta, imageBD_Hbeta, imageZG_Hbeta, imageYO_Hbeta, imageRZV_Hbeta, imageLC_Hbeta, imageRSP_Hbeta, imageRT_Hgamma, imageSC_Hgamma, imageYS_Hgamma,imageXS_Hgamma, imageBD_Hgamma, imageZG_Hgamma, imageYO_Hgamma, imageRZV_Hgamma, imageLC_Hgamma, imageRSP_Hgamma, imageRT_Halpha, imageSC_Halpha, imageYS_Halpha,imageXS_Halpha, imageBD_Halpha, imageZG_Halpha, imageYO_Halpha, imageRZV_Halpha, imageLC_Halpha, imageRSP_Halpha, xvectorRT_Hdelta, xvectorSC_Hdelta, xvectorYS_Hdelta,xvectorXS_Hdelta, xvectorBD_Hdelta, xvectorZG_Hdelta, xvectorYO_Hdelta, xvectorRZV_Hdelta, xvectorLC_Hdelta, xvectorRSP_Hdelta, xvectorRT_Hbeta, xvectorSC_Hbeta, xvectorYS_Hbeta,xvectorXS_Hbeta, xvectorBD_Hbeta, xvectorZG_Hbeta, xvectorYO_Hbeta, xvectorRZV_Hbeta, xvectorLC_Hbeta, xvectorRSP_Hbeta, xvectorRT_Hgamma, xvectorSC_Hgamma, xvectorYS_Hgamma,xvectorXS_Hgamma, xvectorBD_Hgamma, xvectorZG_Hgamma, xvectorYO_Hgamma, xvectorRZV_Hgamma, xvectorLC_Hgamma, xvectorRSP_Hgamma, xvectorRT_Halpha, xvectorSC_Halpha, xvectorYS_Halpha,xvectorXS_Halpha, xvectorBD_Halpha, xvectorZG_Halpha, xvectorYO_Halpha, xvectorRZV_Halpha, xvectorLC_Halpha, xvectorRSP_Halpha, yvectorRT_Hdelta, yvectorSC_Hdelta, yvectorYS_Hdelta,yvectorXS_Hdelta, yvectorBD_Hdelta, yvectorZG_Hdelta, yvectorYO_Hdelta, yvectorRZV_Hdelta, yvectorLC_Hdelta, yvectorRSP_Hdelta, yvectorRT_Hbeta, yvectorSC_Hbeta, yvectorYS_Hbeta,yvectorXS_Hbeta, yvectorBD_Hbeta, yvectorZG_Hbeta, yvectorYO_Hbeta, yvectorRZV_Hbeta, yvectorLC_Hbeta, yvectorRSP_Hbeta, yvectorRT_Hgamma, yvectorSC_Hgamma, yvectorYS_Hgamma,yvectorXS_Hgamma, yvectorBD_Hgamma, yvectorZG_Hgamma, yvectorYO_Hgamma, yvectorRZV_Hgamma, yvectorLC_Hgamma, yvectorRSP_Hgamma, yvectorRT_Halpha, yvectorSC_Halpha, yvectorYS_Halpha,yvectorXS_Halpha, yvectorBD_Halpha, yvectorZG_Halpha, yvectorYO_Halpha, yvectorRZV_Halpha, yvectorLC_Halpha, yvectorRSP_Halpha,phase0,phase1,phase2,phase3,phase4,phase5,phase6,phase7,phase8,phase9,NBnom,imageRT_HCa2, imageSC_HCa2, imageYS_HCa2, imageXS_HCa2, imageBD_HCa2, imageZG_HCa2, imageYO_HCa2, imageRZV_HCa2, imageLC_HCa2, imageRSP_HCa2, xvectorRT_HCa2, xvectorSC_HCa2, xvectorYS_HCa2,xvectorXS_HCa2, xvectorBD_HCa2, xvectorZG_HCa2, xvectorYO_HCa2, xvectorRZV_HCa2, xvectorLC_HCa2, xvectorRSP_HCa2, yvectorRT_HCa2, yvectorSC_HCa2, yvectorYS_HCa2,yvectorXS_HCa2, yvectorBD_HCa2, yvectorZG_HCa2, yvectorYO_HCa2, yvectorRZV_HCa2, yvectorLC_HCa2, yvectorRSP_HCa2,imageRT_HNa1, imageSC_HNa1, imageYS_HNa1, imageXS_HNa1, imageBD_HNa1, imageZG_HNa1, imageYO_HNa1, imageRZV_HNa1, imageLC_HNa1, imageRSP_HNa1, xvectorRT_HNa1, xvectorSC_HNa1, xvectorYS_HNa1,xvectorXS_HNa1, xvectorBD_HNa1, xvectorZG_HNa1, xvectorYO_HNa1, xvectorRZV_HNa1, xvectorLC_HNa1, xvectorRSP_HNa1, yvectorRT_HNa1, yvectorSC_HNa1, yvectorYS_HNa1,yvectorXS_HNa1, yvectorBD_HNa1, yvectorZG_HNa1, yvectorYO_HNa1, yvectorRZV_HNa1, yvectorLC_HNa1, yvectorRSP_HNa1, imagemoyRT_Hdelta, imagemoySC_Hdelta, imagemoyYS_Hdelta, imagemoyXS_Hdelta, imagemoyBD_Hdelta, imagemoyZG_Hdelta, imagemoyYO_Hdelta, imagemoyRZV_Hdelta, imagemoyLC_Hdelta, imagemoyRSP_Hdelta, imagemoyRT_Hbeta, imagemoySC_Hbeta, imagemoyYS_Hbeta,imagemoyXS_Hbeta, imagemoyBD_Hbeta, imagemoyZG_Hbeta, imagemoyYO_Hbeta, imagemoyRZV_Hbeta, imagemoyLC_Hbeta, imagemoyRSP_Hbeta, imagemoyRT_Hgamma, imagemoySC_Hgamma, imagemoyYS_Hgamma,imagemoyXS_Hgamma, imagemoyBD_Hgamma, imagemoyZG_Hgamma, imagemoyYO_Hgamma, imagemoyRZV_Hgamma, imagemoyLC_Hgamma, imagemoyRSP_Hgamma, imagemoyRT_Halpha, imagemoySC_Halpha, imagemoyYS_Halpha,imagemoyXS_Halpha, imagemoyBD_Halpha, imagemoyZG_Halpha, imagemoyYO_Halpha, imagemoyRZV_Halpha, imagemoyLC_Halpha, imagemoyRSP_Halpha,phase0,phase1,phase2,phase3,phase4,phase5,phase6,phase7,phase8,phase9,NBnom,imagemoyRT_HCa2, imagemoySC_HCa2, imagemoyYS_HCa2, imagemoyXS_HCa2, imagemoyBD_HCa2, imagemoyZG_HCa2, imagemoyYO_HCa2, imagemoyRZV_HCa2, imagemoyLC_HCa2, imagemoyRSP_HCa2,imagemoyRT_HNa1, imagemoySC_HNa1, imagemoyYS_HNa1, imagemoyXS_HNa1, imagemoyBD_HNa1, imagemoyZG_HNa1, imagemoyYO_HNa1, imagemoyRZV_HNa1, imagemoyLC_HNa1, imagemoyRSP_HNa1,SpSig,SpMoy,VarMOY, griddedDataRT_Halpha,griddedDataSC_Halpha, griddedDataYS_Halpha, griddedDataXS_Halpha, griddedDataBD_Halpha, griddedDataZG_Halpha, griddedDataYO_Halpha, griddedDataRZV_Halpha, griddedDataLC_Halpha, griddedDataRSP_Halpha,griddedDataRT_Hbeta,griddedDataSC_Hbeta, griddedDataYS_Hbeta, griddedDataXS_Hbeta, griddedDataBD_Hbeta, griddedDataZG_Hbeta, griddedDataYO_Hbeta, griddedDataRZV_Hbeta, griddedDataLC_Hbeta, griddedDataRSP_Hbeta, griddedDataRT_Hgamma,griddedDataSC_Hgamma, griddedDataYS_Hgamma, griddedDataXS_Hgamma, griddedDataBD_Hgamma, griddedDataZG_Hgamma, griddedDataYO_Hgamma, griddedDataRZV_Hgamma, griddedDataLC_Hgamma, griddedDataRT_Hdelta,griddedDataSC_Hdelta, griddedDataYS_Hdelta, griddedDataXS_Hdelta, griddedDataBD_Hdelta, griddedDataZG_Hdelta, griddedDataYO_Hdelta, griddedDataRZV_Hdelta, griddedDataLC_Hdelta, griddedDataRSP_Hdelta, Profondeur, phase0, phase1, phase2, phase3, phase4, phase5, phase6, phase7, phase8, phase9
CLOSE,/all



END