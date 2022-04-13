{ pkgs, ...}:

{
  home-manager.users.nekifirus.home.packages = with pkgs; [
    git
    gitAndTools.git-extras
    gitAndTools.gh
    git-crypt
  ];

  home-manager.users.nekifirus.programs.git = {
    enable = true;
    userName = "Nikita Mistyukov";
    userEmail = "nekifirus@gmail.com";
    ignores = ["*~" "*.swp" ".direnvrc" ".envrc" "shell.nix"];
    signing = {
      signByDefault = true;
      key = "Nikita Mistyukov <nekifirus@gmail.com>";
    };
    extraConfig = {
      core = { editor = "emacsclient -c"; };
    };
  };
}
