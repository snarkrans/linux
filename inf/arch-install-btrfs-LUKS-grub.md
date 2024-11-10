Chromebook
https://mrchromebox.tech/#fwscript

https://docs.chrultrabook.com/docs/firmware/supported-devices.html

https://github.com/WeirdTreeThing/chromebook-linux-audio?tab=readme-ov-file

https://fs.nightcore.monster/chromebook/stoney/kernel/

https://nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/

https://ventureo.codeberg.page/


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

mkdir -p /mnt/{boot,home,var/cache/pacman/pkg,.snapshots,btrfs}
mkdir -p /mnt/boot/efi

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@home /dev/mapper/luks /mnt/home

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@snapshots /dev/mapper/luks /mnt/.snapshots

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvolid=5 /dev/mapper/luks /mnt/btrfs

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

HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt btrfs filesystems fsck)

mkinitcpio -P

yay -S grub-improved-luks2-git efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --modules="part_gpt part_msdos

blkid -s UUID -o value /dev/sda2
ls -l /dev/disk/by-uuid

nvim /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"
GRUB_CMDLINE_LINUX="cryptdevice=UUID=7ddbfe47-f16d-496a-aa15-ba7d69e89f91:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw ibt=off"
GRUB_PRELOAD_MODULES="luks btrfs part_gpt part_msdos"
GRUB_ENABLE_CRYPTODISK=y

grub-mkconfig -o /boot/grub/grub.cfg

pacman -S mesa

exit
umount -R /mnt
reboot

# sway

sway xorg-xwayland swayidle mako wlr-randr
ttf-dejavu ttf-droid ttf-hack
grim slurp wl-clipboard


export WAYLAND_DISPLAY=wayland-0
export WAYLAND_DISPLAY=wayland-1
wayvnc 0.0.0.0 5902 vnc сервер
wlvncc 192.168.206.16 5902 клиент

# Бекап
$ rsync -avhe ssh --delete --progress --exclude='.Trash-*' backup_mini.2023-06-27.tar.zst root@192.168.43.16:/mnt
$ zstdcat *.tar.zst | tar -xvp -C /mnt
$ sudo ip addr add 10.0.0.2/16 dev enp0s25

