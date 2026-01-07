#!/bin/bash
ip=192.168.134.42
rsync -Pa -z --zc=zstd --zl=9 --delete /home/snark/data/video/ snark@$ip:/pool0/bc_data/video
sync
