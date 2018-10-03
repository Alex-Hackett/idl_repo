Angstrom = '!6!sA!r!u!9 %!6!n'
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/381D-0262B_2008Dec26/raw/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/381D-0262B_2008Dec26/calib/'
dirproc='/Users/jgroh/data/eso_vlt/crires/Etacar/381D-0262B_2008Dec26/proc/'

sraw1=dirsci+'CRIRE.2008-12-26T07:05:44.119.fits'
sraw2=dirsci+'CRIRE.2008-12-26T07:06:50.241.fits'
flat1=dirproc+'crires_spec_flat_set01.fits'


;reading FITS files
dataa0=mrdfits(sraw1,0,header10)
dataa1=mrdfits(sraw1,1,header11)
dataa2=mrdfits(sraw1,2,header12)
dataa3=mrdfits(sraw1,3,header13)
dataa4=mrdfits(sraw1,4,header14)

datab0=mrdfits(sraw2,0,header20)
datab1=mrdfits(sraw2,1,header21)
datab2=mrdfits(sraw2,2,header22)
datab3=mrdfits(sraw2,3,header23)
datab4=mrdfits(sraw2,4,header24)

flata0=mrdfits(flat1,0,headerf10)
flata1=mrdfits(flat1,1,headerf11)
flata2=mrdfits(flat1,2,headerf12)
flata3=mrdfits(flat1,3,headerf13)
flata4=mrdfits(flat1,4,headerf14)


datacomb2=(dataa2+datab2)/2.


;using other extensions?
;dataa2=dataa2
;swmpa2=swmpa2

;cropping data in the spatial direction around science spectrum 
;star=249 ;(for HeI at 2070 img)
star=245  ;(for HeI  1087 at 0:46) 
;star=244.5 ;(for HeI  1090 at 0:20) 
;star=155   ;(for HeI 1090 P79 at 5:30) 
;star=158   ;(for Fe II 168 P79 at 5:30) 
;star=star-76
;star=230. ;(for brg 2150 at 1:37:44)
;star=198. ;(for brg 2150 at 0:07)
;star=208. ;(for brg 2156)
;sub=+0.5
sub=0.14
row=14
crop=row
cmi=star-crop
cma=star+crop
;swmpa2=swmpa2[*,cmi:cma]
;dataa2=dataa2[*,cmi:cma]
dataa2=shift_sub(dataa2,0,sub)


