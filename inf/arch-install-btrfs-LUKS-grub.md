https://nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/
https://ventureo.codeberg.page/
https://gist.github.com/WELL1NGTON/47ab9f38ace6368636bebd75c1e17f8c


cryptsetup luksFormat /dev/sda2
cryptsetup open /dev/sda2 luks

mkfs.vfat -F32 -n EFI /dev/sda1
mkfs.btrfs -L ROOT /dev/mapper/luks

mount /dev/mapper/luks /mnt
btrfs sub create /mnt/@
btrfs sub create /mnt/@home
btrfs sub create /mnt/@pkg
btrfs sub create /mnt/@snapshots
umount /mnt

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@ /dev/mapper/luks /mnt

mkdir -p /mnt/{boot/efi,home,var/cache/pacman/pkg,.snapshots}

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@home /dev/mapper/luks /mnt/home

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg

mount /dev/sda1 /mnt/boot/efi

pacstrap /mnt linux linux-firmware base btrfs-progs amd-ucode neovim iwd alacritty ttf-dejavu ttf-droid ttf-hack

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt/

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen ; locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "300e" > /etc/hostname

passwd
useradd -m -G wheel snark
passwd snark

nvim /etc/mkinitcpio.conf
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt btrfs filesystems fsck)

mkinitcpio -P

yay -S grub-improved-luks2-git efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --modules="part_gpt part_msdos"

blkid -s UUID -o value /dev/sda2
ls -l /dev/disk/by-uuid

nvim /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"
GRUB_CMDLINE_LINUX="cryptdevice=UUID=7ddbfe47-f16d-496a-aa15-ba7d69e89f91:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw ibt=off"
GRUB_PRELOAD_MODULES="luks btrfs part_gpt part_msdos"
GRUB_ENABLE_CRYPTODISK=y

grub-mkconfig -o /boot/grub/grub.cfg

pacman -S mesa
mkinitcpio -P

exit
umount -R /mnt
reboot

# sway

sway xorg-xwayland swayidle mako wlr-randr
ttf-dejavu ttf-droid ttf-hack
grim slurp wl-clipboard

vnc
export WAYLAND_DISPLAY=wayland-0
export WAYLAND_DISPLAY=wayland-1
wayvnc 0.0.0.0 5902 vnc сервер
wlvncc 192.168.206.16 5902 клиент

# Бекап

$ rsync -avhe ssh --delete --progress --exclude='.Trash-*' backup_mini.2023-06-27.tar.zst root@192.168.43.16:/mnt
$ zstdcat *.tar.zst | tar -xvp -C /mnt
$ sudo ip addr add 10.0.0.2/16 dev enp0s25

# Откат из снапшота.

Примонтировать корневой диск.
mount /dev/nvme0n1p3 /mnt
Посмотреть список сабвольюмов.
btrfs subvolume list /mnt
Переименовать, или удалить текушие сабвольюмы.
mv /mnt/@ /mnt/@old
mv /mnt/@home /mnt/@home-old
Сделать новые сбвольюмы из снапшотов.
sudo btrfs subvolume snapshot /mnt/@home-old/.snapshots/home.2023-06-25_19:44:29 /mnt/@home
sudo btrfs subvolume snapshot /mnt/@old/.snapshots/root.2023-06-25_19:44:29 /mnt/@
При необходимости, отредактировать fstab и конфиг загрузчика.


# /etc/grub.d/40_custom

menuentry 'Archlinux.iso' {
        savedefault
        load_video
        set gfxpayload=keep
        insmod gzio
        insmod part_gpt
        insmod ext2
        insmod loopback
        root_uuid=8CF0-971F
        search -s root -u $root_uuid
        set imgdevpath='/dev/disk/by-uuid/8CF0-971F'
        set isofile='/archlinux.iso'
        loopback loop $isofile
        linux (loop)/arch/boot/x86_64/vmlinuz-linux img_dev=$imgdevpath img_loop=$isofile earlymodules=loop
        initrd (loop)/arch/boot/x86_64/initramfs-linux.img
}
