#!/bin/bash
# Перед созданием бекапа нужно примонтировать загрузочный раздел.
exclude=/home/snark/snl/sc/backup/backup_snark_live/exclude
backup_dir=/home/snark/data/backups/backup_mini
cd /
sudo tar --exclude-from=$exclude -cpzvf $backup_dir/backup_mini.$(date +%F).tgz .
exit


example_01. backup restore
sudo tar xvpfz b01.tgz -C /mnt/arch
* возможно, необходимо создать недостающие директории

example_02. backup
cd /
tar --exclude=./{proc,sys,mnt,tmp,lost+found} --exclude=./home/snark/{snsoft,Downloads} --exclude=./var/{log,cache} -cpzvf /mnt/work/linux/backup/backup.tgz .
