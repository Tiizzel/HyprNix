#!/usr/bin/env bash

######################################
# Install script for HyprNix
# https://github.com/Tiizzel/HyprNix
######################################

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
BRED='\033[1;31m'
GREEN='\033[0;32m'
BGREEN='\033[1;32m'
YELLOW='\033[0;33m'
BYELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
BMAGENTA='\033[1;35m'
CYAN='\033[0;36m'
BCYAN='\033[1;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m'

# ── Log file ──────────────────────────────────────────────────────────────────
LOG_DIR="$(dirname "$0")"
LOG_FILE="${LOG_DIR}/install_$(date +"%Y-%m-%d_%H-%M-%S").log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

# ── UI Helpers ────────────────────────────────────────────────────────────────

STEP=0

print_banner() {
  clear
  echo
  echo -e "${BMAGENTA}  ╭──────────────────────────────────────────────────────────────────╮${NC}"
  echo -e "${BMAGENTA}  │${NC}                                                                    ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${BCYAN}  ██╗  ██╗██╗   ██╗██████╗ ██████╗ ███╗   ██╗██╗██╗  ██╗       ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${BCYAN}  ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗████╗  ██║██║╚██╗██╔╝       ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${BCYAN}  ███████║ ╚████╔╝ ██████╔╝██████╔╝██╔██╗ ██║██║ ╚███╔╝        ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${BCYAN}  ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║╚██╗██║██║ ██╔██╗        ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${BCYAN}  ██║  ██║   ██║   ██║     ██║  ██║██║ ╚████║██║██╔╝ ██╗       ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${BCYAN}  ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝       ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${NC}                                                                    ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${NC}  ${DIM}NixOS  ·  Hyprland  ·  Stylix  ·  Wayland${NC}                        ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${NC}  ${DIM}https://github.com/Tiizzel/HyprNix${NC}                              ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  │${NC}                                                                    ${BMAGENTA}│${NC}"
  echo -e "${BMAGENTA}  ╰──────────────────────────────────────────────────────────────────╯${NC}"
  echo
}

print_step() {
  STEP=$((STEP + 1))
  echo
  echo -e "  ${BMAGENTA}●${NC} ${WHITE}STEP ${STEP}${NC}  ${BCYAN}${1}${NC}"
  echo -e "  ${DIM}  ──────────────────────────────────────────────────────────────${NC}"
  echo
}

ok()   { echo -e "  ${BGREEN}  ✓${NC}  ${1}"; }
info() { echo -e "  ${BCYAN}  →${NC}  ${DIM}${1}${NC}"; }
warn() { echo -e "  ${BYELLOW}  ⚠${NC}  ${BYELLOW}${1}${NC}"; }
err()  { echo -e "\n  ${BRED}  ✗${NC}  ${BRED}${1}${NC}\n"; }
hint() { echo -e "         ${DIM}${1}${NC}"; }

print_summary() {
  echo
  echo -e "  ${BCYAN}  ╭─────────────────────────────────────────────────────────────╮${NC}"
  echo -e "  ${BCYAN}  │${NC}  ${WHITE}Configuration Summary${NC}                                         ${BCYAN}│${NC}"
  echo -e "  ${BCYAN}  ├─────────────────────────────────────────────────────────────┤${NC}"
  echo -e "  ${BCYAN}  │${NC}"
  echo -e "  ${BCYAN}  │${NC}    ${DIM}Hostname          ${NC}  ${WHITE}${1}${NC}"
  echo -e "  ${BCYAN}  │${NC}    ${DIM}GPU Profile       ${NC}  ${WHITE}${2}${NC}"
  echo -e "  ${BCYAN}  │${NC}    ${DIM}Username          ${NC}  ${WHITE}${3}${NC}"
  echo -e "  ${BCYAN}  │${NC}    ${DIM}Timezone          ${NC}  ${WHITE}${4}${NC}"
  echo -e "  ${BCYAN}  │${NC}    ${DIM}Keyboard Layout   ${NC}  ${WHITE}${5}${NC}"
  echo -e "  ${BCYAN}  │${NC}    ${DIM}Keyboard Variant  ${NC}  ${WHITE}${6:-none}${NC}"
  echo -e "  ${BCYAN}  │${NC}    ${DIM}Console Keymap    ${NC}  ${WHITE}${7:-$5}${NC}"
  echo -e "  ${BCYAN}  │${NC}"
  echo -e "  ${BCYAN}  ╰─────────────────────────────────────────────────────────────╯${NC}"
  echo
}