;;lambda0=2.0587
;;lambda0=2.16612
;lambda0=1.0833
;;lambda0=1.6769
;
;
;;crop data in spectral direction to remove last zero
;;dataa2=dataa2[0:1022,*]
;;swmpa2=swmpa2[0:1022,*]
;
;;additional cropping in spectral direction?
;;dataa2=dataa2[50:1020,*]
;;swmpa2=swmpa2[50:1020,*]
;;t=t[400:800]
;
;
;;normalizing telluric spectrum interactively using FUSE routine LINE_NORM
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;line_norm,w2ca,f2ca,f2canorm,norm,xnodes,ynodes
;f2canorm=f2canorm[0:1022]
;f2cainorm=cspline(w2ca,f2canorm,swmpa2[*,10]) ;interpolate to the same lambda grid
;
;;shifting in velocity the normalized telluric spectrum
;C=299792.458
;v=-1.0
;w2can=swmpa2[*,row]*(1.+v/C)
;f2cainormv=cspline(w2can,f2cainorm,swmpa2[*,row])
;f2cainormv=((f2cainormv-1.0)*1.0 +1.) ;scaling due to slight different airmass
;help,f2cainormv
;;dividing Etacar 2D image by a telluric spectrum which was previously normalized
;C=299792.458
;for i=0, (size(dataa2))[2] - 1 do begin
;
;;normalize each row by the continuum? crudely done 
;;dataa2[*,i]=dataa2[*,i]/dataa2[930,i]
;;dataa2[*,i]=dataa2[*,i]/dataa2[*,row]
;
;;convolve with a gaussian with a fwhm in the spectral direction?
;;fwhm=2.35*1.1
;;fwhm=40.
;;fhwm=0.5
;;dataa2[*,i]=cnvlgauss(dataa2[*,i],fwhm=fwhm)
;
;endfor
;;
;;;convolve with a gaussian with a fwhm in the spatial direction?
;;;fwhm=2.35*1.1
;;fwhm=2.35*1.1
;;
;;prel=dblarr((size(dataa2))[2])
;;for i=0, (size(dataa2))[1] - 1 do begin
;;prel[*]=dataa2[i,*]
;;prel=cnvlgauss(prel,fwhm=fwhm)
;;dataa2[i,*]=prel
;;endfor
;
;
;;shifting each column in the spatial direction fucking shit ITS WORKIN!
;	;1st finding centroids using gaussians
;	l=(size(dataa2))[1]
;	s=(size(dataa2))[2]
;	y=findgen(s)
;	center=dblarr(l)	
;	;
;	;xgaussfit,y,dataa2[row,*]
;	for i=0., l-1 do begin
;	fit=gaussfit(y,dataa2[i,*],A)
;	center[i]=A[1]
;	endfor
;
;	;2nd sigma clipping centroids around mean value in order to remove spikes
;	meanclip,center,mean,sigma
;	
;	for i=0., l-1 do begin
;	if center[i] lt (mean - 3*sigma) then begin
;	center[i]=mean
;	endif
;	if center[i] gt (mean + 3*sigma) then begin
;	center[i]=mean
;	endif
;	endfor
;	
;	;3rd manually replacing the first 7 pixels by crude linear interpolation in order to remove the influence of the teluric line
;        ;
;	for i=0, 6 do begin
;	center[i]=center[7]+ ((7-i)*(center[8]-center[7]))
;	endfor
;	
;	; 3rd fitting centroids
;	x=indgen(l)
;	yfit2 = poly_fit2(x, center, 2)  ;LINEAR FIT
;	line_norm,x,center,centernorm,centervals,xnodescen,ynodescen ;SPLINE FIT INTERACTIVE, BETTER CHOICE
;        ;
;
;	;convolve with a gaussian with a fwhm in the spectral direction?
;	;fwhm=2.35*1.1
;	fwhm=30.
;	center2=cnvlgauss(center,fwhm=fwhm)
;        
;	; 4th finding offsets which can be relative to a given  line (arbitrary) 410 (i.e. 411) or to the mean centroid value
;	;
;	spatoffset=centervals-centervals[511]
;	;spatoffset=centervals - mean  
;	;
;	;plotting routines for debugging
;	LOADCT,0
;	window,8
;	plot,center , yrange=[row-2,row+8]
;	oplot,yfit2,color=fsc_color('blue'),noclip=0,linestyle=1,thick=1.9 
;	oplot,center2,color=fsc_color('red')
;	oplot,centervals,color=fsc_color('green')
;
;	;shifting each column by the offset (i.e. shifting in spatial direction) 
;	prel=dblarr((size(dataa2))[2])	
;	for i=0, (size(dataa2))[1] - 1 do begin
;	prel[*]=dataa2[i,*]
;	prel=shiftf(prel,-1.*spatoffset[i])
;	dataa2[i,*]=prel
;	endfor
;
;
;;normalizing after aligning
;t=f2cainormv
;vel=2. 
;for i=0, (size(dataa2))[2] - 1 do begin
;
;;for brgamma 26 2156 
;;t=ZE_SHIFT_SPECTRA_VEL(swmpa2[*,i],f2cainormv,2.)
;;for brgamma 26 2150 
;t=ZE_SHIFT_SPECTRA_VEL(swmpa2[*,i],f2cainormv,0.)
;;for hei 20587
;;t=ZE_SHIFT_SPECTRA_VEL(swmpa2[*,i],f2cainormv,+0.4)
;
;dataa2[*,i]=dataa2[*,i]/t
;
;;normalize each row by the continuum? crudely done 
;;dataa2[*,i]=dataa2[*,i]/dataa2[30,i]
;;dataa2[*,i]=dataa2[*,i]/dataa2[*,row+1]
;;dataa2[*,i]=dataa2[*,i]/fnormdiv
;
;;subtract continuum for each row ? crudely done 
;;dataa2[*,i]=dataa2[*,i] / dataa2[30,i]        ;column 900 for He I 1090.4
;;dataa2[*,i]=dataa2[*,i]/dataa2[*,row+1]
;;dataa2[*,i]=dataa2[*,i]/fnormdiv
;
;endfor
;
;;dataa2(WHERE(dataa2) le 0)=0.0001
;;using  log
;;dataa2=alog10(dataa2)
;
;;using  sqrt
;dataa2=SQRT(dataa2)
;
;;plotting image
;a=min(dataa2,/NAN)
;;a=1.0
;b=max(dataa2,/NAN)
;;b=1.44
;img=bytscl(dataa2,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
;imginv=255b-img ;invert img
;imginv=img
;;plotting in window
;aa=1300.
;bb=300.
;window,19,xsize=aa,ysize=bb,retain=0,XPOS=30,YPOS=60
;ticklen = 15.
;!x.ticklen = ticklen/bb
;!y.ticklen = ticklen/aa
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;plot, ZE_LAMBDA_TO_VEL(swmpa2[*,5]*10.,lambda0*10^4), [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Wavelength (Angstrom)', ytitle='offset (arcsec)',$
;/NODATA, Position=[0.07, 0.22, 0.94, 0.98],ycharsize=2,xcharsize=2,charthick=1.2;,XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)]
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;LOADCT, 13
;;LOADCT,0
;tvimage,imginv, /Overplot
;;linear colorbar
;x=[0,10]
;xfin=[0,2,4,6,8,10]
;y=[a,b]
;LINTERP,x,y,xfin,yfin
;colorbarv = yfin/max(yfin)
;colorbar, COLOR=fsc_color('black'),TICKNAMES=['0.0','0.2','0.4','0.6','0.8','1.0'], FORMAT='(F5.1)', DIVISIONS=5, /VERTICAL, /RIGHT,$
;POSITION=[0.95, 0.24, 0.97, 0.90]
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)],xcharsize=0
;AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(swmpa2[*,2]*10.),max(swmpa2[*,5]*10.)],xcharsize=2
;AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;xyouts,1230,280,TEXTOIDL('F/Fmax'),/DEVICE,color=fsc_color('black')
;xyouts,420,870,TEXTOIDL('PA=325^o'),/DEVICE,color=fsc_color('black'),charsize=3
;cut1=-4
;cut2=4
;cut3=0
;d1=cut1*0.086
;d2=cut2*0.086
;d3=cut3*0.086
;xyouts,min(swmpa2[*,row]*10.)-1.,d1,'-->',color=fsc_color('black'),charsize=1,charthick=3
;xyouts,min(swmpa2[*,row]*10.)-1.,d2,'-->',color=fsc_color('orange'),charsize=1,charthick=3
;i=28.
;file_output='/Users/jgroh/temp/etc_crires_'+strcompress(string(i, format='(I08)'), /remove)
;;image = TVREAD(FILENAME = file_output, /PNG, /NODIALOG)
;;back to linear scale
;;dataa2=10.^(dataa2)
;dataa2=(dataa2)^2.
;;plots,swmpa2[*,row+cut1]*10.,dataa2[*,row+cut1]/max(dataa2[*,row+cut1])/2. + 0.6 ,color=fsc_color('white')
;;plots,swmpa2[*,row+cut2]*10.,dataa2[*,row+cut2]/max(dataa2[*,row+cut2])*2.,color=fsc_color('green'),noclip=0,linestyle=0,thick=1
;;plots,swmpa2[*,row]*10.,dataa2[*,row]/max(dataa2[*,row])*1.,color=125
;
;LOADCT,13
;;image = TVREAD(FILENAME = file_output, /JPEG, /NODIALOG)
;
;ymin=0.0
;ymax=4.
;
;
;;sum flux from lmin to lmax lines centered at center
;center=0
;apradius=1
;flux_sum=0.
;for i=0, 2*apradius do begin
;flux_sum=dataa2[*,row+center-apradius+i]+flux_sum
;print,row+center-apradius+i
;endfor
;print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1)*0.086,decimals=2)+'x 0.20 arcsec'
;
;norm_col=400
;
;;checking wavelength difference between science star and telluric calibrator star for row corresponding to central star
;window,12,xsize=900,ysize=400,retain=2
;plot,ZE_LAMBDA_TO_VEL(swmpa2[*,row]*10.,lambda0*10000.),dataa2[*,row]/dataa2[900,row],xstyle=1,ystyle=1,xrange=[-950,250.], xtitle='velocity [km/s]',ytitle='F/Fc',$
;yrange=[ymin,ymax],charsize=2,charthick=1.5, /NODATA,POSITION=[0.08,0.2,0.9,0.98]
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut1]*10.,lambda0*10000.),dataa2[*,row+cut1]/dataa2[norm_col,row+cut1],noclip=0
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut2]*10.,lambda0*10000.),dataa2[*,row+cut2]/dataa2[norm_col,row+cut2],color=fsc_color('orange'),noclip=0,linestyle=2
;;flux_sum=dataa2[*,row+cut3]+dataa2[*,row+cut3+1]+dataa2[*,row+cut3-1]
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut3]*10.,lambda0*10000.),dataa2[*,row+cut3]/dataa2[norm_col,row+cut3],color=fsc_color('blue'),noclip=0,linestyle=0
;;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut3]*10.,lambda0*10000.),flux_sum/flux_sum[norm_col],color=fsc_color('green'),noclip=0,linestyle=0,thick=3
;
;xyouts,850,70,number_formatter(d1,decimals=2),/DEVICE,color=fsc_color('black'),charsize=1,alignment=1.0
;xyouts,850,120,number_formatter(d2,decimals=2),/DEVICE,color=fsc_color('orange'),charsize=1,alignment=1.0
;xyouts,850,95,number_formatter(d3,decimals=2),/DEVICE,color=fsc_color('blue'),charsize=1,alignment=1.0
;;plots,w2ca,f2canorm,color=fsc_color('green'),noclip=0
;plots,swmpa2[*,row+cut1]*10,f2cainormv,color=fsc_color('red'),noclip=0,linestyle=1
;;plots,swmpa2[*,row],ZE_SHIFT_SPECTRA_VEL(swmpa2[*,row],f2cainormv,30)
;;plots,swmpa2[*,row],dataa2[*,row]/max(dataa2[*,row])*2.92/f2cainormv,color=fsc_color('orange'),noclip=0,linestyle=0
;;plots,swmpa2[*,row],dataa2[*,row]/max(dataa2[*,row+2])*1.,color=125
;;plots,w2a,f2cai*70.,color=fsc_color('red'),noclip=0
;;plots,w2a,f2cain*70.,color=fsc_color('green'),noclip=0
;
;;
;;;plotting science spectrum on the star and telluric lines
;;fnormdiv=dataa2[*,row+cut1]/dataa2[1000,row+cut1]/t ; use this if 2d image is NOT divided by t
;fnormdiv=dataa2[*,row+cut1]/dataa2[900,row+cut1]; use this if 2d image is already divided by t
;fnormdiv2=dataa2[*,row+cut2]/dataa2[900,row+cut2]
;window,11,xsize=900,ysize=400,retain=0
;plot,swmpa2[*,row+cut1]/1000.,dataa2[*,row+cut1]/dataa2[800,row+cut1],title=TEXTOIDL('CRIRES observations of Eta Car at Br\gamma 2.16 \mum'),$
;POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
;xstyle=1,ystyle=1,xrange=[lambda0-0.004,lambda0+0.004], yrange=[0.0,5],/NODATA,charsize=2
;;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=2,thick=1.9
;plots,swmpa2[*,row+cut1]/1000.,fnormdiv,noclip=0
;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,color=fsc_color('blue'),noclip=0,linestyle=0,thick=1.9
;;plots,swmpa2[*,row]/1000.,f2cainormv+2.5,color=fsc_color('red'),noclip=0,linestyle=0,thick=1.9
;;xyouts,2.052,3.6,TEXTOIDL('telluric spectrum from calibrator + offset'),color=fsc_color('red'),charsize=1.5
;;xyouts,2.052,1.2,TEXTOIDL('Eta Car divided by telluric'),color=fsc_color('blue'),charsize=1.5
;;
;;
;window,14
;plot,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut1]/1000.,lambda0),fnormdiv,title=TEXTOIDL('CRIRES observations of Eta Car at Br\gamma 2.16 \mum'),$
;POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
;xstyle=1,ystyle=1,xrange=[-800.,300.], yrange=[0.0,5],/NODATA,charsize=2
;;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=2,thick=1.9
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut1]/1000.,lambda0),fnormdiv,noclip=0
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut2]/1000.,lambda0),fnormdiv2,noclip=0
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut3]/1000.,lambda0),fnormdiv2,noclip=0
;;set_plot,'ps'
;;device,filename='/Users/jgroh/temp/output_etc_2070.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.76,/inches
;;plot,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,title=TEXTOIDL('CRIRES observations of Eta Car at He I 2.058 \mum'),$
;;POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
;;xstyle=1,ystyle=1,xrange=[2051.6/1000.,2062.0/1000.], yrange=[-0.2,4],/NODATA,charsize=1.5,charthick=3
;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=1,thick=1.9
;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,color=fsc_color('blue'),noclip=0,linestyle=0,thick=1.9
;;plots,swmpa2[*,row]/1000.,f2cainormv+2.5,color=fsc_color('red'),noclip=0,linestyle=0,thick=1.9
;;xyouts,2.052,3.65,TEXTOIDL('telluric spectrum from calibrator + offset'),color=fsc_color('red'),charsize=1.2,charthick=3
;;xyouts,2.052,1.2,TEXTOIDL('Eta Car divided by telluric'),color=fsc_color('blue'),charsize=1.2,charthick=3
;;xyouts,2.052,1.5,TEXTOIDL('Eta Car raw'),color=fsc_color('black'),charsize=1.2,charthick=3
;;device,/close
;;set_plot,'x'
;
;
;;set_plot,'ps'
;;device,filename='/Users/jgroh/temp/output_etc_2150.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=5.76,/inches
;;plot,swmpa2[*,row+cut1]/1000.,fnormdiv,title=TEXTOIDL('CRIRES observations of Eta Car at Br\gamma 2.16 \mum'),$
;;POSITION=[0.10, 0.18, 0.93, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',charthick=2.,$
;;xstyle=1,ystyle=1,xrange=[2159.6/1000.,2168.4/1000.], yrange=[0.0,5.],charsize=1.5, /NODATA
;;plots,swmpa2[*,row+cut1]/1000.,fnormdiv,thick=2.,noclip=0,clip=[2159.6/1000.,0,2168.4/1000.,5]
;;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=2,thick=1.9
;;plots,swmpa2[*,row+cut1]/1000.,dataa2[*,row+cut1]/dataa2[100,row+cut1]/f2cainormv,color=fsc_color('black'),noclip=0
;
;;plot,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,title=TEXTOIDL('CRIRES observations of Eta Car at He I 2.058 \mum'),$
;;POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
;;xstyle=1,ystyle=1,xrange=[2051.6/1000.,2062.0/1000.], yrange=[-0.2,4],/NODATA,charsize=1.5,charthick=3
;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=1,thick=1.9
;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,color=fsc_color('blue'),noclip=0,linestyle=0,thick=1.9
;;plots,swmpa2[*,row]/1000.,f2cainormv+2.5,color=fsc_color('red'),noclip=0,linestyle=0,thick=1.9
;;xyouts,2.052,3.65,TEXTOIDL('telluric spectrum from calibrator + offset'),color=fsc_color('red'),charsize=1.2,charthick=3
;;xyouts,2.052,1.2,TEXTOIDL('Eta Car divided by telluric'),color=fsc_color('blue'),charsize=1.2,charthick=3
;;xyouts,2.052,1.5,TEXTOIDL('Eta Car raw'),color=fsc_color('black'),charsize=1.2,charthick=3
;;device,/close
;set_plot,'x'
;
;;output=dirsci+'tel_2150_norm.txt'
;;openw,1,output
;;for f=0, 1000. do begin
;;printf,1, swmpa2[f,row+cut1]*10,t[f]
;;endfor
;;close,1 
;;
;;
;;output=dirsci+'etc_2150_norm_div_row0.txt'
;;openw,1,output
;;for f=0, 1020. do begin
;;printf,1, swmpa2[f,row+cut1]*10,fnormdiv[f]
;;endfor
;;close,1 
;
;;plot spatial profile and fit a gaussian interactively
;;LOADCT,0
;;!P.Background = fsc_color('white')
;;!P.Color = fsc_color('black')
;;  s=(size(dataa2))[2]
;;  y=findgen(s)
;;  y=y+(cmi-star-sub)
;;  xgaussfit,y,dataa2[911,*]



END
