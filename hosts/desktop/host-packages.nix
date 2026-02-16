{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop # Bitwarden Desktop App
    nodejs # Node.js
    heroic # Heroic Games Launcher
    qbittorrent # qBittorrent
    scanmem # Cheat Engine
    taterclient-ddnet # TaterClient DDNet
  ];
}
