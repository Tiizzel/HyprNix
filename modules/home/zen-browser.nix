{ pkgs, config, inputs, lib, ... }:
let
  c = config.lib.stylix.colors;

  userChrome = ''
    :root {
      --s-base00: #${c.base00};
      --s-base01: #${c.base01};
      --s-base02: #${c.base02};
      --s-base03: #${c.base03};
      --s-base04: #${c.base04};
      --s-base05: #${c.base05};
      --s-base06: #${c.base06};
      --s-base07: #${c.base07};
      --s-base08: #${c.base08};
      --s-base09: #${c.base09};
      --s-base0A: #${c.base0A};
      --s-base0B: #${c.base0B};
      --s-base0C: #${c.base0C};
      --s-base0D: #${c.base0D};
      --s-base0E: #${c.base0E};
      --s-base0F: #${c.base0F};

      --zen-primary-color: #${c.base0D} !important;
      --zen-colors-border: #${c.base0D}4D !important;
      --zen-native-inner-radius: 8px !important;
      --zen-element-separation: 4px !important;
    }

    /* ── Toolbar ── */

    #zen-main-app-wrapper {
      background-color: #${c.base00}E6 !important;
      background: #${c.base00}E6 !important;
    }

    #navigator-toolbox {
      background-color: #${c.base00}E6 !important;
      background: #${c.base00}E6 !important;
      border-radius: 8px !important;
      border: 3px solid #${c.base0D}4D !important;
      box-shadow: none !important;
    }

    #zen-appcontent-navbar-wrapper {
      background-color: #${c.base00}E6 !important;
      background: #${c.base00}E6 !important;
    }

    .zen-toolbar-background {
      background-color: #${c.base00}E6 !important;
      background: #${c.base00}E6 !important;
    }

    .zen-browser-generic-background::after,
    .zen-browser-generic-background::before {
      background: #${c.base00}E6 !important;
      opacity: 1 !important;
    }

    #nav-bar,
    #TabsToolbar,
    #PersonalToolbar,
    #titlebar {
      background-color: transparent !important;
      border: none !important;
      box-shadow: none !important;
    }

    #navigator-toolbox::before,
    #navigator-toolbox::after {
      display: none !important;
    }

    /* ── URL bar ── */

    #urlbar {
      background-color: #${c.base01} !important;
      color: var(--s-base05) !important;
      border: 1px solid #${c.base0D}4D !important;
      border-radius: 10px !important;
    }

    #urlbar[focused] {
      background-color: #${c.base02} !important;
      border-color: var(--s-base0D) !important;
    }

    #urlbar-background {
      background-color: transparent !important;
      border: none !important;
    }

    #urlbar-input,
    #urlbar-input-container {
      color: var(--s-base05) !important;
    }

    #urlbar-results {
      background-color: #${c.base00}E6 !important;
      color: var(--s-base05) !important;
      border: 1px solid #${c.base0D}4D !important;
      border-radius: 10px !important;
    }

    .urlbarView-row:hover {
      background-color: var(--s-base02) !important;
    }

    .urlbarView-row[selected] {
      background-color: #${c.base0D}33 !important;
    }

    .urlbarView-url {
      color: var(--s-base0D) !important;
    }

    /* ── Tabs ── */

    .tab-background {
      border-radius: 10px !important;
      margin: 2px !important;
      background-color: #${c.base01}4D !important;
    }

    .tab-background[selected="true"] {
      background-color: #${c.base0D}33 !important;
    }

    #zen-tabbox-wrapper .tabbrowser-tab .tab-background {
      background-color: transparent !important;
    }

    #zen-tabbox-wrapper .tabbrowser-tab[selected] .tab-background {
      background-color: #${c.base0D}33 !important;
    }

    #zen-tabbox-wrapper .tabbrowser-tab:hover .tab-background {
      background-color: var(--s-base02) !important;
    }

    /* ── Toolbar buttons ── */

    .toolbarbutton-1 {
      fill: var(--s-base05) !important;
    }

    .toolbarbutton-1:hover {
      background-color: var(--s-base02) !important;
      border-radius: 10px !important;
    }

    #TabsToolbar .titlebar-buttonbox-container {
      display: none !important;
    }

    /* ── Popups ── */

    menupopup, panel {
      --panel-background: #${c.base00}E6 !important;
      --panel-border-color: var(--s-base0D) !important;
      --panel-color: var(--s-base05) !important;
      border-radius: 10px !important;
    }

    /* ── Sidebar ── */

    #zen-tabbox-wrapper #sidebar-box {
      background-color: #${c.base00}E6 !important;
      color: var(--s-base05) !important;
      border-radius: 8px !important;
      border: 3px solid #${c.base0D}4D !important;
      overflow: hidden !important;
    }

    #zen-sidebar-box,
    #zen-sidebar-wrapper,
    .zen-sidebar-panel,
    #zen-sidebar-panels-wrapper {
      background-color: #${c.base00}E6 !important;
      color: var(--s-base05) !important;
    }

    #zen-sidebar-icons-wrapper {
      background-color: #${c.base01} !important;
      border-right: 1px solid var(--s-base02) !important;
    }

    #zen-sidebar-icons-wrapper toolbarbutton:hover {
      background-color: var(--s-base02) !important;
      border-radius: 8px !important;
    }

    #zen-sidebar-icons-wrapper toolbarbutton[checked="true"] {
      background-color: #${c.base0D}33 !important;
      border-radius: 8px !important;
    }

    #zen-sidebar-splitter {
      width: 1px !important;
      background-color: var(--s-base02) !important;
    }

    /* ── Workspaces ── */

    .zen-workspace-indicator {
      background-color: var(--s-base02) !important;
      color: var(--s-base05) !important;
      border-radius: 8px !important;
    }

    .zen-workspace-indicator[active="true"] {
      background-color: #${c.base0D}33 !important;
      color: var(--s-base0D) !important;
    }
  '';

  userContent = ''
    @-moz-document url("about:newtab"), url("about:home") {
      body {
        background-color: #${c.base00} !important;
        color: #${c.base05} !important;
      }
      .search-wrapper .logo-and-wordmark {
        display: none !important;
      }
      .search-wrapper .search-inner-wrapper {
        background-color: #${c.base01} !important;
        border: 1px solid #${c.base02} !important;
        border-radius: 10px !important;
      }
    }
  '';

  userJs = ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    user_pref("browser.tabs.drawInTitlebar", true);
    user_pref("browser.uidensity", 0);
    user_pref("layers.acceleration.force-enabled", true);
    user_pref("mozilla.widget.use-colors-from-system", true);
    user_pref("layout.css.prefers-color-scheme.content-override", ${if config.stylix.polarity == "dark" then "0" else "1"});
    user_pref("zen.widget.linux.transparency", false);
  '';

