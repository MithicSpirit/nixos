{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        addKeysToAgent = "ask";
      };

      "github.com" = {
        user = "git";
      };

      "terminal.shop" = {
        extraOptions = {
          PreferredAuthentications = "keyboard-interactive";
        };
      };
    };
  };
}
