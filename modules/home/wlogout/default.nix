{config, ...}: {
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
        "label" = "reboot";
        "action" = "sleep 1; systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
      {
        "label" = "logout";
        "action" = "sleep 1; hyprctl dispatch exit";
        "text" = "Exit";
        "keybind" = "e";
      }
      {
        "label" = "suspend";
        "action" = "sleep 1; systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
      {
        "label" = "lock";
        "action" = "sleep 1; hyprlock";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "hibernate";
        "action" = "sleep 1; systemctl hibernate";
        "text" = "Hibernate";
        "keybind" = "h";
      }
    ];
      #${config.lib.stylix.colors.base0B}

    style = ''

      * {
        font-family: "Fira Sans Semibold", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        background-image: none;
        transition: 20ms;
        box-shadow: none;
      }

      window {
      	background-color: rgba(12, 12, 12, 0.5);
      	background-image: none;
      }

      button {
        background-repeat: no-repeat;
        background-position: center;
        background-size: 20%;
        animation: gradient_f 20s ease-in infinite;
        border-radius: 80px; /* Increased border radius for a more rounded look */
        border: 3px solid #${config.lib.stylix.colors.base05};
        transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
        color: #${config.lib.stylix.colors.base05};
        background-color: rgba(12, 12, 12, 0.5);
        margin: 10px;
        min-width: 150px;
        min-height: 150px;
      }

      button:focus {
        background-color: #${config.lib.stylix.colors.base02};
        background-size: 25%;
        border: 3px solid #${config.lib.stylix.colors.base05};
      }

      button:hover {
          background-color: #${config.lib.stylix.colors.base0B};
          opacity: 0.8;
          color: #${config.lib.stylix.colors.base0B};
          background-size: 30%;
          margin: 30px;
          border-radius: 80px;
          box-shadow: 0 0 50px @shadow;
      }

      /* Adjust the size of the icon or content inside the button */
      button span {
          font-size: 1.2em; /* Increase the font size */
      }

      /*
      -----------------------------------------------------
      Buttons
      -----------------------------------------------------
      */

      #lock {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("icons/lock.png"));
      }

      #logout {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("icons/logout.png"));
      }

      #suspend {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("icons/suspend.png"));
      }

      #hibernate {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("icons/hibernate.png"));
      }

      #shutdown {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("icons/shutdown.png"));
      }

      #reboot {
        margin: 10px;
        border-radius: 20px;
        background-image: image(url("icons/reboot.png"));
      }
    '';
  };
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };
}
