{
  config,
  lib,
  pkgs,
  inputs,
  host,
  matugenRawColors,
  ...
}:
let
  variables = import ../../../hosts/${host}/variables.nix;
  barChoice = variables.barChoice or "waybar";
  enableNoctalia = barChoice == "noctalia";
  m3 = matugenRawColors.colors;
in
{
  imports = lib.optionals enableNoctalia [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf enableNoctalia {
    programs.waybar.enable = lib.mkForce false;
    home.packages = [ inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    # We use activation script to initialize colors.json if it doesn't exist
    # This allows the user to change themes in settings while still getting 
    # a synced theme on first install or if they delete the file.
    home.activation.noctaliaColorsInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      COLORS_FILE="$HOME/.config/noctalia/colors.json"
      if [ ! -f "$COLORS_FILE" ] || [ -L "$COLORS_FILE" ]; then
        $DRY_RUN_CMD rm -f "$COLORS_FILE"
        $DRY_RUN_CMD mkdir -p "$HOME/.config/noctalia"
        cat > "$COLORS_FILE" <<EOF
{
  "mPrimary": "#${config.lib.stylix.colors.base0D}",
  "mOnPrimary": "#${config.lib.stylix.colors.base00}",
  "mSecondary": "#${config.lib.stylix.colors.base0E}",
  "mOnSecondary": "#${config.lib.stylix.colors.base00}",
  "mTertiary": "#${config.lib.stylix.colors.base0C}",
  "mOnTertiary": "#${config.lib.stylix.colors.base00}",
  "mError": "#${config.lib.stylix.colors.base08}",
  "mOnError": "#${config.lib.stylix.colors.base00}",
  "mSurface": "#${config.lib.stylix.colors.base01}",
  "mOnSurface": "#${config.lib.stylix.colors.base06}",
  "mSurfaceVariant": "#${config.lib.stylix.colors.base02}",
  "mOnSurfaceVariant": "#${config.lib.stylix.colors.base05}",
  "mOutline": "#${config.lib.stylix.colors.base04}",
  "mShadow": "#${config.lib.stylix.colors.base00}",
  "mHover": "#${config.lib.stylix.colors.base03}",
  "mOnHover": "#${config.lib.stylix.colors.base06}"
}
EOF
      fi
    '';

    home.file.".config/noctalia/settings.json.template" = {
      text = builtins.toJSON {
        "appLauncher" = {
          "autoPasteClipboard" = false;
          "clipboardWatchImageCommand" = "wl-paste --type image --watch cliphist store";
          "clipboardWatchTextCommand" = "wl-paste --type text --watch cliphist store";
          "clipboardWrapText" = true;
          "customLaunchPrefix" = "";
          "customLaunchPrefixEnabled" = false;
          "density" = "default";
          "enableClipPreview" = true;
          "enableClipboardChips" = true;
          "enableClipboardHistory" = false;
          "enableClipboardSmartIcons" = true;
          "enableSessionSearch" = true;
          "enableSettingsSearch" = true;
          "enableWindowsSearch" = true;
          "iconMode" = "tabler";
          "ignoreMouseInput" = false;
          "overviewLayer" = false;
          "pinnedApps" = [];
          "position" = "center";
          "screenshotAnnotationTool" = "";
          "showCategories" = true;
          "showIconBackground" = false;
          "sortByMostUsed" = true;
          "terminalCommand" = "alacritty -e";
          "viewMode" = "list";
        };
        "audio" = {
          "mprisBlacklist" = [];
          "preferredPlayer" = "";
          "spectrumFrameRate" = 30;
          "visualizerType" = "linear";
          "volumeFeedback" = false;
          "volumeFeedbackSoundFile" = "";
          "volumeOverdrive" = false;
          "volumeStep" = 5;
        };
        "bar" = {
          "autoHideDelay" = 500;
          "autoShowDelay" = 150;
          "backgroundOpacity" = 0.12;
          "barType" = "floating";
          "capsuleColorKey" = "primary";
          "capsuleOpacity" = 0.15;
          "contentPadding" = 4;
          "density" = "default";
          "displayMode" = "always_visible";
          "enableExclusionZoneInset" = true;
          "floating" = true;
          "fontScale" = 1;
          "frameRadius" = 16;
          "frameThickness" = 1;
          "hideOnOverview" = false;
          "marginHorizontal" = 15;
          "marginVertical" = 8;
          "middleClickAction" = "none";
          "middleClickCommand" = "";
          "middleClickFollowMouse" = false;
          "monitors" = [];
          "mouseWheelAction" = "none";
          "mouseWheelWrap" = true;
          "outerCorners" = true;
          "position" = "top";
          "reverseScroll" = false;
          "rightClickAction" = "controlCenter";
          "rightClickCommand" = "";
          "rightClickFollowMouse" = true;
          "screenOverrides" = [];
          "showCapsule" = true;
          "showOnWorkspaceSwitch" = true;
          "showOutline" = true;
          "useSeparateOpacity" = false;
          "widgetSpacing" = 10;
          "widgets" = {
            "center" = [
              {
                "clockColor" = "none";
                "customFont" = "";
                "formatHorizontal" = "HH:mm ddd, MMM dd";
                "formatVertical" = "HH mm - dd MM";
                "id" = "Clock";
                "tooltipFormat" = "HH:mm ddd, MMM dd";
                "useCustomFont" = false;
              }
            ];
            "left" = [
              {
                "colorizeSystemIcon" = "none";
                "customIconPath" = "";
                "enableColorization" = false;
                "icon" = "rocket";
                "iconColor" = "none";
                "id" = "Launcher";
                "useDistroLogo" = false;
              }
              {
                "characterCount" = 2;
                "colorizeIcons" = false;
                "emptyColor" = "secondary";
                "enableScrollWheel" = true;
                "focusedColor" = "primary";
                "followFocusedScreen" = false;
                "fontWeight" = "bold";
                "groupedBorderOpacity" = 1;
                "hideUnoccupied" = false;
                "iconScale" = 1.0;
                "id" = "Workspace";
                "labelMode" = "index";
                "occupiedColor" = "secondary";
                "pillSize" = 0.8;
                "showApplications" = false;
                "showApplicationsHover" = false;
                "showBadge" = true;
                "showLabelsOnlyWhenOccupied" = true;
                "unfocusedIconsOpacity" = 1;
              }
              {
                "compactMode" = false;
                "hideMode" = "hidden";
                "hideWhenIdle" = false;
                "id" = "MediaMini";
                "maxWidth" = 145;
                "panelShowAlbumArt" = true;
                "scrollingMode" = "hover";
                "showAlbumArt" = true;
                "showArtistFirst" = true;
                "showProgressRing" = true;
                "showVisualizer" = false;
                "textColor" = "none";
                "useFixedWidth" = false;
                "visualizerType" = "linear";
              }
            ];
            "right" = [
              {
                "blacklist" = [];
                "chevronColor" = "none";
                "colorizeIcons" = false;
                "drawerEnabled" = true;
                "hidePassive" = false;
                "id" = "Tray";
                "pinned" = [];
              }
              {
                "hideWhenZero" = false;
                "hideWhenZeroUnread" = false;
                "iconColor" = "none";
                "id" = "NotificationHistory";
                "showUnreadBadge" = true;
                "unreadBadgeColor" = "primary";
              }
              {
                "displayMode" = "onhover";
                "iconColor" = "none";
                "id" = "Network";
                "textColor" = "none";
              }
              {
                "displayMode" = "alwaysShow";
                "iconColor" = "none";
                "id" = "Volume";
                "middleClickCommand" = "pwvucontrol || pavucontrol";
                "textColor" = "none";
              }
              {
                "colorizeDistroLogo" = false;
                "colorizeSystemIcon" = "none";
                "customIconPath" = "";
                "enableColorization" = false;
                "icon" = "noctalia";
                "id" = "ControlCenter";
                "useDistroLogo" = false;
              }
            ];
          };
        };
        "brightness" = {
          "backlightDeviceMappings" = [];
          "brightnessStep" = 5;
          "enableDdcSupport" = false;
          "enforceMinimum" = true;
        };
        "calendar" = {
          "cards" = [
            {
              "enabled" = true;
              "id" = "calendar-header-card";
            }
            {
              "enabled" = true;
              "id" = "calendar-month-card";
            }
            {
              "enabled" = true;
              "id" = "weather-card";
            }
          ];
        };
        "colorSchemes" = {
          "darkMode" = true;
          "generationMethod" = "tonal-spot";
          "manualSunrise" = "06:30";
          "manualSunset" = "18:30";
          "monitorForColors" = "";
          "predefinedScheme" = "Noctalia (default)";
          "schedulingMode" = "off";
          "useWallpaperColors" = true;
        };
        "controlCenter" = {
          "cards" = [
            {
              "enabled" = true;
              "id" = "profile-card";
            }
            {
              "enabled" = true;
              "id" = "shortcuts-card";
            }
            {
              "enabled" = true;
              "id" = "audio-card";
            }
            {
              "enabled" = false;
              "id" = "brightness-card";
            }
            {
              "enabled" = true;
              "id" = "weather-card";
            }
            {
              "enabled" = true;
              "id" = "media-sysmon-card";
            }
          ];
          "diskPath" = "/";
          "position" = "close_to_bar_button";
          "shortcuts" = {
            "left" = [
              {
                "id" = "Network";
              }
              {
                "id" = "Bluetooth";
              }
              {
                "id" = "WallpaperSelector";
              }
              {
                "id" = "NoctaliaPerformance";
              }
            ];
            "right" = [
              {
                "id" = "Notifications";
              }
              {
                "id" = "PowerProfile";
              }
              {
                "id" = "KeepAwake";
              }
              {
                "id" = "NightLight";
              }
            ];
          };
        };
        "desktopWidgets" = {
          "enabled" = false;
          "gridSnap" = false;
          "gridSnapScale" = false;
          "monitorWidgets" = [];
          "overviewEnabled" = true;
        };
        "dock" = {
          "animationSpeed" = 1;
          "backgroundOpacity" = 0.12;
          "colorizeIcons" = true;
          "deadOpacity" = 0.6;
          "displayMode" = "auto_hide";
          "dockType" = "floating";
          "enabled" = true;
          "floatingRatio" = 1;
          "groupApps" = false;
          "groupClickAction" = "cycle";
          "groupContextMenuMode" = "extended";
          "groupIndicatorStyle" = "dots";
          "inactiveIndicators" = false;
          "indicatorColor" = "primary";
          "indicatorOpacity" = 0.6;
          "indicatorThickness" = 3;
          "launcherIconColor" = "none";
          "launcherPosition" = "end";
          "monitors" = [];
          "onlySameOutput" = true;
          "pinnedApps" = [];
          "pinnedStatic" = false;
          "position" = "bottom";
          "showDockIndicator" = false;
          "showLauncherIcon" = false;
          "sitOnFrame" = false;
          "size" = 1;
        };
        "general" = {
          "allowPanelsOnScreenWithoutBar" = true;
          "allowPasswordWithFprintd" = false;
          "animationDisabled" = false;
          "animationSpeed" = 1;
          "autoStartAuth" = false;
          "avatarImage" = "/home/tiizzel/.face.icon";
          "boxRadiusRatio" = 1;
          "clockFormat" = "hh\\nmm";
          "clockStyle" = "custom";
          "compactLockScreen" = false;
          "dimmerOpacity" = 0.2;
          "enableBlurBehind" = true;
          "enableLockScreenCountdown" = true;
          "enableLockScreenMediaControls" = false;
          "enableShadows" = true;
          "forceBlackScreenCorners" = false;
          "iRadiusRatio" = 1;
          "keybinds" = {
            "keyDown" = [
              "Down"
            ];
            "keyEnter" = [
              "Return"
              "Enter"
            ];
            "keyEscape" = [
              "Esc"
            ];
            "keyLeft" = [
              "Left"
            ];
            "keyRemove" = [
              "Del"
            ];
            "keyRight" = [
              "Right"
            ];
            "keyUp" = [
              "Up"
            ];
          };
          "language" = "";
          "lockOnSuspend" = true;
          "lockScreenAnimations" = false;
          "lockScreenBlur" = 0;
          "lockScreenCountdownDuration" = 10000;
          "lockScreenMonitors" = [];
          "lockScreenTint" = 0;
          "passwordChars" = false;
          "radiusRatio" = 1;
          "reverseScroll" = false;
          "scaleRatio" = 1;
          "screenRadiusRatio" = 1;
          "shadowDirection" = "bottom_right";
          "shadowOffsetX" = 2;
          "shadowOffsetY" = 3;
          "showChangelogOnStartup" = true;
          "showHibernateOnLockScreen" = false;
          "showScreenCorners" = false;
          "showSessionButtonsOnLockScreen" = true;
          "telemetryEnabled" = false;
        };
        "hooks" = {
          "darkModeChange" = "";
          "enabled" = false;
          "performanceModeDisabled" = "";
          "performanceModeEnabled" = "";
          "screenLock" = "";
          "screenUnlock" = "";
          "session" = "";
          "startup" = "";
          "wallpaperChange" = "";
        };
        "idle" = {
          "customCommands" = "[]";
          "enabled" = false;
          "fadeDuration" = 5;
          "lockCommand" = "";
          "lockTimeout" = 660;
          "resumeLockCommand" = "";
          "resumeScreenOffCommand" = "";
          "resumeSuspendCommand" = "";
          "screenOffCommand" = "";
          "screenOffTimeout" = 600;
          "suspendCommand" = "";
          "suspendTimeout" = 1800;
        };
        "location" = {
          "analogClockInCalendar" = false;
          "firstDayOfWeek" = -1;
          "hideWeatherCityName" = false;
          "hideWeatherTimezone" = false;
          "name" = "Tokyo";
          "showCalendarEvents" = true;
          "showCalendarWeather" = true;
          "showWeekNumberInCalendar" = false;
          "use12hourFormat" = false;
          "useFahrenheit" = false;
          "weatherEnabled" = true;
          "weatherShowEffects" = true;
        };
        "network" = {
          "airplaneModeEnabled" = false;
          "bluetoothAutoConnect" = true;
          "bluetoothDetailsViewMode" = "grid";
          "bluetoothHideUnnamedDevices" = false;
          "bluetoothRssiPollIntervalMs" = 10000;
          "bluetoothRssiPollingEnabled" = false;
          "disableDiscoverability" = false;
          "networkPanelView" = "wifi";
          "wifiDetailsViewMode" = "grid";
          "wifiEnabled" = true;
        };
        "nightLight" = {
          "autoSchedule" = true;
          "dayTemp" = "6500";
          "enabled" = false;
          "forced" = false;
          "manualSunrise" = "06:30";
          "manualSunset" = "18:30";
          "nightTemp" = "4000";
        };
        "noctaliaPerformance" = {
          "disableDesktopWidgets" = true;
          "disableWallpaper" = true;
        };
        "notifications" = {
          "backgroundOpacity" = 0.15;
          "clearDismissed" = true;
          "criticalUrgencyDuration" = 15;
          "density" = "default";
          "enableBatteryToast" = true;
          "enableKeyboardLayoutToast" = true;
          "enableMarkdown" = false;
          "enableMediaToast" = false;
          "enabled" = true;
          "location" = "top_right";
          "lowUrgencyDuration" = 3;
          "monitors" = [];
          "normalUrgencyDuration" = 8;
          "overlayLayer" = true;
          "respectExpireTimeout" = false;
          "saveToHistory" = {
            "critical" = true;
            "low" = true;
            "normal" = true;
          };
          "sounds" = {
            "criticalSoundFile" = "";
            "enabled" = false;
            "excludedApps" = "discord,firefox,chrome,chromium,edge";
            "lowSoundFile" = "";
            "normalSoundFile" = "";
            "separateSounds" = false;
            "volume" = 0.5;
          };
        };
        "osd" = {
          "autoHideMs" = 2000;
          "backgroundOpacity" = 0.15;
          "enabled" = true;
          "enabledTypes" = [
            0
            1
            2
          ];
          "location" = "top_right";
          "monitors" = [];
          "overlayLayer" = true;
        };
        "plugins" = {
          "autoUpdate" = false;
        };
        "sessionMenu" = {
          "countdownDuration" = 10000;
          "enableCountdown" = true;
          "largeButtonsLayout" = "grid";
          "largeButtonsStyle" = false;
          "position" = "center";
          "powerOptions" = [
            {
              "action" = "lock";
              "enabled" = true;
              "keybind" = "1";
            }
            {
              "action" = "suspend";
              "enabled" = true;
              "keybind" = "2";
            }
            {
              "action" = "hibernate";
              "enabled" = true;
              "keybind" = "3";
            }
            {
              "action" = "reboot";
              "enabled" = true;
              "keybind" = "4";
            }
            {
              "action" = "logout";
              "enabled" = true;
              "keybind" = "5";
            }
            {
              "action" = "shutdown";
              "enabled" = true;
              "keybind" = "6";
            }
          ];
          "showHeader" = true;
          "showKeybinds" = true;
        };
        "settingsVersion" = 58;
        "systemMonitor" = {
          "batteryCriticalThreshold" = 5;
          "batteryWarningThreshold" = 20;
          "cpuCriticalThreshold" = 90;
          "cpuWarningThreshold" = 80;
          "criticalColor" = "";
          "diskAvailCriticalThreshold" = 10;
          "diskAvailWarningThreshold" = 20;
          "diskCriticalThreshold" = 90;
          "diskWarningThreshold" = 80;
          "enableDgpuMonitoring" = false;
          "externalMonitor" = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
          "gpuCriticalThreshold" = 90;
          "gpuWarningThreshold" = 80;
          "memCriticalThreshold" = 90;
          "memWarningThreshold" = 80;
          "swapCriticalThreshold" = 90;
          "swapWarningThreshold" = 80;
          "tempCriticalThreshold" = 90;
          "tempWarningThreshold" = 80;
          "useCustomColors" = false;
          "warningColor" = "";
        };
        "templates" = {
          "activeTemplates" = [
            {
              "enabled" = true;
              "id" = "hyprland";
            }
          ];
          "enableUserTheming" = false;
        };
        "ui" = {
          "boxBorderEnabled" = true;
          "fontDefault" = "Montserrat";
          "fontDefaultScale" = 1;
          "fontFixed" = "monospace";
          "fontFixedScale" = 1;
          "panelBackgroundOpacity" = 0.15;
          "panelsAttachedToBar" = true;
          "scrollbarAlwaysVisible" = true;
          "settingsPanelMode" = "attached";
          "settingsPanelSideBarCardStyle" = false;
          "tooltipsEnabled" = true;
          "translucentWidgets" = true;
        };
        "wallpaper" = {
          "automationEnabled" = false;
          "directory" = "/home/tiizzel/Pictures/Wallpapers";
          "enableMultiMonitorDirectories" = false;
          "enabled" = true;
          "favorites" = [];
          "fillColor" = "#000000";
          "fillMode" = "crop";
          "hideWallpaperFilenames" = false;
          "monitorDirectories" = [];
          "overviewBlur" = 0.4;
          "overviewEnabled" = false;
          "overviewTint" = 0.6;
          "panelPosition" = "follow_bar";
          "randomIntervalSec" = 300;
          "setWallpaperOnAllMonitors" = true;
          "showHiddenFiles" = false;
          "skipStartupTransition" = false;
          "solidColor" = "#1a1a2e";
          "sortOrder" = "name";
          "transitionDuration" = 1500;
          "transitionEdgeSmoothness" = 0.05;
          "transitionType" = "random";
          "useSolidColor" = false;
          "useWallhaven" = false;
          "viewMode" = "single";
          "wallhavenApiKey" = "";
          "wallhavenCategories" = "111";
          "wallhavenOrder" = "desc";
          "wallhavenPurity" = "100";
          "wallhavenQuery" = "landscape";
          "wallhavenRatios" = "";
          "wallhavenResolutionHeight" = "";
          "wallhavenResolutionMode" = "atleast";
          "wallhavenResolutionWidth" = "";
          "wallhavenSorting" = "relevance";
          "wallpaperChangeMode" = "random";
        };
      };
    };

    home.activation.noctaliaSettingsInit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      SETTINGS_FILE="$HOME/.config/noctalia/settings.json"
      TEMPLATE_FILE="$HOME/.config/noctalia/settings.json.template"

      if [ ! -f "$SETTINGS_FILE" ] || [ -L "$SETTINGS_FILE" ]; then
        $DRY_RUN_CMD rm -f "$SETTINGS_FILE"
        $DRY_RUN_CMD cp "$TEMPLATE_FILE" "$SETTINGS_FILE"
        $DRY_RUN_CMD chmod 644 "$SETTINGS_FILE"
      fi
    '';

    home.activation.noctaliaWarning = lib.hm.dag.entryAfter [ "noctaliaSettingsInit" ] ''
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo "🌙 Noctalia Shell is ENABLED"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "⚠️  Waybar has been automatically disabled"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "📝 Configuration: ~/.config/noctalia/settings.json (GUI-editable)"
      $DRY_RUN_CMD echo "🎨 Settings synced from GUI (use ./sync-from-gui.py to update)"
      $DRY_RUN_CMD echo "✏️  All GUI changes persist across reboots"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "💡 To update Nix template from GUI changes:"
      $DRY_RUN_CMD echo "   cd modules/home/noctalia-shell && ./sync-from-gui.py"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "📚 Docs: https://docs.noctalia.dev"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo ""
    '';
  };
}
