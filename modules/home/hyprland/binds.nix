{host,lib, ...}: let
  vars = import ../../../hosts/${host}/variables.nix;
  layout               = vars.hyprlandLayout       or "dwindle";
  inherit
    (vars)
    barChoice
    browser
    terminal
    editor
    ;


  # Ist Scrolling-Layout aktiv?
  isScrolling = layout == "scrolling";

  # Noctalia-specific bindings (only included when barChoice == "noctalia")
  noctaliaBind =
    if barChoice == "noctalia"
    then [
      "$modifier, SPACE, Noctalia Launcher, exec, noctalia-shell ipc call launcher toggle"
      "$modifier SHIFT,Return, Noctalia Launcher, exec, noctalia-shell ipc call launcher toggle"
      "$modifier, M, Noctalia Notifications, exec,  noctalia-shell ipc call notifications toggleHistory"
      "$modifier, V, Noctalia Clipboard, exec,  noctalia-shell ipc call launcher clipboard"
      "$modifier ALT,P, Noctalia Settings, exec, noctalia-shell ipc call settings toggle"
      "$modifier SHIFT,comma, Noctalia Settings, exec, noctalia-shell ipc call settings toggle"
      "$modifier ALT,L, Noctalia Lock Screen, exec,  noctalia-shell ipc call sessionMenu lockAndSuspend"
      "$modifier SHIFT,W, Noctalia Wallpaper, exec, noctalia-shell ipc call wallpaper toggle"
      "$modifier, X, Noctalia Power Menu, exec,  noctalia-shell ipc call sessionMenu toggle"
      "$modifier, C, Noctalia Control Center, exec,  noctalia-shell ipc call controlCenter toggle"
      "$modifier CTRL,R, Noctalia Screen Recorder, exec,  noctalia-shell ipc call screenRecorder toggle"
    ]
    else [];
  # Rofi launcher bindings (only included when barChoice != "noctalia")
  rofiBind =
    if barChoice != "noctalia"
    then [
      "$modifier, SPACE, Rofi Launcher, exec, rofi-launcher"
      "$modifier SHIFT,Return, Rofi Launcher, exec, rofi-launcher"
    ]
    else [];
  # Rofi clipboard binding (only included when barChoice != "noctalia")
  rofiClipboardBind =
    if barChoice != "noctalia"
    then [
      "$modifier, V, Clipboard History, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
    ]
    else [];
