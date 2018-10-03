;-------------PROFIL GAUSSIEN STATIQUE
FUNCTION PROFIL,DL,DLo,FWHM,dim
PROF=dim*1./SQRT(2.*!PI*FWHM^2./(4.*ALOG(2.)))*EXP(-4.*ALOG(2.)*(DL-DLo)^2./(FWHM^2.))
PROF=PROF/TOTAL(PROF)
RETURN,PROF
END

PRO Cepheide_MFWG



;--------------LECTURE DES PARAMETRES
A=DBLARR(20)
OPENR,1,'C:\Documents and Settings\Nicolas Nardetto\Mes documents\RECHERCHE\IDL&Yorick\input_Cepheide.txt'
READF,1,A
CLOSE,1

IF A(19) NE 0 THEN BEGIN
device,retain=2.
WINDOW,1,XSIZE=800,YSIZE=600
!P.MULTI=[0,2,3]
PRINT,'PARAMETRES PHYSIQUES & NUMERIQUES:'
PRINT,A(0), '   A(0)= resolution spatiale (pixel)'
PRINT,A(1), '   A(1)= resolution spectrale (pixel)'
PRINT, A(2),'   A(2)= profondeur (lie a l''abondance-TBD)'
PRINT,A(3),'   A(3)= lambda (A)'
PRINT,A(4),'   A(4)= borne (A)'
PRINT,A(5),'   A(5)= vitesse pulsante (km/s)'
PRINT,A(6),'   A(6)= ACB (sans unite -> Claret et al. 2000)'
PRINT,A(7),'   A(7)= Vrot*sin(i) en km/s'
PRINT,A(8),'   A(8)= FWHM statique (A)'
PRINT,A(9),'   A(9)= Nb. de pts dans le premier lobe de la TF'
PRINT,A(10),'   A(10)= RAYON de l''etoile (Rs)'
PRINT,A(11),'   A(11)= distance (pc)'
PRINT,A(12),'   A(12)= Bp1 (m)'
PRINT,A(13),'   A(13)= Az1 (en deg [-180,180] N->E)'
PRINT,A(14),'   A(14)= Bp2 (m)'
PRINT,A(15),'   A(15)= Az2 (en deg [-180,180] N->E)'
PRINT,A(16),'   A(16)= Bp3 (m)'
PRINT,A(17),'   A(17)= Az3 (en deg [-180,180] N->E)'
PRINT,A(18),'   A(18)= Axe de rotationl (en deg [-180,180] N->E)'
PRINT,A(19),'   A(19)= 0 -> pas d''infos /// 1 -> infos'
ENDIF

SPECTRE_conv=DBLARR(A(1))
SPECTRE_pond=DBLARR(A(1))
SPECTRE_conv(*)=1.
SPECTRE_pond(*)=1.
;-------------DEFINITION DES LONGUEUR D'ONDE
cl=DOUBLE(299792.458)                                  ; c en km/s
R=2.*A(4)/A(1)                                                     ; resolution spectrale
DL=2*A(4)*(DINDGEN(A(1))-(A(1)-1)/2.)/A(1)

;-------------DEFINITION DU PROFIL GAUSSIEN
PROFIL_indice=DBLARR(A(1))
PROFIL_indice(*)=PROFIL(DL,DL(A(1)/2.),A(8),A(1))

;--------------DEFINITION DE LE CARTE D'INTENSITE de taille A(0)*A(0)
INTxy=DBLARR(A(0),A(0))
val_x=(DINDGEN(A(0))-(A(0)-1)/2.)#REPLICATE(1,A(0))
val_x=val_x/(max(val_x))
val_y=TRANSPOSE(val_x)
r_proj=val_x*val_x+val_y*val_y

r_proj(WHERE(r_proj GE 1.))=2.
INTxy(*,*)=1.
INTxy=1.-A(6)+A(6)*SQRT(1-r_proj)
INTxy(WHERE(r_proj GE 1.))=0.
INTxy=INTxy/TOTAL(INTxy)

;--------------DEFINITION DES VITESSES PROJETEES (A(0)*A(0))
Vxy=DBLARR(A(0),A(0))
Vrot=(DINDGEN(A(0))-(A(0)-1)/2.)#REPLICATE(1,A(0))/((A(0)-1)/2.)
Vxy=A(5)*SQRT(1-r_proj)+A(7)*Vrot
Vxy(WHERE(r_proj GE 1.))=0.


