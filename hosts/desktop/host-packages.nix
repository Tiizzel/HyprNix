{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop # Bitwarden Desktop App
    heroic # Heroic Games Launcher
    nodejs # Node.js
    qbittorrent # qBittorrent
    scanmem # Cheat Engine
  ];
}
