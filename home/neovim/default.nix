{ pkgs, ... }: {
  imports = [ ./treesitter.nix ./lsp.nix ./telescope.nix ./lang ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # TODO: get a statusline (NOT lualine please for the love of god please)
    # TODO: theme
    plugins = with pkgs.vimPlugins; [
      hotpot-nvim
      # tpope
      vim-sleuth
      vim-eunuch
      vim-rsi
      vim-fugitive
      vim-repeat
      {
        plugin = vim-surround;
        type = "fennel";
        config = ''
          (set vim.g.surround_no_insert_mappings 0)
          (vim.keymaps.set :i "<C-s>" "<Plug>Isurround")
        '';
      }
      #{
      #  plugin = vim-characterize;
      #  config = ''
      #    vim.keymaps.set("n", "g<C-a>", "<Plug>(characterize)")
      #  '';
      #}
      vim-commentary
      # misc
      colorizer
      {
        plugin = gitsigns-nvim;
        type = "fennel";
        config = "(require :custom.gitsigns)";
      }
      {
        plugin = indent-blankline-nvim;
        type = "fennel";
        config = "(require :custom.ibl)";
      }
      # { TODO: get up-to-date version
      #   plugin = trouble-nvim;
      #   config = "require 'custom.trouble'";
      # }
      {
        plugin = hop-nvim;
        type = "fennel";
        config = "(require :custom.hop)";
      }
      {
        plugin = vim-sneak;
        type = "fennel";
        config = ''
          (tset vim.g :sneak#use_ic_scs 1)
          (vim.keymaps.set "" "f" "<Plug>Sneak_f")
          (vim.keymaps.set "" "F" "<Plug>Sneak_F")
          (vim.keymaps.set "" "t" "<Plug>Sneak_t")
          (vim.keymaps.set "" "F" "<Plug>Sneak_T")
        '';
      }
      {
        plugin = undotree;
        type = "fennel";
        config = ''
          (set vim.g.undotree_SetFocusWhenToggle 1)
          (set vim.g.undotree_ShortIndicators 1)
          (vim.keymaps.set :n "<leader>u" "<Cmd>UndotreeToggle<CR>")
        '';
      }
      # TODO: nvim-parinfer
      # TODO: firenvim
    ];

    # place at the start
    extraLuaConfig = ''
      vim.loader.enable()
      vim.opt.runtimepath:prepend('${./.}')
      require "hotpot".setup {
        provide_require_fennel = true,
        enable_hotpot_diagnostics = true,
      }
      require "custom.opts"
      require "custom.maps"
      require "custom.autocmd"
      require "custom.misc"
      -- vim.cmd.colorscheme("custom")
      require "custom.plugins"
    '';
    # TODO: colorscheme ^

    extraPackages = [ ];
  };
}
