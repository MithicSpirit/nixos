{ config, pkgs, inputs, root, overlays, ... }: {

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = pkgs.nixVersions.latest;

  imports = [
    inputs.hardware.nixosModules.framework-16-7040-amd
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ./disko.nix
    /${root}/host/secure-boot
    /${root}/host/man
    /${root}/host/sshd
    /${root}/host/pipewire
    /${root}/host/dnscrypt
    /${root}/host/logitech
    /${root}/host/virt
    /${root}/host/gaming
    /${root}/host/keyd
    /${root}/host/bluetooth
    /${root}/host/tlp # or ppd
    /${root}/host/sway
  ];

  nixpkgs.overlays = overlays;
  nixpkgs.config = {
    allowUnfree = false; # TODO: make global?
    rocmSupport = true;
  };

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "kernel.sysrq" = 244;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "all" ];
  time.timeZone = "US/Eastern";

  services.fwupd.enable = true;

  services.smartd.enable = true;
  boot.tmp.useTmpfs = true;

  networking.hostName = "hipparchus";
  networking.networkmanager = {
    enable = true;
    wifi.powersave = true;
  };

  console = {
    enable = true; # default, but just to be safe
    earlySetup = true;
    keyMap = "us";
    colors = with (import /${root}/common/colorscheme.nix).raw; [
      base00
      base01
      base02
      base03
      base04
      base05
      base06
      base07
      base08
      base09
      base10
      base11
      base12
      base13
      base14
      base15
    ];
  };

  # TODO: is zswap enough? investigate % mem zswapped
  # zramSwap = {
  #   enable = true;
  #   priority = 1000;
  #   algorithm = "zstd";
  #   memoryPercent = 25;
  # };

  services.flatpak.enable = true;
  fonts.fontDir.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  services.printing.enable = true;
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.kdeconnect.enable = true; # open firewall

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
    comma
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
    useUserPackages = true;
    useGlobalPkgs = true;
    users."mithic" = import ./home/mithic.nix;
  };
  systemd.services."user@${toString config.users.users."mithic".uid}" = {
    environment = builtins.mapAttrs (_: toString)
      config.home-manager.users."mithic".home.sessionVariables;
    overrideStrategy = "asDropin";
  };

  services.tlp.settings = let mhz = 1000;
  in {
    CPU_SCALING_MIN_FREQ_ON_AC = 3800 * mhz;
    CPU_SCALING_MAX_FREQ_ON_AC = 5137 * mhz;
    CPU_SCALING_MIN_FREQ_ON_BAT = 400 * mhz;
    CPU_SCALING_MAX_FREQ_ON_BAT = 1500 * mhz;
  };

  services.geoclue2.enable = true;

  services.logind = let sth = "suspend-then-hibernate";
  in {
    powerKey = sth;
    powerKeyLongPress = "poweroff";
    lidSwitch = sth;
    suspendKey = sth;
    hibernateKeyLongPress = config.services.logind.suspendKey;
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1day
    SuspendEstimationSec=0
  '';

}
