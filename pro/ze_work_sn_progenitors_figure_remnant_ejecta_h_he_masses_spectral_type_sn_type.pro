;PRO ZE_WORK_SN_PROGENITORS_FIGURE_REMNANT_EJECTA_H_HE_MASSES_SPECTRAL_TYPE_SN_TYPE

inimassrot=[9,12,15,16.5,18,20,25,28,32,40,60,85,120]
finradrot=[555.08,714.24,886.73,894.92,451.20, 28.29, 26.20, 23.68,  0.58,  0.49,  0.48,  0.53,  0.48]
;throwing away for now the new models
inimassrot=[9,12,15,20,25,32,40,60,85,120]
finradrot=[555.08,714.24,886.73, 28.29, 26.20,  0.58,  0.49,  0.48,  0.53,  0.48]
barionremmassrot=[1.30,1.48,1.71,2.10,2.69,3.38,3.90,5.40,7.88,5.69]
totejectamassrot=[7.22,8.73,9.26,5.06,6.99,6.73,8.42,12.58,18.47,13.29]
H_ejectamassrot=[3.53,4.02,3.31,0.02,0.00, 0.00,0.00, 0.00,0.00, 0.00]
He_ejectamassrot=[3.03, 3.31, 3.72, 1.61, 1.59, 0.28,0.41,0.50,0.61, 0.52]
lineplot,inimassrot,barionremmassrot
lineplot,inimassrot,H_ejectamassrot+barionremmassrot
lineplot,inimassrot,He_ejectamassrot+barionremmassrot
lineplot,inimassrot,totejectamassrot+barionremmassrot

;lineplot,inimassrot,finradrot
;
;lineplot,barionremmassrot,finradrot
;lineplot,barionremmassrot+H_ejectamassrot,finradrot
;lineplot,barionremmassrot+He_ejectamassrot,finradrot

;lineplot,finradrot,H_ejectamassrot
;lineplot,finradrot,He_ejectamassrot
END