{
  disko.devices = {
    disk = {
      short = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "luks-main";
                settings.allowDiscards = true;
                passwordFile = "/tmp/password";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/nixroot" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress-force=zstd:3"
                        "noatime"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd:2"
                        "nosuid"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      mountOptions = [
                        "nodatacow"
                        "noatime"
                        "noexec"
                        "lazytime"
                      ];
                      swap.swapfile.size = "48G";
                    };
                  };
                };
              };
            };

          };
        };
      };
    };
  };
}
