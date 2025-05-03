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
        "mail.serverDefaultStoreContractID" = "@mozilla.org/msgstore/maildirstore;1";
      };
      extraConfig = "";
    };
  };

}
