{ config, ... }: {
  programs.git = {
    enable = true;

    userName = "MithicSpirit";
    userEmail = "rpc01234@gmail.com";
    extraConfig = {
      # basic
      init.defaultBranch = "main";
      commit.verbose = true;
      advice.addEmptyPathspec = false;
      # branches and remotes
      branch = {
        autoSetupMerge = "simple";
        sort = "-commiterdate";
      };
      fetch = {
        all = true;
        parallel = 0;
        prune = true;
        fsckObjects = true;
      };
      pull.ff = "only";
      push = {
        autoSetupRemote = true;
        default = "simple";
        followTags = true;
      };
      transfer.fsckObjects = true;
      receive.fsckObjects = true;
      # diffs and conflicts
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
        colorMovedWS = "allow-indentation-change";
        context = 6;
        tool = "nvimdiff";
      };
      merge = {
        conflictStyle = "diff3";
        tool = "nvimdiff2";
      };
      rebase = {
        autoSquash = true;
        missingCommitsCheck = "warn";
      };
      rerere.enabled = true;
      # misc
      sendemail = {
        confirm = "always";
        annotate = true;
        multiEdit = true;
        smtpEncryption = "tls";
        smtpUser = config.programs.git.userEmail;
        smtpServer = "smtp.gmail.com";
        smtpServerPort = 587;
      };
      gc.autoDetach = true;
    };
    signing.signByDefault = true;
    signing.key = null;
    aliases = { hub = "!gh"; };

    ignores = [ "/compile_commands.json" "/venv/**" "/.venv/**" "flycheck_*" ];

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "ansi";
        right-arrow = "->";
        line-numbers-left-format = "{nm:^4}|";
        width = 80;
        # colormoved support
        map-styles = with builtins; let
          table = {
            "bold purple" = ''syntax "#380f2e"'';
            "bold blue" = ''syntax "#2c1349"'';
            "bold cyan" = ''syntax "#0d3a36"'';
            "bold yellow" = ''syntax "#273414"'';
          };
        in foldl' (acc: elem:
          let new = "${elem} => ${table.${elem}}";
          in if acc == "" then new else "${acc}, ${new}") "" (attrNames table);
        # map-styles = ''
        #   bold purple => syntax "#380f2e", \
        #   bold blue => syntax "#2c1349", \
        #   bold cyan => syntax "#0d3a36", \
        #   bold yellow => syntax "#273414"
        # '';
        # TODO: ^ check if works
      };
    };
  };
}
