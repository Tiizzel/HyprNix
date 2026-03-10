{ pkgs, config, lib, ... }: {
  home.packages = with pkgs; [
    taterclient-ddnet
  ];

  # Writable symlink for DDNet configuration
  home.file.".local/share/ddnet".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/HyprNix/ddnet-data";
}
