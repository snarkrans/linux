#!/bin/bash
# Перед созданием бекапа нужно примонтировать загрузочный раздел.
exclude="/home/snark/snl/sc/backup/backup_snark_live/exclude"
backup_dir="/home/snark/data/backups/backup_m900"

sudo tar "-I zstd -9 --long -T0" --exclude-from=$exclude -cpvf $backup_dir/backup_m900.$(date +%F).tar.zst -C / .
sudo chown snark:users $backup_dir/backup_m900.$(date +%F).tar.zst
pacman -Qqe > $backup_dir/backup_m900.$(date +%F).pkg.txt

# --long требует больше памяти
#zstdcat *.tar.zst | tar -xvp -C /mnt
#rsync -avhe ssh --progress backup_mini.2023-06-27.tar.zst root@192.168.43.16:/mnt