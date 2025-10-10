#!/usr/bin/env sh
set -euo pipefail

trap '' INT HUP TERM QUIT

case "$(bemenu -p 'Power' -cl 9 -W 0.2 <<__EOF__
1. Lock
2. Screen Off
3. Reload
4. Exit
5. Log Off
6. Suspend
7. Hibernate
8. Reboot
9. Power Off
__EOF__
)" in
	*"Lock") loginctl lock-session ;;
	*"Screen Off")
		loginctl lock-session
		sleep 3; hyprctl dispatch forceidle 660
		;;
	*"Reload") hyprctl reload ;;
	*"Suspend")
		loginctl lock-session
		sleep 3; systemctl suspend-then-hibernate
		;;
	*"Hibernate")
		loginctl lock-session
		sleep 3; systemctl hibernate
		;;
	*"Exit") hyprctl dispatch exit ;;
	*"Log Off")
		systemctl --user exit
		sleep 1; hyprctl dispatch exit
		sleep 1; killall -HUP -u mithic
		sleep 1; killall -TERM -u mithic
		sleep 1; killall -KILL -u mithic
		;;
	*"Reboot")
		systemctl reboot
		sleep 1; killall -HUP -u mithic
		sleep 1; killall -TERM -u mithic
		sleep 1; killall -KILL -u mithic
		;;
	*"Power Off")
		systemctl poweroff
		sleep 1; killall -HUP -u mithic
		sleep 1; killall -TERM -u mithic
		sleep 1; killall -KILL -u mithic
		;;
	*) exit 1 ;;
esac
