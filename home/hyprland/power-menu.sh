#!/usr/bin/env sh
set -euo pipefail

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
		sleep 2; hyprctl dispatch dpms off ;;
	*"Reload") hyprctl reload ;;
	*"Suspend") sleep 2; systemctl suspend-then-hibernate ;;
	*"Hibernate") sleep 2; systemctl hibernate ;;
	*"Exit") hyprctl dispatch exit ;;
	*"Log Off")
		systemctl --user exit
		sleep 1; hyprctl dispatch exit
		sleep 1; killall -u mithic ;;
	*"Reboot") systemctl reboot ;;
	*"Power Off") systemctl poweroff ;;
	*) exit 1 ;;
esac
