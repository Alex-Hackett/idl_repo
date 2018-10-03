;PRO DU_VERBAL
;cria tabela de verbos regulares 

;escolhe conjugacao
PRINT,'Digite o codigo da conjugacao desejada [1,2,3]:  '
READ, ' (ar=1, er=2, ir=3)',conjugacao

CASE conjugacao of

1: BEGIN

filename_verbos='/Users/jgroh/temp/du_verbos_ar.txt'
out_file='/Users/jgroh/temp/du_verbos_ar_conjugados.txt'
verbos_ar_struct=READ_ASCII(filename_verbos,header=ewdata_header,count=ewdata_count,TEMPLATE=ASCII_TEMPLATE(filename_verbos),DATA_START=0)
verbos_ar=verbos_ar_struct.field1
verbos_ar_radical=verbos_ar
pos_vec=DBLARR(n_elements(verbos_ar))

;acha radical do verbo
FOR i=0, n_elements(verbos_ar)-1 DO BEGIN
pos=STRPOS(verbos_ar[i],'ar',/REVERSE_SEARCH)
pos_vec[i]=pos
verbos_ar_radical[i]=STRMID(verbos_ar[i],0,pos)
ENDFOR

;conjuga presente
verbos_ar_presente_1apessoa_sing = verbos_ar_radical+'o'
verbos_ar_presente_2apessoa_sing = verbos_ar_radical+'a'
verbos_ar_presente_1apessoa_plu = verbos_ar_radical+'amos'
verbos_ar_presente_2apessoa_plu = verbos_ar_radical+'am'

;conjuga passado perfeito
verbos_ar_pas_perfeito_1apessoa_sing = verbos_ar_radical+'ei'
verbos_ar_pas_perfeito_2apessoa_sing = verbos_ar_radical+'ou'
verbos_ar_pas_perfeito_1apessoa_plu = verbos_ar_radical+'amos'
verbos_ar_pas_perfeito_2apessoa_plu = verbos_ar_radical+'aram'

;conjuga passado imperfeito
verbos_ar_pas_imperfeito_1apessoa_sing = verbos_ar_radical+'ava'
verbos_ar_pas_imperfeito_2apessoa_sing = verbos_ar_radical+'ava'
verbos_ar_pas_imperfeito_1apessoa_plu = verbos_ar_radical+'avamos'
verbos_ar_pas_imperfeito_2apessoa_plu = verbos_ar_radical+'avam'

;conjuga futuro formal
verbos_ar_fut_formal_1apessoa_sing = verbos_ar_radical+'arei'
verbos_ar_fut_formal_2apessoa_sing = verbos_ar_radical+'ara'
verbos_ar_fut_formal_1apessoa_plu = verbos_ar_radical+'aremos'
verbos_ar_fut_formal_2apessoa_plu = verbos_ar_radical+'arao'

;conjuga futuro informal
verbos_ar_fut_informal_1apessoa_sing = 'vou_' + verbos_ar
verbos_ar_fut_informal_2apessoa_sing = 'vai_' + verbos_ar
verbos_ar_fut_informal_1apessoa_plu = 'vamos_' + verbos_ar
verbos_ar_fut_informal_2apessoa_plu = 'vao_' + verbos_ar
END

2: BEGIN

filename_verbos='/Users/jgroh/temp/du_verbos_er.txt'
out_file='/Users/jgroh/temp/du_verbos_er_conjugados.txt'
verbos_ar_struct=READ_ASCII(filename_verbos,header=ewdata_header,count=ewdata_count,TEMPLATE=ASCII_TEMPLATE(filename_verbos),DATA_START=0)
verbos_ar=verbos_ar_struct.field1
verbos_ar_radical=verbos_ar
pos_vec=DBLARR(n_elements(verbos_ar))

;acha radical do verbo
FOR i=0, n_elements(verbos_ar)-1 DO BEGIN
pos=STRPOS(verbos_ar[i],'er',/REVERSE_SEARCH)
pos_vec[i]=pos
verbos_ar_radical[i]=STRMID(verbos_ar[i],0,pos)
ENDFOR

;conjuga presente
verbos_ar_presente_1apessoa_sing = verbos_ar_radical+'o'
verbos_ar_presente_2apessoa_sing = verbos_ar_radical+'e'
verbos_ar_presente_1apessoa_plu = verbos_ar_radical+'emos'
verbos_ar_presente_2apessoa_plu = verbos_ar_radical+'em'

;conjuga passado perfeito
verbos_ar_pas_perfeito_1apessoa_sing = verbos_ar_radical+'i'
verbos_ar_pas_perfeito_2apessoa_sing = verbos_ar_radical+'eu'
verbos_ar_pas_perfeito_1apessoa_plu = verbos_ar_radical+'emos'
verbos_ar_pas_perfeito_2apessoa_plu = verbos_ar_radical+'eram'

;conjuga passado imperfeito
verbos_ar_pas_imperfeito_1apessoa_sing = verbos_ar_radical+'ia'
verbos_ar_pas_imperfeito_2apessoa_sing = verbos_ar_radical+'ia'
verbos_ar_pas_imperfeito_1apessoa_plu = verbos_ar_radical+'iamos'
verbos_ar_pas_imperfeito_2apessoa_plu = verbos_ar_radical+'iam'