print_success_banner() {
  echo
  echo -e "  ${BGREEN}  ╔═════════════════════════════════════════════════════════════╗${NC}"
  echo -e "  ${BGREEN}  ║                                                             ║${NC}"
  echo -e "  ${BGREEN}  ║   ✓  HyprNix installed successfully!                       ║${NC}"
  echo -e "  ${BGREEN}  ║                                                             ║${NC}"
  echo -e "  ${BGREEN}  ║   Reboot your system for all changes to take effect.        ║${NC}"
  echo -e "  ${BGREEN}  ║   Run  ${WHITE}reboot${BGREEN}  when you are ready.                         ║${NC}"
  echo -e "  ${BGREEN}  ║                                                             ║${NC}"
  echo -e "  ${BGREEN}  ╚═════════════════════════════════════════════════════════════╝${NC}"
  echo
}

print_failure_banner() {
  echo
  echo -e "  ${BRED}  ╔═════════════════════════════════════════════════════════════╗${NC}"
  echo -e "  ${BRED}  ║                                                             ║${NC}"
  echo -e "  ${BRED}  ║   ✗  HyprNix installation failed.                          ║${NC}"
  echo -e "  ${BRED}  ║                                                             ║${NC}"
  echo -e "  ${BRED}  ║   Check the log for details:                                ║${NC}"
  echo -e "  ${BRED}  ║   ${DIM}${LOG_FILE}${NC}"
  echo -e "  ${BRED}  ║                                                             ║${NC}"
  echo -e "  ${BRED}  ╚═════════════════════════════════════════════════════════════╝${NC}"
  echo
}

# ══════════════════════════════════════════════════════════════════════════════

print_banner

echo -e "  ${WHITE}  Welcome to the HyprNix installer.${NC}"
echo -e "  ${DIM}  Sets up a fully declarative NixOS desktop with Hyprland and Stylix.${NC}"
echo
echo -e "  ${DIM}  Defaults are shown in brackets. Press Enter to accept.${NC}"
echo -e "  ${DIM}  Log: ${LOG_FILE}${NC}"
echo
sleep 1

# ── Step 1: System Requirements ───────────────────────────────────────────────

print_step "Verifying System Requirements"

if ! command -v git &>/dev/null; then
  err "Git is not installed."
  hint "Run:  nix-shell -p git pciutils"
  exit 1
fi
ok "git found"

if ! command -v lspci &>/dev/null; then
  err "pciutils is not installed."
  hint "Run:  nix-shell -p git pciutils"
  exit 1
fi
ok "pciutils found"

if grep -qi nixos /etc/os-release 2>/dev/null; then
  ok "NixOS detected"
else
  err "This does not appear to be NixOS."
  exit 1
fi

cd "$HOME" || exit 1

# ── Step 2: Hostname ──────────────────────────────────────────────────────────

print_step "Hostname Configuration"

warn "Do NOT use 'default' — it is reserved and will be overwritten on updates."
echo
echo -e "  ${DIM}  Examples:  my-desktop  ·  gaming-rig  ·  workstation  ·  nixos-laptop${NC}"
echo
read -rp "    Hostname  [ my-desktop ]:  " hostName
[ -z "$hostName" ] && hostName="my-desktop"

if [ "$hostName" = "default" ]; then
  warn "Cannot use 'default'. Enter a different name:"
  read -rp "    Hostname: " hostName
  if [ -z "$hostName" ] || [ "$hostName" = "default" ]; then
    warn "Falling back to 'my-desktop'."
    hostName="my-desktop"
  fi
fi

echo
ok "Hostname:  ${WHITE}${hostName}${NC}"

