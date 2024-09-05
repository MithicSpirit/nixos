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
        search = {
          engines =
            let
              day = 24 * 60 * 60 * 1000;
            in
            {
              "Startpage" = {
                urls = [
                  {
                    template = "https://www.startpage.com/sp/search";
                    params = [
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                iconUpdateURL = "https://www.startpage.com/favicon.ico";
                updateInterval = day;
                metaData.hideOneOffButton = true;
              };

              # TODO: figure out hideOneOffButton
              "DuckDuckGo".metaData.hideOneOffButton = true;
              "Google".metaData.hidden = true;
              "Bing".metaData.hidden = true;
              "Wikipedia (en)".metaData.hidden = true;
            };
          default = "Startpage";
          privateDefault = "DuckDuckGo";
          order = [
            "Startpage"
            "DuckDuckGo"
          ];
          force = true;
        };

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
