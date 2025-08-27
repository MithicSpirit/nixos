{ pkgs, lib, ... }:
{

  # set default but allow imperative modification
  time.timeZone = lib.mkForce "US/Eastern";
  systemd.services.systemd-timedated.environment."NIXOS_STATIC_TIMEZONE" =
    lib.mkForce null;

  # requires imperative modification
  services.tzupdate = {
    enable = true;
    timer.enable = true;
  };
  systemd.services."tzupdate" = {
    preStart =
      let
        curl = lib.getExe pkgs.curl;
        sleep = lib.getExe' pkgs.coreutils "sleep";
        waitnet = pkgs.writeShellScript "waitnet" ''
          while ! ${curl} -fsSLm 10 --connect-timeout 2 -o /dev/null 'https://example.com'
          do ${sleep} 1
          done
        '';
      in
      "${waitnet}";
  };

  nixpkgs.overlays = [
    (_final: prev: {
      tzupdate = prev.tzupdate.overrideAttrs (
        _finalAttrs: prevAttrs: {
          patches = (prevAttrs.patches or [ ]) ++ [
            (pkgs.writeText "tzupdate-remove-services.diff" ''
              diff --git a/src/http.rs b/src/http.rs
              index 34aaab4..4acba31 100644
              --- a/src/http.rs
              +++ b/src/http.rs
              @@ -10,16 +10,12 @@ struct GeoIPService {
                   tz_keys: &'static [&'static str],
               }

               /// {ip} will be replaced with the IP. Services must be able to take {ip} being replaced with "" as
               /// meaning to use the source IP for the request.
               static SERVICES: &[GeoIPService] = &[
              -    GeoIPService {
              -        url: "https://geoip.chrisdown.name/{ip}",
              -        tz_keys: &["location", "time_zone"],
              -    },
                   GeoIPService {
                       url: "https://api.ipbase.com/v1/json/{ip}",
                       tz_keys: &["time_zone"],
                   },
                   GeoIPService {
                       url: "https://ipapi.co/{ip}/json/",
            '')
          ];
        }
      );
    })
  ];

}
