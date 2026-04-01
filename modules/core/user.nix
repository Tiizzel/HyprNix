{
  pkgs,
  inputs,
  username,
  host,
  profile,
  matugenRawColors,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) gitUsername;
  # secrets = import ../../secrets;
  secrets = { sshKeys = []; }; # Temporary dummy
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs username host profile pkgs matugenRawColors;};
    users.${username} = {
      imports = [
        ./../home
      ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "23.11";
      };
    };
  };
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "adbusers"
      "docker" #access to docker as non-root
      "libvirtd" #Virt manager/QEMU access
      "lp"
      "networkmanager"
      "scanner"
      "wheel" #sudo access
      "vboxusers" #Virtual Box
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = secrets.sshKeys;
  };
  nix.settings.allowed-users = ["${username}"];
}
