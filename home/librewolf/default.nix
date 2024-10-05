{ config, pkgs, ... }:
{

  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [ pkgs.bitwarden-desktop ];

    profiles."mithic" =
      let
        force = pkgs.lib.mkForce;
      in
      {
        # must be empty for chrome stuff below to work
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
        + (if pkgs.stdenv.hostPlatform.isDarwin then "/Profiles/" else "/")
        + self.profiles."mithic".path;
      ui-fix = pkgs.firefox-ui-fix.overrideAttrs {
        patchPhase = "patch -Np1 <${./chrome.patch}";
      };
      chrome = ui-fix + "/chrome";
    in
    {
      "${path}/chrome".source = chrome;
      "${path}/user.js".source = chrome + "/user.js";
    };

}