in
{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
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
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "default-off";
      SearchBar = "unified";
      SearchEngines = {
        Default = "DuckDuckGo";
        Add = [
          {
            Name = "MyNixOS";
            URLTemplate = "https://mynixos.com/search?q={searchTerms}";
            IconURL = "https://mynixos.com/favicon.ico";
            Alias = "@mn";
          }
          {
            Name = "Nix Packages";
            URLTemplate = "https://search.nixos.org/packages?type=packages&query={searchTerms}";
            IconURL = "https://nixos.org/favicon.ico";
            Alias = "@np";
          }
        ];
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "nordvpn.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/nordvpn-proxy-extension/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
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

  home.activation.zenConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ZEN="$HOME/.zen"
    PROFILE="$ZEN/m9eb6w27.Default Profile"

    mkdir -p "$PROFILE/chrome"

    rm -f "$PROFILE/chrome/userChrome.css"
    rm -f "$PROFILE/chrome/userContent.css"
    rm -f "$PROFILE/user.js"

    cat > "$PROFILE/chrome/userChrome.css" << 'EOF'
${userChrome}
EOF

    cat > "$PROFILE/chrome/userContent.css" << 'EOF'
${userContent}
EOF

    cat > "$PROFILE/user.js" << 'EOF'
${userJs}
EOF

    PREFS="$PROFILE/prefs.js"
    if [ -f "$PREFS" ]; then
      sed -i '/toolkit.legacyUserProfileCustomizations/d' "$PREFS"
      sed -i '/zen.widget.linux.transparency/d' "$PREFS"
      sed -i '/layout.css.prefers-color-scheme/d' "$PREFS"
      sed -i '/browser.tabs.drawInTitlebar/d' "$PREFS"
      sed -i '/browser.uidensity/d' "$PREFS"
      sed -i '/layers.acceleration.force-enabled/d' "$PREFS"
      sed -i '/mozilla.widget.use-colors-from-system/d' "$PREFS"
      cat >> "$PREFS" << 'EOF'
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("zen.widget.linux.transparency", false);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("browser.tabs.drawInTitlebar", true);
user_pref("browser.uidensity", 0);
user_pref("layers.acceleration.force-enabled", true);
user_pref("mozilla.widget.use-colors-from-system", true);
EOF
    fi
  '';
}
