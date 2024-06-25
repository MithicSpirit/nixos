{ ... }: {

  programs.ssh = {

    enable = true;
    addKeysToAgent = "ask";

    matchBlocks = {
      github = {
        hostname = "github.com";
        user = "git";
      };
    };

  };

}
