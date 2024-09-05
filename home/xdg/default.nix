{ config, ... }:
let
  home = config.home.homeDirectory;
  dataDir = f: "${config.xdg.dataHome}/${f}";
  configDir = f: "${config.xdg.configHome}/${f}";
in
{

  xdg = {
    enable = true;

    cacheHome = "${home}/.local/cache";
    configHome = "${home}/.local/etc";
    dataHome = "${home}/.local/share";
    stateHome = "${home}/.local/state";
    userDirs =
      let
        parent = "${home}/files";
      in
      {
        enable = true;
        createDirectories = true;
        templates = "${config.xdg.dataHome}/templates";

        documents = "${parent}/documents";
        download = "${parent}/downloads";
        pictures = "${parent}/pictures";
        videos = "${parent}/videos";
        music = "${parent}/music";
        desktop = "${parent}/desktop";
        publicShare = "${parent}/public";
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

  home.sessionVariables = {
    "RUSTUP_HOME" = dataDir "rustup";
    "ELAN_HOME" = dataDir "elan";
    "STACK_XDG" = "1";
  };

  gtk.gtk2.configLocation = configDir "gtk-2.0/gtkrc";
  xresources.path = configDir "Xresources";

}
