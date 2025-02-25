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
    end,
    ft = { "markdown" },
  },
  {
    "neoclide/coc.nvim",
    event = "VeryLazy",
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
    'Kicamon/markdown-table-mode.nvim',
    event = 'VeryLazy',
    config = function()
      require('markdown-table-mode').setup()
    end
  }
}
