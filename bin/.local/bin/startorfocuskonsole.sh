#!/bin/sh

WINTITLE="Konsole"
COMMAND="/usr/bin/konsole"

matches=$(wmctrl -l | grep -c $WINTITLE)

if [ $matches -ne 0 ]; then
    wmctrl -a $WINTITLE
else
    $COMMAND
fi
