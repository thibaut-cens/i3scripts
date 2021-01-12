#!/usr/bin/env bash

#Order application run on startup
autorandr -c

nitrogen --restore
~/.config/polybar/launch.sh
~/.config/compton/launch.sh

mailnag > ~/.local/logs/mailnag-$(date +%s).log 2>&1 &
