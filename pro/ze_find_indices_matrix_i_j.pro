;PRO ZE_FIND_INDICES_MATRIX_I_J,indexi,indexj
;find number indices of matrix where i GT J or I lt J
n=2 
indexi=indgen(2*n)
indexj=indgen(n)

imatrix=cmreplicate(indexi,n_elements(indexj))
jmatrix=transpose(imatrix)

s=where(jmatrix GT imatrix,count)
print,count

END