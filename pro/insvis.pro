; $Id: insvis.pro,v 1.11 2005/02/01 20:24:26 scottm Exp $
;
; Copyright (c) 1996-2005, Research Systems, Inc.  All rights reserved.
;       Unauthorized reproduction prohibited.
;+
; NAME:
;       INSVIS
;
; PURPOSE:
;       Stub for INSVIS.  Displays message saying that Insight must be running.
;       Once Insight is restored and running this routine will be replaced by
;       the actual compiled version in the Insight save file.
;
; NOTES:
;       - See the online documentation for usage information.
;
;------------------------------------------------------------------------------
pro InsVis, $
    name1, $                ;  IN: name of dependent data
    name2, $                ;  IN: (opt) name of independent data
    _EXTRA=extra

    ;;  Notify user that Insight must be running to use this function.
    ;;
    result = DIALOG_MESSAGE($
        ['Insight must be running in order to use InsVis.', $
        'Please start Insight and try again.'] )
end
