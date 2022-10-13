#!/bin/bash
# Скрипт качает последнюю версию блендера в директорию ~/blender/downloads/alpha/.
# Зависимости: axel wget

pacman -Q | grep axel > /dev/null 2>&1 || echo "dependency required: axel - light command line download accelerator"
pacman -Q | grep wget > /dev/null 2>&1 || echo "dependency required: wget - the non-interactive network downloader."
echo
ls -l ~/blender/downloads/alpha/ > /dev/null 2>&1 || mkdir -p ~/blender/downloads/alpha/
rm -r ~/blender/downloads/alpha/* > /dev/null 2>&1
cd ~/blender/downloads/alpha/
var=$(wget -qO- https://builder.blender.org/download/daily/ | grep -o -G 'blender-[^a-z]*-alpha+master.[0-9a-z]*-linux.x86_64-release.tar.xz' | awk 'NR==1')
axel -n 10 https://builder.blender.org/download/daily/$var
tar -xf ~/blender/downloads/alpha/*.tar.xz -C ~/blender/downloads/alpha
cp ~/blender/BlenderAlpha.desktop ~/.local/share/applications
#sed -ie 's|Exec.*|Exec=~/blender/downloads/alpha/blender-*/blenderSSSSSSSSSSS %f |g' BlenderAlpha.desktop
