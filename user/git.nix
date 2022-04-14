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

  home-manager.users.nekifirus.services.git-sync = {
    enable = true;
    repositories = {
      org = {
        path = "/home/nekifirus/org/";
        uri = "ssh://git@github.com:nekifirus/my-org.git";
        interval = 1000;
      };
    };
  };
}
