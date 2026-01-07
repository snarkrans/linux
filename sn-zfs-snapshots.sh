#!/bin/bash
save=30 # snapshots count.

# zroot/ROOT/default
zfs snapshot -r zroot/ROOT/default@$(date +%Y-%m-%d_%H:%M:%S)
all=$(zfs list -t snapshot | grep -E "default" | wc -l)
zfs list -t snapshot | grep -E "default" | head -n+$(($all -$save ))| cut -d ' ' -f 1 | xargs -i zfs destroy -r {}
# zroot/data/home
zfs snapshot -r zroot/data/home@$(date +%Y-%m-%d_%H:%M:%S)
all=$(zfs list -t snapshot | grep -E "home" | wc -l)
zfs list -t snapshot | grep -E "home" | head -n+$(($all -$save ))| cut -d ' ' -f 1 | xargs -i zfs destroy -r {}
# zroot/data/tank
zfs snapshot -r zroot/data/tank@$(date +%Y-%m-%d_%H:%M:%S)
all=$(zfs list -t snapshot | grep -E "tank" | wc -l)
zfs list -t snapshot | grep -E "tank" | head -n+$(($all -$save ))| cut -d ' ' -f 1 | xargs -i zfs destroy -r {}
