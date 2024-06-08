{ config, pkgs, inputs, root, overlays, ... }: {

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix # FIXME: update
    inputs.home-manager.nixosModules.default
    inputs.disko.nixosModules.default
    ./disko.nix
    /${root}/host/secure-boot
    /${root}/host/man
    /${root}/host/ssh
    /${root}/host/pipewire
    /${root}/host/dnscrypt
    /${root}/host/logitech
    /${root}/host/virt
    /${root}/host/gaming
    /${root}/host/keyd
    /${root}/host/bluetooth
    /${root}/host/tlp
  ];

  nixpkgs.overlays = overlays;

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # TODO: boot.kernelParams loglevel=3, no quiet (check /proc/cmdline)
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "kernel.sysrq" = 244;
    # TODO: "vm.max_map_count" = 1048576;
    # TODO: "kernel.pid_max" = 4194304;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "US/Eastern";

  services.fwupd.enable = true;

  services.smartd.enable = true;
  services.fstrim.enable = true;

  networking.hostName = "hipparchus";
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  console = {
    enable = true; # default, but just to be safe
    earlySetup = true;
    keyMap = "us";
    colors = [
      # nord theme
      # TODO: use import common
      "292E38"
      "BF616A"
      "A3BE8C"
      "EBCB8B"
      "81A1C1"
      "B48EAD"
      "88C0D0"
      "F2F5FA"
      "64718B"
      "C76B74"
      "ADC698"
      "F3D599"
      "8CA9C6"
      "BC9AB5"
      "93BEBE"
      "ECEFF4"
    ];
  };

  # TODO: is zswap enough? investigate % mem zswapped
  # zramSwap = {
  #   enable = true;
  #   priority = 1000;
  #   algorithm = "zstd";
  #   memoryPercent = 25;
  # };

  hardware.opengl.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  services.printing.enable = true;
  programs.dconf.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    pruneBindMounts = true;
    localuser = null;
  };

  services.gpm.enable = true;

  environment.systemPackages = (with pkgs; [
    coreutils
    moreutils
    busybox
    util-linux
    which
    dash
    curl
    openssh
    tmux
    ed
    vim
    emacs
    git
    htop
    findutils
    rename
    lsof
    mtr
    ldns
    testdisk
    tree
    file
    zip
    unzip
    unrar-wrapper
    fastfetch
    dotacat
    cmatrix
    neo-cowsay
    bsdgames
    sl
  ]) ++ (with builtins; # get all packages from unixtools
    filter (p: typeOf p == "set") (attrValues pkgs.unixtools));

  programs.zsh = {
    enable = true;
    enableLsColors = true;
    enableCompletion = true;
  };
  environment.pathsToLink = [ "/share/zsh" ]; # fix zsh completions

  environment.enableDebugInfo = true;

  users.users."mithic" = {
    description = "MithicSpirit";
    extraGroups = [ "wheel" "video" "gamemode" ];
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "";
    createHome = true;
    homeMode = "750";
    linger = true;
  };
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit root;
      inherit overlays;
    };
    users."mithic" = import ./home/mithic.nix;
  };
  systemd.services.${config.users.users."mithic".uid} = {
    environment = builtins.mapAttrs (_: toString)
      config.home-manager.users."mithic".home.sessionVariables;
    overrideStrategy = "asDropin";
  };

}
