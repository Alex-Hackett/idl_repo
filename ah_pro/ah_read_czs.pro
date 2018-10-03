FUNCTION AH_READ_CZS, data_wgfile_cut, zones

z_index = FLOOR(FINDGEN(40, START = 69))
zones = [ ]
FOREACH i, z_index, index DO BEGIN
zones = [[zones],[REFORM(data_wgfile_cut[i,*])]]
ENDFOREACH
zones = TRANSPOSE(zones)


RETURN, zones
END
