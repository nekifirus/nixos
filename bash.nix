{ pkgs, ...}:

{
  programs.bash = {
    enable = true;
    historySize = 10000;
    historyControl = ["erasedups"];
    historyIgnore = ["ls" "cd" "exit"];
    sessionVariables = {};
    shellAliases = {
      ls = "exa --group-directories-first";
    };
    bashrcExtra = ''
      PS1="\W: $  "
      eval "$(direnv hook bash)"
      neofetch
    '';
  };
}
