{ pkgs, ...}:

{
  home-manager.users.nekifirus.home.packages = with pkgs; [
    dust
    eza
    fastfetch
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
      ls = "eza --group-directories-first";
      initflake = "nix flake new -t github:nix-community/nix-direnv .";
      start-exwm = "startx $HOME/.exwm-xinitrc -- :2 vt4";
    };
    shellOptions = [ "histappend"  "checkwinsize" "checkjobs"];
    # bashrcExtra = ''
    #   PS1="\W: $  "
    # '';
    initExtra = "fastfetch";
  };
}
