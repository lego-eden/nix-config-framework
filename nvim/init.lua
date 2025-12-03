-- Must be done first!
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', 'ä', ']', {})
vim.keymap.set('n', 'ö', '[', {})
vim.keymap.set('o', 'ä', ']', {})
vim.keymap.set('o', 'ö', '[', {})
vim.keymap.set('t', '<esc>', '<C-\\><C-n>', {})
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>d', function()
  vim.diagnostic.open_float({})
end, {})
vim.keymap.set('n', '<Leader>a', vim.lsp.buf.code_action, {})

vim.cmd.colorscheme('catppuccin')

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.winborder = 'rounded'
vim.opt.linebreak = true

-- Sync clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Snacks
require('snacks').setup({
  picker = { enabled = true },
  explorer = { enabled = true },
})
vim.keymap.set('n', "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set('n', "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set('n', "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set('n', "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set('n', "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set('n', "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })

-- Setup treesitter
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
})

-- Setup blink.cmp
require('blink.cmp').setup({
  -- 'default' for mappings similar to built-in completions (C-y to accept)
  -- 'super-tab' for mappings similar to vscode (tab to complete)
  -- 'enter' for enter to accept
  -- 'none' for no mappings
  --
  -- All presets have the following mappings:
  -- C-space: Open meny or open docs if already open
  -- C-n/C-p or Up/Down: Select next/previous item
  -- C-e: Hide menu
  -- C-k: Toggle signature help (if signature.enabled = true)
  --
  -- See :h blink-cmp-config-keymap for defining your own keymap
  keymap = { preset = 'default' },

  appearance = {
    nerd_font_variant = 'mono'
  },

  completion = { documentation = { auto_show = false } },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" }
});

-- Setup lspconfig
local lspconfig = require('lspconfig')

-- Setup metals
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "mill", "sc" },
  callback = function()
    require("metals").initialize_or_attach({})
  end,
  group = nvim_metals_group,
})
