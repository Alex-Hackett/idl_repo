function mk_dem,type,logT=logT,pardem=pardem,indem=indem,$
	xcur=xcur,ycur=ycur,loopy=loopy,lcomp=lcomp, _extra=e
;+
;function	mk_dem
;	returns DEM(T) [cm^-5]
;
;syntax
;	DEM=mk_dem(type,logT=logT,indem=indem,pardem=pardem,$
;	sloop=sloop,xcur=xcur,ycur=ycur,loopy=loopy,lcomp=lcomp,$
;	weight=weight,/gauss,verbose=verbose)
;
;description
;	this provides a way to generate DEMs quickly by various means.
;	TYPE, a string variable, decides what sort of method to use to
;	generate the DEM.  TYPE can be
;		'help'
;		'constant'	PARDEM = value
;		'chebyshev'	PARDEM = coefficients
;		'cursor'	PARDEM = max range in DEM
;		'interpolate'	PARDEM = original logT
;		'loop'   	PARDEM = original logT
;		'rebin' 	PARDEM = rebinning scales
;		'spline'	PARDEM = logT location of points
;		'varsmooth'	PARDEM = smoothing scales
;		'delta'		PARDEM = logT locations of EM components
;	if a particular method requires an input DEM (e.g., 'interpolate'),
;	feed that in via the keyword parameter INDEM.
;	any parameters that the method requires go in via PARDEM (e.g., for
;	'interpolate', PARDEM would be the temperature grid at which INDEM
;	is defined).
;
;parameters
;	type	[INPUT; required] specifies what type of DEM.
;		* if 'help', prints out available options
;
;keywords
;	logT	[INPUT; default=findgen(81)*0.05+4] log10(T [K]) at which
;		to return DEM(T)
;	pardem	[INPUT] parameters to be used to figure out the DEM.
;		strictly case dependent.
;	indem	[INPUT] for those cases that require an input/initial DEM
;	xcur	[I/O] cursor X locations for the "cursor" option
;	ycur	[I/O] cursor Y locations for the "cursor" option
;	loopy	[INPUT] set to the maximum number of loop components
;		that should be used for LOOP type DEMs
;		* the top LOOPY EM values are kept as is, and the rest are
;		  discarded
;		* LCOMP lists the components that _must_ be kept
;	lcomp	[INPUT] scalar or vector which contains the indices of
;		the parameters that must be used to compute loops
;		  -- if LCOMP exceeds LOOPY, only the largest of the
;		     specified components that are within quota are kept
;		  -- if LCOMP is less than LOOPY, the remaining slots are
;		     filled in by the largest of the remaining components
;	_extra	[INPUT ONLY] allows setting defined keywords to subroutines
;		-- VARSMOOTH (WEIGHT, GAUSS, STEPS)
;		-- LOOPEM (SLOOP, VERBOSE)
;
;subroutines
;	CHEBYSHEV, VARSMOOTH, LOOPEM
;
;history
;	vlk (Jun98)
;	added option to interpolate (VK; Dec98)
;	added option for variable scale rebin (VK; 1999)
;	added option to interactively specify DEM (VK; MMJul)
;	rebin option now works (VK; AugMM)
;	added keywords XCUR and YCUR (VK; JanMMI)
;	converted array notation to IDL 5 (VK; Apr02)
;	added 'delta' option (VK; Mar03)
;	now correctly converts EM to DEM for 'delta' (VK; Jun03)
;	added keyword LOOPY; allows limiting the number of T components
;	  for LOOP (VK; Mar05)
;	added keyword LCOMP (VK; Jun05)
;	button press status now stored in !MOUSE, not !ERR (VK; Apr09)
;-

;	usage
usage=[	'Usage: DEM=mk_dem(type,logT=logT,indem=indem,pardem=pardem,$',$
	'       sloop=sloop,xcur=xcur,ycur=ycur,loopy=loopy,lcomp=lcomp,$',$
	'       weight=weight,/gauss,verbose=verbose)',$
	'  returns DEM(T)',$
	'',$
	'TYPE=',$
	'  H*elp:-  print this message',$
	'  CO*nstant:- PARDEM=value; DEM[T]=pardem[0]',$
	'  CH*ebyshev:- Chebyshev polynomial; PARDEM=[COEFFS]',$
	'  CU*rsor:- set DEM interactively; PARDEM=[minDEM,maxDEM]; XCUR,YCUR',$
	'  R*ebin:- variable scale rebinning; PARDEM=[STEPPED INDICES]',$
	'  I*nterpolate:- PARDEM=inlogT; DEM[logT]=interp(INDEM[inlogT],inlogT,LOGT)',$
	'  S*pline:- spline interpolation; PARDEM=[LOGT]',$
	'  V*arsmooth:- variable scale smoothing; PARDEM=[SCALES]',$
	'  L*oop:- loop-model DEMs from EMs; PARDEM=[LOGTmax],INDEM==EM[LOGTmax]',$
	'         also uses keywords SLOOP, LOOPY, LCOMP',$
	'  D*elta:- multiple EM components: PARDEM=[LOGT],INDEM=EM[LOGT]',$
	'-----------------------------------------------']
