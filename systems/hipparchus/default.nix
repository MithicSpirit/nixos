{
  config,
  pkgs,
  inputs,
  root,
  overlays,
  ...
}:
{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
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
    /${root}/host/amdgpu
    /${root}/host/fw-fanctrl
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
    font = "${pkgs.iosevka-mithic}/share/fonts/truetype/iosevka-mithic.ttc";
    theme = "breeze";
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "kernel.sysrq" = 244;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "all" ];
  time.timeZone = "US/Eastern";

  services.fwupd.enable = true;

  services.smartd.enable = true;
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "100%"; # fine because of swap
  };

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

  environment.systemPackages =
    (with pkgs; [
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
      nixfmt-rfc-style
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
    SuspendEstimationSec=0
  '';

  services.upower.enable = true;

  # weird framework 16 stuff. see arch and nixos wikis
  services.udev.extraRules = # udev
    ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    '';

}
