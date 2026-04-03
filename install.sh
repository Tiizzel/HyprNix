#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────────────────────────
#  HyprNix Install Script
#  github.com/Tiizzel/HyprNix
# ─────────────────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

LOG_FILE="$HOME/hyprnix-install-$(date +%Y-%m-%d_%H-%M-%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

# ─────────────────────────────────────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────────────────────────────────────

header() {
  echo ""
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${CYAN}  $1${NC}"
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

ok()   { echo -e "${GREEN}  ✓ $1${NC}"; }
warn() { echo -e "${YELLOW}  ⚠  $1${NC}"; }
err()  { echo -e "${RED}  ✗ $1${NC}"; }
info() { echo -e "${BLUE}  → $1${NC}"; }

# ─────────────────────────────────────────────────────────────────────────────
#  Banner
# ─────────────────────────────────────────────────────────────────────────────

clear
echo -e "${BOLD}${CYAN}"
cat << 'EOF'
  ██╗  ██╗██╗   ██╗██████╗ ██████╗ ███╗   ██╗██╗██╗  ██╗
  ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗████╗  ██║██║╚██╗██╔╝
  ███████║ ╚████╔╝ ██████╔╝██████╔╝██╔██╗ ██║██║ ╚███╔╝
  ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║╚██╗██║██║ ██╔██╗
  ██║  ██║   ██║   ██║     ██║  ██║██║ ╚████║██║██╔╝ ██╗
  ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
EOF
echo -e "${NC}"
echo -e "  ${BOLD}Hyprland · NixOS · Stylix · Noctalia Shell${NC}"
echo -e "  ${BLUE}github.com/Tiizzel/HyprNix${NC}"
echo ""

# ─────────────────────────────────────────────────────────────────────────────
#  1. Requirements
# ─────────────────────────────────────────────────────────────────────────────

header "Checking Requirements"

if ! grep -qi nixos /etc/os-release 2>/dev/null; then
  err "This script requires NixOS."
  exit 1
fi
ok "Running NixOS"

if ! command -v git &>/dev/null; then
  err "git is not installed. Run: nix-shell -p git pciutils"
  exit 1
fi
ok "git found"

if ! command -v lspci &>/dev/null; then
  err "pciutils (lspci) is not installed. Run: nix-shell -p git pciutils"
  exit 1
fi
ok "pciutils found"

# ─────────────────────────────────────────────────────────────────────────────
#  2. Gather configuration
# ─────────────────────────────────────────────────────────────────────────────

header "System Configuration"

echo -e "  ${BOLD}Default values are shown in [brackets] — press Enter to accept.${NC}"
echo ""

# Hostname
echo -e "  ${YELLOW}The hostname becomes your NixOS networking.hostName and host directory name.${NC}"
read -rp "  Hostname [hyprnix]: " hostName
hostName="${hostName:-hyprnix}"
if [[ "$hostName" == "desktop" || "$hostName" == "default" ]]; then
  warn "'$hostName' is reserved. Using 'hyprnix' instead."
  hostName="hyprnix"
fi
ok "Hostname: $hostName"

# NixOS username
defaultUser="$(id -un 2>/dev/null || echo nixos)"
read -rp "  NixOS username [$defaultUser]: " nixosUser
nixosUser="${nixosUser:-$defaultUser}"
ok "Username: $nixosUser"

# Git identity
read -rp "  Git full name [$nixosUser]: " gitName
gitName="${gitName:-$nixosUser}"
read -rp "  Git email [$nixosUser@example.com]: " gitEmail
gitEmail="${gitEmail:-$nixosUser@example.com}"
ok "Git: $gitName <$gitEmail>"

# Timezone
echo ""
echo -e "  ${BLUE}Examples: Europe/Berlin  America/New_York  Asia/Tokyo  UTC${NC}"
read -rp "  Timezone [Europe/Berlin]: " timezone
timezone="${timezone:-Europe/Berlin}"
ok "Timezone: $timezone"

# Keyboard
echo ""
echo -e "  ${BLUE}Layout examples: de  us  uk  fr  es  it  ru  dvorak${NC}"
read -rp "  Keyboard layout [us]: " kbLayout
kbLayout="${kbLayout:-us}"
read -rp "  Keyboard variant (blank for none) []: " kbVariant
kbVariant="${kbVariant:-}"
read -rp "  Console keymap [$kbLayout]: " consoleKeymap
consoleKeymap="${consoleKeymap:-$kbLayout}"
ok "Keyboard: layout=$kbLayout variant=${kbVariant:-none} console=$consoleKeymap"

# ─────────────────────────────────────────────────────────────────────────────
#  3. GPU Profile Detection
# ─────────────────────────────────────────────────────────────────────────────

header "GPU Profile Detection"

has_nvidia=false; has_amd=false; has_intel=false; has_vm=false
while read -r line; do
  echo "$line" | grep -qi 'nvidia'                            && has_nvidia=true
  echo "$line" | grep -qi 'amd\|ati\|advanced micro devices' && has_amd=true
  echo "$line" | grep -qi 'intel'                            && has_intel=true
  echo "$line" | grep -qi 'virtio\|vmware\|qemu'             && has_vm=true
done < <(lspci 2>/dev/null | grep -i 'vga\|3d\|display')

if   $has_vm;                   then detected="vm"
elif $has_nvidia && $has_amd;   then detected="amd-nvidia-hybrid"
elif $has_nvidia && $has_intel; then detected="nvidia-laptop"
elif $has_nvidia;               then detected="nvidia"
elif $has_amd;                  then detected="amd"
elif $has_intel;                then detected="intel"
else                                 detected=""
fi

profile=""
if [[ -n "$detected" ]]; then
  info "Detected GPU profile: $detected"
  read -rp "  Use this profile? [Y/n]: " gpuConfirm
  [[ "${gpuConfirm:-Y}" =~ ^[Yy]$ ]] && profile="$detected"
fi

if [[ -z "$profile" ]]; then
  echo ""
  echo -e "  ${BLUE}Available: amd  nvidia  nvidia-laptop  amd-nvidia-hybrid  intel  vm${NC}"
  read -rp "  GPU profile [amd]: " profile
  profile="${profile:-amd}"
fi
ok "GPU profile: $profile"

# ─────────────────────────────────────────────────────────────────────────────
#  4. Summary + confirm
# ─────────────────────────────────────────────────────────────────────────────

header "Installation Summary"

echo ""
echo -e "${CYAN}  ┌───────────────────────────────────────────────────┐${NC}"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "Hostname"       "$hostName"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "Username"       "$nixosUser"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "Git name"       "$gitName"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "Git email"      "$gitEmail"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "Timezone"       "$timezone"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "Keyboard"       "$kbLayout${kbVariant:+ ($kbVariant)}"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "Console keymap" "$consoleKeymap"
printf "${CYAN}  │${NC}  %-16s ${BLUE}%s${NC}\n" "GPU profile"    "$profile"
echo -e "${CYAN}  └───────────────────────────────────────────────────┘${NC}"
echo ""

read -rp "  Proceed with installation? [Y/n]: " proceed
[[ "${proceed:-Y}" =~ ^[Yy]$ ]] || { echo "  Cancelled."; exit 0; }

# ─────────────────────────────────────────────────────────────────────────────
#  5. Backup existing HyprNix if present
# ─────────────────────────────────────────────────────────────────────────────

header "Cloning HyprNix"

cd "$HOME" || exit 1

if [[ -d "$HOME/HyprNix" ]]; then
  warn "Existing ~/HyprNix detected."
  echo ""
  echo -e "  ${RED}This will REPLACE your current configuration.${NC}"
  echo -e "  ${YELLOW}A timestamped backup will be saved to ~/.config/HyprNix-backups/${NC}"
  echo ""
  read -rp "  Type REPLACE to continue, or Ctrl+C to abort: " replaceConfirm
  if [[ "$replaceConfirm" != "REPLACE" ]]; then
    echo "  Cancelled."
    exit 0
  fi
  backupDir="$HOME/.config/HyprNix-backups/$(date +%Y-%m-%d_%H-%M-%S)"
  mkdir -p "$backupDir"
  mv "$HOME/HyprNix" "$backupDir/"
  ok "Backed up to $backupDir"
fi

info "Cloning from github.com/Tiizzel/HyprNix ..."
git clone https://github.com/Tiizzel/HyprNix.git --depth=1 "$HOME/HyprNix"
cd "$HOME/HyprNix" || { err "Clone failed — check your internet connection."; exit 1; }
ok "Cloned successfully"

# ─────────────────────────────────────────────────────────────────────────────
#  6. Set up host directory
# ─────────────────────────────────────────────────────────────────────────────

header "Setting Up Host Directory"

if [[ "$hostName" != "desktop" ]]; then
  info "Creating hosts/$hostName/ from hosts/desktop/ ..."
  mkdir -p "hosts/$hostName"
  cp hosts/desktop/*.nix "hosts/$hostName/"
  ok "hosts/$hostName/ created"
else
  ok "Using existing hosts/desktop/"
fi

# Generate a random 8-char hex hostId (required for ZFS)
newHostId=$(head -c4 /dev/urandom | od -An -tx4 | tr -d ' \n' | head -c8)
ok "Generated hostId: $newHostId"

# ─────────────────────────────────────────────────────────────────────────────
#  7. Patch configuration files
# ─────────────────────────────────────────────────────────────────────────────

header "Patching Configuration"

# flake.nix — host, profile, username
info "Patching flake.nix ..."
sed -i \
  -e "s|^\([[:space:]]*host[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${hostName}\";|" \
  -e "s|^\([[:space:]]*profile[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${profile}\";|" \
  -e "s|^\([[:space:]]*username[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${nixosUser}\";|" \
  flake.nix
ok "flake.nix"

# hosts/<host>/variables.nix — localization + git identity
info "Patching hosts/$hostName/variables.nix ..."
sed -i \
  -e "s|^\([[:space:]]*gitUsername[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${gitName}\";|" \
  -e "s|^\([[:space:]]*gitEmail[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${gitEmail}\";|" \
  -e "s|^\([[:space:]]*keyboardLayout[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${kbLayout}\";|" \
  -e "s|^\([[:space:]]*keyboardVariant[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${kbVariant}\";|" \
  -e "s|^\([[:space:]]*consoleKeyMap[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${consoleKeymap}\";|" \
  -e "s|^\([[:space:]]*timezone[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${timezone}\";|" \
  -e "s|^\([[:space:]]*hostId[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${newHostId}\";|" \
  "hosts/$hostName/variables.nix"
ok "variables.nix"

# modules/core/system.nix — timezone is also hardcoded here
info "Patching modules/core/system.nix ..."
sed -i \
  -e "s|^\([[:space:]]*time\.timeZone[[:space:]]*=[[:space:]]*\)\"[^\"]*\";|\1\"${timezone}\";|" \
  modules/core/system.nix
ok "system.nix"

# ─────────────────────────────────────────────────────────────────────────────
#  8. Hardware configuration
# ─────────────────────────────────────────────────────────────────────────────

header "Generating Hardware Configuration"

info "Running nixos-generate-config ..."
sudo nixos-generate-config --show-hardware-config > "hosts/$hostName/hardware.nix"
ok "Written to hosts/$hostName/hardware.nix"

# Stage all files so the flake evaluator can see them
git config --global user.name  "$gitName"
git config --global user.email "$gitEmail"
git add .

# ─────────────────────────────────────────────────────────────────────────────
#  9. Build
# ─────────────────────────────────────────────────────────────────────────────

header "Building NixOS"

echo ""
warn "First build downloads everything — this can take 20–60+ minutes."
echo ""
read -rp "  Start build now? [Y/n]: " buildConfirm
if [[ ! "${buildConfirm:-Y}" =~ ^[Yy]$ ]]; then
  echo ""
  info "Skipped. When ready:"
  echo "    cd ~/HyprNix && sudo nixos-rebuild boot --flake .#${profile}"
  git config --global --unset user.name  2>/dev/null || true
  git config --global --unset user.email 2>/dev/null || true
  exit 0
fi

echo ""
info "sudo nixos-rebuild boot --flake ~/HyprNix/#${profile}"
echo ""

sudo nixos-rebuild boot --flake "$HOME/HyprNix/#${profile}"
BUILD_EXIT=$?

git config --global --unset user.name  2>/dev/null || true
git config --global --unset user.email 2>/dev/null || true

echo ""
if [[ $BUILD_EXIT -eq 0 ]]; then
  echo -e "${BOLD}${GREEN}"
  echo "  ╔═══════════════════════════════════════════════════════╗"
  echo "  ║       HyprNix installed successfully!                 ║"
  echo "  ║                                                       ║"
  echo "  ║   Reboot to enter your new system:                    ║"
  echo "  ║     sudo reboot                                       ║"
  echo "  ║                                                       ║"
  echo "  ║   After first login, set your password:               ║"
  echo "  ║     passwd                                            ║"
  echo "  ╚═══════════════════════════════════════════════════════╝"
  echo -e "${NC}"
else
  echo -e "${BOLD}${RED}"
  echo "  ╔═══════════════════════════════════════════════════════╗"
  echo "  ║   Build failed. Check the log for details:            ║"
  echo "  ║   $LOG_FILE"
  echo "  ╚═══════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  exit 1
fi
