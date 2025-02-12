require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
--map("i", "jk", "<ESC>")
map("n", "<leader>tk", ":Telescope keymaps<CR>", { desc = "Serch keymaps"})
map("n", "<leader>md", "<cmd> :MarkdownPreview <CR>", {desc = "MarkDown show preview"})
map("n", "<leader>ms", "<cmd> :MarkdownPreviewStop <CR>", {desc = "Markdown preview stop"})
map("t", "<C-q>", "<cmd> :q <CR>", {desc = "Exit terminal"})

map("n", "<leader>lf", function()
  vim.diagnostic.open_float { border = "rounded" }
end, {desc = "Floating diagnostic" })

map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

map('n', '<leader>gb', function()
  require("gitsigns").blame_line{full=true}
end, { desc = "git blame"})

map("n", "<leader>pb", "<cmd>ToggleBufferPanel<CR>", {desc = "Toggle buffer panel"})

map('n', '<leader>lhs', function()
  vim.cmd('%!xxd')
end, {desc = "hex show" })

map('n', '<leader>lhr', function()
  vim.cmd('%!xxd -r')
end, {desc = "hex show" })

map("n", "<leader>do", "<cmd>lua require('dapui').toggle()<CR>", {desc = "debug toggle ui"})
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", {desc = "debug toggle breakpoint"})
map("n", "<leader>dr", "<cmd>lua require('dap').continue()<CR>", {desc = "debug run/continue"});
