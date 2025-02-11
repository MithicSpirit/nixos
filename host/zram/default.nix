{ ... }:
{

  zramSwap = {
    enable = true;
    algorithm = "lz4 zstd";
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  # zswap+zram = bad
  boot.kernelParams = [ "zswap.enabled=0" ];

}
