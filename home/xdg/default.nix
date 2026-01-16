{
  config,
  pkgs,
  ...
}: let
  home = config.home.homeDirectory;
  xdg = config.xdg;
  files = "${home}/files";
in {
  imports = [./trash.nix];

  xdg = {
    enable = true;

    cacheHome = "${home}/.cache";
    configHome = "${home}/.config";
    dataHome = "${home}/.local/share";
    stateHome = "${home}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = "${xdg.dataHome}/templates";

      documents = "${files}/documents";
      download = "${files}/downloads";
      pictures = "${files}/pictures";
      videos = "${files}/videos";
      music = "${files}/music";
      desktop = "${files}/desktop";
      publicShare = "${files}/public";
    };

    mime.enable = true;
    mimeApps.enable = true;

    # More portal options set in particular DE
    portal.enable = true;
    portal.xdgOpenUsePortal = true;

    terminal-exec.enable = true;
  };

  home.preferXdgDirectories = true;

  home.file."local" = {
    source = pkgs.runCommandLocal "xdg-local" {} ''
      mkdir "$out"
      ln -s "${xdg.cacheHome}" "$out/cache"
      ln -s "${xdg.configHome}" "$out/etc"
      ln -s "${xdg.dataHome}" "$out/share"
      ln -s "${xdg.stateHome}" "$out/state"
    '';
  };
}
