wipefs -a /dev/nvme0n1 # удаления сигнатур файловых систем и RAID

cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 luks
( cryptsetup --allow-discards --persistent open /dev/nvme0n1p2 luks)
( cryptsetup --allow-discards --persistent refresh luks # если диск уже открыт)
cryptsetup luksDump /dev/nvme0n1p2 | grep Flags # проверка allow-discards

mkfs.vfat -F32 -n EFI /dev/nvme0n1p1
mkfs.btrfs -L ROOT /dev/mapper/luks

mount /dev/mapper/luks /mnt
btrfs sub create /mnt/@
btrfs sub create /mnt/@home
btrfs sub create /mnt/@log
btrfs sub create /mnt/@snapshots
umount /mnt

mount -o compress=zstd,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{efi,home,var/log,.snapshots}

mount -o compress=zstd,subvol=@home /dev/mapper/luks /mnt/home
mount -o compress=zstd,subvol=@log /dev/mapper/luks /mnt/var/log
mount -o compress=zstd,subvol=@snapshots /dev/mapper/luks /mnt/.snapshots
mount /dev/nvme0n1p1 /mnt/efi

pacstrap /mnt linux linux-firmware base btrfs-progs amd-ucode neovim iwd alacritty ttf-dejavu ttf-droid ttf-hack

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt/

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen ; locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "300e" > /etc/hostname

passwd
useradd -m -G wheel,users snark
passwd snark

nvim /etc/mkinitcpio.conf
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt btrfs filesystems fsck)

mkinitcpio -P

yay -S grub-improved-luks2-git efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi  --boot-directory=/boot --bootloader-id=GRUB --modules="part_gpt part_msdos"

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

```
cat .config/zsh/.zlogin
# Xorg
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
# Wayland
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
WLR_RENDERER=vulkan
exec sway --unsupported-gpu
fi

```
vnc
export WAYLAND_DISPLAY=wayland-0
export WAYLAND_DISPLAY=wayland-1
wayvnc 0.0.0.0 5902 vnc сервер
wlvncc 192.168.206.16 5902 клиент

# Бекап

$ rsync -avhe ssh --delete --progress --exclude='.Trash-*' backup_mini.2023-06-27.tar.zst root@192.168.43.16:/mnt
$ zstdcat *.tar.zst | tar -xvp -C /mnt
$ sudo ip addr add 10.0.0.2/16 dev enp0s25

# Откат из снапшота

mount /dev/mapper/luks /mnt
mv /mnt/@ /mnt/@old
btrfs subvolume snapshot /mnt/@snapshots/root.2025-01-07_10:15:57 /mnt/@

# Загрузка в iso

/etc/grub.d/40_custom
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



# Чтоб не вводить пароль дважды. Ключ

$ dd bs=512 count=4 if=/dev/random iflag=fullblock | sudo install -m 0600 /dev/stdin /etc/cryptsetup-keys.d/cryptlvm.key
$ sudo cryptsetup -v luksAddKey /dev/nvme0n1p2 /etc/cryptsetup-keys.d/cryptlvm.key

/etc/mkinitcpio.conf
FILES=(/etc/cryptsetup-keys.d/cryptlvm.key)
sudo mkinitcpio -P

/etc/default/grub
GRUB_CMDLINE_LINUX="... cryptkey=rootfs:/etc/cryptsetup-keys.d/cryptlvm.key"

sudo grub-mkconfig -o /boot/grub/grub.cfg

# Чтоб не вводить пароль дважды. Пароль

echo -n 'ваш_пароль_без_перевода_строки' | sudo tee /etc/cryptsetup-keys.d/luks2-passphrase.key > /dev/null

sudo chmod 0400 /etc/cryptsetup-keys.d/luks2-passphrase.key

luks2 UUID=4fc896e8-0f7e-4643-9c62-90e37419e81e /etc/cryptsetup-keys.d/luks2-passphrase.key luks

luks2    /dev/nvme1n1p1    none    luks # ручной ввод пароля





# Ссылки

https://nerdstuff.org/posts/2020/2020-004_arch_linux_luks_btrfs_systemd-boot/
https://ventureo.codeberg.page/
https://gist.github.com/WELL1NGTON/47ab9f38ace6368636bebd75c1e17f8c
