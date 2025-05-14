{
  config,
  pkgs,
  lib,
  inputs,
  root,
  overlays,
  ...
}:
{

  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      build-dir = "/var/tmp";
    };

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  imports =
    [
      inputs.hardware.nixosModules.framework-16-7040-amd
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.default
      ./hardware-configuration.nix
      ./disko.nix
    ]
    ++ builtins.map (path: root + /host + path) [
      /secure-boot
      /man
      /sshd
      /pipewire
      /dnscrypt
      /logitech
      /virt
      /gaming
      /keyd
      /bluetooth
      /tlp # or ppd
      /sway
      /amdgpu
      /fw-fanctrl
      /zswap # or zram
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
  boot.plymouth = {
    enable = false; # TODO?
    font = pkgs.iosevka-mithic + /share/fonts/truetype/iosevka-mithic.ttc;
    theme = "breeze";
  };

  boot.kernelPackages = pkgs.linuxPackages; # TODO: go back to _latest
  boot.kernel.sysctl = {
    "kernel.sysrq" = 244;
    "net.ipv4.tcp_keepalive_time" = 120;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "all" ];
  time.timeZone = "US/Eastern";

  services.fwupd.enable = true;

  services.smartd.enable = true;
  services.btrfs.autoScrub.enable = true;

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "100%"; # fine because of swap
  };

  networking.hostName = "hipparchus";
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    wifi.powersave = true;
  };

  console = {
    enable = true; # default, but just to be safe
    earlySetup = true;
    keyMap = "us";
    colors = with (import (root + /common/colorscheme.nix)).raw; [
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

  hardware.enableRedistributableFirmware = true;

  services.flatpak.enable = true;
  fonts.fontDir.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };
  services.gnome.gnome-keyring.enable = true; # TODO: use keepassxc (or bitwarden)

  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.kdeconnect.enable = true; # open firewall

  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    pruneBindMounts = true;
  };

  services.gpm.enable = true;

  environment.systemPackages =
    (with pkgs; [
      coreutils
      moreutils
      util-linux
      usbutils
      (lib.lowPrio busybox)
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
      nixfmt-rfc-style
      nix-index
      htop
      findutils
      rename
      lsof
      mtr
      ldns
      testdisk
      stress-ng
      tree
      file
      zip
      unzip
      unrar-wrapper
      xorg.xkill
      fastfetch
      dotacat
      cmatrix
      neo-cowsay
      bsdgames
      sl
    ])
    ++ (
      with builtins; # get all packages from unixtools
      filter (p: typeOf p == "set") (attrValues pkgs.unixtools)
    );
  # TODO: environment.binsh = with pkgs; lib.getExe dash;

  programs.zsh = {
    enable = true;
    enableLsColors = true;
    enableCompletion = true;
  };
  environment.pathsToLink = [ "/share/zsh" ]; # fix zsh completions

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = false;
    package = null;
  };

  environment.enableDebugInfo = true;

  users.users."mithic" = {
    description = "MithicSpirit";
    extraGroups = [
      "wheel"
      "video"
      "gamemode"
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "";
    createHome = true;
    homeMode = "755";
    linger = true;
    uid = 1000;
  };
  home-manager = {
    extraSpecialArgs = {
      inherit inputs root overlays;
      hostConfig = config;
    };
    useUserPackages = true;
    useGlobalPkgs = true;
    users."mithic" = import ./home/mithic.nix;
  };
  systemd.services."user@${toString config.users.users."mithic".uid}" = {
    environment = builtins.mapAttrs (
      _: toString
    ) config.home-manager.users."mithic".home.sessionVariables;
    overrideStrategy = "asDropin";
  };

  services.geoclue2 = {
    enable = true;
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    submitData = true;
    submissionUrl = "https://beacondb.net/v2/geosubmit";
  };

  programs.nano.enable = false;

  services.logind = rec {
    powerKey = suspendKey;
    powerKeyLongPress = "poweroff";
    lidSwitch = suspendKey;

    suspendKey = "suspend-then-hibernate";
    suspendKeyLongPress = hibernateKey;

    hibernateKey = "hibernate";
    hibernateKeyLongPress = suspendKey;
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1day
    SuspendEstimationSec=0s
  '';

  services.upower.enable = true;

  programs.gamemode.settings.gpu.gpu_device = 1;

  # weird framework 16 stuff. see arch and nixos wikis
  services.udev.extraRules = # udev
    ''
      # keyboard
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"
      # trackpad
      ACTION=="add", SUBSYSTEM=="i2c", DRIVERS=="i2c_hid_acpi", ATTRS{name}=="PIXA3854:00", ATTR{power/wakeup}="disabled"
      # audio
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0010", ATTR{power/wakeup}="disabled"
    '';

  # remove when properly cooled
  services.tlp.settings = {
    PLATFORM_PROFILE_ON_AC = lib.mkForce "low-power";
    CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "power";
  };

  systemd.services.bluetooth-rfkill-resume = {
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
    };
  };

  programs.gamescope.args = [
    "-w2560"
    "-h1600"
    "-r165"
    "--adaptive-sync"
  ];

}