;--------------CREATION DU PROFIL SPECTRAL (A(1))
;--------------CREATION DES CARTES D'INTENSITES (A(0)*A(0)*A(1))

IMAGE_V=DBLARR(A(0),A(0),A(1))
FOR indice=0,A(1)-1 DO BEGIN
IMAGE_V(*,*,indice)=INTxy(*,*)
ENDFOR

indice=DBLARR(A(0),A(0))

IF A(7) NE 0. THEN BEGIN
indice(WHERE(Vxy GE 0))=FIX(Vxy(WHERE(Vxy GE 0))*A(3)/cl/R)+ (A(1)-1)/2.
indice(WHERE(Vxy LT 0))=FIX(Vxy(WHERE(Vxy LT 0))*A(3)/cl/R)+ (A(1)-1)/2.-1
ENDIF

IF (A(7) EQ 0) AND (A(5) GE 0.) THEN BEGIN
indice(WHERE(Vxy GE 0))=FIX(Vxy(WHERE(Vxy GE 0))*A(3)/cl/R)+ (A(1)-1)/2.
ENDIF

IF (A(7) EQ 0) AND (A(5) LT 0.) THEN BEGIN
indice(WHERE(Vxy LT 0))=FIX(Vxy(WHERE(Vxy LT 0))*A(3)/cl/R)+ (A(1)-1)/2.-1
ENDIF

SPECTRE_pond2=1.-HISTOGRAM(indice(WHERE(r_proj LT 1)),MIN=0,BINSIZE=1.0,MAX=A(1))*(A(1)*A(2)*INTxy)

FOR i=0,A(0)-1 DO BEGIN
 FOR j=0,A(0)-1 DO BEGIN
      IF SQRT((i-(A(0)-1)/2.)^2+(j-(A(0)-1)/2.)^2) LT (A(0)-1)/2. THEN BEGIN
     SPECTRE_conv(*)=SPECTRE_conv(*)-A(2)*A(1)*INTxy(i,j)*PROFIL(DL,DL(indice(i,j)),A(8),A(1))
     SPECTRE_pond(indice(i,j))=SPECTRE_pond(indice(i,j))-A(1)*A(2)*INTxy(i,j)
     FOR cs=0, A(1)-1 DO BEGIN
           IF ABS(indice(i,j)-cs)  LT A(1)/2. THEN correction=PROFIL_indice(A(1)/2.+ABS(indice(i,j)-cs)) ELSE correction=0.
           IMAGE_V(i,j,cs)=IMAGE_V(i,j,cs)-A(2)*INTxy(i,j)*correction*A(1)
     ENDFOR
ENDIF
ENDFOR
ENDFOR

;--------------DEFINITIONS POUR TFs
dim2=(A(0)-1)*A(9)+1
zero=(dim2-1)/2.
pm=(A(0)-1)/2.
image=DBLARR(dim2,dim2)
V1=DBLARR(A(1))
V2=DBLARR(A(1))
V3=DBLARR(A(1))
TF_phi1=DBLARR(A(1))
TF_phi2=DBLARR(A(1))
TF_phi3=DBLARR(A(1))

;--------------CALCULS RELATIFS AUX BASES INTERFEROMETRIQUES
ANGLEeff1=A(13)-A(18)
Bx1=-A(12)*SIN(ANGLEeff1*!PI/180.)
By1=A(12)*COS(ANGLEeff1*!PI/180.)

ANGLEeff2=A(15)-A(18)
Bx2=-A(14)*SIN(ANGLEeff2*!PI/180.)
By2=A(14)*COS(ANGLEeff2*!PI/180.)

ANGLEeff3=A(16)-A(18)
Bx3=-A(16)*SIN(ANGLEeff3*!PI/180.)
By3=A(16)*COS(ANGLEeff3*!PI/180.)

;--------------CALCULS DIMENSIONNELS
taillepix=A(10)*6.96e10/(A(11)*3.08e18*pm)
champ=dim2*taillepix
uniaxe=DOUBLE(A(3))*1e-10/champ
x1=(findgen(dim2)-zero)*uniaxe