# ── Step 3: GPU Profile ───────────────────────────────────────────────────────

print_step "GPU Profile Detection"

DETECTED_PROFILE=""
has_nvidia=false; has_intel=false; has_amd=false; has_vm=false

if lspci | grep -qi 'vga\|3d\|display'; then
  while read -r line; do
    echo "$line" | grep -qi 'nvidia'                            && has_nvidia=true
    echo "$line" | grep -qi 'amd\|ati\|advanced micro devices' && has_amd=true
    echo "$line" | grep -qi 'intel'                            && has_intel=true
    echo "$line" | grep -qi 'virtio\|vmware'                   && has_vm=true
  done < <(lspci | grep -i 'vga\|3d\|display')

  if   $has_vm;                   then DETECTED_PROFILE="vm"
  elif $has_nvidia && $has_amd;   then DETECTED_PROFILE="amd-nvidia-hybrid"
  elif $has_nvidia && $has_intel; then DETECTED_PROFILE="nvidia-laptop"
  elif $has_nvidia;               then DETECTED_PROFILE="nvidia"
  elif $has_amd;                  then DETECTED_PROFILE="amd"
  elif $has_intel;                then DETECTED_PROFILE="intel"
  fi
fi

if [ -n "$DETECTED_PROFILE" ]; then
  profile="$DETECTED_PROFILE"
  ok "Detected:  ${WHITE}${profile}${NC}"
  echo
  read -p "    Is this correct? (Y/N):  " -n 1 -r; echo
  [[ ! $REPLY =~ ^[Yy]$ ]] && profile=""
fi

if [ -z "$profile" ]; then
  echo
  echo -e "  ${DIM}  Available profiles:${NC}"
  echo -e "  ${CYAN}    amd  ·  nvidia  ·  nvidia-laptop  ·  amd-nvidia-hybrid  ·  intel  ·  vm${NC}"
  echo
  read -rp "    GPU Profile  [ amd ]:  " profile
  [ -z "$profile" ] && profile="amd"
fi

ok "GPU profile:  ${WHITE}${profile}${NC}"

# ── Step 4: Existing Installation Check ───────────────────────────────────────

print_step "Checking for Existing Installation"

backupname=$(date +"%Y-%m-%d-%H-%M-%S")
if [ -d "$HOME/HyprNix" ]; then
  echo
  echo -e "  ${BYELLOW}  ╭──────────────────────────────────────────────────────────────╮${NC}"
  echo -e "  ${BYELLOW}  │  ⚠  Existing installation found at ~/HyprNix                 │${NC}"
  echo -e "  ${BYELLOW}  │                                                               │${NC}"
  echo -e "  ${BYELLOW}  │  Continuing will REPLACE your current configuration.          │${NC}"
  echo -e "  ${BYELLOW}  │  A backup will be saved to ~/.config/hyprnix-backups/         │${NC}"
  echo -e "  ${BYELLOW}  ╰──────────────────────────────────────────────────────────────╯${NC}"
  echo
  read -p "    Type REPLACE to continue, or Ctrl+C to cancel:  " confirmation
  if [ "$confirmation" != "REPLACE" ]; then
    echo; ok "Installation cancelled."; echo
    exit 0
  fi
  mkdir -p "$HOME/.config/hyprnix-backups"
  mv "$HOME/HyprNix" "$HOME/.config/hyprnix-backups/$backupname"
  ok "Backup saved to  ${DIM}~/.config/hyprnix-backups/${backupname}${NC}"
else
  ok "No existing installation found."
  echo
  echo -e "  ${DIM}  Welcome — glad to have you here. Enjoy HyprNix!${NC}"
fi

# ── Step 5: Clone Repository ──────────────────────────────────────────────────

print_step "Cloning HyprNix Repository"

info "Cloning from https://github.com/Tiizzel/HyprNix.git"
echo
git clone https://github.com/Tiizzel/HyprNix.git -b main --depth=1 ~/HyprNix
cd ~/HyprNix || exit 1
echo
ok "Repository cloned to ~/HyprNix"

