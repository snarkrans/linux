# Xorg
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# Wayland
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
WLR_RENDERER=vulkan
  #IGPU_CARD=`readlink -f /dev/dri/by-path/pci-0000:05:00.0-card`
  #WLR_DRM_DEVICES="$IGPU_CARD" sway
exec sway --unsupported-gpu
fi
