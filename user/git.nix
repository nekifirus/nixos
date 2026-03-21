{ pkgs, ...}:

{
  home-manager.users.nekifirus.home.packages = with pkgs; [
    git
    git-extras
    gh
    git-crypt
  ];

  home-manager.users.nekifirus.programs.git = {
    enable = true;
    ignores = ["*~" "*.swp" ".direnvrc" ".envrc" "shell.nix"];
    signing = {
      signByDefault = true;
      key = "A74D 85A6 0235 90FA 2ADF  E904 CA06 0E46 3B9E 220B";
    };
    settings = {
      user.name = "Nikita Mistiukov";
      user.email = "nekifirus@gmail.com";
      core.editor = "emacsclient -c";
    };
  };

  home-manager.users.nekifirus.services.git-sync = {
    enable = true;
    repositories = {
      org = {
        path = "/home/nekifirus/org/";
        uri = "ssh://git@git.sr.ht:~nekifirus/org";
        interval = 1000;
      };
    };
  };
}
