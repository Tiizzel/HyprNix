{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodejs
    taterclient-ddnet
  ];
}
