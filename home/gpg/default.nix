{ config, pkgs, ... }: {

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = false;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;

    grabKeyboardAndMouse = true;
    pinentryPackage = pkgs.pinentry-bemenu;

    defaultCacheTtl = 15 * 60;
    defaultCacheTtlSsh = 30 * 60;
    maxCacheTtl = 60 * 60;
    maxCacheTtlSsh = 2 * 60 * 60;
    extraConfig = ''
      pinentry-timeout ${builtins.toString (6 * 60 * 60)}
      no-allow-external-cache
      allow-emacs-pinentry
    '';
  };

}
