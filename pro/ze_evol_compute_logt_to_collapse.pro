FUNCTION ZE_EVOL_COMPUTE_LOGT_TO_COLLAPSE,model,age_Array
;returns an array containing log t before core collapse
 ;times of Ne O Si burning form Hirschi+2004

  IF model eq 'P060z14S0' THEN BEGIN 
       t_neosi=0.99 ; in years
       cburning=1
    ENDIF  
  

;assumes age_Array goes up to end of carbon burning; needs t_neosi, which is the time up to end of Si burning
IF KEYWORD_SET(cburning) THEN logtcollapse=alog10(age_Array[n_elements(age_array)-1]+t_neosi-age_Array) ELSE $
                              logtcollapse=alog10(age_Array[n_elements(age_array)-1]-age_Array)

RETURN,logtcollapse
                              
END