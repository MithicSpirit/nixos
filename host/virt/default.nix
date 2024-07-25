{ pkgs, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      storageDriver = "btrfs";
      enableOnBoot = false;
      autoPrune = {
        enable = true;
        dates = "daily";
      };
    };

    podman.enable = true;
  };

  environment.systemPackages = with pkgs; [
    qemu
    virt-manager
  ];
}
