{ pkgs, ... }:
{

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    nativeMessagingHosts = [ pkgs.thunderbird-external-editor-revived ];

    profiles."mithic" = {
      isDefault = true;
      settings = { };
      extraConfig = "";
    };
  };

}
