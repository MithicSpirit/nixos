final: prev: {

  tlp = final.callPackage ./tlp.nix {
    inherit (final.linuxPackages) x86_energy_perf_policy;
  };

}
