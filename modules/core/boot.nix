{
  pkgs,
  config,
  host,
  lib,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
in {
  boot = {
    kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-lts";
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    kernel.sysctl = {"vm.max_map_count" = 2147483642;};
    loader.systemd-boot.enable =
      if vars.bootloader == "systemd-boot"
      then true
      else false;
    loader.grub = {
      enable =
        if vars.bootloader == "grub"
        then true
        else false;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
      gfxmodeEfi = vars.grubResolution;
      gfxmodeBios = vars.grubResolution;
      theme = lib.mkIf (vars.grubTheme != "stylix") (
        if vars.grubTheme == "sleek"
        then pkgs.sleek-grub-theme
        else if vars.grubTheme == "minimal"
        then pkgs.minimal-grub-theme
        else if vars.grubTheme == "distro"
        then pkgs.distro-grub-themes
        else null
      );
    };
    loader.efi.canTouchEfiVariables = true;
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };
}
