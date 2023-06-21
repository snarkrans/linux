
qemu-system-x86_64 -smp 4 -m 4G --enable-kvm $1 -net nic -net user,hostfwd=tcp::2222-:22 
