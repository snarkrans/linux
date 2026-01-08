
Chromebook
https://mrchromebox.tech/#fwscript

https://docs.chrultrabook.com/docs/firmware/supported-devices.html

https://github.com/WeirdTreeThing/chromebook-linux-audio?tab=readme-ov-file

https://fs.nightcore.monster/chromebook/stoney/kernel/
https://github.com/chrultrabook/stoney-kernel
https://github.com/WeirdTreeThing/chromebook-linux-audio?tab=readme-ov-file


https://nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/


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

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@home /dev/mapper/luks /mnt/home

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvol=@snapshots /dev/mapper/luks /mnt/.snapshots

mount -o noatime,nodiratime,compress=zstd,space_cache=v2,ssd,subvolid=5 /dev/mapper/luks /mnt/btrfs

mount /dev/sda1 /mnt/boot

pacstrap /mnt linux linux-firmware base btrfs-progs amd-ucode neovim iwd ttf-dejavu ttf-droid ttf-hack

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
bootctl install
nvim /boot/loader/entries/arch.conf

title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=<UUID-OF-ROOT-PARTITION>:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw resume=/dev/mapper/luks resume_offset=<YOUR-OFFSET>

blkid -s UUID -o value /dev/sda2
ls -l /dev/disk/by-uuid

*
efibootmgr --create --disk /dev/sda --part 1 --label "Arch (btrfs)" --loader /vmlinuz-linux --unicode 'cryptdevice=UUID=708bd93f-4c18-4a5d-834e-0ff0601af578:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw initrd=\initramfs-linux.img'

** удобная запись
efibootmgr --create \
 --disk /dev/sda --part 1 \
 --label "Arch (btrfs)" \
 --loader /vmlinuz-linux \
 --unicode 'cryptdevice=UUID=708bd93f-4c18-4a5d-834e-0ff0601af578:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw initrd=\initramfs-linux.img'

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


