;PRO ZE_ETACAR_AMBER_CREATE_LATEX_FIGURES_ALL_QUANTITIES,epoch,grat_angle,det

;gratdet=epoch+'_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
;caption_prefix= epoch+' grat angle='+strcompress(string(grat_angle, format='(I04)'))+' detector='+strcompress(string(det, format='(I01)'))     ;we have to do that to remove the '_' which are not accepted in latex
line_epoch='brg_dur'
sufix=''
caption=line_epoch
quantity_vector=['Vis12','dVis12','Vis23','dVis23','Vis13','dVis12','DP12','DP23','DP13','CP']
ZE_ETACAR_AMBER_CREATE_LATEX_FIGURES_MULTIPANEL,line_epoch,quantity_vector,caption,'/Users/jgroh/temp/'

;sufix='_contsub'
;caption=caption_prefix+' '+strmid(sufix,1)
;ZE_ETACAR_CRIRES_CREATE_LATEX_FIGURES_MULTIPANEL,gratdet,sufix,caption,'/Users/jgroh/temp/'
;print,'\newpage'
;print,'\clearpage'
;sufix='_contdiv'
;caption=caption_prefix+' '+strmid(sufix,1)
;ZE_ETACAR_CRIRES_CREATE_LATEX_FIGURES_MULTIPANEL,gratdet,sufix,caption,'/Users/jgroh/temp/'
;
;sufix='_psfsub'
;caption=caption_prefix+' '+strmid(sufix,1)
;ZE_ETACAR_CRIRES_CREATE_LATEX_FIGURES_MULTIPANEL,gratdet,sufix,caption,'/Users/jgroh/temp/'
;print,'\newpage'
;print,'\clearpage'

END