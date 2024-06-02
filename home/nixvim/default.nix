{ pkgs, inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./treesitter.nix
    ./lsp.nix
    ./telescope.nix
    ./git.nix
    ./hop.nix
    ./ibl.nix
    ./trouble.nix
    ./lang/tex.nix
    ./lang/coq.nix
    ./lang/idris.nix
    ./lang/lean.nix
    # TODO: get a statusline (NOT lualine please for the love of god please)
  ];

  programs.nixvim = {
    enableMan = true;
    luaLoader.enable = true;

    extraPlugins = with pkgs.vimPlugins; [
      hotpot-nvim
      # tpope
      vim-sleuth
      vim-eunuch
      vim-rsi
      vim-repeat
      vim-surround
      vim-characterize
      vim-commentary
      # misc
      vim-sneak
      undotree
      colorizer
      # TODO: nvim-parinfer
      # TODO: firenvim
    ];
    extraConfigLuaPre = ''
      vim.opt.runtimepath:prepend('${./.}')
      require 'hotpot'.setup {
        provide_require_fennel = true,
        enable_hotpot_diagnostics = true,
      }
    '';
    extraConfigLua = ''
      -- vim-surround
      vim.g.surround_no_insert_mappings = 0
      vim.keymaps.set('i', '<C-s>', '<Plug>Isurround')
      -- vim-characterize
      vim.keymaps.set('n', 'g<C-a>', '<Plug>(characterize)')
      -- vim-sneak
      vim.g['sneak#use_ic_scs'] = 1
      vim.keymaps.set("", 'f', '<Plug>Sneak_f')
      vim.keymaps.set("", 'F', '<Plug>Sneak_F')
      vim.keymaps.set("", 't', '<Plug>Sneak_t')
      vim.keymaps.set("", 'F', '<Plug>Sneak_T')
      -- undotree
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
      vim.keymaps.set('n', '<leader>u', '<Cmd>UndotreeToggle<CR>')
    '';

    # FIXME: path:append "**"
    opts = {
      # functionality
      timeout = false;
      allowrevins = true;
      tildeop = true;
      spelllang = "en_us";
      # searching
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      # mouse
      mouse = "nv";
      mousemodel = "extend";
      mousescroll = "ver:2,hor:4";
      # appearance
      guifont = "Iosevka Mithic:h12:#e-antialias:#h-full";
      cursorline = true;
      conceallevel = 2; # FIXME: disable in dumb terminals
      linespace = 0;
      termguicolors = false;
      showmode = false;
    };

    extraPackages = [ ];
  };
}
