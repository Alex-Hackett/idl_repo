; $Id: acs_startup.pro,v 1.2 2002/03/12 18:45:09 mccannwj Exp $

; CHANGE PROMPT
!PROMPT = 'ACS>'

; Warn about obsolete routines
!WARN.OBS_ROUTINES = 1

DEFSYSV, '!DUMP', 0
DEFSYSV, '!prelaunch', 0

; SET UP ASTROLIB UTILS
astrolib
