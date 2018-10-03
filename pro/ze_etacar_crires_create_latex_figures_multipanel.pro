PRO ZE_ETACAR_CRIRES_CREATE_LATEX_FIGURES_MULTIPANEL,gratdet,sufix,caption,dest_dir

print,'\begin{figure}'
print,'\hspace{-1cm}'
j=1
order=['3','4','2','5','1','6'] ;choose here order of the panels
for i=1, 6 DO BEGIN
print,'\resizebox{0.6\columnwidth}{!}{\includegraphics{'+dest_dir+'etc_crires'+gratdet+'_offset'+order[i-1]+sufix+'.eps}}'
IF i eq 2*j THEN BEGIN 
  print,''
  print,'\hspace{-1cm}'
  j=j+1
ENDIF
ENDFOR
print,'\caption{'+caption+'}'
print,'\end{figure}'

END