{ pkgs, ... }: {

  home.packages = with pkgs; [
    # utils
    gimp
    gnome.gnome-characters
    vlc

    # communication
    armcord
    element-desktop
    signal-desktop
    thunderbird
  ];

}
