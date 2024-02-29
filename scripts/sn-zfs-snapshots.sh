#!/bin/bash
save=3 # snapshots count.

# zroot/ROOT/default
zfs snapshot -r zroot/ROOT/default@$(date +%Y-%m-%d_%H:%M:%S)
all=$( zfs list -t snapshot | grep -E "ROOT" | wc -l)
zfs list -t snapshot | grep -E "ROOT" | head -n+$(($all -$save ))| cut -d ' ' -f 1 | xargs -i sudo zfs destroy -r {}
# zroot/data/home
zfs snapshot -r zroot/data/home@$(date +%Y-%m-%d_%H:%M:%S)
all=$( zfs list -t snapshot | grep -E "home" | wc -l)
zfs list -t snapshot | grep -E "home" | head -n+$(($all -$save ))| cut -d ' ' -f 1 | xargs -i sudo zfs destroy -r {}