
DEVICE, DECOMPOSED=0  ; Frescuras do IDL!!!
LOADCT, 13  ; Carrega a tabela de cores, neste caso 13 s�o as cores do arco-�ris...
X = SIN(FINDGEN(100)) & Y = COS(FINDGEN(100)) & Z=X*Y ; Criar vetores X, Y e Z: ; Plotar o gr�fico:
PLOT, X, Y, /NODATA
PLOTS, X, Y, Z, COLOR = BYTSCL(Z, TOP=!D.N_COLORS-1), /NORMAL

end
