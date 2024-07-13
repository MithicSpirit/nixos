{ ... }: {

  programs.ssh = {

    enable = true;
    addKeysToAgent = "ask";

    matchBlocks = {
      "github.com" = {
        user = "git";
      };
    };

  };

}
