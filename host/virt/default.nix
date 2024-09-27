{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "daily";
      };
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    qemu
    virt-manager
  ];
}
