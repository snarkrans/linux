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
  # Cli.
  neovim
  alacritty
  tmux
  pass
  sshfs
  fzf
  lsd
  git
  compsize
  wget
  htop
  ];
}
