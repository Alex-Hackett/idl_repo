FUNCTION ZE_EVOL_ADD_SPACE_TO_TIMESTEP_FORMAT,timestep
;add leading space to timestep to have the right formatting in evol
;input is integer or float, output is string 
 IF timestep LT 10 then timestep_str='      '+strcompress(string(timestep),/remove_all) ELSE $
 IF timestep LT 100 then timestep_str='     '+strcompress(string(timestep),/remove_all) ELSE $
 IF timestep LT 1000 then timestep_str='    '+strcompress(string(timestep),/remove_all) ELSE $
 IF timestep LT 10000 then timestep_str='   '+strcompress(string(timestep),/remove_all) ELSE $
 IF timestep LT 10000 then timestep_str='   '+strcompress(string(timestep),/remove_all) ELSE $
 IF timestep LT 100000 then timestep_str='  '+strcompress(string(timestep),/remove_all)

return,timestep_str
END