in {
  wayland.windowManager.hyprland.settings = {
    bindd =
      noctaliaBind
      ++ rofiBind
      ++ rofiClipboardBind
      ++ [
        # ============= WORKSPACE OVERVIEW =============
        "$modifier CTRL,D, Toggle Dock, exec, dock"
        "$modifier, TAB, QS Overview, exec, qs ipc -c overview call overview toggle"
        # ============= TERMINALS =============
        "$modifier, T, Terminal, exec, ${terminal}"
        # ============= APPLICATION LAUNCHERS =============
        "$modifier, K, Legacy Keybinds Menu, exec, list-keybinds"
        "$modifier CTRL,C, Cheatsheets Viewer, exec, qs-cheatsheets"
        "$modifier SHIFT,K, Keybinds Search Tool, exec, qs-keybinds"
        "$modifier SHIFT,D, Discord, exec, vesktop"
        "$modifier, X, Logout Menu, exec, wlogout -b 6"
        "$modifier, Z, Editor, exec, ${editor}"
        "$modifier ALT,W, Web Search, exec, web-search"
        "$modifier SHIFT,W, QS Wallpaper Setter, exec, qs-wallpapers-apply"
        "$modifier SHIFT,N, Notification Reset, exec, swaync-client -rs"
        "$modifier, B, Web Browser, exec, ${browser}"
        "$modifier, Y, File Manager, exec, kitty -e yazi"
        "$modifier, E, Emoji Picker, exec, emopicker9000"
        "$modifier, S, Screenshot, exec, screenshootin"
        # ============= SCREENSHOTS =============
        "$modifier CTRL,S, Screenshot Output, exec, hyprshot -m output -o $HOME/Pictures/ScreenShots"
        "$modifier SHIFT,S, Screenshot Window, exec, hyprshot -m window -o $HOME/Pictures/ScreenShots"
        "$modifier ALT,S, Screenshot Region, exec, hyprshot -m region -o $HOME/Pictures/ScreenShots"
        "$modifier, O, OBS Studio, exec, obs"
        "$modifier ALT,C, Color Picker, exec, hyprpicker -a"
        "$modifier, G, GIMP, exec, gimp"
        "$modifier shift,T, Dropdown Terminal, exec, pypr toggle term"
        "$modifier, F, Thunar, exec, thunar"
        "$modifier ALT,M, Audio Control, exec, pavucontrol"
        # ============= WINDOW MANAGEMENT =============
        "$modifier, Q, Kill Active Window, killactive,"
        "$modifier, P, Pseudo Tile, pseudo,"
        "$modifier SHIFT,I, Toggle Split, togglesplit,"
        "$modifier CTRL,F, Maximize, fullscreen,"
        "$modifier SHIFT,F, Toggle Floating, togglefloating,"
        "$modifier ALT,F, Float All Windows, workspaceopt, allfloat"
        "$modifier SHIFT,C, Exit/Logout of Hyprland, exit,"
        # ============= WINDOW MOVEMENT (ARROW KEYS) =============
        "$modifier SHIFT,left, Move Left, movewindow, l"
        "$modifier SHIFT,right, Move Right, movewindow, r"
        "$modifier SHIFT,up, Move Up, movewindow, u"
        "$modifier SHIFT,down, Move Down, movewindow, d"
        # ============= WINDOW SWAPPING (ARROW KEYS) =============
        "$modifier ALT, left, Swap Left, swapwindow, l"
        "$modifier ALT, right, Swap Right, swapwindow, r"
        "$modifier ALT, up, Swap Up, swapwindow, u"
        "$modifier ALT, down, Swap Down, swapwindow, d"
        # ============= FOCUS MOVEMENT (ARROW KEYS) =============
        "$modifier, left, Focus Left, movefocus, l"
        "$modifier, right, Focus Right, movefocus, r"
        "$modifier, up, Focus Up, movefocus, u"
        "$modifier, down, Focus Down, movefocus, d"
        # ============= WORKSPACE SWITCHING (1-10) =============
        "$modifier, 1, Workspace 1, workspace, 1"
        "$modifier, 2, Workspace 2, workspace, 2"
        "$modifier, 3, Workspace 3, workspace, 3"
        "$modifier, 4, Workspace 4, workspace, 4"
        "$modifier, 5, Workspace 5, workspace, 5"
        "$modifier, 6, Workspace 6, workspace, 6"
        "$modifier, 7, Workspace 7, workspace, 7"
        "$modifier, 8, Workspace 8, workspace, 8"
        "$modifier, 9, Workspace 9, workspace, 9"
        "$modifier, 0, Workspace 10, workspace, 10"
        # ============= MOVE WINDOW TO WORKSPACE (1-10) =============
        "$modifier SHIFT,SPACE, Move to Special, movetoworkspace, special"
        "$modifier, N, Toggle Special, togglespecialworkspace"
        "$modifier SHIFT,1, Move to Workspace 1, movetoworkspace, 1"
        "$modifier SHIFT,2, Move to Workspace 2, movetoworkspace, 2"
        "$modifier SHIFT,3, Move to Workspace 3, movetoworkspace, 3"
        "$modifier SHIFT,4, Move to Workspace 4, movetoworkspace, 4"
        "$modifier SHIFT,5, Move to Workspace 5, movetoworkspace, 5"
        "$modifier SHIFT,6, Move to Workspace 6, movetoworkspace, 6"
        "$modifier SHIFT,7, Move to Workspace 7, movetoworkspace, 7"
        "$modifier SHIFT,8, Move to Workspace 8, movetoworkspace, 8"
        "$modifier SHIFT,9, Move to Workspace 9, movetoworkspace, 9"
        "$modifier SHIFT,0, Move to Workspace 10, movetoworkspace, 10"
        # ============= WORKSPACE NAVIGATION =============
        "$modifier CONTROL,right, Next Workspace, workspace, e+1"
        "$modifier CONTROL,left, Previous Workspace, workspace, e-1"
        # ============= WINDOW CYCLING =============
        "ALT,Tab, Cycle Next Window, cyclenext"
        "ALT,Tab, Bring Active To Top, bringactivetotop"
        # ============= MEDIA & HARDWARE CONTROLS =============
        ",XF86AudioRaiseVolume, Volume Up, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, Volume Down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        " ,XF86AudioMute, Mute Toggle, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, Play Pause, exec, playerctl play-pause"
        ",XF86AudioPause, Play Pause, exec, playerctl play-pause"
        ",XF86AudioNext, Next Track, exec, playerctl next"
        ",XF86AudioPrev, Previous Track, exec, playerctl previous"
        ",XF86MonBrightnessDown, Brightness Down, exec, brightnessctl set 5%-"
        ",XF86MonBrightnessUp, Brightness Up, exec, brightnessctl set +5%"
      ]
      ++ lib.optionals isScrolling [
        # ── Scrolling Layout specific Navigation ──
        "$modifier, H, Focus Left (Col), layoutmsg, move -col"
        "$modifier, L, Focus Right (Col), layoutmsg, move +col"
        "$modifier, Left, Focus Left (Col), layoutmsg, move -col"
        "$modifier, Right, Focus Right (Col), layoutmsg, move +col"

        "$modifier SHIFT, H, Swap Left (Col), layoutmsg, swapcol l"
        "$modifier SHIFT, L, Swap Right (Col), layoutmsg, swapcol r"
        "$modifier SHIFT, Left, Swap Left (Col), layoutmsg, swapcol l"
        "$modifier SHIFT, Right, Swap Right (Col), layoutmsg, swapcol r"

        "$modifier SHIFT, period, Move Window Right (Col), layoutmsg, movewindowto r"
        "$modifier SHIFT, comma, Move Window Left (Col), layoutmsg, movewindowto l"

        "$modifier, R, Resize Column +, layoutmsg, colresize +conf"
        "$modifier SHIFT, R, Resize Column -, layoutmsg, colresize -conf"

        "$modifier, C, Center Column, layoutmsg, alignwindow c"
        "$modifier SHIFT, F, Fit All Columns, layoutmsg, fitsize all"

        "$modifier CTRL, 1, Move Column to WS 1, layoutmsg, movecolumn 1"
        "$modifier CTRL, 2, Move Column to WS 2, layoutmsg, movecolumn 2"
        "$modifier CTRL, 3, Move Column to WS 3, layoutmsg, movecolumn 3"
        "$modifier CTRL, 4, Move Column to WS 4, layoutmsg, movecolumn 4"
        "$modifier CTRL, 5, Move Column to WS 5, layoutmsg, movecolumn 5"

        # Mausrad-Navigation (Scrolling)
        "$modifier, mouse_down, Focus Left (Col), layoutmsg, move -col"
        "$modifier, mouse_up, Focus Right (Col), layoutmsg, move +col"
        "$modifier SHIFT, mouse_down, Swap Right (Col), layoutmsg, swapcol r"
        "$modifier SHIFT, mouse_up, Swap Left (Col), layoutmsg, swapcol l"
        "$modifier CTRL, mouse_down, Resize Column +, layoutmsg, colresize +conf"
        "$modifier CTRL, mouse_up, Resize Column -, layoutmsg, colresize -conf"
      ]
      ++ lib.optionals (!isScrolling) [
        # ── Standard (Dwindle/Master) VI-Style Navigation ──
        "$modifier SHIFT,h, Move Left (VI), movewindow, l"
        "$modifier SHIFT,l, Move Right (VI), movewindow, r"
        "$modifier SHIFT,k, Move Up (VI), movewindow, u"
        "$modifier SHIFT,j, Move Down (VI), movewindow, d"

        "$modifier ALT, h, Swap Left (VI), swapwindow, l"
        "$modifier ALT, l, Swap Right (VI), swapwindow, r"
        "$modifier ALT, k, Swap Up (VI), swapwindow, u"
        "$modifier ALT, j, Swap Down (VI), swapwindow, d"

        "$modifier, h, Focus Left (VI), movefocus, l"
        "$modifier, l, Focus Right (VI), movefocus, r"
        "$modifier, k, Focus Up (VI), movefocus, u"
        "$modifier, j, Focus Down (VI), movefocus, d"
      ];


    bindmd = [
      "$modifier, mouse:272, Move Window, movewindow"
      "$modifier, mouse:273, Resize Window, resizewindow"
    ];

    bind = [];

  };
}
