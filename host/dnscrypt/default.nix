{...}: {
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;

      cache = true;
      cache_min_ttl = 60 * 15; # 15 minutes
      cache_max_ttl = 60 * 60; # 1 hour
    };
  };

  networking.nameservers = [
    "::1"
    "127.0.0.1"
    "1.1.1.1"
  ];
  networking.networkmanager.dns = "none";
}
