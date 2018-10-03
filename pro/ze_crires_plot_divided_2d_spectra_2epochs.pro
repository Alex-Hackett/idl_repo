;PRO ZE_CRIRES_PLOT_DIVIDED_2D_SPECTRA_2EPOCHS,epoch1,epoch2

;gratdet1='1087_2'
gratdet1='1090_2'
;gratdet1='2009apr03_1087_2'
gratdet2='2009apr03_1090_2'



restore,'/Users/jgroh/espectros/etc_'+gratdet1+'_allvar.sav'
print,'File restored:','/Users/jgroh/espectros/etc_'+gratdet1+'_allvar.sav'
dataa2subjan=dataa2sub
lambdajan=lambda_newcal_vac_hel[*,row]
image1=dataa2subjan

ZE_CRIRES_PLOT_GENERIC_2D_SPECTRA,2,15,lambda0,lambda_newcal_vac_hel,dataa2subjan,cmi,cma,star,sub,row
restore,'/Users/jgroh/espectros/etc_'+gratdet2+'_allvar.sav'
print,'File restored:','/Users/jgroh/espectros/etc_'+gratdet2+'_allvar.sav'
dataa2subapr=dataa2sub
image2=dataa2subapr
lambdaapr=lambda_newcal_vac_hel[*,row]
ZE_CRIRES_PLOT_GENERIC_2D_SPECTRA,2,15,lambda0,lambda_newcal_vac_hel,dataa2subapr,cmi,cma,star,sub,row


;setting values lower than the threshold value min_val to a large number, in order to get rid of low S/N part.
min_val=2.
image3=image1
image4=image2
;image3(WHERE(image1 le 2.))=min_val
;image4(WHERE(image2 le min_val))=1000000000.
;dataa2subapr(WHERE(dataa2subapr) le min_val)=10000000.

A=image4
nxny = [n_elements(A(*,0)),n_elements(A(0,*))]
Aresult = interp2d(A,lambdaapr,indexspat,lambdajan,indexspat,nxny,/grid,/extrapolate)
;nxny2 = 10*nxny
;Aresult2 = interp2d(Aresult,lambdajan,indexspat,lambdajan,indexspat,nxny2,/grid,/extrapolate)

lambdafactor=10.
spatfactor=10.
nptslam=n_elements(lambdajan)*lambdafactor
lambdajani=indgen(nptslam,/DOUBLE)*1. 
nptsspat=n_elements(indexspat)*spatfactor
indexspati=indgen(nptsspat,/DOUBLE)*1. 
for i=0., nptslam-1. do lambdajani[i]=min(lambdajan)+((i)*(max(lambdajan)-min(lambdajan))/(nptslam-1.*1.))
for i=0., nptsspat-1. do indexspati[i]=min(indexspat)+((i)*(max(indexspat)-min(indexspat))/(nptsspat-1.*1.))
Aresult2 = interp2d(Aresult,lambdajan,indexspat,lambdajani,indexspati,nxny2,/grid)
Aresult3 = interp2d(image3,lambdajan,indexspat,lambdajani,indexspati,nxny2,/grid)
;ZE_CRIRES_PLOT_GENERIC_2D_SPECTRA,2,15,lambda0,lambda_newcal_vac_hel,Aresult2,cmi,cma,star,sub,row
;ZE_CRIRES_PLOT_GENERIC_2D_SPECTRA,2,15,lambda0,lambda_newcal_vac_hel,Aresult3,cmi,cma,star,sub,row

div_image=image3/Aresult
;div_image=Aresult/image3
div_image(WHERE(image3 le min_val))=1.0
div_image(WHERE(Aresult le min_val AND image3 ge min_val*3.))=5.0
div_image(WHERE(Aresult le min_val AND image3 le min_val))=0.0
;div_image(WHERE(Aresult ge min_val AND image3 le min_val))=0.5

imin=0.0
imax=2.0
;ZE_CRIRES_PLOT_GENERIC_2D_SPECTRA,imin,imax,lambda0,lambda_newcal_vac_hel,Aresult3/Aresult2,cmi,cma,star,sub,row
;ZE_CRIRES_PLOT_GENERIC_2D_SPECTRA,imin,imax,lambda0,lambda_newcal_vac_hel,image3/image4,cmi,cma,star,sub,row
ZE_CRIRES_PLOT_GENERIC_2D_SPECTRA,imin,imax,lambda0,lambda_newcal_vac_hel,div_image,cmi,cma,star,sub,row

END