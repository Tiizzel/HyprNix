{pkgs,inputs, ...}: {
  programs.spicetify =
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.stdenv.hostPlatform.system};
  in
  {
    enable = true;
    #theme = spicePkgs.themes.dribbblish;
    #colorScheme = "MyTheme";
  };
}
