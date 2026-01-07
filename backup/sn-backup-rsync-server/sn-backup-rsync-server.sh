#!/bin/bash
ip=100.116.29.116
ssh -t snark@$ip "sudo zfs load-key pool0/bc_data && sudo zfs mount pool0/bc_data"
exclude="/home/snark/snl/backup/sn-backup-rsync-server/exclude"
rsync -Pa -z --zc=zstd --zl=9 --delete --exclude-from=$exclude /home/snark/data/ snark@$ip:/pool0/bc_data
sync
