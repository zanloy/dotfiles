local M = {}

local packer_bootstrap = false

local function packer_init()
  local fn = vim.fn
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    }
    vim.cmd [[packadd packer.nvim]]
  end
  --vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
end

packer_init()

function M.setup()
  local conf = {
    compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  local function plugins(use)
    use { "lewis6991/impatient.nvim" }
    use { "wbthomason/packer.nvim" }

    -- Development
    use {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    }
    use {
      "kyazdani42/nvim-tree.lua",
      event = "BufWinEnter",
      requires = {
        "kyazdani42/nvim-web-devicons", -- optional, for file icons
      },
      config = function()
        require("nvim-tree").setup {
          actions = {
            open_file = { quit_on_open = true }
          },
          view = {
            adaptive_size = true,
            mappings = {
              list = {
                { key = "u", action = "dir_up" },
              },
            },
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          },
        }
        vim.api.nvim_set_keymap("", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
      end,
    }

    -- LSP Configuration
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }
    use {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("null-ls").setup({
          sources = {
            require("null-ls").builtins.formatting.stylua,
            require("null-ls").builtins.diagnostics.eslint,
            require("null-ls").builtins.completion.spell,
          },
        })
      end,
    }
    use {
      "neovim/nvim-lspconfig",
      as = "nvim-lspconfig",
      after = { "nvim-cmp", "nvim-treesitter" },
      opt = true,
      config = function()
        require("config.lsp").setup()
      end,
    }

    -- Completion Engine
    use {
      "hrsh7th/nvim-cmp",
      after = { "lspkind", "plenary" },
      event = "InsertEnter",
      opt = true,
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-calc",
        "quangnguyen30192/cmp-nvim-ultisnips",
        "f3fora/cmp-spell",
        "hrsh7th/cmp-emoji",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
      },
      config = function()
        require("config.cmp").setup()
      end,
    }
    use {
      "onsails/lspkind-nvim",
      as = "lspkind",
      config = function()
        require("lspkind").init()
      end,
    }
    use { "nvim-lua/plenary.nvim", as = "plenary" }

    -- Syntax Engine
    use {
      "nvim-treesitter/nvim-treesitter",
      as = "nvim-treesitter",
      event = "BufRead",
      opt = true,
      run = function()
        require("nvim-treesitter.install").update({ with_sync = true})
      end,
      config = function()
        require("config.treesitter").setup()
      end,
    }

    -- Languages
    --use {
    --  "fatih/vim-go",
    --  opt = true,
    --  ft = 'go',
    --  run = function()
    --    vim.cmd [[:GoUpdateBinaries]]
    --  end,
    --}
    use { "cespare/vim-toml" }
    --use {
    --  "jose-elias-alvarez/typescript.nvim",
    --  config = function()
    --    require("typescript").setup()
    --  end,
    --}

    -- Quality of Life helpers
    use {
      "nvim-lualine/lualine.nvim",
      after = "nvim-treesitter",
      config = function()
        require("config.lualine").setup()
      end,
    }
    use {
      "akinsho/bufferline.nvim",
      event = "BufReadPre",
      config = function()
        require("config.bufferline").setup()
      end,
    }
    use {
      "rcarriga/nvim-notify",
      config = function()
        vim.notify = require "notify"
      end,
    }
    use {
      "folke/which-key.nvim",
      config = function()
        --require("config.whichkey").setup()
        require("which-key").setup {}
      end,
    }
    use { "christoomey/vim-tmux-navigator" }
    use { "kevinhwang91/nvim-bqf", ft = "qf" }
    use { "ray-x/lsp_signature.nvim" }
    use {
      "folke/trouble.nvim",
      event = "VimEnter",
      cmd = { "TroubleToggle", "Trouble" },
      config = function()
        require("trouble").setup {}
      end,
    }
    use { "jdhao/whitespace.nvim", event = "VimEnter" }

    -- Snippets
    --use {
    --  "SirVer/ultisnips",
    --  requires = { { "honza/vim-snippets", rtp = "." } },
    --  config = function()
    --    vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
    --    vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
    --    vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
    --    vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
    --    vim.g.UltiSnipsRemoveSelectModeMappings = 0
    --  end,
    --}

    -- Colorschemes
    use {
      "arcticicestudio/nord-vim",
      config = function()
        vim.cmd "colorscheme nord"
      end,
    }
    use { "cocopon/iceberg.vim", opt = true }
    use { "dracula/vim", as = "dracula", opt = true }
    use { "chuling/equinusocio-material.vim", opt = true }
    use { "sainnhe/gruvbox-material", opt = true }

    if packer_bootstrap then
      print "Setting up Neovim. Restart required after installation!"
      require("packer").sync()
    end
  end

  pcall(require, "impatient")
  pcall(require, "packer_compiled")
  require("packer").init(conf)
  require("packer").startup(plugins)
end

return M

-- vim: set ts=2 shiftwidth=2 expandtab:
