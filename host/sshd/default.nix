{...}: {
  services.openssh = {
    enable = true;
    ports = [22023];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;
}
