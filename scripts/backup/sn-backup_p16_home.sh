#!/bin/bash

dir="/home/snark/data/backup/backup_p16_home/"

rsync -Pa --delete  /home/snark/sn $dir
rsync -Pa --delete  /home/snark/snl $dir

rsync -Pa --delete  /home/snark/.config/blender $dir

rsync -Pa --delete  /home/snark/.local/share/gnupg $dir
rsync -Pa --delete  /home/snark/.local/share/pass $dir

rsync -Pa --delete  /home/snark/.ssh $dir
