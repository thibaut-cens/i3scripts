#!/usr/bin/env bash

#Order application run on startup
autorandr -c

nitrogen --restore
~/.config/polybar/launch.sh
~/.config/compton/launch.sh
