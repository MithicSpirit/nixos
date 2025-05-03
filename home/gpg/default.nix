{ config, pkgs, ... }:
{

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = false;
  };

  services.gpg-agent =
    let
      hours = h: h * 60 * 60;
    in
    {
      enable = true;
      enableSshSupport = true;

      grabKeyboardAndMouse = true;
      pinentry.package = pkgs.pinentry-qt;

      defaultCacheTtl = hours 1;
      defaultCacheTtlSsh = hours 1;
      maxCacheTtl = hours 3;
      maxCacheTtlSsh = hours 3;
      extraConfig = ''
        pinentry-timeout ${builtins.toString (hours 24)}
        no-allow-external-cache
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };

}
