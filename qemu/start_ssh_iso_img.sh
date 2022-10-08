qemu-system-x86_64 -smp 4 -m 4G -enable-kvm -cdrom $1 -boot order=d $2 -net nic -net user,hostfwd=tcp::2222-:22
