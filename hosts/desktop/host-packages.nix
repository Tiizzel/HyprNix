{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop # Bitwarden Desktop App
    mangohud # MangoHud
    nodejs # Node.js
    taterclient-ddnet # TaterClient DDNet
    protonup-qt # ProtonUp-Qt
    protontricks # ProtonTricks
    wine # Wine
    winetricks # Winetricks
    wine-wayland # Wine Wayland
  ];
}
