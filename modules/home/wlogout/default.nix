{ config, pkgs, ... }:
let
  blurredImage = pkgs.runCommand "blurred-wallpaper.png" {
    nativeBuildInputs = [ pkgs.imagemagick ];
  } ''
    convert ${config.stylix.image} -blur 0x25 $out
  '';
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
        font-family: "JetBrains Mono Nerd Font", "Fira Sans Semibold", sans-serif;
      }

      window {
        background-image: url("${blurredImage}");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
      }

      button {
        color: #${config.lib.stylix.colors.base05};
        background-color: rgba(30, 30, 46, 0.5);
        outline-style: none;
        border: 2px solid rgba(255, 255, 255, 0.1);
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-radius: 20px;
        box-shadow: none;
        text-shadow: none;
        margin: 10px;
        transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682);
      }

      button:focus,
      button:active,
      button:hover {
        background-color: rgba(137, 180, 250, 0.5);
        border: 2px solid #${config.lib.stylix.colors.base0D};
        background-size: 30%;
        color: #${config.lib.stylix.colors.base0B};
      }

      #shutdown {
        background-image: image(url("icons/shutdown.png"));
      }

      #logout {
        background-image: image(url("icons/logout.png"));
      }

      #suspend {
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
