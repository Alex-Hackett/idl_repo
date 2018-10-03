PRO ZE_CCD_LOCATE_FILES_IN_STARNAME,starname,str,starname_found,index_found,count_found
;locate files that contain STR as start characters of their filenames in a given night dir
;return both starname_found and index_found, so other vector similar to starname can then be easily cropped

index_found=WHERE(strmatch(starname,str+'*') EQ 1,count_found)
IF count_found GT 0 THEN starname_found=starname(index_found)

END