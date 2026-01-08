#!/bin/bash

sudo mount /dev/mapper/luks /mnt

#root
save=12
btrfs subvolume snapshot -r / /.snapshots/root.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/root" | wc -l)
sudo btrfs subv list / | grep -E "/root" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#home
save=12
btrfs subvolume snapshot -r /home /.snapshots/home.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/home" | wc -l)
sudo btrfs subv list / | grep -E "/home" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#data
save=12
btrfs subvolume snapshot -r /home/snark/data /.snapshots/data.$(date +%Y-%m-%d_%H:%M:%S); sync
all=$(sudo btrfs subv list / | grep -E "/data" | wc -l)
sudo btrfs subv list / | grep -E "/data" | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

sudo umount /mnt

exit

Отправить снимки по ssh можно командой sudo btrfs -v send /.snapshots/* | sudo ssh -p 22 root@192.168.43.72 "btrfs receive /.snapshots"
#Откат из снапшота.
Примонтировать корневой диск.
mount /dev/nvme0n1p3 /mnt
Посмотреть список сабвольюмов.
btrfs subvolume list /mnt
Переименовать, или удалить текушие сабвольюмы.
mv /mnt/@ /mnt/@old
mv /mnt/@home /mnt/@home-old
Сделать новые сбвольюмы из снапшотов.
sudo btrfs subvolume snapshot /mnt/@home-old/.snapshots/home.2023-06-25_19:44:29 /mnt/@home
sudo btrfs subvolume snapshot /mnt/@old/.snapshots/root.2023-06-25_19:44:29 /mnt/@
При необходимости, отредактировать fstab и конфиг загрузчика.
