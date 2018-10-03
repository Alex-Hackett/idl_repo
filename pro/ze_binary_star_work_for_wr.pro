PRO ZE_BINARY_STAR_WORK_FOR_WR

;eccentricity values for R145, Schnurr et al. 2009
e=0.7
MP=116. ;minimum masses, M sin^3 i.
MS=48.  ;minimum masses, M sin^3 i.
P=158./365. ;period in yers

;eccentricity values for NGC3603-A1, Schnurr et al. 2009
e=0.0
MP=116. ;minimum masses, M sin^3 i.
MS=89.  ;minimum masses, M sin^3 i.
P=3.77/365. ;period in yers

a=ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P(MP,MS,P)
print,'a=',a
phi_min=0.
phi_max=1.
phi_step=0.05
phi_size=(phi_max-phi_min)/phi_step + 1.
phi_vector=fltarr(phi_size)

FOR I=0, phi_size -1 DO phi_vector[i]=phi_min+(phi_step*i)

M_vector=2*!PI*phi_vector
eccanom_vector=keplereq(M_vector,e)
window,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
 orbitplot,eccen=e,a=a,omega=90.0,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015
 orbitplot,eccen=e,a=a,omega=90.0,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015,orbitcol=fsc_color('red'),/oplot
 orbitplot,eccen=e,a=a,omega=90.0,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.994,phase2=1.006,orbitcol=fsc_color('green'),/oplot

;changing eccentricity
window,1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
e2=0.0
omega2=90.
 orbitplot,eccen=e2,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015;,XRANGE=[-32,15],YRANGE=[-15,15],xstyle=1,ystyle=1
 orbitplot,eccen=e2,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015,orbitcol=fsc_color('red'),/oplot;XRANGE=[-32,15],YRANGE=[-21,21],xstyle=1,ystyle=1
 orbitplot,eccen=e2,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.9942,phase2=1.0058,orbitcol=fsc_color('green'),/oplot;,XRANGE=[-32,15],YRANGE=[-21,21],xstyle=1,ystyle=1


;changing mass of both stars 
fac_mass=0.3
MP=116.*fac_mass
MS=48.*fac_mass
P=158./365. ;period in yers
a2=ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P(MP,MS,P)

window,2
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
e2=0.7
omega2=90.
 orbitplot,eccen=e2,a=a2,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015
 orbitplot,eccen=e2,a=a2,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015,orbitcol=fsc_color('red'),/oplot
 orbitplot,eccen=e2,a=a2,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.9942,phase2=1.0058,orbitcol=fsc_color('green'),/oplot

;changing photospheric radius of the primary
rprim=2.0
window,4
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
omega2=90.
 orbitplot,eccen=e,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=rprim,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015
 orbitplot,eccen=e,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.985,phase2=1.015,orbitcol=fsc_color('red'),/oplot
 orbitplot,eccen=e,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.9942,phase2=1.0058,orbitcol=fsc_color('green'),/oplot
   
   
 ;to EPS
 
xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
PositionPlot3=[0.10, 0.12, 0.49, 0.49]
PositionPlot1=[0.10, 0.61, 0.49, 0.98]
PositionPlot4=[0.59, 0.12, 0.98, 0.49]
PositionPlot2=[0.59, 0.61, 0.98, 0.98]
set_plot,'ps'
;making psplots
xtitleplot='x [AU]'
ytitleplot='y [AU]'
!p.multi=[0, 1, 4]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=4.3
!X.charsize=4.3
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

width=20


device,filename='/Users/jgroh/temp/wr_orbit_geometry_sketch.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
LOADCT,0
 
 ;eccentricity
e=0.9
MP=90.
MS=30.
P=2022.7/365. ;period in yers
a=ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P(MP,MS,P)
phi_min=0.
phi_max=1.
phi_step=0.05
phi_size=(phi_max-phi_min)/phi_step + 1.
phi_vector=fltarr(phi_size)

FOR I=0, phi_size -1 DO phi_vector[i]=phi_min+(phi_step*i)
M_vector=2*!PI*phi_vector
eccanom_vector=keplereq(M_vector,e)

phase1obs=0.977
phase2obs=1.023

