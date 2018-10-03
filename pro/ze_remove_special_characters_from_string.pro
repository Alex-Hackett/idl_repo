PRO ZE_REMOVE_SPECIAL_CHARACTERS_FROM_STRING,string1,string2,string3,string4,string5
;remove special characters from xtitle,ytitle,label, so a valid filename can be set:
;works for up to 5 strings, easy to expand to more strings if needed be

special_characters=['*','!','/','\','?','(',')',' ','+','-','=',',']

   for j=0, n_elements(special_characters) -1 do remchar,string1,special_characters[j]
   for j=0, n_elements(special_characters) -1 do remchar,string2,special_characters[j]
   for j=0, n_elements(special_characters) -1 do remchar,string3,special_characters[j]
   for j=0, n_elements(special_characters) -1 do remchar,string4,special_characters[j]
   for j=0, n_elements(special_characters) -1 do remchar,string5,special_characters[j]         

END