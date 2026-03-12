{inputs, ...}: {
  nixpkgs.overlays = [
    # Provide pkgs.google-antigravity via antigravity-nix overlay
    inputs.antigravity-nix.overlays.default
    inputs.nix-cachyos-kernel.overlays.default

    (final: prev: {
      distro-grub-themes = prev.stdenv.mkDerivation {
        pname = "distro-grub-themes";
        version = "3.2";
        src = prev.fetchFromGitHub {
          owner = "AdisonCavani";
          repo = "distro-grub-themes";
          rev = "v3.2";
          hash = "sha256-U5QfwXn4WyCXvv6A/CYv9IkR/uDx4xfdSgbXDl5bp9M=";
        };
        installPhase = ''
          mkdir -p $out
          tar -xf themes/nixos.tar -C $out
        '';
      };
    })
  ];
}
