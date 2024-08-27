{ config, pkgs, ... }:
{

  programs.librewolf = {
    enable = true;
    profiles."mithic" =
      let
        force = pkgs.lib.mkForce;
      in
      {

        # must be empty for stuff below to work
        settings = force { };
        extraConfig = force "";
        bookmarks = force [ ];
        userChrome = force "";
        userContent = force "";

      };
  };

  home.file =
    let
      self = config.programs.librewolf;
      path =
        self.configPath
        ++ (if pkgs.stdenv.hostPlatform.isDarwin then "/Profiles/" else "/")
        ++ self.profiles."mithic".path;
    in
    {
      "${path}/chrome".source = pkgs.firefox-ui-fix;
      "${path}/user.js".source = config.lib.mkOutOfStoreSymlink "./chrome/user.js";
    };

}
