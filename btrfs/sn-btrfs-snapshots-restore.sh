#!/bin/bash

sn_name=$(sudo btrfs subvolume list / | grep -i root | fzf | cut -d" " -f9)

read -p "Продолжить? (y/n): " answer
if [[ "$answer" == "y" ]]; then
    echo "Продолжаем..."
    sudo mount /dev/mapper/luks /mnt
	sudo mv /mnt/@ /mnt/@old
	sudo btrfs subvolume snapshot /mnt/$sn_name /mnt/@
else
    echo "Отменено"
    exit 1
fi

# clean
# mount /dev/mapper/luks /mnt
# btrfs subvolume delete /mnt/@old
