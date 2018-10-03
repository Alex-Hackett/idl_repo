PRO ZE_ETACAR_AMBER_CREATE_LATEX_FIGURES_MULTIPANEL,line_epoch,quantity_vector,caption,dest_dir

print,'\begin{figure}'
print,'\hspace{-1cm}'
j=1
order=['3','4','2','5','1','6'] ;choose here order of the panels
for i=1, 10 DO BEGIN
print,'\resizebox{0.4\columnwidth}{!}{\includegraphics{'+dest_dir+'etacar_amber_'+quantity_vector[i-1]+'_lambda_pa_2D_'+line_epoch+'_2009.eps}}'
IF i eq 2*j THEN BEGIN 
  print,''
  print,'\hspace{-1cm}'
  j=j+1
ENDIF
ENDFOR
print,'\caption{'+caption+'}'
print,'\end{figure}'

END