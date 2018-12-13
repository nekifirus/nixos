{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.fortune
    pkgs.direnv
  ];

  programs.emacs = {
    enable = true;
    extraPackages = ekpgs: [
      ekpgs.nix-mode
      ekpgs.magit
    ];
  };

  programs.firefox = {
    enable = true;
    enableIcedTea = true;
  };

  programs.bash = {
    enable = true;
    historySize = 10000;
    historyControl = ["erasedups"];
    historyIgnore = ["ls" "cd" "exit"];
    sessionVariables = {};
    shellAliases = {};
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.git = {
    enable = true;
    userName = "Nikita Mistyukov";
    userEmail = "nekifirus@gmail.com";
    ignores = ["*~" "*.swp" ".direnvrc"];
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
