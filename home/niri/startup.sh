#!/usr/bin/env sh

set -x
trap 'pkill -eu "$USER" -KILL; exit 2' INT
trap '' HUP TERM QUIT CONT TSTP

niri-session >>/tmp/niri.log 2>&1

sleep 1
systemctl --user exit

sleep 2
pgrep -u "$USER" --list-name --ignore-ancestors
[ $? -eq 1 ] && exit 0
pstree "$USER"

sleep 2
pkill -eu "$USER" -TERM --ignore-ancestors
timeout -f '5s' pidwait -u "$USER" --ignore-ancestors
[ $? -le 1 ] && exit 0
pkill -eu "$USER" -TERM --ignore-ancestors

sleep 2
pgrep -u "$USER" --list-name --ignore-ancestors
[ $? -eq 1 ] && exit 0
pstree "$USER"

sleep 5
pkill -eu "$USER" -KILL
exit 1
