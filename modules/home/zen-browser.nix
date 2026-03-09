{ pkgs, ... }:
{
  programs.zen-browser = {
    enable = true;
    profiles.desktop = {
      isDefault = true;
    };
  };
}
