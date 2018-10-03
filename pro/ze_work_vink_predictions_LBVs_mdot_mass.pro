;Vink and de koter 2002 predictions for LBVs
;log Mdot propto -1.81 log M
Mvink=35
Mdotvink=2.5E-05
Mgroh=70
mdotgroh=1.5E-05
mdotpredvink=Mdotvink*(Mgroh/Mvink)^(-1.81)
print,mdotpredvink
END