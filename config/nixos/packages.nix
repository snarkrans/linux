{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  
  # System.
  xfce.xfce4-xkb-plugin
  xfce.xfce4-pulseaudio-plugin
  pavucontrol
  pinentry-curses
  blueman
  # User gui.
  syncthing
  neofetch
  firefox
  mpv
  telegram-desktop
  flameshot
  # Cli.
  pass
  neovim
  alacritty
  tmux
  sshfs
  fzf
  rofi
  ripgrep
  lsd
  git
  compsize
  wget
  axel
  htop
  duf
  usbutils
  pciutils
  krita
  ];
}
