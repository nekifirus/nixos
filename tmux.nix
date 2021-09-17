{ pkgs, ...}:

{
  programs.tmux = {
    enable = true;
    tmuxp.enable = true;
    extraConfig = ''
      set -g mouse on
    '';
    plugins =  with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.yank
      tmuxPlugins.urlview
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '15' # minutes
                set -g status-right '#{continuum_status}'
              '';
      }
    ];
  };
}
