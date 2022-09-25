#!/bin/bash
btrfs subvolume snapshot -r /home /.snapshots/home.$(date +%Y-%m-%d); sync
btrfs subvolume snapshot -r / /.snapshots/root.$(date +%Y-%m-%d); sync   

count_all=$(sudo btrfs subv list / | grep -E "/home.|/root." | wc -l)
count_left=30
sudo btrfs subv list / | grep -E "/home.|/root." | head -n+$(($count_all -$count_left ))| cut -d ' ' -f 9 | xargs -i echo /{} | xargs -i sudo btrfs subvolume delete {}
Exit

Скрипт создает снапшот сабвольюмов /@ и /@home в директорию /.snapshots и удаляет старые снапшоты. 30 последних снапшотов не будут удалены. 
Скрипт можно добавить в crontab командой sudo EDITOR=nvim crontab -e. Команда 0 4 * * * /home/user/sn-btrfs-snapshots.sh будет запускать скрипт каждый день в 04:00 часа.
Число хранимых снапшотов можно изменить отредактировав переменную count_left.

