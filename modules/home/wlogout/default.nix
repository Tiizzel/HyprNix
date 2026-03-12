{ config, pkgs, lib, ... }:
let
  blurredImage = pkgs.runCommand "blurred-wallpaper.png" {
    nativeBuildInputs = [ pkgs.imagemagick ];
  } ''
    convert ${config.stylix.image} -blur 0x25 $out
  '';
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
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "sleep 1; systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "lock";
        action = "sleep 1; hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "sleep 1; hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "reboot";
        action = "sleep 1; systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "hibernate";
        action = "sleep 1; systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "sleep 1; systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
    ];

    style = ''
      * {
        background-image: none;
        box-shadow: none;
        text-shadow: none;
        font-family: "${config.stylix.fonts.sansSerif.name}", "JetBrains Mono Nerd Font", sans-serif;
      }

      window {
        background-image: url("${blurredImage}");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
        background-color: ${toRGBA c.base00 "0.5"};
      }

      button {
        color: #${c.base05};
        background-color: ${toRGBA c.base01 "0.4"};
        outline-style: none;
        border: 2px solid ${toRGBA c.base05 "0.1"};
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-radius: 15px;
        margin: 15px;
        transition: all 0.2s cubic-bezier(.55, 0.0, .28, 1.682);
      }

      button:focus,
      button:active,
      button:hover {
        color: #${c.base0D};
        background-color: ${toRGBA c.base02 "0.6"};
        border: 2px solid #${c.base0D};
        background-size: 30%;
      }

      button label {
        color: #${c.base05};
        font-size: 16px;
        margin-top: 110px;
      }

      button:hover label {
        color: #${c.base0D};
      }

      #shutdown {
        background-image: image(url("icons/shutdown.png"));
      }

      #logout {
        background-image: image(url("icons/logout.png"));
      }

      #suspend {
        background-image: image(url("icons/suspend.png"));
      }

      #lock {
        background-image: image(url("icons/lock.png"));
      }

      #reboot {
        background-image: image(url("icons/reboot.png"));
      }

      #hibernate {
        background-image: image(url("icons/hibernate.png"));
      }
    '';
  };
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };
}
