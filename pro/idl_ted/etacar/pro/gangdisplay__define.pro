;+
;   NAME:
;                 GANGDISPLAY
;
;   PURPOSE:
;      Object-oriented image display widget for synchronized displays.
;
;   EXPLANATION:
;      These routines set up an object-oriented widget for synchronized
;      (ganged) image displays.  The object orientation is in the programming
;      method, not the graphics, which are traditional IDL direct graphics.
;
;      For arguments, see the individual routines below, especially the
;      init method.  See also imgdisplay__define.pro, and
;      repeater__define.pro, which set up the objects from which this 
;      one inherits directly.
;
;      Using the displays created by this object, the programmer can
;      replicate zooming and panning for two different images.
;      One display is the "sender" and the others are "receivers".
;      Double-clicking in a display window of a receiver turns it into
;      sender.
;
;   INHERITS:
;      imgdisplay   - image display and readout widget
;      repeater     - object to replicate and propagate events 
;                     from one widget to another
;
;   CATEGORY:
;      Widgets.
;
;   CALLING SEQUENCE FOR INITIALIZATION:
;      new = obj_new('gangdisplay', parent, prev, first, keywords=.....)
;
;   ARGUMENTS:
;      See also the objects from which this one inherits.
;      PARENT:    Widget ID of parent base widget
;      PREV:      Object reference for previous display in chain    
;      FIRST:     Object reference for first display in chain
;
;   KEYWORDS:
;      BLINKABLE:   NOT IMPLEMENTED.  If set, endow displays with blink
;                   capability.
;      _EXTRA:      The other keywords needed by IMGDISPLAY, which see.
;
;   MODIFICATION HISTORY:
;      Written by R. S. Hill, Raytheon ITSS, 23 April 1999
;      11 May 1999 - added scale synchronizing button.  RSH
;      24 May 1999 - changed call to ::v to call to ::draw.  RSH
;      27 May 1999 - Correct processing of double click
;                    if already sender.  RSH
;-


PRO GANGDISPLAY::E, Event

;
;  Event handling for the gangdisplay object.
;

;
;  What kind of event?  To do what?
;
tn = tag_names(event)
event_name = tag_names(event,/structure_name)


IF obj_valid(self) THEN BEGIN   ; defensive programming
    ;
    ;   Is it a draw event? 
    draw = event_name EQ 'WIDGET_DRAW'
    IF draw THEN type = event.type ELSE type = -99
    IF type EQ 1 AND self.eat_a_release THEN BEGIN
        ;
        ;   If we had a double-click, we need to catch the
        ;   next release, which will goof things up.
        self.eat_a_release = 0
        repeat_event = 0
    ENDIF ELSE BEGIN
        ;
        ;   "Specials" are for controls that are only in
        ;   gangdisplay, not imgdisplay
        special = event.id EQ self.blink_button $
                  OR event.id EQ self.sync_button
        ;
        ;   We don't rebroadcast viewport updates, because
        ;   in imgdisplay, they already generate duplicated
        ;   events (panning window motions).  We don't rebroadcast
        ;   doubleclicks because they have the meta-function of
        ;   changing the controlling display.
        repeat_event = 0
        double_click = 0
        IF draw THEN BEGIN
            double_click = event.clicks GE 2
            repeat_event = (NOT double_click) AND (event.type NE 3)
        ENDIF
        ;
        ;   If double click, make self the sender.
        IF double_click THEN BEGIN
            this = self.next
            WHILE this NE self DO BEGIN
                this.sender = 0
                this = this.next
            ENDWHILE
            self.sender = 1
            self.eat_a_release = 1
        ENDIF
        ;
        ;   Process specials.
        IF special THEN BEGIN
            IF event.id EQ self.blink_button THEN BEGIN
            ;  Do nothing right now.  TO be implemented later. 
            ENDIF
            IF event.id EQ self.sync_button THEN BEGIN
                ;
                ;  Find sender
                this = self
                WHILE NOT this.sender DO this = this.next
                ;
                ;  Get display parameters (data units)
                IF this.sigabsval THEN BEGIN
                    lower_limit = this.lowsigval
                    upper_limit = this.hisigval
                ENDIF ELSE BEGIN
                    lower_limit = this.min_other
                    upper_limit = this.max_other
                ENDELSE
                scaling = this.linlogval
                ;
                ;  Change all displays in ring to have those parameters
                this = this.next
                WHILE NOT this.sender DO BEGIN
                    this.sigabsval = 1
                    this.lowsigval = lower_limit
                    this.hisigval = upper_limit
                    this.linlogval = scaling
                    this->draw
                    this = this.next
                ENDWHILE
            ENDIF
        ENDIF
        ;
        ;   We're done with gandisplay event processing, now
        ;   cascade to the imgdisplay event processing.
        IF NOT (special OR double_click) THEN BEGIN
            self->imgdisplay::e, event
        ENDIF
    ENDELSE
ENDIF

;
;   Make sure we still exist.  If so, are we sender?
sender = 0
IF obj_valid(self) THEN sender = self.sender
;
;   Here's where the events get rebroadcast.  Only "real" events
;   (non-anonymous structures) get propagated.  This is defensive
;   programming to prevent loops.  The underlying repeater object
;   is structured so that only senders send, and they don't 
;   send to themselves, but why not some extra safety in case of
;   a booboo?
;
IF repeat_event AND sender AND event_name NE "" THEN $
        self->repeater::send, event


RETURN
END


FUNCTION GANGDISPLAY::INIT, Parent, Prev, First, SYNC=sync, $
                            BLINKABLE=blinkable, _extra=extra
;  Arguments:
;   Parent:    Widget ID of parent base widget
;   Prev:      Object reference for previous display in chain    
;   First:     Object reference for first display in chain
;
;  Keywords:
;   BLINKABLE:   NOT IMPLEMENTED.  If set, endow displays with blink
;                capability.
;   _EXTRA:      The other keywords needed by IMGDISPLAY, which see.
;

;
;  Events from the widgets identified in these IMGDISPLAY tags will
;  be propagated along the display chain.
fields = ['zoomlist', 'pandisp', 'zoomdisp', 'killid', $
          'maindisp']

ret = self->repeater::init(parent, prev, first, fields)
IF self.sender THEN BEGIN
    ret = self->imgdisplay::init(Parent, _extra=extra)
ENDIF ELSE BEGIN
    ;
    ;  No kill button on any display except the first, which
    ;  is the initial sender
    extra.kill_button=0
    ret = self->imgdisplay::init(Parent, _extra=extra)
ENDELSE

IF keyword_set(blinkable) THEN BEGIN
    ;
    ;   self.button_frame is part of IMGDISPLAY
    self.blink_button = widget_button( $
        self.button_frame, value='BLINK')
ENDIF

IF keyword_set(sync) THEN BEGIN
    ;
    ;   button to synchronize display scales
    self.sync_button = widget_button( $
        self.button_frame, value='Same Scale')
ENDIF

RETURN, ret
END

PRO GANGDISPLAY::CLEANUP

;  Stop nicely when quitting from widget.

self->repeater::cleanup
self->imgdisplay::cleanup

RETURN
END


PRO GANGDISPLAY__DEFINE

;  Just gets the object definition into the IDL session.

struct = {GANGDISPLAY, blink_button:-1L, sync_button:-1L, $
          eat_a_release:0b, $
          inherits IMGDISPLAY, inherits REPEATER}

RETURN
END
