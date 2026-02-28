

[[linux - zfs]] [[linux - шпаргалка]]  

https://git.s-morozov.net/sergey/archlive-zfs  

https://florianesser.ch/posts/20220714-arch-install-zbm/  
# Установка Arch Linux на ZFS.

$ wipefs -a /dev/nvme0n1 # удаления сигнатур файловых систем и RAID  
$ cfdisk -z /dev/vda # Создаем таблицу GPT и два раздела. vda1 - 256Mb и Type - EFI System. vda2 - все свободное место, Type - Solaris Root.  

Загружаем FZF модули ядра.  
https://github.com/eoli3n/archiso-zfs  
$ curl -s https://raw.githubusercontent.com/eoli3n/archiso-zfs/master/init | bash  

$ modprobe zfs  

Создаем пул.  
zpool create -f -o ashift=12         \
             -O acltype=posixacl       \
             -O relatime=on            \
             -O xattr=sa               \
             -O dnodesize=legacy       \
             -O normalization=formD    \
             -O mountpoint=none        \
             -O canmount=off           \
             -O devices=off            \
             -R /mnt                   \
             -O compression=lz4        \
             -O encryption=aes-256-gcm \
             -O keyformat=passphrase   \
             -O keylocation=prompt     \
             zroot /dev/disk/by-partuuid/...

$ zpool create -f -o ashift=12     	\
         	-O acltype=posixacl   	\
         	-O relatime=on        	\
         	-O xattr=sa           	\
         	-O dnodesize=legacy   	\
         	-O normalization=formD	\
         	-O mountpoint=none    	\
         	-O canmount=off       	\
         	-O devices=off        	\
         	-R /mnt               	\
         	zroot /dev/vda2

Создаем пул. Пример с mirror рейдом и сжатием.  
$ zpool create -f -o ashift=12     	\
         	-O acltype=posixacl   	\
         	-O relatime=on        	\
         	-O xattr=sa           	\
         	-O dnodesize=legacy   	\
         	-O normalization=formD	\
         	-O mountpoint=none    	\
         	-O canmount=off       	\
         	-O devices=off        	\
         	-R /mnt               	\
     	-O compression=lz4        \
         	zroot mirror /dev/vda2 /dev/vdb1

Создаем datasets.  
$ zfs create -o mountpoint=none zroot/data  
$ zfs create -o mountpoint=none zroot/ROOT  
$ zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default  
$ zfs create -o mountpoint=/home zroot/data/home  
$ zfs create -o mountpoint=/var/cache/pacman/pkg zroot/ROOT/pkg  

Экспортируем/импортируем пул.  
$ zpool export zroot  
$ zpool import -d /dev/vda2 -R /mnt zroot -N  

$ zfs load-key zroot  
(zfs load-key zroot < /keyfile)  
$ zfs mount zroot/ROOT/default  
$ zfs mount -a  
 
Настройка.  
$ zpool set bootfs=zroot/ROOT/default zroot  
$ zpool set cachefile=/etc/zfs/zpool.cache zroot  
$ mkdir -p /mnt/etc/zfs  
$ mkdir -p /mnt/efi  

$ cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache  
$ mkfs.vfat -F32 -n EFI /dev/vda1  
$ mount /dev/vda1 /mnt/efi  

Ставим систему.  
$ pacstrap /mnt base linux-lts linux-lts-headers neovim base-devel iwd  

$ genfstab -U -p /mnt > /mnt/etc/fstab  
$ arch-chroot /mnt  
Удалить из /mnt/etc/fstab все, кроме монтирования /boot  

https://github.com/archzfs/archzfs/wiki  
Добавить в /etc/pacman.conf репозиторий archzfs.  
[archzfs]  
Server = http://archzfs.com/$repo/x86_64  
Server = http://mirror.sum7.eu/archlinux/archzfs/$repo/x86_64  
Server = https://mirror.biocrafting.net/archlinux/archzfs/$repo/x86_64  
Server = https://mirror.in.themindsmaze.com/archzfs/$repo/x86_64  
Server = https://zxcvfdsa.com/archzfs/$repo/$arch  
```
# pacman-key -r DDF7DB817396A49B2A2723F7403BD972F75D9D76
# pacman-key --lsign-key DDF7DB817396A49B2A2723F7403BD972F75D9D76
```

