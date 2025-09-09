{
  config,
  pkgs,
  lib,
  ...
}:
let
  home = config.home.homeDirectory;
  xdg = config.xdg;
  files = "${home}/files";
in
{

  imports = [ ./trash.nix ];

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
    mimeApps = {
      enable = true;
      # TODO: swayimg module
      defaultApplications = lib.genAttrs [
        "image/avif"
        "image/bmp"
        "image/gif"
        "image/heif"
        "image/jpeg"
        "image/jpg"
        "image/pbm"
        "image/pjpeg"
        "image/png"
        "image/svg+xml"
        "image/tiff"
        "image/webp"
        "image/x-bmp"
        "image/x-exr"
        "image/x-png"
        "image/x-portable-anymap"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
        "image/x-targa"
        "image/x-tga"
      ] (_: "swayimg.desktop");
    };

    # More portal options set in particular DE
    portal.enable = true;
    portal.xdgOpenUsePortal = true;

    terminal-exec.enable = true;
  };

  home.preferXdgDirectories = true;

  home.file."local" = {
    source = pkgs.runCommandLocal "xdg-local" { } ''
      mkdir "$out"
      ln -s "${xdg.cacheHome}" "$out/cache"
      ln -s "${xdg.configHome}" "$out/etc"
      ln -s "${xdg.dataHome}" "$out/share"
      ln -s "${xdg.stateHome}" "$out/state"
    '';
  };

}
