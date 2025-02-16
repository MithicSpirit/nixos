{ config, ... }:
{
  assertions = [
    {
      assertion = !config.zramSwap.enable;
      message = "Do not enable zram and zswap simultaneously";
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 80;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.max_pool_percent=25"
  ];

}
