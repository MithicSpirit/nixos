{ config, ... }:
{

  programs.btop.enable = true;
  programs.btop.settings = {
    color_theme = "${config.programs.btop.package}/share/btop/themes/tokyo-night.theme";
    theme_background = false;
    presets = "";
    vim_keys = true;
    rounded_corners = false;
    update_time = 2000;
    proc_per_core = true;
    proc_gradient = false;
    cpu_graph_lower = "Auto";
    show_gpu_info = "Auto";
    gpu_mirror_graph = true;
    show_uptime = false;
    clock_format = " /user@/host (/uptime) | %H:%M:%S | %a, %b %d, %Y ";
    disks_filter = "";
    swap_disk = false; # TODO?
    net_iface = ""; # TODO
  };

}
