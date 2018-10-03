;PRO ZE_COMPUTE_WIND_COOLING_TIMESCALE_SBW1_NATHAN
;based on hillier et al. 1993, eq. 12

U0=300.0
mu=1.27
gamma=1.0
mdot=1e-8
rstar=24.5
r1=reverse(indgen(10000)/100.+1.0)
vinf1=1000.0
tcool1=ZE_COMPUTE_WIND_COOLING_TIMESCALE_FROM_HILLIER93(300.0,mu,gamma,1e-7,rstar,r1,vinf1) ;U0,mu,gamma,mdot,rstar,r1,vinf1
tcool2=ZE_COMPUTE_WIND_COOLING_TIMESCALE_FROM_HILLIER93(300.0,mu,gamma,1e-8,rstar,r1,vinf1) ;U0,mu,gamma,mdot,rstar,r1,vinf1
tcool3=ZE_COMPUTE_WIND_COOLING_TIMESCALE_FROM_HILLIER93(100.0,mu,gamma,1e-8,rstar,r1,vinf1) ;U0,mu,gamma,mdot,rstar,r1,vinf1


v1=dblarr(10000.0)
;velocity law for epoch 1:
vinf1=2180.
v0_1=1.0
beta1=1.0
sclht_1=0.04
;;v2mod=v2
nd1=n_elements(r1)
FOR k=0, nd1-1 do begin
v1[k]=(v0_1+(vinf1-v0_1)*((1-(r1[nd1-1]/r1[k]))^beta1))/(1.0+(v0_1/sclht_1)*exp((r1[nd1-1]-r1[k])/(sclht_1*r1[nd1-1])))
endfor
v1[where(v1 lt 10.0)] = 10.0



tflow=((r1-1.0)*rstar*6.96e10)/(v1*1e5) ;in s
tflow1=dblarr(10000.0)
dtflow=(shift(r1,1)-r1)*rstar*6.96e10/(v1*1e5) ;in s
dtflow[0]=0.0
tflow1[0]=0.0
for i=1, nd1-1 do begin
tflow1[i]=tflow[i-1] + dtflow[i]
endfor
tflow1=reverse(tflow1)
vs1=15.0
;ZE_COMPUTE_FLOWTIMESCALE,r1,v1,nd1,vs1,flowtime1,rirev1,virev1,flowtimerev1,dflowtimerev1
;S_TO_DAY=1.0d/(24.0D*3600.0D)
;flowtime1s=flowtime1/S_TO_DAY


;plot for SBW1 paper

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,r1,tflow,TEXTOIDL('r/Rstar'),TEXTOIDL('t (s)'),'',linestyle1=0,color1='black',$ 
                                _EXTRA=extra,/xlog,ylog=1,xrange=[1.3,100],yrange=[8e2,1e7],psxsize=800,psysize=600,filename='sbw1_cooling_flow',$
                                 x2=r1,y2=tcool1,color2='red',linestyle2=0,double_yaxis=0,alty_min=1,alty_max=5,$;OIV 3411 
                                 x3=r1,y3=tcool2,color3='blue',linestyle3=3,$ 
                                 x4=r1,y4=tcool3,color4='green',linestyle4=2,$
;                                x9=data.field01[0,*],y9=data.field01[33,*],color9=colorcarb,linestyle9=1,$ ;C4+
;                                x10=data.field01[0,*],y10=data.field01[39,*],color_10=coloriron,linestyle_10=0,$ ;Fe5+    
;                                x11=data.field01[0,*],y11=data.field01[41,*],color_11=coloriron,linestyle_11=1,$ ;Fe6+      
;                                x12=data.field01[0,*],y12=data.field01[43,*],color_12=coloriron,linestyle_12=2,$ ;Fe7+                                                                                         
                                xcharsize=1.9,ycharsize=1.9,POSITION=[0.14,0.16,0.90,0.97],pthick=10,charthick=8,xthick=8,ythick=8;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues


END