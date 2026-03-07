{pkgs, ...}: {
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

    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
  ];
}
