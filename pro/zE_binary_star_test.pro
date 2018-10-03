;changing eccentricity
window,1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
e2=0.9
omega2=90.
 orbitplot,eccen=e2,a=15.4,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.9,phase2=0.95;,XRANGE=[-32,15],YRANGE=[-15,15],xstyle=1,ystyle=1
 orbitplot,eccen=e2,a=15.4,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.57,phase2=0.75,orbitcol=fsc_color('red'),/oplot;XRANGE=[-32,15],YRANGE=[-21,21],xstyle=1,ystyle=1
 orbitplot,eccen=e2,a=15.4,omega=omega2,incl=0*!PI/180.,units=textoidl('AU'), $
   starrad=2.2,/degrees,/periastron,starname=' ', $
   position=[0.11,0.11,0.97,0.97],space=0.19,phase1=0.9942,phase2=1.0058,orbitcol=fsc_color('green'),/oplot;,XRANGE=[-32,15],YRANGE=[-21,21],xstyle=1,ystyle=1
END