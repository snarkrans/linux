#!/bin/bash
backup_dir="/home/snark/data/backup/backup_p16_ar"
backup_name="backup_p16_home-$(date +%F)"

tar "-I zstd -9 --long -T0" -cpvf $backup_dir/$backup_name.tar.zst -C /home/snark/data/backup/backup_p16_home .
