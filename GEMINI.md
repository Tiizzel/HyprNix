# HyprNix Project Context

HyprNix is a modular and feature-rich NixOS configuration flake, originally based on ZaneyOS. it is designed for ease of use while providing a highly customized Hyprland desktop environment with advanced shell features and automated system management.

## Project Overview

*   **Main Technologies:** NixOS (Unstable), Flakes, Home Manager, Hyprland.
*   **Theming:** [Stylix](https://github.com/nix-community/stylix) for system-wide color schemes and wallpapers.
*   **Desktop Components:** [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell) (default), Waybar (optional), Rofi/Wlogout.
*   **Management Tool:** `zcli` - A custom CLI utility for system maintenance and configuration.

## Project Structure

*   `hosts/`: Contains host-specific configurations.
    *   `default/`: Template for new host configurations.
    *   `<hostname>/variables.nix`: The primary configuration file for user-specific settings, enabled features, and theming choices.
    *   `<hostname>/hardware.nix`: System-specific hardware configuration (generated via `nixos-generate-config`).
*   `modules/`: Modular Nix code separated into functional areas.
    *   `core/`: System-level modules (boot, networking, security, user management, global packages).
    *   `drivers/`: GPU and hardware-specific drivers.
    *   `home/`: Home Manager modules (Hyprland, waybar, terminals, scripts, etc.).
*   `profiles/`: GPU-specific entry points (amd, nvidia, intel, vm, etc.).
*   `wallpapers/`: Collection of wallpapers used by Stylix.

## Configuration Guide

The main entry point for personalizing HyprNix is the `hosts/<hostname>/variables.nix` file. Key settings include:

*   **System Info:** `gitUsername`, `gitEmail`, `keyboardLayout`, `timezone`.
*   **UI/UX:** `barChoice` ("noctalia" or "waybar"), `hyprlandLayout` ("scrolling", "dwindle", or "master"), `terminal` ("kitty" by default).
*   **Enable/Disable Features:** `gamingSupportEnable`, `tmuxEnable`, `vscodeEnable`, `doomEmacsEnable`.
*   **Theming:** `stylixImage` (path to wallpaper), `waybarChoice` (select from multiple presets), `animChoice` (Hyprland animation presets).

## Key Commands (`zcli`)

The `zcli` tool is the recommended way to interact with the system.

| Command | Description |
| :--- | :--- |
| `zcli rebuild` | Rebuild the NixOS system using `nh os switch`. |
| `zcli update` | Update the flake lockfile and rebuild the system. |
| `zcli cleanup` | Interactive tool to remove old system generations and free up space. |
| `zcli update-host` | Automatically sets the `host` and `profile` in `flake.nix` based on current hardware. |
| `zcli add-host [name]` | Creates a new host folder from the template. |
| `zcli diag` | Generates a system diagnostic report (`~/diag.txt`). |
| `zcli doom install` | Installs Doom Emacs (requires `doomEmacsEnable = true` in variables). |

**Manual Nix Commands:**
*   `sudo nixos-rebuild switch --flake .#<profile>`
*   `nix-shell -p git pciutils` (for initial installation/bootstrap)

## Development Workflow

1.  **Adding a New Host:**
    ```bash
    cp -r hosts/default hosts/my-new-host
    # Edit hosts/my-new-host/variables.nix and hardware.nix
    zcli update-host my-new-host amd  # or your GPU profile
    zcli rebuild
    ```
2.  **Modifying UI:**
    Changes made in `modules/home/` are automatically applied to the user environment via Home Manager when rebuilding.
3.  **Adding Packages:**
    *   System-wide: Add to `modules/core/packages.nix`.
    *   User-specific: Add to `modules/home/home-packages.nix` or toggle in `variables.nix`.

## Important Files
*   `flake.nix`: The root entry point defining inputs and system outputs.
*   `hosts/<host>/variables.nix`: User-level configuration and feature toggles.
*   `modules/home/scripts/zcli.nix`: Source code for the `zcli` utility.
*   `README.md`: Contains a comprehensive list of Hyprland keybindings.
