#!/usr/bin/env bash
# Battery status script for tmux

batt_info=$(pmset -g batt)
percent=$(echo "$batt_info" | grep -o '[0-9]\+%' | head -1)
level=${percent%\%}

# Battery emoji based on level
if echo "$batt_info" | grep -q "AC Power"; then
    icon="🔌"
elif (( level >= 80 )); then
    icon="🔋"
elif (( level >= 60 )); then
    icon="🔋"
elif (( level >= 40 )); then
    icon="🪫"
elif (( level >= 20 )); then
    icon="🪫"
else
    icon="🪫"
fi

echo "${icon} ${percent}"
