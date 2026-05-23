{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        addKeysToAgent = "ask";
      };

      "github.com" = {
        user = "git";
      };
    };
  };
}
