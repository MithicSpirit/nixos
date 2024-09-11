{ config, ... }:
{

  xdg =
    let
      home = config.home.homeDirectory;
      files = "${home}/files";
    in
    {
      enable = true;

      cacheHome = "${home}/.local/cache";
      configHome = "${home}/.local/etc";
      dataHome = "${home}/.local/share";
      stateHome = "${home}/.local/state";
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

}