# ── Step 6: Git Configuration ─────────────────────────────────────────────────

print_step "Git Configuration"

installusername="$USER"
info "System user: ${installusername}"
echo
read -rp "    Full name for git commits  [ ${installusername} ]:  " gitUsername
[ -z "$gitUsername" ] && gitUsername="$installusername"

echo
read -rp "    Email for git commits  [ ${installusername}@example.com ]:  " gitEmail
[ -z "$gitEmail" ] && gitEmail="${installusername}@example.com"

echo
ok "Git name:   ${WHITE}${gitUsername}${NC}"
ok "Git email:  ${WHITE}${gitEmail}${NC}"

# ── Step 7: Timezone ──────────────────────────────────────────────────────────

print_step "Timezone"

echo -e "  ${DIM}  Examples:  Europe/Berlin  ·  America/New_York  ·  Asia/Tokyo  ·  UTC${NC}"
echo
read -rp "    Timezone  [ America/New_York ]:  " timezone
[ -z "$timezone" ] && timezone="America/New_York"
echo
ok "Timezone:  ${WHITE}${timezone}${NC}"

# ── Step 8: Keyboard ──────────────────────────────────────────────────────────

print_step "Keyboard Layout"

echo -e "  ${DIM}  Examples:  us  ·  de  ·  fr  ·  uk  ·  es  ·  it  ·  ru  ·  dvorak${NC}"
echo
read -rp "    Layout  [ us ]:  " keyboardLayout
[ -z "$keyboardLayout" ] && keyboardLayout="us"

echo
variant_suggestion=""
case "$keyboardLayout" in
  dvorak | colemak | workman | intl | us-intl) variant_suggestion="$keyboardLayout" ;;
esac
read -rp "    Variant (leave blank for none)  [ ${variant_suggestion:-none} ]:  " keyboardVariant
keyboardVariant="${keyboardVariant:-$variant_suggestion}"

keyboardLayout=$(echo "$keyboardLayout" | tr '[:upper:]' '[:lower:]')
keyboardVariant=$(echo "$keyboardVariant" | tr '[:upper:]' '[:lower:]')

case "$keyboardLayout" in
  us-intl | intl)
    keyboardLayout="us"
    [ -z "$keyboardVariant" ] && keyboardVariant="intl"
    ;;
  dvorak | colemak | workman)
    [ -z "$keyboardVariant" ] && keyboardVariant="$keyboardLayout"
    keyboardLayout="us"
    ;;
esac
if [[ "$keyboardVariant" =~ ^(us|br|de|fr|es|it|ru|uk)$ ]]; then
  keyboardLayout="$keyboardVariant"
  keyboardVariant=""
fi

echo
ok "Layout:   ${WHITE}${keyboardLayout}${NC}"
ok "Variant:  ${WHITE}${keyboardVariant:-none}${NC}"

print_step "Console Keymap"

echo -e "  ${DIM}  Usually matches your keyboard layout.${NC}"
echo
defaultConsoleKeyMap="$keyboardLayout"
[[ ! "$keyboardLayout" =~ ^(us|uk|de|fr|es|it|ru|us-intl|dvorak)$ ]] && defaultConsoleKeyMap="us"
read -rp "    Console keymap  [ ${defaultConsoleKeyMap} ]:  " consoleKeyMap
[ -z "$consoleKeyMap" ] && consoleKeyMap="$defaultConsoleKeyMap"
echo
ok "Console keymap:  ${WHITE}${consoleKeyMap}${NC}"

# ── Summary & Confirmation ────────────────────────────────────────────────────

print_summary "$hostName" "$profile" "$installusername" "$timezone" "$keyboardLayout" "$keyboardVariant" "$consoleKeyMap"

echo -e "  ${BYELLOW}  Please review your settings above before continuing.${NC}"
echo
read -p "    Continue with installation? (Y/N):  " -n 1 -r; echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo; err "Installation cancelled."; echo
  exit 1
fi

echo
ok "Configuration confirmed. Starting installation…"
echo

