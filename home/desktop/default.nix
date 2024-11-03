{ pkgs, ... }:
{

  home.packages = with pkgs; [
    # utils
    bitwarden-desktop
    gimp
    gnome-characters
    vlc

    # communication
    thunderbird
    # armcord
    # element-desktop
    # signal-desktop
  ];

}