xx1=INTERPOL(INDGEN(dim2),x1,Bx1)
xy1=INTERPOL(INDGEN(dim2),x1,By1)

xx2=INTERPOL(INDGEN(dim2),x1,Bx2)
xy2=INTERPOL(INDGEN(dim2),x1,By2)

xx3=INTERPOL(INDGEN(dim2),x1,Bx3)
xy3=INTERPOL(INDGEN(dim2),x1,By3)

;--------------CALCULS DES TFs & DES PHASES

FOR indice=0.,A(1)-1 DO BEGIN
image(*,*)=0.
IMAGE_V(*,*,indice)=IMAGE_V(*,*,indice)/TOTAL(IMAGE_V(*,*,indice))

image(zero-pm:zero+pm,zero-pm:zero+pm)=IMAGE_V(*,*,indice)
image=SHIFT(image,zero+1,zero+1)
TFimage=SHIFT(FFT(image(*,*),1),zero,zero)
TFimage2D=SQRT(double(TFimage*CONJ(TFimage)))
phase2D=ATAN(IMAGINARY(TFimage),DOUBLE(TFimage))*180./!PI

V1(indice)=BILINEAR(TFimage2D,xx1,xy1)
TF_phi1(indice)=BILINEAR(phase2D,xx1,xy1)

V2(indice)=BILINEAR(TFimage2D,xx2,xy2)
TF_phi2(indice)=BILINEAR(phase2D,xx2,xy2)

V3(indice)=BILINEAR(TFimage2D,xx3,xy3)
TF_phi3(indice)=BILINEAR(phase2D,xx3,xy3)

IF A(19) NE 0 THEN BEGIN
PLOT,DL,SPECTRE_conv,YRANGE=[0.6,1],XRANGE=[-A(4),A(4)],XTITLE='lambda (A)', YTITLE='Flux'
PLOTS,DL(indice),0.6
PLOTS,DL(indice),1,/CONTINU
OPLOT,DL,SPECTRE_pond,LINESTYLE=2.

PLOT,IMAGE_V(pm,*,indice), XRANGE=[-10,40]
OPLOT,IMAGE_V(*,pm,indice),LINESTYLE=2.

PLOT,x1,TFimage2D(zero,*),XRANGE=[0,250],TITLE=' Fourier transform-V',XTITLE='m',YTITLE='V'
OPLOT,x1,TFimage2D(*,zero)
PLOTS,A(12),0
PLOTS,A(12),1,/CONTINU
PLOTS,A(14),0
PLOTS,A(14),1,/CONTINU,LINESTYLE=2.
PLOTS,A(16),0
PLOTS,A(16),1,/CONTINU,LINESTYLE=3.

PLOT,x1,phase2D(zero,*),XRANGE=[0,250],YRANGE=[-200,200],TITLE=' Fourier transform-phase',XTITLE='m',YTITLE='phase'
OPLOT,x1,phase2D(*,zero)
PLOTS,A(12),-200
PLOTS,A(12),200,/CONTINU
PLOTS,A(14),-200
PLOTS,A(14),200,/CONTINU,LINESTYLE=2.
PLOTS,A(16),-200
PLOTS,A(16),200,/CONTINU,LINESTYLE=3.

PLOT,DL,V1+1000.,YRANGE=[0.0,1.0],XTITLE='lambda (A)',YTITLE='V'
OPLOT,DL,V1
OPLOT,DL,V2,LINESTYLE=2.
OPLOT,DL,V3,LINESTYLE=3.

PLOT,DL,TF_phi1, YRANGE=[-50,50.],XTITLE='lambda (A)',YTITLE='Phase (deg)'
OPLOT,DL,TF_phi2,LINESTYLE=2
OPLOT,DL,TF_phi3,LINESTYLE=3

TVSCL,IMAGE_V(*,*,indice)
ENDIF
ENDFOR

OPENW,1,'XSGR4.dat',WIDTH=1000.
FOR indice=0.,A(1)-1 DO BEGIN
PRINTF,1,DL(indice),SPECTRE_conv(indice),TF_phi1(indice),TF_phi2(indice),TF_phi3(indice)
ENDFOR
CLOSE,1

END