# ── Step 9: Apply Configuration ───────────────────────────────────────────────

print_step "Writing Configuration Files"

info "Creating host directory:  hosts/${hostName}"
mkdir -p hosts/"$hostName"
cp hosts/default/*.nix hosts/"$hostName"
ok "Host directory created"

info "Updating flake.nix"
cp ./flake.nix ./flake.nix.bak
sed -i 's|^[[:space:]]*host[[:space:]]*=[[:space:]]*"[^"]*"|    host = "'"$hostName"'"|'             ./flake.nix.bak
sed -i 's|^[[:space:]]*profile[[:space:]]*=[[:space:]]*"[^"]*";|    profile = "'"$profile"'";|'       ./flake.nix.bak
sed -i 's|^[[:space:]]*username[[:space:]]*=[[:space:]]*"[^"]*";|    username = "'"$installusername"'";|' ./flake.nix.bak
cp ./flake.nix.bak ./flake.nix
rm ./flake.nix.bak
ok "flake.nix updated"

info "Updating timezone in modules/core/system.nix"
cp ./modules/core/system.nix ./modules/core/system.nix.bak
awk -v newtz="$timezone" \
  '/^  time\.timeZone = / { sub(/"[^"]*"/, "\"" newtz "\"") } { print }' \
  ./modules/core/system.nix.bak > ./modules/core/system.nix
rm ./modules/core/system.nix.bak
ok "Timezone updated"

info "Updating hosts/${hostName}/variables.nix"
cp ./hosts/"$hostName"/variables.nix ./hosts/"$hostName"/variables.nix.bak
awk -v v_user="$gitUsername" \
    -v v_email="$gitEmail" \
    -v v_kb="$keyboardLayout" \
    -v v_kv="$keyboardVariant" \
    -v v_ckm="$consoleKeyMap" '
  /^  gitUsername = /     { sub(/"[^"]*"/, "\"" v_user  "\"") }
  /^  gitEmail = /        { sub(/"[^"]*"/, "\"" v_email "\"") }
  /^  keyboardLayout = /  { sub(/"[^"]*"/, "\"" v_kb    "\"") }
  /^  keyboardVariant = / { sub(/"[^"]*"/, "\"" v_kv    "\"") }
  /^  consoleKeyMap = /   { sub(/"[^"]*"/, "\"" v_ckm   "\"") }
  { print }
' ./hosts/"$hostName"/variables.nix.bak > ./hosts/"$hostName"/variables.nix
rm ./hosts/"$hostName"/variables.nix.bak
ok "variables.nix updated"

info "Staging configuration with git"
git config --global user.name "$gitUsername"
git config --global user.email "$gitEmail"
git add .
git config --global --unset-all user.name
git config --global --unset-all user.email
ok "Changes staged"

# ── Step 10: Hardware Configuration ──────────────────────────────────────────

print_step "Generating Hardware Configuration"

info "Running nixos-generate-config  (any /bin errors are harmless)"
echo
sudo nixos-generate-config --show-hardware-config > ./hosts/"$hostName"/hardware.nix
echo
ok "Hardware config saved to  ${DIM}hosts/${hostName}/hardware.nix${NC}"

# ── Step 11: NixOS Build ──────────────────────────────────────────────────────

print_step "NixOS Build"

echo -e "  ${DIM}  Profile:  ${WHITE}${profile}${NC}"
echo -e "  ${DIM}  Command:  ${CYAN}sudo nixos-rebuild boot --flake ~/HyprNix/#${profile}${NC}"
echo
read -p "    Ready to build? (Y/N):  " -n 1 -r; echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo
  warn "Build skipped. To build manually later:"
  hint "cd ~/HyprNix && sudo nixos-rebuild boot --flake .#${profile}"
  echo
  exit 1
fi

echo
NIX_CONFIG="experimental-features = nix-command flakes" \
  sudo nixos-rebuild boot --flake ~/HyprNix/#"${profile}"

if [ $? -eq 0 ]; then
  print_success_banner
else
  print_failure_banner
fi
