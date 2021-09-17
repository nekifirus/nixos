{ pkgs, ...}:

{
  home.packages = with pkgs; [ git gitAndTools.git-extras ];

  programs.git = {
    enable = true;
    userName = "Nikita Mistyukov";
    userEmail = "nekifirus@gmail.com";
    ignores = ["*~" "*.swp" ".direnvrc" ".envrc" "shell.nix"];
    signing = {
      signByDefault = true;
      key = "nekifirus@gmail.com";
    };
    extraConfig = {
      core = { editor = "emacsclient -c"; };
    };
  };
}