;conjuga futuro formal
verbos_ar_fut_formal_1apessoa_sing = verbos_ar_radical+'erei'
verbos_ar_fut_formal_2apessoa_sing = verbos_ar_radical+'era'
verbos_ar_fut_formal_1apessoa_plu = verbos_ar_radical+'eremos'
verbos_ar_fut_formal_2apessoa_plu = verbos_ar_radical+'erao'

;conjuga futuro informal
verbos_ar_fut_informal_1apessoa_sing = 'vou_' + verbos_ar
verbos_ar_fut_informal_2apessoa_sing = 'vai_' + verbos_ar
verbos_ar_fut_informal_1apessoa_plu = 'vamos_' + verbos_ar
verbos_ar_fut_informal_2apessoa_plu = 'vao_' + verbos_ar
END

3: BEGIN

filename_verbos='/Users/jgroh/temp/du_verbos_ir.txt'
out_file='/Users/jgroh/temp/du_verbos_ir_conjugados.txt'
verbos_ar_struct=READ_ASCII(filename_verbos,header=ewdata_header,count=ewdata_count,TEMPLATE=ASCII_TEMPLATE(filename_verbos),DATA_START=0)
verbos_ar=verbos_ar_struct.field1
verbos_ar_radical=verbos_ar
pos_vec=DBLARR(n_elements(verbos_ar))

;acha radical do verbo
FOR i=0, n_elements(verbos_ar)-1 DO BEGIN
pos=STRPOS(verbos_ar[i],'ir',/REVERSE_SEARCH)
pos_vec[i]=pos
verbos_ar_radical[i]=STRMID(verbos_ar[i],0,pos)
ENDFOR

;conjuga presente
verbos_ar_presente_1apessoa_sing = verbos_ar_radical+'o'
verbos_ar_presente_2apessoa_sing = verbos_ar_radical+'e'
verbos_ar_presente_1apessoa_plu = verbos_ar_radical+'imos'
verbos_ar_presente_2apessoa_plu = verbos_ar_radical+'em'

;conjuga passado perfeito
verbos_ar_pas_perfeito_1apessoa_sing = verbos_ar_radical+'i'
verbos_ar_pas_perfeito_2apessoa_sing = verbos_ar_radical+'iu'
verbos_ar_pas_perfeito_1apessoa_plu = verbos_ar_radical+'imos'
verbos_ar_pas_perfeito_2apessoa_plu = verbos_ar_radical+'iram'

;conjuga passado imperfeito
verbos_ar_pas_imperfeito_1apessoa_sing = verbos_ar_radical+'ia'
verbos_ar_pas_imperfeito_2apessoa_sing = verbos_ar_radical+'ia'
verbos_ar_pas_imperfeito_1apessoa_plu = verbos_ar_radical+'iamos'
verbos_ar_pas_imperfeito_2apessoa_plu = verbos_ar_radical+'iam'

;conjuga futuro formal
verbos_ar_fut_formal_1apessoa_sing = verbos_ar_radical+'irei'
verbos_ar_fut_formal_2apessoa_sing = verbos_ar_radical+'ira'
verbos_ar_fut_formal_1apessoa_plu = verbos_ar_radical+'iremos'
verbos_ar_fut_formal_2apessoa_plu = verbos_ar_radical+'irao'

;conjuga futuro informal
verbos_ar_fut_informal_1apessoa_sing = 'vou_' + verbos_ar
verbos_ar_fut_informal_2apessoa_sing = 'vai_' + verbos_ar
verbos_ar_fut_informal_1apessoa_plu = 'vamos_' + verbos_ar
verbos_ar_fut_informal_2apessoa_plu = 'vao_' + verbos_ar
END

ENDCASE

openw,5,out_file     ; open file to write

FOR i=0,n_elements(verbos_ar)-1 DO BEGIN
printf,5,FORMAT='(A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x,A26,2x)',verbos_ar[i],verbos_ar_radical[i], verbos_ar_presente_1apessoa_sing[i],verbos_ar_presente_2apessoa_sing[i],verbos_ar_presente_1apessoa_plu[i],verbos_ar_presente_2apessoa_plu[i],$
      verbos_ar_pas_perfeito_1apessoa_sing[i],verbos_ar_pas_perfeito_2apessoa_sing[i],verbos_ar_pas_perfeito_1apessoa_plu[i],verbos_ar_pas_perfeito_2apessoa_plu[i],$
      verbos_ar_pas_imperfeito_1apessoa_sing[i],verbos_ar_pas_imperfeito_2apessoa_sing[i],verbos_ar_pas_imperfeito_1apessoa_plu[i],verbos_ar_pas_imperfeito_2apessoa_plu[i],$
      verbos_ar_fut_formal_1apessoa_sing[i],verbos_ar_fut_formal_2apessoa_sing[i],verbos_ar_fut_formal_1apessoa_plu[i],verbos_ar_fut_formal_2apessoa_plu[i],$
      verbos_ar_fut_informal_1apessoa_sing[i],verbos_ar_fut_informal_2apessoa_sing[i],verbos_ar_fut_informal_1apessoa_plu[i],verbos_ar_fut_informal_2apessoa_plu[i]
ENDFOR
close,5












END