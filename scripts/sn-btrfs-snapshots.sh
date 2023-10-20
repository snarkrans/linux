#!/bin/bash
btrfs subvolume snapshot -r /home /.snapshots/home.$(date +%Y-%m-%d_%H:%M:%S); sync
btrfs subvolume snapshot -r / /.snapshots/root.$(date +%Y-%m-%d_%H:%M:%S); sync
#btrfs subvolume snapshot -r /home/snark/mnt/drive_01 /home/snark/mnt/drive_01/.snapshots/drive_01.$(date +%Y-%m-%d_%H:%M:%S); sync   

all=$(sudo btrfs subv list / | grep -E "/home.|/root." | wc -l)
save=30
sudo btrfs subv list / | grep -E "/home.|/root." | head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /{}

#all=$(sudo btrfs subv list /home/snark/mnt/drive_01 | grep -E "drive_01." | wc -l)
#save=6
#sudo btrfs subv list /home/snark/mnt/drive_01 | grep -E "drive_01."| head -n+$(($all -$save ))| cut -d ' ' -f 9 | xargs -i sudo btrfs subvolume delete /home/snark/mnt/drive_01/{}

exit

Скрипт создает снимки сабвольюмов /@ и /@home в директорию /.snapshots и удаляет все снимки кроме 30 последних. Число хранимых снимков можно изменить отредактировав переменную save.
Скрипт можно добавить в crontab командой sudo EDITOR=vim crontab -e. Команда 0 4 * * * /home/user/sn-btrfs-snapshots.sh будет запускать скрипт каждый день в 04:00 часа.
Отправить снимки по ssh можно командой sudo btrfs -v send /.snapshots/* | sudo ssh -p 22 root@192.168.43.72 "btrfs receive /.snapshots"
