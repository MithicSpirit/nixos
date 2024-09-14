{ config, ... }:
let
  home = config.home.homeDirectory;
  xdg-root = "${home}/local";
  files = "${home}/files";
in
{

  xdg = {
    enable = true;

    cacheHome = "${xdg-root}/cache";
    configHome = "${xdg-root}/etc";
    dataHome = "${xdg-root}/share";
    stateHome = "${xdg-root}/state";
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = "${config.xdg.dataHome}/templates";

      documents = "${files}/documents";
      download = "${files}/downloads";
      pictures = "${files}/pictures";
      videos = "${files}/videos";
      music = "${files}/music";
      desktop = "${files}/desktop";
      publicShare = "${files}/public";
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      # TODO
    };

    # More portal options set in particular DE
    portal.enable = true;
    portal.xdgOpenUsePortal = true;
  };

  home.preferXdgDirectories = true;

  home.file =
    let
      symlink = l: { source = config.lib.file.mkOutOfStoreSymlink l; };
    in
    {
      ".local" = symlink xdg-root;
      ".config" = symlink config.xdg.configHome;
      ".cache" = symlink config.xdg.cacheHome;
    };

}
