{ config, pkgs, ... }: {

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    profiles."mithic" = {

      settings = { };
      bookmarks = [ ];
      extraConfig = "";
      userChrome = "";
      userContent = "";

    };
  };

  home.file = let
    path = if pkgs.stdenv.hostPlatform.isDarwin then
      "TODO"
    else
      ".librewolf/${config.programs.firefox.profiles."mithic".path}";
  in {
    "${path}/chrome".source = pkgs.firefox-ui-fix;
    "${path}/user.js".source =
      config.lib.mkOutOfStoreSymlink "./chrome/user.js";
  };

}
