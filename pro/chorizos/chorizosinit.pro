PRO CHORIZOSINIT
chorizos_version = 'v2.1.4'
chorizos_path    = FILE_SEARCH(STRSPLIT(!PATH, PATH_SEP(/SEARCH_PATH),/EXTRACT) + '/chorizos.sav')
RESTORE, chorizos_path[0]
END
