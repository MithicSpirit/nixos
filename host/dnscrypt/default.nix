{ ... }:
{
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
    };
  };

  networking.nameservers = [
    "::1"
    "127.0.0.1"
    "1.1.1.1"
  ];
  networking.networkmanager.dns = "none";
}
