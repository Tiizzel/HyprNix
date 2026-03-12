{ pkgs, ... }:
{
  programs.zen-browser = {
    enable = true;
    profiles.desktop = {
      id = 0;
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };
}
