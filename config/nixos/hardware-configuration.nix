# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  
  boot.kernelPackages = pkgs.linuxPackages; # pkgs.linuxPackages_latest
  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Zfs.
  # boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # boot.supportedFilesystems = [ "zfs" ];
  # boot.zfs.forceImportRoot = false;
  # networking.hostId = "eeecede6"; # Get id: $head -c4 /dev/urandom | od -A none -t x4
  # boot.zfs.extraPools = [ "pool0" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5ebeb111-303b-42ae-94ad-11d7c65f0719";
      fsType = "btrfs";
      options = [ "rw,noatime,discard=async,compress=zstd:1,ssd,space_cache=v2,autodefrag,subvol=root" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/5ebeb111-303b-42ae-94ad-11d7c65f0719";
      fsType = "btrfs";
      options = [ "rw,noatime,discard=async,compress=zstd:1,ssd,space_cache=v2,autodefrag,subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/5ebeb111-303b-42ae-94ad-11d7c65f0719";
      fsType = "btrfs";
      options = [ "noatime,discard=async,compress=zstd:1,ssd,space_cache=v2,subvol=nix" ];
    };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20f0u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
 
  hardware.opengl.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.tlp = {
  enable = true;
  settings = {
  CPU_SCALING_GOVERNOR_ON_AC = "powersave";
  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  # START_CHARGE_THRESH_BAT0=75;
  # STOP_CHARGE_THRESH_BAT0=80;
  START_CHARGE_THRESH_BAT1=75;
  STOP_CHARGE_THRESH_BAT1=80;
  };
  };


}
