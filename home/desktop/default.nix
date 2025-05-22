{ pkgs, ... }:
{

  home.packages = with pkgs; [
    # utils
    bitwarden-desktop
    gimp3
    gnome-characters
    vlc

    # communication
    # armcord
    # element-desktop
    # signal-desktop
  ];

}
