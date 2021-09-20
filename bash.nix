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
    direnv
    nix-direnv
  ];
  home-manager.users.nekifirus.programs.bash = {
    enable = true;
    historySize = 10000;
    historyControl = ["erasedups"];
    historyIgnore = ["ls" "cd" "exit"];
    sessionVariables = {};
    shellAliases = {
      ls = "exa --group-directories-first";
    };
    shellOptions = [ "histappend"  "checkwinsize" "checkjobs"];
    bashrcExtra = ''
      PS1="\W: $  "
      eval "$(direnv hook bash)"
    '';
    initExtra = "neofetch";
  };
}
