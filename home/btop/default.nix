{ config, ... }: {

  programs.btop.enable = true;
  programs.btop.settings = {
    color_theme =
      "${config.programs.btop.package}/share/btop/themes/tokyo-night.theme";
    theme_background = false;
    presets = "";
    vim_keys = true;
    update_time = 2000;
    cpu_graph_lower = "Auto";
    show_gpu_info = "Auto";
    gpu_mirror_graph = true;
    show_uptime = false;
    temp_scale = "kelvin";
    clock_format = " /user@/host (/uptime) | %H:%M:%S | %a, %b %d, %Y ";
    disks_filter = "";
    swap_disk = false; # TODO?
    net_iface = ""; # TODO
  };

}