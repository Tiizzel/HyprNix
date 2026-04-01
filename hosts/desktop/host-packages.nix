{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop # Bitwarden Desktop App
    brave # Brave Browser
    gtt # Google Translate (with support for Deeül and others)
    heroic # Heroic Games Launcher
    nodejs # Node.js
    qbittorrent # qBittorrent
    scanmem # Cheat Engine
  ];
}
