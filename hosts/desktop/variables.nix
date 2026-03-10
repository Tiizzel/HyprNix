{
  # ────────────────────────────────────────────────────────────────────────────
  # 👤 SYSTEM & USER CONFIGURATION
  # ────────────────────────────────────────────────────────────────────────────

  # Git Configuration
  gitUsername = "Tiizzel";
  gitEmail    = "tiizztwitch@gmail.com";

  # Localization
  keyboardLayout  = "de";
  keyboardVariant = "";
  consoleKeyMap   = "de";
  timezone        = "Europe/Berlin"; # Added default
  hostId          = "5ab03f50";      # Required for ZFS

  # ────────────────────────────────────────────────────────────────────────────
  # 🚀 BOOTLOADER & HARDWARE
  # ────────────────────────────────────────────────────────────────────────────

  # Bootloader Settings
  # Options: "systemd-boot", "grub"
  bootloader     = "grub";
  grubResolution = "5120x1440";
  grubTheme      = "distro"; # Options: "sleek", "minimal", "stylix", "distro"

  # Hardware Support
  gamingSupportEnable = true;  # Controllers, gamescope, protonup-qt
  enableNFS           = true;  # Network File System
  printEnable         = false; # Printing support

  # GPU IDs (For hybrid support: Intel/NVIDIA Prime or AMD/NVIDIA)
  intelID  = "PCI:1:0:0";
  amdgpuID = "PCI:5:0:0";
  nvidiaID = "PCI:0:2:0";

  # ────────────────────────────────────────────────────────────────────────────
  # 🖥️ DISPLAY & WINDOW MANAGER
  # ────────────────────────────────────────────────────────────────────────────

  # Display Manager
  # Options: "sddm" (GUI), "tui" (Text)
  displayManager = "sddm";

  # Hyprland Layout
  # Options: "dwindle" (standard), "scrolling" (master-stack), "master"
  hyprlandLayout = "scrolling";

  # Monitor Settings
  extraMonitorSettings = "
    monitor = DP-1,5120x1440@240,auto,1, bitdepth, 10, cm, hdr, sdrbrightness, 1.33, sdrsaturation, 1.18
  ";

  # ────────────────────────────────────────────────────────────────────────────
  # 🛠️ UI COMPONENTS & SHELL
  # ────────────────────────────────────────────────────────────────────────────

  # Status Bar
  # Options: "noctalia" (default), "waybar"
  barChoice = "waybar";

  # Waybar Settings (used when barChoice = "waybar")
  clock24h = true;

  # Terminal & Editor
  terminal = "kitty";  # Options: Kitty, ghostty, wezterm, alacritty
  editor   = "zeditor";
  browser  = "zen-beta";

  # ────────────────────────────────────────────────────────────────────────────
  # 📦 FEATURE TOGGLES (ENABLE/DISABLE)
  # ────────────────────────────────────────────────────────────────────────────

  # Application Enablers
  thunarEnable    = true;  # GUI File Manager (Yazi is default CLI)
  tmuxEnable      = false;
  alacrittyEnable = false;
  weztermEnable   = false;
  ghosttyEnable   = false;
  vscodeEnable    = false;
  antigravityEnable = false; # Google fork of VSCodium
  helixEnable     = false; # Evil-helix with VIM binds
  doomEmacsEnable = false; # Requires: zcli doom install

  # MIME Defaults (XDG)
  mimeDefaultApps = {
    "application/pdf"         = ["okular.desktop"];
    "application/x-pdf"       = ["okular.desktop"];
    "x-scheme-handler/http"   = ["firefox.desktop"];
    "x-scheme-handler/https"  = ["firefox.desktop"];
    "text/html"               = ["firefox.desktop"];
    "inode/directory"         = ["thunar.desktop"];
    "text/plain"              = ["nvim.desktop"];
  };

  # ────────────────────────────────────────────────────────────────────────────
  # 🎨 THEMING & AESTHETICS
  # ────────────────────────────────────────────────────────────────────────────

  # Transparency (0.0 to 1.0)
  opacity         = 1.0;
  inactiveOpacity = 0.69;

  # Wallpaper & Color Palette
  stylixImage = ../../wallpapers/aishot-3247.jpg;

  # Waybar Presets (Uncomment one)
  waybarChoice = ../../modules/home/waybar/waybar-hyprnix.nix;
  # waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  # waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  # waybarChoice = ../../modules/home/waybar/waybar-jak-ml4w-modern.nix;
  # waybarChoice = ../../modules/home/waybar/waybar-old-ddubsos.nix;

  # Hyprland Animation Style (Uncomment one)
  animChoice = ../../modules/home/hyprland/animations-dynamic.nix;
  # animChoice = ../../modules/home/hyprland/animations-ml4w-classic.nix;
  # animChoice = ../../modules/home/hyprland/animations-end4.nix;
}
