{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    radeontop
    nvtopPackages.amd
  ];
}
