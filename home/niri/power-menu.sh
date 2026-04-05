#!/usr/bin/env sh
set -euo pipefail

trap '' INT HUP TERM QUIT CONT TSTP

case "$(bemenu -p 'Power' -cl 8 -W 0.2 <<__EOF__
1. Lock
2. Screen Off
3. Reload
4. Log Off
5. Suspend
6. Hibernate
7. Reboot
8. Power Off
__EOF__
)" in
	*"Lock") loginctl lock-session ;;
	*"Screen Off")
		loginctl lock-session
		sleep 3; niri msg action power-off-monitors
		;;
	*"Reload") niri msg action load-config-file ;;
	*"Suspend")
		loginctl lock-session
		sleep 3; systemctl suspend-then-hibernate
		;;
	*"Hibernate")
		loginctl lock-session
		sleep 3; systemctl hibernate
		;;
	*"Log Off")
		systemctl --user exit
		niri msg action quit --skip-confirmation
		;;
	*"Reboot")
		systemctl reboot
		niri msg action quit --skip-confirmation
		;;
	*"Power Off")
		systemctl poweroff
		niri msg action quit --skip-confirmation
		;;
	*) exit 1 ;;
esac
