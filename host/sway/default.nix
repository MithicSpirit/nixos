{ pkgs, ... }: {

  programs.sway = {
    enable = true;
    # xwayland.enable = true; (doesn't exist?)
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [ swaylock-effects swayidle ];
  };

}
