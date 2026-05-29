#!/usr/bin/env sh

set -x
trap 'pkill -eu mithic -KILL; exit 2' INT
trap '' HUP TERM QUIT CONT TSTP

niri-session >>/tmp/niri.log 2>&1
sleep 1

systemctl --user exit
sleep 1
pgrep -u mithic --list-name --ignore-ancestors
[ $? -eq 1 ] && exit 0
sleep 1
pstree mithic
sleep 10

pkill -eu mithic -TERM --ignore-ancestors
timeout -f '10s' pidwait -u mithic --ignore-ancestors
[ $? -le 1 ] && exit 0

pgrep -u mithic --list-name --ignore-ancestors
pstree mithic
sleep 10
loginctl kill-session '' --signal=SIGKILL
exit 1
