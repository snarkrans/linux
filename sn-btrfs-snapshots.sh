#!/bin/bash
btrfs subvolume snapshot -r /home /.snapshots/home.$(date +%Y-%m-%d); sync
btrfs subvolume snapshot -r / /.snapshots/root.$(date +%Y-%m-%d); sync   

count_all=$(sudo btrfs subv list / | grep -E "/home.|/root." | wc -l)
count_left=30
sudo btrfs subv list / | grep -E "/home.|/root." | head -n+$(($count_all -$count_left ))| cut -d ' ' -f 9 | xargs -i echo /{} | xargs -i sudo btrfs subvolume delete {}
Exit

Скрипт создает снимки сабвольюмов /@ и /@home в директорию /.snapshots и удаляет все снимки кроме 30 последних. Число хранимых снимков можно изменить отредактировав переменную count_left.
Скрипт можно добавить в crontab командой sudo EDITOR=vim crontab -e. Команда 0 4 * * * /home/user/sn-btrfs-snapshots.sh будет запускать скрипт каждый день в 04:00 часа.
Отправить снимки по ssh можно командой sudo btrfs -v send /.snapshots/* | sudo ssh -p 22 root@192.168.43.72 "btrfs receive /.snapshots"

