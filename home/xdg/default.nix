{ config, ... }:
let home = config.home.homeDirectory;
in {

  xdg = {
    enable = true;

    cacheHome = "${home}/.local/cache";
    configHome = "${home}/.local/etc";
    dataHome = "${home}/.local/share";
    stateHome = "${home}/.local/state";
    userDirs = let documents = config.xdg.userDirs.documents;
    in {
      enable = true;
      createDirectories = true;
      templates = "${config.xdg.dataHome}/templates";

      documents = "${home}/documents";
      download = "${documents}/downloads";
      pictures = "${documents}/pictures";
      videos = "${documents}/videos";
      music = "${documents}/music";
      desktop = "${documents}/desktop";
      publicShare = "${documents}/public";
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

}
