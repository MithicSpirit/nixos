{ pkgs, ... }:
{

  home.packages = with pkgs; [
    # utils
    bitwarden-desktop
    gimp
    gnome-characters
    vlc

    # communication
    betterbird
    # armcord
    # element-desktop
    # signal-desktop
  ];

}
