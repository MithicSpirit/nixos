{ pkgs, lib, ... }:
{

  home.sessionPath = [ "${./bin}" ];
  # TODO: improve menu-browser and turn it into a standalone package

  home.sessionVariables."BROWSER" = "menu-browser";
  xdg =
    let
      mimeTypes = [
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ];
    in
    {
      desktopEntries."menu-browser" = {
        name = "Menu Browser";
        genericName = "Web Browser";
        exec = "${./bin/menu-browser} %U";
        comment = "Choose web browser to launch";
        terminal = false;
        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = mimeTypes;
        settings.Keywords = "Internet;WWW;Browser;Web;Explorer";
      };
      mimeApps.defaultApplications = lib.genAttrs mimeTypes (
        _name: "menu-browser.desktop"
      );
    };

  # dependencies
  home.packages = with pkgs; [
    libnotify
    xdg-utils
    wl-clipboard
    cliphist
    bemenu
  ];

}
