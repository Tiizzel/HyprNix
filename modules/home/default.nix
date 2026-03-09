{host, ...}: let
  vars = import ../../hosts/${host}/variables.nix;
  inherit
    (vars)
    alacrittyEnable
    barChoice
    ghosttyEnable
    tmuxEnable
    waybarChoice
    weztermEnable
    vscodeEnable
    helixEnable
    doomEmacsEnable
    antigravityEnable
    ;
  # Select bar module based on barChoice
  barModule =
    if barChoice == "noctalia"
    then ./noctalia-shell/default.nix #./noctalia.nix
    else waybarChoice;
in {
  imports =
    [
      ./amfora.nix
      ./bash.nix
      ./bashrc-personal.nix
      ./cli/atuin.nix
      ./cli/bat.nix
      ./cli/btop.nix
      ./cli/bottom.nix
      ./cli/cava.nix
      ./cli/fzf.nix
      ./cli/gh.nix
      ./cli/git.nix
      ./cli/htop.nix
      ./cli/lazygit.nix
      ./cli/pay-respects.nix
      #./editors/nvf.nix
      ./editors/nixvim.nix
      ./editors/nano.nix
      ./emoji.nix
      ./eza.nix
      ./fastfetch
      ./firefox.nix
      ./gtk.nix
      ./home-packages.nix
      ./hyprland
      ./hytale.nix
      ./terminals/kitty.nix
      ./obs-studio.nix
      ./overview.nix
      ./python.nix
      ./rofi
      ./qt.nix
      ./scripts
      ./scripts/gemini-cli.nix
      ./stylix.nix
      ./swappy.nix
      ./swaync.nix
      ./tealdeer.nix
      ./virtmanager.nix
      barModule
      ./wlogout
      ./xdg.nix
      ./yazi
      ./zen-browser.nix
      ./zoxide.nix
      ./zsh
    ]
    ++ (
      if helixEnable
      then [./editors/evil-helix.nix]
      else []
    )
    ++ (
      if vscodeEnable
      then [./editors/vscode.nix]
      else []
    )
    ++ (
      if antigravityEnable
      then [./editors/antigravity.nix]
      else []
    )
    ++ (
      if doomEmacsEnable
      then [
        ./editors/doom-emacs-install.nix
        ./editors/doom-emacs.nix
      ]
      else []
    )
    ++ (
      if weztermEnable
      then [./terminals/wezterm.nix]
      else []
    )
    ++ (
      if ghosttyEnable
      then [./terminals/ghostty.nix]
      else []
    )
    ++ (
      if tmuxEnable
      then [./terminals/tmux.nix]
      else []
    )
    ++ (
      if alacrittyEnable
      then [./terminals/alacritty.nix]
      else []
    );
}
