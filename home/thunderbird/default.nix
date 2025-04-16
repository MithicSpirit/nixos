{ pkgs, ... }:
{

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    nativeMessagingHosts = [ pkgs.thunderbird-external-editor-revived ];

    profiles."mithic" = {
      isDefault = true;
      settings = {
        "mailnews.wraplength" = 70;
        "general.smoothScroll.mouseWheel" = false;
      };
      extraConfig = "";
    };
  };

}
