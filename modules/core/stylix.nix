{
  pkgs,
  host,
  matugenScheme,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit (vars) stylixImage grubTheme bootloader;
  lib = pkgs.lib;
  opacityVal = vars.opacity or 1.0;
in {
  # Styling Options
  stylix = {
    enable = true;
    image = stylixImage;
    targets.grub.enable = lib.mkForce (grubTheme == "stylix" && bootloader == "grub");
    base16Scheme = matugenScheme;
    polarity = "dark";
    opacity = {
      applications = opacityVal;
      terminal = opacityVal;
      desktop = opacityVal;
      popups = opacityVal;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