ptobs=56
ptpos=28
space1=0.60
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
 orbitplot,eccen=0.9,a=a,omega=90.0,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ', $
   position=PositionPlot1,space=space1,phase1=phase1obs,phase2=phase2obs,xtitle=xtitleplot, ytitle=ytitleplot
 orbitplot,eccen=0.9,a=a,omega=90.0,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0,/degrees,/periastron,starname=' ',phasethick=ptobs, $
   position=PositionPlot1,space=space1,phase1=phase1obs,phase2=phase2obs,orbitcol=fsc_color('red'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot
 orbitplot,eccen=0.9,a=a,omega=90.0,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0,/degrees,/periastron,starname=' ',phasethick=ptpos, $
   position=PositionPlot1,space=space1,phase1=0.994,phase2=1.006,orbitcol=fsc_color('green'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot
  eye,9,-0.03,/data,size=3,angle=180

;changing eccentricity
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
e2=0.00
omega2=90.
 orbitplot,eccen=e2,a=15.4,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ', $
   position=PositionPlot2,space=0.25,phase1=phase1obs,phase2=phase2obs,xtitle=xtitleplot, ytitle=ytitleplot;,XRANGE=[-32,15],YRANGE=[-15,15],xstyle=1,ystyle=1
 orbitplot,eccen=e2,a=15.4,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ',phasethick=ptobs, $
   position=PositionPlot2,space=0.25,phase1=phase1obs,phase2=phase2obs,orbitcol=fsc_color('red'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot;XRANGE=[-32,15],YRANGE=[-21,21],xstyle=1,ystyle=1
 orbitplot,eccen=e2,a=15.4,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ',phasethick=ptpos, $
   position=PositionPlot2,space=0.25,phase1=phase1obs,phase2=phase2obs,orbitcol=fsc_color('green'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot;,XRANGE=[-32,15],YRANGE=[-21,21],xstyle=1,ystyle=1
  eye,29,-0.03,/data,size=3,angle=180

MP=4.
MS=4.
P=2024./365. ;period in yers
a2=ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P(MP,MS,P)


;changing mass of both stars
space3=0.70

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
e2=0.9
omega2=90.
 orbitplot,eccen=e2,a=a2,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ', $
   position=PositionPlot3,space=space3,phase1=phase1obs,phase2=phase2obs,xtitle=xtitleplot, ytitle=ytitleplot
 orbitplot,eccen=e2,a=a2,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', phasethick=ptobs,$
   position=PositionPlot3,space=space3,phase1=phase1obs,phase2=phase2obs,orbitcol=fsc_color('red'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot
 orbitplot,eccen=e2,a=a2,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.2,/degrees,/periastron,starname=' ', phasethick=ptpos,$
   position=PositionPlot3,space=space3,phase1=phase1obs,phase2=phase2obs,orbitcol=fsc_color('green'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot
  eye,4.5,-0.03,/data,size=3,angle=180
  
;changing photospheric radius of the primary
space4=0.6
rprim=5.5
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
omega2=90.
 orbitplot,eccen=0.9,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=rprim,/degrees,/periastron,starname=' ', $
   position=PositionPlot4,space=space4,phase1=phase1obs,phase2=phase2obs,xtitle=xtitleplot, ytitle=ytitleplot
 orbitplot,eccen=0.9,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.,/degrees,/periastron,starname=' ', phasethick=ptobs,$
   position=PositionPlot4,space=space4,phase1=phase1obs,phase2=phase2obs,orbitcol=fsc_color('red'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot
 orbitplot,eccen=0.9,a=a,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=0.,/degrees,/periastron,starname=' ',phasethick=ptpos, $
   position=PositionPlot4,space=space4,phase1=phase1obs,phase2=phase2obs,orbitcol=fsc_color('green'),/oplot,xtitle=xtitleplot, ytitle=ytitleplot
   eye,10,-0.03,/data,size=3,angle=180



;legends
lc=2.0 ;legend charsize
ltt=5
xyouts, 0.11,0.95,/NORMAL,TEXTOIDL('a) R_{phot,A}=2.2AU,e=0.90,M_P=90Msun,M_S=30Msun'),charsize=lc;,charthick=lt
xyouts, 0.60,0.95,/NORMAL,TEXTOIDL('b) R_{phot,A}=2.2AU,e=0.00,M_P=90Msun,M_S=30Msun'),charsize=lc;,charthick=lt
xyouts, 0.11,0.45,/NORMAL,TEXTOIDL('c) R_{phot,A}=2.2AU,e=0.90,M_P=4Msun,M_S=4Msun'),charsize=lc;,charthick=lt
xyouts, 0.60,0.45,/NORMAL,TEXTOIDL('d) R_{phot,A}=5.5sAU,e=0.90,M_P=90Msun,M_S=30Msun'),charsize=lc;,charthick=lt

device,/close
set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
!P.Background = fsc_color('white')
   
END