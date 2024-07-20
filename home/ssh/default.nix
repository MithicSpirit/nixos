{ ... }: {

  programs.ssh = {

    enable = true;
    addKeysToAgent = "ask";

    matchBlocks = {
      "github.com" = { user = "git"; };
      "terminal.shop" = {
        extraOptions = { PreferredAuthentications = "keyboard-interactive"; };
      };
    };

  };

}
