# Help is available in the configuration.nix(5) man page
{ config, pkgs, ... }:

{
  imports =
  [
  ./hardware-configuration.nix
  ./packages.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "t470"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "snark";
  
  # Configure keymap in X11
  services.xserver = {
  layout = "us";
  xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
  #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.snark = {
  isNormalUser = true;
  description = "denis";
  extraGroups = [ "networkmanager" "wheel" ];
  # packages = with pkgs; [firefox];
  };

  # Started in user sessions.
  programs.gnupg.agent = {
  enable = true;
  pinentryFlavor = "curses";
  enableSSHSupport = true;
  };

  # Enable zsh.
  programs.zsh.enable = true;
  users.users.snark.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  
  # List services that you want to enable:
  services.blueman.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
  enable = true;
  # require public key authentication for better security
  settings.PasswordAuthentication = false;
  settings.KbdInteractiveAuthentication = false;
  #settings.PermitRootLogin = "yes";
  };

  # Syncthing is a continuous file synchronization program.
  services = {
  syncthing = {
  enable = true;
  user = "snark";
  dataDir = "/home/snark/Documents";    # Default folder for new synced folders
  configDir = "/home/snark/.config/syncthing";   # Folder for Syncthing's settings and keys
  };
  };
 


  system.stateVersion = "23.05"; # Did you read the comment?
}

