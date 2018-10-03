;compute scaled Mdot for different clumping filling factors, since Mdot*f^(-0.5)=cte
f1=0.1
f2=[0.05,0.25,1.0]
Mdot1=1.4E-05
Mdot2=Mdot1*(f1/f2)^(-0.5)
print,f2,Mdot2

;compute scaled Mdot for different L, since Mdot*L^0.75=cte
L1=1.5
L2=[0.7,2.2]
Mdot1=1.4E-05
Mdot2=Mdot1*(L2/L1)^0.75
print,L2,Mdot2
END