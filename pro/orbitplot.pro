PRO orbitplot,a=a,eccen=eccen,lonasc=xlonasc,incl=xincl,omega=xomega, $
              position=position,space=space,units=units,xtitle=xtitle, $
              ytitle=ytitle,periastron=periastron,degrees=degrees, $
              nostar=nostar,starrad=starrad,oplot=oplot,starname=starname, $
              phase1=phase1,phase2=phase2,orbitcol=orbitcol, $
              compsymbol=compsymbol,symbolsize=symbolsize,shownodes=shownodes, $
              dirarrow=arrowdir,phasethick=phasethick,posdash=posdash, $
              nodata=nodata, _extra=extra

;+
; NAME:
;       orbitplot
;
;
; PURPOSE:
;       make plot of orbit in binary star system. Observers look at
;       the orbit from the left and the companion circles the star in
;       the clockwise direction
;
;
; CATEGORY:
;       astronomy
;
;
; CALLING SEQUENCE:
;       orbitplot
;
;
; INPUTS:
;      
;
;
; OPTIONAL INPUTS:
;      a     : semimajor axis of the orbit (default: 1.)
;      eccen : Eccentricity of the orbit (default: 0.)
;      lonasc: Longitude of ascending node (capital Omega; radians; default:0)
;      incl  : Inclination (radians; not used; default: 0.)
;      omega : Longitude of periastron (little omega; radians,
;              default: 0.)
;      position: position of figure in normal coordinates 
;              (default:0.1,0.1,0.95,0.95)
;      space  : fraction of free space around the ellipse (default: 0.05)
;      units  : length unit of the plot (i.e., units of semimajor
;               axis)
;      xtitle, ytitle: title for the x- and y-axis. 
;              Default (x-, and y-), if set, the units-keyword is ignored
;      starrad: radius of the star (same units as semi-major axis)
;              if given, a filled circle with radius starrad is drawn,
;              if not, a dot at (0,0) designating the position of the
;              star is plotted (default; but see keyword nostar)
;      starname: name of the central star, overplotted on the star
;              (unless nostar-keyword is given)
;      phase1: phases to plot symbols on orbit (can be array)
;      phase2: ending phase of highlighted orbit segment
;              (if phase1 and phase2 are given, draw segment from phase1
;              to phase2, NOTE: in this case phase1 must be scalar)
;      phasethick: thickness of highlighted ellipse segment (default: 3)
;      posdash : draw line perpendicular to ellipse at start and stop
;                of highlighted orbit segment
;      dirarrow: draw an arrow indicating the direction of motion
;                from phase1 to phase2 (note phase2 MUST be greater
;                than phase1)
;      orbitcol: color for the orbit segment
;      compsymbol: symbol to be plotted at the position of the stellar
;                  companionorbit, works only if phase2 is not defined
;                  (see IDL Help for PSYM, default: 0 (cross))
;      symbolsize: sets symbolsize of input compsymbol (default: 1.0)
;      shownodes: shows the line of nodes via a dotted line
;
; KEYWORD PARAMETERS:
;      nostar: if set, no position or circle is plotted at the
;              stellar position
;      degrees: if set, the angular input parameters are in DEGREES
;      periastron: if set, draw triangular symbol at periastron
;      oplot  : if set, the ellipse is drawn in the currently setup
;               coordinate system (e.g., for plotting many cometary
;               orbits)
;      nodata : just setup the figure, do not plot the ellipse
;      
;  furthermore, the routine also accepts all keyword parameters of the
;  plot and oplot commands via the _extra mechanism, thus allowing one
;  to plot, e.g., colored orbits or change the thickness of the
;  ellipse that is to be plotted
;
;
; OUTPUTS:
;      none
;
;
; SIDE EFFECTS:
;      a plot is drawn
;
;
; RESTRICTIONS:
;      the eccentricity must be less than unity; parabolic or
;      hyperbolic orbits are not allowed at the moment.
;
;
; PROCEDURE:
;      the ellipse coordinates are computed, then the bounding box
;      is determined and the coordinate system is setup in a way that
;      the x- and y-coordinates have the same length
;
;
; EXAMPLE:
; ;
; **********************************
; Orbits of the inner solar system:
; ; Mars    
; orbitplot,a= 1.524,eccen=0.093,incl= 1.85,lonasc= 49.58, omega=336.0
; ; Mercury
; orbitplot,a= 0.387,eccen=0.206,incl= 7.00,lonasc= 48.33, omega= 77.5,/oplot
; ; Venus   
; orbitplot,a= 0.723,eccen=0.007,incl= 3.39,lonasc= 76.68, omega=131.5,/oplot
; ; Earth   
; orbitplot,a= 1.000,eccen=0.017,incl= 0.00,lonasc=-11.26, omega=102.9,/oplot
; stop
; ;
; **********************************
; Orbits of the outer solar system:
; ; Pluto   
; orbitplot,a=39.482,eccen=0.249,incl=17.14,lonasc=110.30, omega=224.1
; ; Jupiter 
; orbitplot,a= 5.203,eccen=0.048,incl= 1.31,lonasc=100.56, omega= 14.8,/oplot
; ; Saturn  
; orbitplot,a= 9.537,eccen=0.054,incl= 2.48,lonasc=113.72, omega= 92.4,/oplot
; ; Uranus  
; orbitplot,a=19.191,eccen=0.047,incl= 0.77,lonasc= 74.23, omega=171.0,/oplot
; ; Neptune 
; orbitplot,a=30.069,eccen=0.009,incl= 1.77,lonasc=131.72, omega= 45.0,/oplot
;
; **********************************
; Make PNG of the Vela X-1 system
; set_plot,'Z'
; device,set_resolution=[500,500]
; orbitplot,eccen=0.1885,a=53,omega=150.6,units=textoidl('R_O'), $
;   starrad=30.,/degrees,/periastron,starname='HD 77581', $
;   position=[0.11,0.11,0.97,0.97],space=0.07
; image=tvrd()
; write_png,'velax1.png',image
;
;
; MODIFICATION HISTORY:
;
; $Log: orbitplot.pro,v $
; Revision 1.5  2005/02/22 15:55:05  wilms
; replaced keyword arrowdir with dirarrow, since it produced a clash
; with IDL's keyword abbreviation mechanism.
;
; Revision 1.4  2005/02/18 23:28:54  wilms
; added shownodes, arrowdir, phasethick, posdash, nodata and _extra keywords
;
; Revision 1.3  2003/04/01 07:41:58  gleiss
; added optional inputs compsymbol and symbolsize
;
; Revision 1.2  2002/09/19 20:55:50  wilms
; added option to highlight orbital segment or specific phases
;
; Revision 1.1  2002/09/09 14:53:28  wilms
; initial release
;
; CVS Version 1.3 2003/04/01 gleiss
; added optional inputs compsymbol and symbolsize
;
;-

  IF (n_elements(a) EQ 0) THEN a=1.
  IF (n_elements(eccen) EQ 0) THEN eccen=0.
  IF (n_elements(xlonasc) EQ 0) THEN xlonasc=0.
  IF (n_elements(xincl) EQ 0) THEN xincl=0.
  IF (n_elements(xomega) EQ 0) THEN xomega=0.
  IF (n_elements(position) EQ 0) THEN position=[0.1,0.1,0.95,0.95]
  IF (n_elements(space) EQ 0) THEN space=0.05
  IF (n_elements(units) EQ 0) THEN units=''
  IF (n_elements(compsymbol) EQ 0) THEN compsymbol=1
  IF (n_elements(symbolsize) EQ 0) THEN symbolsize=1.0
  IF (n_elements(phasethick) EQ 0) THEN phasethick=3
 

  lonasc=xlonasc
  incl=xincl
  omega=xomega
  IF (keyword_set(degrees)) THEN BEGIN 
      lonasc=lonasc*!DPI/180D0
      incl=incl*!DPI/180D0
      omega=omega*!DPI/180D0
  ENDIF 

  ;; semi-latus rectum 
  ell=a*(1.-eccen)*(1.+eccen)

  ;; distance of periastron from companion star
  dperi=a*(1.-eccen)

  ;; distance of apastron from companion star
  dapa=a*(1.+eccen)

  ;; true anomaly
  numpts=500
  theta=2.*!DPI*findgen(numpts)/(numpts-1)

  ;; radial distance as a function of true anomaly
  r=ell/(1.+eccen*cos(theta))

  ;; x- and y-coordinates of the orbit
  xx=r*sin(theta+omega)
  yy=r*cos(theta+omega)

  ;; setup coordinate system, somewhat complicated because we need to
  ;; ensure that the x- and y-coordinates have the same units...

  IF (NOT keyword_set(oplot)) THEN BEGIN 
      ;; "Bounding Box" of orbit
      xmin=min(xx)
      xmax=max(xx)
      xdist=(1.+space)*(xmax-xmin)

      ymin=min(yy)
      ymax=max(yy)
      ydist=(1.+space)*(ymax-ymin)

      ;; figure out aspect ratio of the normalized coordinate system
      devco=convert_coord([0.,1.],[0.,1.],/normal,/to_device)

      ;; width and height of plot in cm 
      ;; (takes into account non-square pixels)
      dx=(devco[0,1]-devco[0,0])/!d.x_px_cm
      dy=(devco[1,1]-devco[1,0])/!d.y_px_cm

      ;; aspect ratio
      aspect=dy/dx

      ;; figure out xrange and yrange
      ;; this depends on whether the extent of the figure is larger
      ;; in the x- or in the y-direction

      ;; aspect ratio in normalized coordinates
      norasp=(position[3]-position[1])/(position[2]-position[0])

      IF (ydist/(aspect*norasp) GE xdist) THEN BEGIN 
          ywid=ydist
          xwid=ywid/(aspect*norasp)
      ENDIF ELSE BEGIN 
          xwid=xdist
          ywid=xwid*aspect*norasp
      ENDELSE 
      xrange=(xmin+xmax)/2.+ [-0.5,+0.5]*xwid
      yrange=(ymin+ymax)/2.+ [-0.5,+0.5]*ywid

      IF (n_elements(xtitle) EQ 0) THEN BEGIN 
          xtitle='z'
          IF (units NE '') THEN xtitle=xtitle+' ['+units+']'
      ENDIF 
      IF (n_elements(ytitle) EQ 0) THEN BEGIN 
          ytitle='x'
          IF (units NE '') THEN ytitle=ytitle+' ['+units+']'
      ENDIF 

      plot,xrange,yrange,xrange=xrange,yrange=yrange,xstyle=1,ystyle=1,$
        xtitle=xtitle,ytitle=ytitle,/nodata,position=position,_extra=extra
  ENDIF 
  
  IF (keyword_set(nodata)) THEN return

  ;;
  ;; Plot the orbit
  ;;
  oplot,xx,yy,_extra=extra

  ;;
  ;; special points on the orbit
  ;;
  
  ;; position of periastron 
  IF (keyword_set(periastron)) THEN BEGIN 
      ;; theta=0: periastron
      rperi=ell/(1.+eccen)
      xperi=rperi*sin(omega)
      yperi=rperi*cos(omega)

      plots,xperi,yperi,psym=5
  ENDIF 

  ;; put star at 0,0
  IF (NOT keyword_set(nostar)) THEN BEGIN 
      IF (n_elements(starrad) EQ 0) THEN BEGIN 
          plots,0,0,psym=3
      ENDIF ELSE BEGIN 
          angle=2.*!dpi*findgen(500)/499.
          xxs=starrad*cos(angle)
          yys=starrad*sin(angle)
          polyfill,xxs,yys
      ENDELSE 
      IF (n_elements(starname) NE 0) THEN BEGIN
          xyouts,0.,0.,starname,alignment=0.5,color=0.
      ENDIF 
  ENDIF 

  ;; 
  ;; Highlight orbit segment from phase1 to phase2
  ;;
  IF (n_elements(phase1) NE 0) THEN BEGIN 

      IF (n_elements(phase2) EQ 0) THEN BEGIN 
          phase=phase1
      ENDIF ELSE BEGIN 
          numpts=50
          phase=phase1+(phase2-phase1)*findgen(numpts)/(numpts-1)
      ENDELSE 

      ;; mean anomaly
      meananom=2.*!dpi*phase

      ;; Now solve Kepler for each of the times
      eccanom=keplereq(meananom,eccen)

      ;; True anomaly from eccentric anomaly
      theta=2.*atan(sqrt((1.+eccen)/(1.-eccen))*tan(eccanom/2.))

      r=ell/(1.+eccen*cos(theta))

      ;; x- and y-coordinates of the orbit
      xxo=r*sin(theta+omega)
      yyo=r*cos(theta+omega)

      ;;
      ;; Symbol at phase 1
      ;;
      IF (n_elements(phase2) EQ 0) THEN BEGIN 
        plots,xxo,yyo,psym=compsymbol,symsize=symbolsize,color=orbitcol
      ENDIF ELSE BEGIN 
        oplot,xxo,yyo,thick=phasethick,color=orbitcol

        IF (keyword_set(posdash)) THEN BEGIN 
            IF (phase2 LT phase1) THEN BEGIN 
                message,'arrowphase: phase2 must be greater than phase1'
            ENDIF 

            dx=xxo[numpts-2]-xxo[numpts-1]
            dy=yyo[numpts-2]-yyo[numpts-1]
            len=sqrt(dx^2+dy^2)
            dx=0.03*a*dx/len
            dy=0.03*a*dy/len
            oplot,xxo[numpts-1]+[+dy,-dy], yyo[numpts-1]+[-dx,+dx], $
              thick=phasethick

            dx=xxo[1]-xxo[0]
            dy=yyo[1]-yyo[0]
            len=sqrt(dx^2+dy^2)
            dx=0.03*a*dx/len
            dy=0.03*a*dy/len
            oplot,xxo[0]+[+dy,-dy], yyo[0]+[-dx,+dx], $
              thick=phasethick
        ENDIF

        IF (keyword_set(arrowdir)) THEN BEGIN 
            IF (phase2 LT phase1) THEN BEGIN 
                message,'arrowdir: phase2 must be greater than phase1'
            ENDIF 
            dx=xxo[numpts-2]-xxo[numpts-1]
            dy=yyo[numpts-2]-yyo[numpts-1]
            len=sqrt(dx^2+dy^2)
            dx=0.06*a*dx/len
            dy=0.06*a*dy/len

            phi=30.*!dpi/180. ;; arrow with 30deg opening angle

            cp=cos(phi)
            sp=sin(phi)

            ddx1= cp*dx + sp*dy
            ddy1=-sp*dx + cp*dy

            ddx2= cp*dx - sp*dy
            ddy2= sp*dx + cp*dy

            oplot,xxo[numpts-1]+[ddx1,0.,ddx2], yyo[numpts-1]+[ddy1,0.,ddy2], $
              thick=phasethick
        ENDIF

      ENDELSE 

  ENDIF 

  ;; 
  ;; show line of nodes
  ;;
  IF (keyword_set(shownodes)) THEN BEGIN 
      ;; true anomaly for ascending and descending node
      theta=[-omega,!dpi-omega]
      r=ell/(1.+eccen*cos(theta))

      ;; x- and y-coordinates of the orbit
      xxn=r*sin(theta+omega)
      yyn=r*cos(theta+omega)

      oplot,xxn,yyn,linestyle=1
  ENDIF 

END 
