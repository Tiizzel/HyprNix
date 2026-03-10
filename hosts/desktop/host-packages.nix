{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop # Bitwarden Desktop App
    claude-code # Claude Code
    gemini-cli-bin # Gemini CLI
    heroic # Heroic Games Launcher
    nodejs # Node.js
    qbittorrent # qBittorrent
    scanmem # Cheat Engine
  ];
}
