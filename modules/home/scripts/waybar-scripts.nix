{
  pkgs,
  temperatureUnit,
  ...
}: let
  # Helper to create a shell script package
  mkScript = name: file:
    pkgs.writeShellScriptBin name ''
      export TEMPERATURE_UNIT="${temperatureUnit}"
      ${builtins.readFile file}
    '';

  # Waybar Scripts
  battery-level = mkScript "waybar-battery-level" ../waybar/scripts/battery-level.sh;
  battery-state = mkScript "waybar-battery-state" ../waybar/scripts/battery-state.sh;
  brightness-control = mkScript "waybar-brightness-control" ../waybar/scripts/brightness-control.sh;
  cpu-temp = mkScript "waybar-cpu-temp" ../waybar/scripts/cpu-temp.sh;
  power-menu = mkScript "waybar-power-menu" ../waybar/scripts/power-menu.sh;
  volume-control = mkScript "waybar-volume-control" ../waybar/scripts/volume-control.sh;
  wifi-status = mkScript "waybar-wifi-status" ../waybar/scripts/wifi-status.sh;

  # Python script for weather
  weather = pkgs.writeScriptBin "waybar-weather" ''
    #!${pkgs.python3.withPackages (ps: [ps.requests])}/bin/python3
    import os
    os.environ["WEATHER_UNITS"] = "${temperatureUnit}"
    ${builtins.readFile ../waybar/scripts/Weather.py}
  '';
in [
  battery-level
  battery-state
  brightness-control
  cpu-temp
  power-menu
  volume-control
  wifi-status
  weather
]
