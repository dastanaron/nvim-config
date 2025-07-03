return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    'junegunn/vim-easy-align',
    event = 'VeryLazy',
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_preview_options = {
        uml = { server = "http://localhost:8080" },
      }
    end,
    ft = { "markdown" },
  },
  { "rcarriga/nvim-dap-ui",
    event = 'VeryLazy',
    init = function()
      require("dapui").setup()
      require('configs.dap')
    end,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    }
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
    },
    opts = {},
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-j>",
          clear_suggestion = "<C-c>",
          accept_word = "<C-w>",
        },
      })
      end,
  },
  {
      'dastanaron/prisma.nvim',
      event = "VeryLazy",
      dependencies = {
          'williamboman/mason.nvim',
          'neovim/nvim-lspconfig',
          'nvim-treesitter/nvim-treesitter'
      },
      config = function()
          require('prisma').setup()
      end,
      opts = {
          -- default configuration
      }
  }
}
