{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    tealdeer # (tldr in rust)
  ];

  documentation.man = {
    enable = true;
    cache.enable = true;
    cache.generateAtRuntime = true;

    man-db.enable = true;
    mandoc.enable = false;
  };

  documentation.dev.enable = true;
  documentation.nixos.enable = true;

  documentation.info.enable = true;
  documentation.doc.enable = true;
}
