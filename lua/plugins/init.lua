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
      require("dap-go").setup()
    end,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "leoluz/nvim-dap-go",
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
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       keymaps = {
  --         accept_suggestion = "<C-j>",
  --         clear_suggestion = "<C-c>",
  --         accept_word = "<C-w>",
  --       },
  --     })
  --     end,
  -- },
  {
    "robitx/gp.nvim",
    event = "VeryLazy",
    config = function()
        local conf = {
          providers = {
            openai = {
              endpoint = "http://localhost:1234/v1/chat/completions",
              secret = "1234",
            }
          },
        	agents = {
            {
              name = "qwen3coder",
              provider = "openai",
              chat = true,
              command = true,
              model = { model = "qwen/qwen3-coder-30b" },
              system_prompt = "I am an AI meticulously crafted to provide programming guidance and code assistance. "
              .. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
              .. "and expect precise, technical responses tailored to your development needs.\n",
            },
          },
        }
        require("gp").setup(conf)
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
        local nvlsp = require "nvchad.configs.lspconfig"
        require('prisma').setup({
        lsp = {
          on_attach = nvlsp.on_attach,
          capabilities = nvlsp.capabilities,
          on_init = nvlsp.on_init,
        }
      })
      end,
  },
}
