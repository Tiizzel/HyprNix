{pkgs, ...}: {
  home.packages = with pkgs; [
    code-cursor
    windsurf
    claude-code
    gemini-cli
  ];

  programs.zed-editor = {
    enable = true;
  };
}
