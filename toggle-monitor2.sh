#!/bin/bash

MONITOR="DP-7"

if kscreen-doctor -o | grep -A2 "Output: .* $MONITOR " | grep -q "enabled"; then
    kscreen-doctor output.$MONITOR.disable
else
    kscreen-doctor output.$MONITOR.enable
fi