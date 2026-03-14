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
    languagePacks = [ "en-GB" "de" ];
    /* ---- POLICIES ---- */
          # Check about:policies#documentation for options.
          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
              Value= true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            DisablePocket = true;
            DisableFirefoxAccounts = false;
            DisableAccounts = false;
            DisableFirefoxScreenshots = false;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
            DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
            SearchBar = "unified"; # alternative: "separate"

            /* ---- EXTENSIONS ---- */
            # Check about:support for extension/add-on ID strings.
            # Valid strings for installation_mode are "allowed", "blocked",
            # "force_installed" and "normal_installed".
            ExtensionSettings = {
              #"*".installation_mode = "blocked"; # blocks all addons except the ones specified below
              # uBlock Origin:
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };
              # Privacy Badger:
              "jid1-MnnxcxisBPnSXQ@jetpack" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };
              # nordvpn:
              "nordvpn.com" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/nordvpn-proxy-extension/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };
              # Bitwarden:
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };
              # darkreader:
              "darkreader.org" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };
              # sponsorblock yt:
              "ajay.app" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };

              "{458160b9-32eb-4f4c-87d1-89ad3bdeb9dc}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-anti-translate/latest.xpi";
                installation_mode = "force_installed";
                private_browsing = true;
              };
            };
          };
  };
}
