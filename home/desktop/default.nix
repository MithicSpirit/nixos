{ pkgs, ... }:
{

  home.packages = with pkgs; [
    # utils
    gimp
    gnome.gnome-characters
    vlc

    # communication
    thunderbird
    # armcord
    # element-desktop
    # signal-desktop
  ];

}
