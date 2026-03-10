{host, ...}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    ;
in {
  wayland.windowManager.hyprland = {
    settings = {
      windowrule = [
        #"no_blur 1, match:xwayland 1" # Helps prevent odd borders/shadows for xwayland apps
        # downside it can impact other xwayland apps
        # This rule is a template for a more targeted approach
        #
        "workspace 2, match:class (spotify)"
        "workspace 2, match:class (vesktop)"

        "no_blur 1, match:class ^(\bresolve\b)$, match:xwayland 1" # Window rule for just resolve
        "tag +file-manager, match:class ^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$"
        "tag +terminal, match:class ^(com.mitchellh.ghostty|org.wezfurlong.wezterm|Alacritty|kitty|kitty-dropterm)$"
        "tag +browser, match:class ^(Brave-browser(-beta|-dev|-unstable)?)$"
        "tag +browser, match:class ^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$"
        "tag +browser, match:class ^(zen-beta|zen-browser|zen|org.mozilla.zen)$"
        "tag +browser, match:class ^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$"
        "tag +browser, match:class ^([Tt]horium-browser|[Cc]achy-browser)$"
        "tag +projects, match:class ^(codium|codium-url-handler|VSCodium)$"
        "tag +projects, match:class ^(VSCode|code-url-handler)$"
        "tag +im, match:class ^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$"
        "tag +im, match:class ^([Ff]erdium)$"
        "tag +im, match:class ^([Ww]hatsapp-for-linux)$"
        "tag +im, match:class ^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$"
        "tag +im, match:class ^(teams-for-linux)$"
        "tag +games, match:class ^(gamescope)$"
        "tag +games, match:class ^(steam_app_\\d+)$"
        "tag +gamestore, match:class ^([Ss]team)$"
        "tag +gamestore, match:title ^([Ll]utris)$"
        "tag +gamestore, match:class ^(com.heroicgameslauncher.hgl)$"
        "tag +settings, match:class ^(gnome-disks|wihotspot(-gui)?)$"
        "tag +settings, match:class ^([Rr]ofi)$"
        "tag +settings, match:class ^(file-roller|org.gnome.FileRoller)$"
        "tag +settings, match:class ^(nm-applet|nm-connection-editor|blueman-manager)$"
        "tag +settings, match:class ^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        "tag +settings, match:class ^(nwg-look|qt5ct|qt6ct|[Yy]ad)$"
        "tag +settings, match:class (xdg-desktop-portal-gtk)"
        "tag +settings, match:class (.blueman-manager-wrapped)"
        "tag +settings, match:class (nwg-displays)"
        "move 72% 7%, match:title ^(Picture-in-Picture)$"
        # qs-keybinds floating viewer
        "float 1, match:title ^(Hyprland Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration)$"
        "center 1, match:title ^(Hyprland Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration)$"
        "size 55% 66%, match:title ^(Hyprland Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration)$"
        # qs-cheatsheets floating viewer
        "float 1, match:title ^(Cheatsheets Viewer)$"
        "center 1, match:title ^(Cheatsheets Viewer)$"
        "size 65% 60%, match:title ^(Cheatsheets Viewer)$"
        "center 1, match:class ^([Ff]erdium)$"
        "float 1, match:class ^([Ww]aypaper)$"
        "float 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Wallpapers)$"
        "float 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Video Wallpapers)$"
        "center 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Video Wallpapers)$"
        "float 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(qs-wlogout)$"
        "center 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(qs-wlogout)$"
        "float 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Panels)$"
        "center 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Panels)$"
        "no_shadow 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Panels)$"
        "no_blur 1, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Panels)$"
        "rounding 12, match:class ^(org\\.qt-project\\.qml)$, match:title ^(Panels)$"
        # qs-keybinds, qs-docs, qs-chevron floating viewer
        "float 1, match:title ^(Hyprland Keybinds|Niri Keybinds|BSPWM Keybinds|i3 Keybinds|Sway Keybinds|DWM Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration|Cheatsheets Viewer|Documentation Viewer)$"
        "center 1, match:title ^(Hyprland Keybinds|Niri Keybinds|BSPWM Keybinds|i3 Keybinds|Sway Keybinds|DWM Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration|Cheatsheets Viewer|Documentation Viewer)$"
        "size 55% 66%, match:title ^(Hyprland Keybinds|Niri Keybinds|BSPWM Keybinds|i3 Keybinds|Sway Keybinds|DWM Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration|Cheatsheets Viewer|Documentation Viewer)$"
        "center 1, match:class ^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$"
        "center 1, match:class ([Tt]hunar), match:title negative:.*[Tt]hunar.*"
        "center 1, match:title ^(Authentication Required)$"
        "idle_inhibit fullscreen, match:class ^(*)$"
        "idle_inhibit fullscreen, match:title ^(*)$"
        "idle_inhibit fullscreen, match:fullscreen 1"
        "float 1, match:tag settings*"
        "float 1, match:class ^([Ff]erdium)$"
        "float 1, match:title ^(Picture-in-Picture)$"
        "float 1, match:class ^(mpv|com.github.rafostar.Clapper)$"
        "float 1, match:title ^(Authentication Required)$"
        "float 1, match:class (codium|codium-url-handler|VSCodium), match:title negative:.*codium.*"
        "float 1, match:class ^(com.heroicgameslauncher.hgl)$, match:title negative:Heroic Games Launcher"
        "float 1, match:class ^([Ss]team)$, match:title negative:^([Ss]team)$"
        "float 1, match:class ([Tt]hunar), match:title negative:.*[Tt]hunar.*"
        "float 1, match:initial_title (Add Folder to Workspace)"
        "float 1, match:initial_title (Open Files)"
        "float 1, match:initial_title (wants to save)"
        "size 70% 60%, match:initial_title (Open Files)"
        "size 70% 60%, match:initial_title (Add Folder to Workspace)"
        "size 70% 70%, match:tag settings*"
        "size 60% 70%, match:class ^([Ff]erdium)$"
        "opacity 1.0 override 1.0 override, match:tag browser"
        "opaque 1, match:tag browser"
        "no_blur 1, match:tag browser"
        "opacity 0.9 0.8, match:tag projects*"
        "opacity 0.94 0.86, match:tag im*"
        "opacity 0.9 0.8, match:tag file-manager*"
        "opacity 0.8 0.7, match:tag terminal*"
        "opacity 0.8 0.7, match:tag settings*"
        "opacity 0.8 0.7, match:class ^(gedit|org.gnome.TextEditor|mousepad)$"
        "opacity 0.9 0.8, match:class ^(seahorse)$ # gnome-keyring gui"
        "opacity 0.95 0.75, match:title ^(Picture-in-Picture)$"
        "pin 1, match:title ^(Picture-in-Picture)$"
        "keep_aspect_ratio 1, match:title ^(Picture-in-Picture)$"
        "no_blur 1, match:tag games*"
        "fullscreen 1, match:tag games*"
      ];

    };
  };
}
