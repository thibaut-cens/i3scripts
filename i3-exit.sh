answer="`dunstify -A yes,'Log out' 'Dou you want to log out ?' -i system-log-out`"

if [ "$answer" = "yes" ]; 
	then i3-msg exit;
fi
