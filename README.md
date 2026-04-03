# ❄️ HyprNix

<div align="center">
  <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos-white.png" width="120" alt="NixOS Logo" />
  <h3>Modular & Feature-Rich Hyprland Configuration</h3>
  <p><i>A customized, high-performance NixOS flake for the modern desktop.</i></p>

  [![NixOS Unstable](https://img.shields.io/badge/NixOS-Unstable-blue.svg?style=flat-square&logo=nixos)](https://nixos.org)
  [![Hyprland](https://img.shields.io/badge/WM-Hyprland-brightgreen.svg?style=flat-square)](https://hyprland.org)
  [![Stylix](https://img.shields.io/badge/Theme-Stylix-ff69b4.svg?style=flat-square)](https://github.com/nix-community/stylix)
  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
</div>

---

## 🚀 Overview

HyprNix is a modular NixOS configuration flake designed for power users who want a beautiful, functional, and automated Hyprland environment. Originally based on ZaneyOS, it has evolved into a highly customized system featuring system-wide theming, advanced shell features, and a dedicated management utility.

### ✨ Highlights
- **🎨 System-wide Theming:** Powered by [Stylix](https://github.com/nix-community/stylix). Change one wallpaper, and your entire system (Terminal, Browsers, WM, Editors) follows suit.
- **🛠️ Custom CLI Tool:** `tcli` simplifies system maintenance, rebuilds, and configuration management.
- **🖥️ Desktop Flexibility:** Choose between the advanced **Noctalia Shell** or a highly customized **Waybar**.
- **🌐 Browser Integration:** Pre-configured Firefox and Zen Browser with Stylix-driven aesthetics.
- **⚡ Performance First:** Optimized for AMD, NVIDIA, and Intel GPUs with specialized profiles.

---

## 📸 Screenshots

<div align="center">
  <p><i>Visual overview of HyprNix in action.</i></p>
  
  <h3>Main Desktop</h3>
  <img src="screenshots/main%20screenshot.png" width="85%"><br>
  <img src="screenshots/desktop%20screenshot.png" width="85%">

  <h3>Applications & UI</h3>
  <table>
    <tr>
      <td><img src="screenshots/spotify%20and%20vesktop.png" alt="Spotify & Vesktop"></td>
      <td><img src="screenshots/screenshot%20thunar.png" alt="Thunar File Manager"></td>
    </tr>
    <tr>
      <td><img src="screenshots/screenshot%20roft.png" alt="Rofi Launcher"></td>
      <td><img src="screenshots/screenshot%20waybar.png" alt="Waybar"></td>
    </tr>
    <tr>
      <td colspan="2" align="center"><img src="screenshots/screenshot%20keybinding%20script.png" alt="Keybindings Script" width="70%"></td>
    </tr>
  </table>
</div>

---

## 📂 Project Structure

```bash
├── hosts/             # Host-specific configurations (Variables & Hardware)
├── modules/
│   ├── core/          # System-level modules (Boot, Network, Security)
│   ├── drivers/       # GPU and Hardware-specific drivers
│   └── home/          # Home Manager modules (UI, Apps, Scripts)
├── profiles/          # Entry points for different GPU/System types
└── wallpapers/        # Collection of Stylix-ready wallpapers
```

---

## 🛠️ Management with `tcli`

The `tcli` utility is your primary way to interact with HyprNix.

| Command | Description |
| :--- | :--- |
| `tcli rebuild` | Rebuild and switch to the current configuration. |
| `tcli rebuild-boot` | Rebuild and stage for next boot. |
| `tcli update` | Update the flake lockfile and rebuild the system. |
| `tcli cleanup` | Remove old generations and free store space. |

---

## ⌨️ Hyprland Keybindings

### Core Binds
| Keybind | Action |
| :--- | :--- |
| `SUPER + T` | Open Terminal (`kitty` by default) |
| `SUPER + Space` | Application Launcher (Noctalia or Rofi) |
| `SUPER + Q` | Kill Active Window |
| `SUPER + Ctrl + F` | Toggle Fullscreen |
| `SUPER + Shift + F` | Toggle Floating Mode |
| `SUPER + Tab` | Toggle Quickshell Overview |
| `SUPER + B` | Open Web Browser |
| `SUPER + S` | Take Screenshot |
| `SUPER + V` | Clipboard Manager |
| `SUPER + X` | Power Menu / Logout Menu |
| `SUPER + 1-0` | Switch Workspace (1-10) |
| `SUPER + Shift + 1-0` | Move Window to Workspace (1-10) |
| `SUPER + N` | Toggle Special Workspace (Scratchpad) |

### Navigation & Layout
HyprNix supports multiple layouts. Navigation keys adapt based on your `hyprlandLayout` setting in `variables.nix`.

**Standard Navigation (Dwindle/Master):**
- `SUPER + H/J/K/L` or `Arrows`: Focus movement.
- `SUPER + Shift + H/J/K/L` or `Arrows`: Move window.
- `SUPER + Alt + H/J/K/L` or `Arrows`: Swap window.

**Scrolling Layout:**
- `SUPER + H/L` or `Left/Right`: Navigate between columns.
- `SUPER + J/K` or `Up/Down`: Navigate within a column.
- `SUPER + R` / `Shift + R`: Resize column width.
- `SUPER + C`: Center current column.
- `SUPER + Shift + F`: Fit all columns to screen.

---

## 🔧 Installation & Setup

> **Prerequisites:** A fresh NixOS installation with internet access.

### Automatic Install (recommended)

The install script handles everything — cloning, GPU detection, host setup, and the initial build.

```bash
nix-shell -p git pciutils
```
```bash
bash <(curl -s https://raw.githubusercontent.com/Tiizzel/HyprNix/main/install.sh)
```

The script will prompt you for:
- Hostname, NixOS username, git identity
- Timezone and keyboard layout
- GPU profile (auto-detected, can be overridden)

It then patches the config, generates your hardware configuration, and runs the initial build. Reboot when done.

---

### Manual Install

#### 1. Bootstrap
```bash
nix-shell -p git pciutils
```

#### 2. Clone the Repository
```bash
git clone https://github.com/Tiizzel/HyprNix.git ~/HyprNix
cd ~/HyprNix
```

#### 3. Create Your Host Directory
Copy the default host and edit `variables.nix` to match your system:
```bash
cp -r hosts/desktop hosts/<your-hostname>
$EDITOR hosts/<your-hostname>/variables.nix
```

Key fields to set in `variables.nix`:
| Field | Description |
| :--- | :--- |
| `gitUsername` / `gitEmail` | Your git identity |
| `keyboardLayout` / `consoleKeyMap` | e.g. `"de"`, `"us"` |
| `timezone` | e.g. `"Europe/Berlin"` |
| `hostId` | 8-char hex, generate with `head -c4 /dev/urandom \| od -An -tx4 \| tr -d ' '` |

#### 4. Generate Hardware Config
```bash
sudo nixos-generate-config --show-hardware-config > hosts/<your-hostname>/hardware.nix
```

#### 5. Update `flake.nix`
Set the three variables at the top of the `outputs` let-block:
```nix
host     = "<your-hostname>";   # must match your hosts/ directory name
profile  = "amd";               # your GPU profile (see below)
username = "<your-username>";
```

Available GPU profiles: `amd` · `nvidia` · `nvidia-laptop` · `amd-nvidia-hybrid` · `intel` · `vm`

#### 6. Build
```bash
git add .
sudo nixos-rebuild boot --flake ~/HyprNix/#<profile>
sudo reboot
```

---

## 🤝 Credits & Acknowledgements

- **ZaneyOS:** The original foundation of this project.
- **Noctalia Devs:** For the incredible Noctalia Shell.
- **Nix Community:** For Stylix, Home Manager, and the NixOS ecosystem.

---

<div align="center">
  <p>Developed with ❤️ by Tiizzel</p>
</div>
