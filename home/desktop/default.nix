{ pkgs, ... }:
{

  home.packages = with pkgs; [
    # utils
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
