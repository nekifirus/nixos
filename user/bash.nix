{ pkgs, ...}:

{
  home-manager.users.nekifirus.home.packages = with pkgs; [
    du-dust
    exa
    neofetch
    gnutar
    htop
    wget
    vim
  ];
  home-manager.users.nekifirus.programs.bash = {
    enable = true;
    historySize = 10000;
    historyControl = ["erasedups"];
    historyIgnore = ["ls" "cd" "exit"];
    sessionVariables = {};
    shellAliases = {
      ls = "exa --group-directories-first";
      initflake = "nix flake new -t github:nix-community/nix-direnv .";
    };
    shellOptions = [ "histappend"  "checkwinsize" "checkjobs"];
    # bashrcExtra = ''
    #   PS1="\W: $  "
    # '';
    initExtra = "neofetch";
  };
}
