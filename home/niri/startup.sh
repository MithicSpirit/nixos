#!/usr/bin/env sh

set -x
trap 'pkill -eu mithic -KILL; exit 2' INT
trap '' HUP TERM QUIT CONT TSTP

niri-session >>/tmp/niri.log 2>&1

sleep 1
systemctl --user exit

sleep 5
pgrep -u mithic --list-name --ignore-ancestors
pstree mithic
sleep 5
pkill -eu mithic -TERM --ignore-ancestors
timeout '10s' pidwait -u mithic --ignore-ancestors
[ $? -le 1 ] && exit 0

pgrep -u mithic --list-name --ignore-ancestors
pstree mithic
sleep 10
loginctl kill-session '' --signal=SIGKILL
exit 1
