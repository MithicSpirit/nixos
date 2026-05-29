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
    # signal-desktop
    vesktop
    zulip
    element-desktop
  ];
}
