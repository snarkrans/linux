#!/bin/bash
# Удалит все снимки проме $1 последних.

sudo mount /dev/mapper/luks /mnt

#root
all=$(sudo btrfs subv list / | grep -E "/root" | wc -l)
sudo btrfs subv list / | grep -E "/root" | head -n+$(($all -$1 ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /mnt/{}

#home
all=$(sudo btrfs subv list / | grep -E "/home" | wc -l)
sudo btrfs subv list / | grep -E "/home" | head -n+$(($all -$1 ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /mnt/{}

#data
all=$(sudo btrfs subv list / | grep -E "/data" | wc -l)
sudo btrfs subv list / | grep -E "/data" | head -n+$(($all -$1 ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /mnt/{}

sudo umount /mnt
exit
