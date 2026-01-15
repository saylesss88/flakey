{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = "autoload -U compinit && compinit";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      package = pkgs.oh-my-zsh;
      enable = true;
      plugins = [
        "git"
        "sudo"
        "rust"
        "fzf"
      ];
    };
    profileExtra = ''
      # if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #  exec Hyprland
      # fi
      # autoload -U compinit
      # compinit
      setopt correct                                                  # Auto correct mistakes
      setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
      setopt nocaseglob                                               # Case insensitive globbing
      setopt rcexpandparam                                            # Array expension with parameters
      setopt nocheckjobs                                              # Don't warn about running processes when exiting
      setopt numericglobsort                                          # Sort filenames numerically when it makes sense
      setopt nobeep                                                   # No beep
      setopt appendhistory                                            # Immediately append history instead of overwriting
      setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
      setopt autocd                                                   # if only directory path is entered, cd there.
      setopt auto_pushd
      setopt pushd_ignore_dups
      setopt pushdminus
    '';
    initContent = ''
                fastfetch
                if [ -f $HOME/.zshrc-personal ]; then
                  source $HOME/.zshrc-personal
                fi
                source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
                source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
                source <(jj util completion zsh)
                # source <(tailscale completion zsh)
                eval "$(${pkgs.coreutils}/bin/dircolors -b)"
                eval "$(fzf --zsh)"


                # Allow Ctrl-z to toggle between suspend and resume
               function Resume {
                 fg
                 zle push-input
                 BUFFER=""
                 zle accept-line
               }
               zle -N Resume
               bindkey "^Z" Resume

               fr() {
                 run0 nixos-rebuild switch --flake "/home/$USER/flake3#"$(hostname)
               }


                eval "$(zoxide init zsh)"
                eval "$(mcfly init zsh)"
                # eval "$(direnv hook zsh)"

       # if [ -n "$TTY" ]; then
       #   export GPG_TTY=$(tty)
       # else
       #   export GPG_TTY="$TTY"
       # fi
       export WLR_NO_HARDWARE_CURSORS=1

      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent

         export MANPAGER='nvim +Man!'
                export MCFLY_KEY_SCHEME=vim
                export MCFLY_FUZZY=2
                export MCFLY_RESULTS=50
                export MCFLY_RESULTS_SORT=LAST_RUN
                export MCFLY_INTERFACE_VIEW=BOTTOM
                export TERM=xterm-256color
                export EDITOR=hx
                export VISUAL=hx
                export PATH=$HOME/.cargo/bin:$PATH
                export ZSH_CUSTOM=/nix/store/0ajaww0dwlfj6sd9drslzjpw2grhv177-oh-my-zsh-2024-10-01/share/oh-my-zsh/plugins
                export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
                export FZF_DEFAULT_OPTS='-i --height=50%'
                # Print tree structure in the preview window
               export FZF_ALT_C_OPTS="
                 --walker-skip .git,node_modules,target
                 --preview 'tree -C {}'"

                # CTRL-Y to copy the command into clipboard using pbcopy
               export FZF_CTRL_R_OPTS="
                 --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
                 --color header:italic
                 --header 'Press CTRL-Y to copy command into clipboard'"
                # export HELIX_RUNTIME=~/src/helix/runtime
                # export NIX_PATH="$NIX_PATH:my-flake=flake:/home/jr/flake"
                # Makes your flake accessible and importable within Nix expressions
                # using the alias `flaked`
                export NIX_PATH="$NIX_PATH:flake=flake:/home/jr/flake"
    '';
    shellAliases = {
      sv = "sudo nvim";
      # fr = "nh os switch --hostname magic /home/jr/flake";
      # fr = "run0 nixos-rebuild switch --flake /home/jr/flake";
      ft = "run0 nixos-rebuild switch --flake /home/jr/flake";
      # ft = "nh os test --hostname magic /home/jr/flake"; # dont save generation to boot menu
      fu = "nh os switch --hostname magic --update /home/jr/flake";
      rebuild = "/home/jr/scripts/performance_hook.sh";
      ncg = "nix-collect-garbage --delete-older-than 3d && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      nc = "nix flake check";
      nt = "nix flake test";
      opts = "man home-configuration.nix";
      zd = "zeditor";
      lg = "lazygit";
      ljj = "lazyjj";
      ip = "ip -color";
      tarnow = "tar -acf ";
      untar = "tar -zxvf ";
      egrep = "grep -E --color=auto";
      fgrep = "grep -F --color=auto";
      nv = "cd ~/flakes && nix run .";
      grep = "grep --color=auto";
      vdir = "vdir --color=auto";
      dir = "dir --color=auto";
      v = "nvim";
      vz = "NVIM_APPNAME='lazy' nvim";
      vk = "NVIM_APPNAME='kick' nvim";
      vc = "nix run /home/jr/flake/modules/nixCats";
      cat = "bat --style snip --style changes --style header";
      l = "eza -lh --icons=auto"; # long list
      # ls = "eza --icons=auto --group-directories-first --icons"; # short list
      ls = "ls --color=tty";
      ll = "eza -lh --icons --grid --group-directories-first --icons";
      la = "eza -lah --icons --grid --group-directories-first --icons";
      ld = "eza -lhD --icons=auto";
      lt = "eza --icons=auto --tree"; # list folder as tree
      rbs = "echo starting performance mode && sudo cpupower frequency-set -g performance && nh os switch --hostname magic --update /home/jr/flakes"; # Amd pstate governor
      powersave = "sudo cpupower frequency-set -g powersave"; # Amd pstate governor
      # Get the error messages from journalctl
      jctl = "journalctl -p 3 -xb";
      mkdir = "mkdir -p";
      y = "yazi";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      keys = "ghostty +list-keybinds";
      cr = "cargo run";
      cb = "cargo build";
      ct = "cargo test";
      cc = "cargo check";
      rr = "rustc";
      rc = "rustc --explain";
      cn = "cargo new";
      cC = "cargo clippy";
      cP = "cargo clippy -- -W clippy::all -W clippy::pedantic";
      cf = "cargo rustfmt";
      repl = "evcxr";
      fz = "fzf --bind 'enter:become(hx {}'";
      hz = "hx $(fzf)";
      c = "__zoxide_zi";
      psc = "ps xawf -eo pid,user,cgroup,args";
      j = "just";
      sudo = "run0";
    };
  };
}
