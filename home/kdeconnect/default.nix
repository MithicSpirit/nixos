{hostConfig, ...}: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = hostConfig.programs.kdeconnect.package;
  };
}
