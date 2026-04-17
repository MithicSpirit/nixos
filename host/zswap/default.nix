{config, ...}: {
  assertions = [
    {
      assertion = !config.zramSwap.enable;
      message = "Do not enable zram and zswap simultaneously";
    }
  ];

  boot = {
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 100;
      "vm.page-cluster" = 0;
    };
    kernelParams = [
      "zswap.enabled=1"
      "zswap.shrinker_enabled=1"
      "zswap.max_pool_percent=50"
      "zswap.compressor=lz4hc"
    ];
    kernelModules = [
      "lz4hc lz4hc_compress"
    ];
  };
}
