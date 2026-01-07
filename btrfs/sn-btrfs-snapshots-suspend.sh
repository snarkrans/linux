#!/bin/bash

#root
save=21
btrfs subvolume snapshot -r / /.snapshots/root.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/root" | wc -l)
sudo btrfs subv list / | grep -E "/root" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#home
save=21
btrfs subvolume snapshot -r /home /.snapshots/home.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/home" | wc -l)
sudo btrfs subv list / | grep -E "/home" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#sn
save=21
btrfs subvolume snapshot -r /home/snark/sn /.snapshots/sn.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/sn" | wc -l)
sudo btrfs subv list / | grep -E "/home" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#data_01
save=21
btrfs subvolume snapshot -r /home/snark/data_01 /.snapshots/data.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/data" | wc -l)
sudo btrfs subv list / | grep -E "/data" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#data_02
save=21
btrfs subvolume snapshot -r /home/snark/data_02 /home/snark/data_02/.snapshots/data.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/data" | wc -l)
sudo btrfs subv list / | grep -E "/data" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#sleep 21
#systemctl suspend
