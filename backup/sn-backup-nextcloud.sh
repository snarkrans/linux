#!/bin/bash
backup_dir="/home/snark/data/backup/backup_p16_ar"
backup_name="nextcloud-backup-$(date +%F)"

sudo tar "-I zstd -9 --long -T0" -cpvf $backup_dir/$backup_name.tar.zst -C /home/snark/data/soft/nextcloud .
sudo chown snark:users $backup_dir/$backup_name.tar.zst

# extract
#sudo zstdcat nextcloud-backup.tar.zst | sudo tar -xvp -C nextcloud
