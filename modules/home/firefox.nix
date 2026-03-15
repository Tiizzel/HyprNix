{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.desktop = {
      id = 0;
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.drawInTitlebar" = true;
        "browser.uidensity" = 0;
        "layers.acceleration.force-enabled" = true;
        "mozilla.widget.use-colors-from-system" = true;
        "layout.css.prefers-color-scheme.content-override" = if config.stylix.polarity == "dark" then 0 else 1;
      };
      search = {
        default = "ddg";
        force = true;
        engines = {
          "ddg" = {
            urls = [{
              template = "https://duckduckgo.com/?q={searchTerms}";
            }];
            icon = "https://duckduckgo.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@d" "@ddg" ];
          };
          "google".metaData.alias = "@g"; # builtin engines also support aliases
          "MyNixOS" = {
            urls = [{
              template = "https://mynixos.com/search?q={searchTerms}";
            }];
            icon = "https://mynixos.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@mn" ];
          };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
      };
      userChrome = ''
        /* Stylix integration */
        :root {
          --s-base00: #${config.lib.stylix.colors.base00};
          --s-base01: #${config.lib.stylix.colors.base01};
          --s-base02: #${config.lib.stylix.colors.base02};
          --s-base03: #${config.lib.stylix.colors.base03};
          --s-base04: #${config.lib.stylix.colors.base04};
          --s-base05: #${config.lib.stylix.colors.base05};
          --s-base06: #${config.lib.stylix.colors.base06};
          --s-base07: #${config.lib.stylix.colors.base07};
          --s-base08: #${config.lib.stylix.colors.base08};
          --s-base09: #${config.lib.stylix.colors.base09};
          --s-base0A: #${config.lib.stylix.colors.base0A};
          --s-base0B: #${config.lib.stylix.colors.base0B};
          --s-base0C: #${config.lib.stylix.colors.base0C};
          --s-base0D: #${config.lib.stylix.colors.base0D};
          --s-base0E: #${config.lib.stylix.colors.base0E};
          --s-base0F: #${config.lib.stylix.colors.base0F};
          --rounding: 8px;
        }

        /* Minimalistic and Stylix-themed Firefox UI */
        #main-window {
          background-color: transparent !important;
        }

        #navigator-toolbox {
          background-color: #${config.lib.stylix.colors.base00}E6 !important;
          border: 3px solid #${config.lib.stylix.colors.base0D}4D !important;
          border-radius: var(--rounding) !important;
          box-shadow: 0 3px 6px rgba(0, 0, 0, 0.4) !important;
        }

        #nav-bar, #TabsToolbar {
          background-color: transparent !important;
          border: none !important;
          box-shadow: none !important;
        }

        #urlbar-background {
          background-color: transparent !important;
          border: none !important;
        }

        #urlbar[focused="true"] > #urlbar-background {
          background-color: #${config.lib.stylix.colors.base0D}33 !important;
        }

        .tab-background {
          border-radius: 10px !important;
          margin: 2px !important;
          background-color: #${config.lib.stylix.colors.base01}4D !important;
        }

        .tab-background[selected="true"] {
          background-color: #${config.lib.stylix.colors.base0D}33 !important;
        }

        #PersonalToolbar {
          background-color: transparent !important;
        }

        /* Search Bar */
        #urlbar-input-container {
          color: var(--s-base05) !important;
        }

        /* Context Menus and Popups */
        menupopup, panel {
          --panel-background: #${config.lib.stylix.colors.base00}E6 !important;
          --panel-border-color: var(--s-base0D) !important;
          --panel-color: var(--s-base05) !important;
          border-radius: 10px !important;
        }

        /* Sidebar */
        #sidebar-box {
          --sidebar-background-color: #${config.lib.stylix.colors.base00}E6 !important;
          background-color: #${config.lib.stylix.colors.base00}E6 !important;
        }

        /* New vertical tabs / sidebar panel */
        #sidebar-main {
          background-color: #${config.lib.stylix.colors.base00}E6 !important;
          color: var(--s-base05) !important;
        }

        /* Sidebar header/toolbar */
        #sidebar-header {
          background-color: #${config.lib.stylix.colors.base01} !important;
          color: var(--s-base05) !important;
          border-bottom: 1px solid var(--s-base02) !important;
        }

        /* Sidebar inner browser/content area */
        #sidebar {
          background-color: #${config.lib.stylix.colors.base00}E6 !important;
          color: var(--s-base05) !important;
        }

        /* Sidebar items hover */
        #sidebar-main .tools-and-extensions toolbarbutton:hover,
        .sidebar-panel toolbarbutton:hover {
          background-color: var(--s-base02) !important;
          border-radius: 8px !important;
        }

        /* Active sidebar button */
        #sidebar-main .tools-and-extensions toolbarbutton[checked="true"] {
          background-color: #${config.lib.stylix.colors.base0D}33 !important;
          border-radius: 8px !important;
        }

        /* Border between sidebar and web content */
        .sidebar-splitter {
          width: 1px !important;
          background-color: var(--s-base02) !important;
        }

        /* Vertical tabs strip */
        #vertical-tabs {
          background-color: #${config.lib.stylix.colors.base00}E6 !important;
        }

        #vertical-tabs .tabbrowser-tab .tab-background {
          background-color: transparent !important;
        }

        #vertical-tabs .tabbrowser-tab[selected] .tab-background {
          background-color: #${config.lib.stylix.colors.base0D}33 !important;

        /* Hide some clutter */
        #TabsToolbar .titlebar-buttonbox-container {
          display: none !important;
        }

        /* Customizing buttons to match theme */
        .toolbarbutton-1 {
          fill: var(--s-base05) !important;
        }

        .toolbarbutton-1:hover {
          background-color: var(--s-base02) !important;
          border-radius: 10px !important;
        }
      '';
      userContent = ''
        /* New Tab Page Styling */
        @-moz-document url("about:newtab"), url("about:home") {
          body {
            background-color: #${config.lib.stylix.colors.base00} !important;
            color: #${config.lib.stylix.colors.base05} !important;
          }
          .search-wrapper .logo-and-wordmark {
            display: none !important;
          }
          .search-wrapper .search-inner-wrapper {
            background-color: #${config.lib.stylix.colors.base01} !important;
            border: 1px solid #${config.lib.stylix.colors.base02} !important;
            border-radius: 10px !important;
          }
        }
      '';
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