nu=n_elements(usage)

;	check input
if n_elements(type) ne 1 then todo='help' else todo=strlowcase(strtrim(type,2))
if not keyword_set(logT) then logT=findgen(81)*0.05+4.
nT=n_elements(logT) & np=n_elements(pardem) & nD=n_elements(indem)

;	what type?
code='h'					;default
if strpos(todo,'h') eq 0 then code='h'		;help
if strpos(todo,'i') eq 0 then code='i'		;interpolate
if strpos(todo,'co') eq 0 then code='co'	;DEM(T)=const.
if strpos(todo,'ch') eq 0 then code='ch'	;Chebyshev polynomials
if strpos(todo,'cu') eq 0 then code='cu'	;cursor interactive
if strpos(todo,'s') eq 0 then code='s'		;Spline interpolation
if strpos(todo,'v') eq 0 then code='v'		;Variable scale smoothing
if strpos(todo,'r') eq 0 then code='r'		;Variable scale rebinning
if strpos(todo,'l') eq 0 then code='l'		;loop-model DEM from EM(T)
if strpos(todo,'d') eq 0 then code='d'		;multi EM components

idlvers=float(!VERSION.release) & if idlvers le 0 then idlvers=7

;	figure out what to do
case code of
  'co': begin					;(constant
    if keyword_set(pardem) then dem0=pardem[0] else dem0=1.
    dem=dblarr(nT)+dem0
  end						;constant)
  'i': begin					;(interpolate
    mD=n_elements(indem) & mT=n_elements(pardem)
    if mT eq 0 then begin		;(make sure TLOG is set
      if mD le 1 then begin
	if mD eq 0 then indem=1e12
	mD=1 & tlog=6. & mT=1
      endif else begin
	mT=mD & tlog=findgen(mT)*(4./float(mT-1.))+4.
      endelse
    endif else tlog=pardem		;MT)
    if mD eq 0 then begin		;(make sure INDEM is set
      indem=dblarr(mT)+1d12 & mD=mT
    endif				;MD)
    if mT ne mD then begin		;(make sure INDEM(PARDEM) makes sense
      message,'input DEM and temperature grid do not match!',/info
      message,'interpolating the grid to match DEM',/info
      tlog=interpol(tlog,mD) & mT=mD
    endif				;MT v/s MD)
    ;
    if mD gt 1 then begin
      dem=((interpol(indem,tlog,logT) > (min(indem))) < (max(indem)))
    endif else begin
      if nT gt 1 then dlogT=median(abs(logT[1:*]-logT)) else dlogT=1./alog(10.)
      dT=min(abs(tlog-logT),iT) & dem=0*logT & dem[iT]=indem[0]/dlogT/alog(10.)
    endelse
  end						;interpolate)
  'ch': begin					;(chebyshev
    if np ge 2 then coeff=pardem else begin
      if nD lt 2 then coeff=[2.,0] else coeff=chebyshev(indem,-1)
    endelse
    dem0=chebyshev(coeff,1)
    ndem0=n_elements(dem0) & tpar=interpol(logT,ndem0)
    if ndem0 gt 2 then dem=spline(tpar,dem0,logT) else $
      dem=interpol(dem0,tpar,logt)
  end						;chebyshev)
  's': begin					;(spline
    if np ne 0 then tlog=pardem
    if nD ne 0 then dem0=indem
    if np le 1 then begin & tlog=[4.,8.] & np=2L & endif
    if nD le 1 then begin & dem0=[1.,1.] & nD=2L & endif
    if np lt nD then begin & tlog=interpol(pardem,nD) & np=nD & endif
    if nD lt np then begin & dem0=interpol(indem,np) & nD=np & endif
    ;
    if nD gt 2 then dem=spline(tlog,dem0,logT) else $
      dem=interpol(dem0,tlog,logt)
  end						;spline)
  'v': begin					;(varsmooth
    if np ne 0 then ss=pardem
    if nD ne 0 then dem0=indem
    if np le 1 then begin & ss=[3.,3.] & np=2L & endif
    if nD le 1 then begin & dem0=[1.,1.] & nD=2L & endif
    if np ne nT then ss=interpol(ss,nT)
    if nD ne nT then dem0=interpol(dem0,nT)
    ;
    dem=varsmooth(dem0,ss, _extra=e)
  end						;varsmooth)
  'r': begin					;(variable rebin
    if np ne 0 then ii=pardem
    if nD ne 0 then dem0=indem else dem0=0*logT+1
    dem=varsmooth(dem0,ii,/steps, _extra=e)
    ;message,'not implemented yet, sorry!',/info & dem=dem0
  end						;variable rebin)
  'cu': begin					;(cursor selection
    xr=[min(logT),max(logT)] & yr=[1e10,1e14]	;the default range
    if np eq 1 then yr=pardem[0]*[100.,0.01]
    if np gt 1 then yr=[min(pardem),max(pardem)]
    ylog=1	;plot in log scale
    if yr[0] le 0 or yr[1] lt 80 then ylog=0
    cursor_help=['	CLICK mouse buttons to edit points',$
	'LEFT: mark point; MIDDLE; delete point; RIGHT: quit',$
	'	CLICK+DRAG move points',$
	'LEFT: move point; MIDDLE: undo last; RIGHT: show help']
    for i=0,n_elements(cursor_help)-1 do message,cursor_help[i],/info
    inok='ok' & nxc=n_elements(xcur) & nyc=n_elements(ycur)
    if nxc eq 0 then inok='missing XCUR' else $
     if nyc eq 0 then inok='missing YCUR' else $
      if nxc ne nyc then inok='YCUR[XCUR] incompatible with XCUR'
    if inok eq 'ok' then begin
      xx=xcur & yy=ycur & dem=mk_dem('spline',logT=logT,indem=yy,pardem=xx)
    endif else begin
      xx=[xr[0]-1.] & yy=[0.5*(yr[0]+yr[1])] & dem=yy+dblarr(nT)
    endelse
    oldxx=xx & oldyy=yy & olddem=dem
    nx=n_elements(xx)
    ;if xx[0] lt xr[0] then nx=0L
    oldnx=nx
    plot,logT,dem,xrange=xr,yrange=yr,/xs,/ys,ylog=ylog,$
	xtitle='log T',ytitle='DEM'
    go_on=1
    while go_on do begin			;{endless loop to mark points
      ;	click and/or drag
      cursor,x0,y0,/down,/data
      if idlvers lt 5 then mbutton=!err else mbutton=!MOUSE.button
      cursor,x1,y1,/up,/data
      ;	drag?
      draglim=xr[1]-xr[0] < (yr[1]-yr[0]) ;shaky mice
      drag=abs(x1-x0)+abs(y1-y0)

      if drag lt 1e-4*draglim then begin	;(CLICK!
	if mbutton eq 1 then begin		;(	left click
	  ;	ADD POINT
	  if nx eq 0 then begin
	    xx=[x0] & yy=[y0] & nx=1L
	  endif else begin
	    oldxx=xx & oldyy=yy & oldnx=nx
	    xx=[xx,x0] & yy=[yy,y0] & nx=nx+1L
	    os=sort(xx) & xx=xx[os] & yy=yy[os]
	  endelse
	endif					;left click)
	if mbutton eq 2 then begin		;(	middle click
	  ;	DELETE POINT
	  if nx gt 0 then begin
	    dmin=min(sqrt((xx-x0)^2+(yy-y0)^2),idmin)
	    ox=where(lindgen(nx) ne idmin,mox)
	    oldxx=xx & oldyy=yy & oldnx=nx
	    if mox gt 0 then begin
	      xx=xx[ox] & yy=yy[ox] & nx=nx-1L
	    endif else begin
	      xx=[xr[0]-1.] & yy=[0.5*(yr[0]+yr[1])] & nx=0L
	    endelse
	  endif else message,'no points to delete',/info
	endif					;middle click)
	if mbutton eq 4 then begin		;(	right click
	  ;	EXIT
	  go_on=0
	endif					;right click)
      endif else begin				;CLICK)(+DRAG!
	if mbutton eq 1 then begin		;(	left click
	  ;	MOVE POINT
	  if nx gt 0 then begin
	    dmin=min(sqrt((xx-x0)^2+(yy-y0)^2),idmin)
	    oldxx=xx & oldyy=yy
	    xx[idmin]=x1 & yy[idmin]=y1
	    os=sort(xx) & xx=xx[os] & yy=yy[os]
	  endif else message,'no points to move',/info
	endif					;left click)
	if mbutton eq 2 then begin		;(	 middle click
	  ;	UNDO LAST
	  txx=xx & tyy=yy & tnx=nx
	  xx=oldxx & yy=oldyy & nx=n_elements(xx)
	  if xx[0] lt xr[0] then nx=nx-1L
	  oldxx=txx & oldyy=tyy & oldnx=nx
	endif					;middle click)
	if mbutton eq 4 then begin		;(	right click
	  for i=0,n_elements(cursor_help)-1 do message,cursor_help[i],/info
	endif					;right click)
      endelse					;CLICK+DRAG)

      olddem=dem
      if nx le 1 then dem=yy[0]+dblarr(nT) else $
       dem=mk_dem('spline',logT=logT,indem=yy,pardem=xx)
      dem = (dem > yr[0]) < (yr[1])
      plot,logT,dem,xrange=xr,yrange=yr,/xs,/ys,ylog=ylog,$
	xtitle='log T',ytitle='DEM'
      oplot,xx,yy,psym=2,symsize=1.5
      oplot,logT,olddem,line=1

    endwhile					;end loop with right click}
    if n_elements(xx) gt 0 then begin
      xcur=xx & ycur=yy			;outputs
    endif
  end						;cursor select)
  'l': begin					;(loop DEM
    ok='ok' & mT=n_elements(pardem) & mD=n_elements(indem) & dem=dblarr(nT)
    if mT eq 0 then ok='set PARDEM to log(Tmax) for loops' else $
     if mD eq 0 then ok='set INDEM to integrated EMs' else $
      if mT ne mD then ok='INDEM and PARDEM are inconsistent'
    if ok ne 'ok' then begin
      message,ok,/info & return,dem
    endif
    logTmax=[pardem] & EMs=[indem]
    if keyword_set(loopy) then begin
      nloop=n_elements(pardem)
      if loopy[0] gt 1 and nloop gt 1 then nloop=long(loopy[0])
      ;
      if keyword_set(lcomp) then begin		;(LCOMP
	ncomp=n_elements(EMs)
	mcomp=n_elements(lcomp) & if lcomp[0] eq -1 then mcomp=0L
	if mcomp gt 0 then begin
	  icomp=[lcomp]
	  ok=where(icomp ge 0 and icomp le ncomp,mok)
	endif else mok=0
	if mok gt 0 then begin			;(ICOMP
	  icomp=icomp[ok]
	  isl=intarr(n_elements(EMs)) & isl[icomp]=1
	  oc=where(isl eq 1,moc)
	  if moc gt 0 then begin		;(OC
	    tc=logTmax[oc] & emc=EMs[oc]
	    osc=reverse(sort(emc))
	    if nloop le moc then osc=oc[osc[0L:nloop-1L]] else begin
	      ox=where(isl eq 0,mox)
	      if mox gt 0 then begin		;(OX
	        tx=logTmax[ox] & emx=EMs[ox]
	        osc=[oc[osc],reverse(sort(emx))]
		if nloop le moc+mox then osc=osc[0L:nloop-1L]
	      endif				;OX)
	    endelse
	    osc=osc[0L:nloop-1L]
	    logTmax=logTmax[osc] & EMs=EMs[osc]
	  endif					;OC)
	endif else begin			;ICOMP)(no ICOMP
	  ; same as no LCOMP
          osl=reverse(sort(EMs)) & osl=osl[0L:nloop-1L]
          logTmax=logTmax[osl] & EMs=EMs[osl]
	endelse					;no ICOMP)
      endif else begin				;LCOMP)(no LCOMP
        osl=reverse(sort(EMs)) & osl=osl[0L:nloop-1L]
        logTmax=logTmax[osl] & EMs=EMs[osl]
      endelse					;no LCOMP)
      ost=sort(logTmax) & logTmax=logTmax[ost] & EMs=EMs[ost]
    endif
    dem=loopem(logTmax,EMs,logT=logT, _extra=e)
  end						;loop DEM)
  'd': begin					;(multi EM components
    ;	INDEM are the emission measures
    ;	at logT[K] defined by PARDEM 
    ok='ok' & mT=n_elements(pardem) & mD=n_elements(indem) & dem=dblarr(nT)
    if mT eq 0 then ok='set PARDEM to log(T[K]) of EM component' else $
     if mD eq 0 then ok='set INDEM to Emission Measure value'
    if ok ne 'ok' then begin
      message,ok,/informational & return,dem
    endif
    xlogT=[pardem] & xEM=dblarr(mT)+indem[0]
    if mT le mD then xEM=indem[0L:mT-1L] else xEM[0L:mD-1L]=indem
    logtbound=mid2bound(logT)
    for i=0L,mT-1L do begin
      tmp=min(abs(logT-xlogT[i]),j)
      dem[j]=dem[j]+xEM[i]/(logtbound[i+1L]-logtbound[i])
    endfor
  end						;multi EM components)
  else: begin					;(help
    for i=0L,nu-1L do print,usage[i]
    dem=0*logT+1.
  end						;help)
endcase

return,dem
end
