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
    };
  };
}
