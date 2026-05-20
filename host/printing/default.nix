{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint gutenprintBin hplip];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
  };
}
