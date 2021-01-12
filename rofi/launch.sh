#!/bin/bash

menu="$1"

if [ "$menu" == "drun" ]; then
    rofi -show drun -theme clean
elif [ "$menu" == "ssh" ]; then
    rofi -show ssh -theme ssh
elif [ "$menu" == "powermenu" ]; then
    # rofi -modi 'Powermenu:~/Scripts/rofi/rofi-powermenu.sh' -show Powermenu -theme powermenu
	rofi -modi "Powermenu:$(dirname $0)/rofi-powermenu.sh" -show Powermenu -theme powermenu -location 3 -xoffset -24 -yoffset 70
else
    rofi -show "$menu" -theme clean
fi
