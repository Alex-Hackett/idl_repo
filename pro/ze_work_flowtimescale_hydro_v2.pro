;PRO ZE_WORK_FLOWTIMESCALE_HYDRO_V2
;v2 computes flowtime in a separate routine
!P.Background = fsc_color('white')
;r and v values of model 1, with increased teff and vinf-150 km/s
;READCOL,'/Users/jgroh/ze_models/timedep_armagh/49/RVSIG_COL_NEW_v150',r1,v1,sigma1,depth1,COMMENT='!',F='D,D'
READCOL,'/Users/jgroh/ze_models/timedep_armagh/14/RVSIG_COL',r1,v1,sigma1,depth1,COMMENT='!',F='D,D'
nd1=n_elements(r1)
rstar1=r1[nd1-1]
;velocity law for epoch 1:
vinf1=150.
v0_1=1.0
beta1=1.0
sclht_1=0.04
;;v2mod=v2
FOR k=0, nd1-1 do begin
v1[k]=(v0_1+(vinf1-v0_1)*((1-(r1[nd1-1]/r1[k]))^beta1))/(1.0+(v0_1/sclht_1)*exp((r1[nd1-1]-r1[k])/(sclht_1*r1[nd1-1])))
endfor

vs1=15.0
ZE_COMPUTE_FLOWTIMESCALE,r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1


r2=r1*1.0
nd2=n_elements(r2)
rstar2=r2[nd2-1]
v2=dblarr(nd2)
;velocity law for epoch 2:
vinf2=70.
v0_2=1.0
beta2=1.0
sclht_2=0.04
;;v2mod=v2
FOR k=0, nd1-1 do begin
v2[k]=(v0_2+(vinf2-v0_2)*((1-(r2[nd2-1]/r2[k]))^beta2))/(1.0+(v0_2/sclht_2)*exp((r2[nd2-1]-r2[k])/(sclht_2*r1[nd2-1])))
endfor

vs2=15.0
ZE_COMPUTE_FLOWTIMESCALE,r2,v2,nd2,vs2,flowtime2,rirev2,virev2,flowtimerev2,dflowtimerev2

;compute delta_x (spacing between the two winds) as a function of time.
;for a given deltat after the change, computes:
;x1=position of the beginning of wind 1 (i.e., old wind) 
;x2=position of the end of wind 2 (i.e., new wind) 
;delta_x=x1 -x2

npts=1000
x1=dblarr(npts)
x2=dblarr(npts)
deltatmax=max(flowtime1)
deltatmin=5.0
deltat=INDGEN(npts,/DOUBLE)*1.0D
FOR k=0,npts -1 DO BEGIN 
  deltat[k]=deltatmin+((deltat[k])*(deltatmax-deltatmin)/(npts-1.*1.))
  ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT,deltat[k],r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1,x1_val,x_r1,index_x_r1
  x1[k]=x1_val
  ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT,deltat[k],r2,v2,nd2,vs2,flowtime2,rirev2,virev2,flowtimerev2,dflowtimerev2,x2_val,x_r2,index_x_r2
  x2[k]=x2_val
ENDFOR

delta_x=x1-x2

;lineplot,deltat,delta_x/rstar1,xtitle='delta t [days]',ytitle='x1,x2,delta_x [r_star]',title='delta_x'
lineplot,deltat,x1/rstar1,xtitle='delta t [days]',ytitle='x1,x2,delta_x [r_star]',title='x1'
lineplot,deltat,x2/rstar1,xtitle='delta t [days]',ytitle='x1,x2,delta_x [r_star]',title='x2'



END