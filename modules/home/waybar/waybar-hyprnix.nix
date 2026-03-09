{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  c = config.lib.stylix.colors;
  # Helper to convert hex to decimal
  hexToDec = hex: let
    digits = {
      "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4; "5" = 5; "6" = 6; "7" = 7;
      "8" = 8; "9" = 9; "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
      "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
    };
    high = builtins.substring 0 1 hex;
    low = builtins.substring 1 1 hex;
  in
    (digits."${high}" * 16) + digits."${low}";
  
  # Format as rgba decimal string
  toRGBA = hex: alpha: 
    "rgba(${toString (hexToDec (builtins.substring 0 2 hex))}, ${toString (hexToDec (builtins.substring 2 2 hex))}, ${toString (hexToDec (builtins.substring 4 2 hex))}, ${alpha})";
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [
      {
        layer = "top";
        position = "top";
        spacing = 3;
        "fixed-center" = true;
        ipc = true;
        "margin-top" = 5;
        "margin-left" = 10;
        "margin-right" = 10;

        "modules-left" = [
          "custom/menu"
          "hyprland/workspaces"
          "mpris"
          "hyprland/window"
        ];

        "modules-center" = [
          "clock"
        ];

        "modules-right" = [
          "cpu"
          "memory"
          "pulseaudio"
          "network"
          "battery"
          "tray"
          "custom/power"
        ];

        "mpris" = {
          "format" = "{player_icon} {title} - {artist}";
          "format-paused" = "{status_icon} <i>{title} - {artist}</i>";
          "player-icons" = {
            "default" = "▶";
            "mpv" = "🎵";
            "spotify" = "";
          };
          "status-icons" = {
            "paused" = "⏸";
          };
          "max-length" = 30;
        };

        "hyprland/workspaces" = {
          "on-click" = "activate";
          "active-only" = false;
          "all-outputs" = true;
          "format" = "{icon}";
          "format-icons" = {
            "default" = "";
            "active" = "󱓻";
            "urgent" = "󱓻";
          };
          "persistent-workspaces" = {
            "*" = 5;
          };
        };

        "hyprland/window" = {
          "format" = "{}";
          "max-length" = 40;
          "separate-outputs" = true;
        };

        "clock" = {
          "format" = "{:%H:%M}";
          "format-alt" = "{:%A, %B %d, %Y (%R)}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='#${c.base05}'><b>{}</b></span>";
              "days" = "<span color='#${c.base05}'><b>{}</b></span>";
              "weeks" = "<span color='#${c.base0C}'><b>W{}</b></span>";
              "weekdays" = "<span color='#${c.base0A}'><b>{}</b></span>";
              "today" = "<span color='#${c.base08}'><b><u>{}</u></b></span>";
            };
          };
        };

        "cpu" = {
          "format" = "󰍛 {usage}%";
          "interval" = 2;
        };

        "memory" = {
          "format" = "󰾆 {percentage}%";
          "interval" = 2;
        };

        "pulseaudio" = {
          "format" = "{icon} {volume}%";
          "format-muted" = "󰖁 Muted";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" "󰕾" ""];
          };
          "on-click" = "pavucontrol";
        };

        "network" = {
          "format-wifi" = " {essid}";
          "format-ethernet" = "󰈀 {ifname}";
          "format-disconnected" = "󰤮 Disconnected";
          "tooltip-format" = "{ifname} via {gwaddr} 󰊗";
          "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
          "tooltip-format-ethernet" = "{ifname} ";
          "tooltip-format-disconnected" = "Disconnected";
          "max-length" = 50;
        };

        "battery" = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = " {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-alt" = "{icon} {time}";
          "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        "tray" = {
          "icon-size" = 18;
          "spacing" = 10;
        };

        "custom/menu" = {
          "format" = "";
          "on-click" = "rofi -show drun";
          "tooltip" = false;
        };

        "custom/power" = {
          "format" = "⏻";
          "on-click" = "wlogout";
          "tooltip" = false;
        };
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      .modules-left, .modules-center, .modules-right {
        background-color: ${toRGBA c.base00 "0.7"};
        border: 2px solid #${c.base0D};
        padding: 2px 10px;
        border-radius: 15px;
        color: #${c.base05};
      }

      #workspaces button {
        padding: 0 5px;
        color: #${c.base05};
      }

      #workspaces button.active {
        color: #${c.base0D};
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 10px;
      }

      #clock, #cpu, #memory, #pulseaudio, #network, #battery, #tray, #custom-menu, #custom-power, #mpris {
        padding: 0 10px;
      }

      #window {
        padding-left: 10px;
        color: #${c.base0B};
      }
    '';
  };
}
