{pkgs, ...}: {
  home.packages = with pkgs; [
    # utils
    bitwarden-desktop
    gimp3
    graphite
    inkscape
    gnome-characters
    vlc

    # communication
    # armcord
    # element-desktop
    # signal-desktop
  ];
}
