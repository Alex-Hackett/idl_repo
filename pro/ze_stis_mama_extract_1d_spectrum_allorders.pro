;PRO ZE_STIS_MAMA_EXTRACT_1D_SPECTRUM_ALLORDERS
dummy=mrdfits('/Users/jgroh/data/hst/stis/umn/eA22_0010.fits',0,headera0)
data=mrdfits('/Users/jgroh/data/hst/stis/umn/eA22_0010.fits',1,headera1)
wave=mrdfits('/Users/jgroh/data/hst/stis/umn/eA22_0010.fits',4,headera4)

crval1=fxpar(headera1,'CRVAL1')
crpix1=fxpar(headera1,'CRPIX1')
crpix2=fxpar(headera1,'CRPIX2') ;position of central star
cd1=fxpar(headera1,'CD1_1')
platesc2=fxpar(headera0,'PLATESC')
platesc=fxpar(headera1,'CD2_2')*3600.D
datamin=fxpar(headera1,'DATAMIN')
datamax=fxpar(headera1,'DATAMAX')
sizaxis1=fxpar(headera0,'SIZAXIS1') ;spectral direction
sizaxis2=fxpar(headera0,'SIZAXIS2') ;spatial direction

peaks=ze_peaks(total(data[300:900,*],1),2)
npeaks=n_elements(peaks)
spec_array=dblarr(sizaxis1,npeaks)
lambda_array=dblarr(sizaxis1,npeaks)


apradius=3

for i=0, npeaks -1 DO BEGIN
  ZE_STIS_MAMA_EXTRACT_1D_SPECTRUM_INDIVIDUAL_ORDERS,data,sizaxis1,peaks[i],apradius,spec_ext
  spec_array[*,i]=spec_ext
ENDFOR

for i=0, npeaks -1 DO BEGIN
  ZE_STIS_MAMA_EXTRACT_1D_WAVELENGTH_INDIVIDUAL_ORDERS,wave,sizaxis1,peaks[i],lambda_ext
  lambda_array[*,i]=lambda_ext
ENDFOR

;getting rid of the first 10 pixels 
lambda_array=lambda_Array[10:sizaxis1-1,*]
spec_array=spec_Array[10:sizaxis1-1,*]

;coadd orders
FOR k=0, npeaks -2  DO BEGIN
l1=REFORM(lambda_Array[*,k])
f1=REFORM(spec_Array[*,k])
f2=REFORM(spec_Array[*,k+1])
l2=REFORM(lambda_Array[*,k+1])

lmerge=lambda_Array[*,k:k+1]
fmerge=spec_Array[*,k:k+1]
hrs_merge,lmerge,fmerge,0,0,lambdacomb_1dspc,fluxcomb_1dspc

ENDFOR

HRS_MERGE,lambda_array,spec_array,0,0,l,f,/interp

filename_23mar00_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_23mar00_OK.dat'
ZE_READ_STIS_DATA_FROM_JOHN,filename_23mar00_e140m,lambda_23mar00_e140m,flux_23mar00_e140m,mask_23mar00_e140m

END