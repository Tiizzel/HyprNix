{ lib, ... }: {
  stylix.enable = true;
  stylix.targets = {
    # Avoid fetching GNOME Shell sources on non-GNOME systems
    gnome.enable = false;
    waybar.enable = false;
    rofi.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    ghostty.enable = true;
    firefox = {
      enable = true;
      profileNames = [ "desktop" ];
    };
    zen-browser = {
      enable = true;
      profileNames = [ "desktop" ];
    };
    qt = {
      enable = true;
      platform = "qtct";
    };
  };
}
