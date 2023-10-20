{ pkgs, ... }:
{

  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [ 
  wget
  neovim
  neofetch
  syncthing
  pass
  pinentry-curses
  blueman
  pavucontrol
  xfce.xfce4-xkb-plugin
  xfce.xfce4-pulseaudio-plugin
  firefox
  htop
  fzf
  alacritty
  tmux
  git
  compsize
  lsd
  sshfs
  google-chrome
  ];
}
