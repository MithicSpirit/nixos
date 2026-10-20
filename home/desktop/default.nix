{pkgs, ...}: {
  home.packages = with pkgs; [
    # utils
    bitwarden-desktop
    gimp3
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