$ pacman -S zfs-dkms xfce4 xorg-server  

Добавить в /etc/mkinitcpio.conf  
MODULES=(zfs)  
HOOKS=(... keyboard zfs filesystems)  

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen ; locale-gen  
echo "LANG=en_US.UTF-8" > /etc/locale.conf  
echo "KEYMAP=us" > /etc/vconsole.conf  
echo "test" > /etc/hostname  
zgenhostid $(hostid)  
hostid  

https://gist.github.com/Adito5393/1f1b53ba907f52fd39e09e93453269c8  

$ mkdir -p /efi/EFI/zbm  
$ wget https://get.zfsbootmenu.org/latest.EFI -O /efi/EFI/zbm/zfsbootmenu.EFI  
$ efibootmgr --disk /dev/vda  --part 1 --create --label "ZFSBootMenu" --loader '\EFI\zbm\zfsbootmenu.EFI' --unicode "spl_hostid=$(hostid) zbm.timeout=3 zbm.prefer=zroot zbm.import_policy=hostid" --verbose  

Set kernel boot parameters:  
$ zfs set org.zfsbootmenu:commandline="noresume init_on_alloc=0 rw spl.spl_hostid=$(hostid)" zroot/ROOT  

$ passwd # создаем пароль для рута  

- Настраиваем pacman, sudo, добавляем пользователя.  
$ useradd -m -g users -G audio,video,network,wheel,storage -s /bin/bash username # добавляем юзера. Вместо username, ставим свое.  
```
useradd -m -G wheel username
```
$ passwd username # создаем пароль юзера. можно использовать такой-же как и для рута.  

$ nano /etc/sudoers # раскомментируем строку: %wheel ALL=(ALL) ALL  
* $ visudo # тоже что и nano /etc/sudoers  

$ mkinitcpio -P  
$ systemctl enable zfs.target  
$ systemctl enable zfs-import.target  
$ systemctl enable zfs-volumes.target  
$ systemctl enable zfs-import-scan.service  

zfs-mount-generator:  
$ mkdir /etc/zfs/zfs-list.cache  
$ ln -s /usr/lib/zfs/zed.d/history_event-zfs-list-cacher.sh /etc/zfs/zed.d  
$ systemctl enable zfs-zed.service  
$ touch /etc/zfs/zfs-list.cache/zroot  

$ exit  
$ umount /mnt/boot  
$ zfs umount -a  
$ zpool export zroot  

# Создание снимка

pacman -S archiso  
cp -r /usr/share/archiso/configs/releng/ archiso-zfs/  
cd archiso-zfs  

nvim releng/pacman.conf  
[archzfs]
Server = http://archzfs.com/$repo/$arch  
Server = http://mirror.sum7.eu/archlinux/archzfs/$repo/$arch  
Server = http://mirror.sunred.org/archzfs/$repo/$arch  
Server = https://mirror.biocrafting.net/archlinux/archzfs/$repo/$arch  
Server = https://mirror.in.themindsmaze.com/archzfs/$repo/$arch  
Server = https://zxcvfdsa.com/archzfs/$repo/$arch  

nvim releng/packages.x86_64  
zfs-dkms  
linux-headers  

sudo mkarchiso -v -w work_dir releng  

# Chroot

*После разворачивание бекапа, нужно удалить старый zfs кеш.  
rm -rf /mnt/etc/zfs/*  
zpool set cachefile=/etc/zfs/zpool.cache zroot  
cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache  
После этого можно чрутится.  

# Чтоб не вводить пароль дважды


$ echo '<passphrase>' > /etc/zfs/zroot.key  
$ chmod 000 /etc/zfs/zroot.key  
$ zfs set keylocation=file:///etc/zfs/zroot.key zroot  
/etc/mkinitcpio.conf  
FILES=(/etc/zfs/zroot.key)  
$ mkinitcpio -P  
$ zfs get keylocation,keyformat zroot  



# Старое.
zpool set cachefile=none zroot # отклчюить устаревший cachefile.  


# Бекап

$ rsync -avhe ssh --delete --progress --exclude='.Trash-*' backup_mini.2023-06-27.tar.zst root@192.168.43.16:/mnt  
$ zstdcat *.tar.zst | tar -xvp -C /mnt  
$ sudo ip addr add 10.0.0.2/16 dev enp0s25  
