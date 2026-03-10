{
  pkgs,
  host,
  lib,
  ...
}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit (vars) stylixImage;

  # Run matugen and get JSON with base16 scheme
  matugenOutput = pkgs.runCommand "matugen-colors.json" {
    nativeBuildInputs = [pkgs.matugen pkgs.gnused];
  } ''
    matugen image "${stylixImage}" --source-color-index 0 --json hex | sed '/"image":/d' > $out
  '';

  # Parse the JSON output
  # Using builtins.readFile on a derivation output causes IFD (Import From Derivation)
  matugenColors = builtins.fromJSON (builtins.readFile matugenOutput);

  # Helper to strip '#' from hex colors
  stripHash = color: builtins.substring 1 6 color;

  # Map matugen base16 to stylix expected format (without #)
  # Matugen uses lowercase (base0a), but Stylix/Base16 expects uppercase (base0A)
  base16Scheme = {
    base00 = stripHash matugenColors.base16.base00.default.color;
    base01 = stripHash matugenColors.base16.base01.default.color;
    base02 = stripHash matugenColors.base16.base02.default.color;
    base03 = stripHash matugenColors.base16.base03.default.color;
    base04 = stripHash matugenColors.base16.base04.default.color;
    base05 = stripHash matugenColors.base16.base05.default.color;
    base06 = stripHash matugenColors.base16.base06.default.color;
    base07 = stripHash matugenColors.base16.base07.default.color;
    base08 = stripHash matugenColors.base16.base08.default.color;
    base09 = stripHash matugenColors.base16.base09.default.color;
    base0A = stripHash matugenColors.base16.base0a.default.color;
    base0B = stripHash matugenColors.base16.base0b.default.color;
    base0C = stripHash matugenColors.base16.base0c.default.color;
    base0D = stripHash matugenColors.base16.base0d.default.color;
    base0E = stripHash matugenColors.base16.base0e.default.color;
    base0F = stripHash matugenColors.base16.base0f.default.color;
  };
in {
  _module.args.matugenScheme = base16Scheme;

  environment.systemPackages = [pkgs.matugen];
}
