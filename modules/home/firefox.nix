{ pkgs, ... }:
{
  programs.firefox = {
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
