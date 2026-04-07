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
  vim.diagnostic.open_float({}) end, {})
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {})
vim.keymap.set('n', '<leader>h', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, {})

vim.cmd.colorscheme('catppuccin')

-- Options
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.winborder = 'rounded'
vim.opt.linebreak = true
vim.opt.swapfile = false
vim.diagnostic.config({
  signs = false,
})

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
local ts = require('nvim-treesitter')
local tslangs = {
  'lua', 'scala', 'java', 'html', 'c', 'rust', 'javascript',
  'zig', 'haskell', 'toml', 'python', 'markdown', 'make',
  'cpp', 'slang', 'nix', 'gleam'
}
vim.filetype.add({
  extension = {
    slang = "slang",
  },
})

ts.install(tslangs)
vim.api.nvim_create_autocmd('FileType', {
  pattern = tslangs,
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'
    -- indentation, provided by nvim-treesitter
    -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Setup markdown specific settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt.wrap = true
  end,
})

-- Setup fidget to have metals not interrupt the user
require('fidget').setup({})

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

-- Setup zls
vim.lsp.config("zls", {
  -- cmd = { "zls" },
  -- filetypes = { "zig", "zir" },
  -- root_dir = lspconfig.util.root_pattern("build.zig", ".git") or vim.loop.cwd,
})
vim.lsp.enable("zls")

-- Setup python
vim.lsp.config("pylsp", {})
vim.lsp.enable("pylsp")

-- Setup C LSP
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--experimental-modules-support",
  },
})
vim.lsp.enable("clangd")

-- Setup Java LSP
vim.lsp.config("jdtls", {})
vim.lsp.enable("jdtls")

-- Setup Gleam LSP
vim.lsp.config("gleam", {})
vim.lsp.enable("gleam")

-- Setup Slang LSP
require('slang').setup({
  auto_format = true,
  inlay_hints = true,
})

-- Setup lualine
-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
  blue     = '#89b4fa',
  cyan     = '#94e2d5',
  black    = '#11111b',
  white    = '#cdd6f4',
  red      = '#f38ba8',
  violet   = '#cba6f7',
  flamingo = '#f2cdcd',
  grey     = '#313244',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.flamingo },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.black, bg = colors.cyan } },
  visual = { a = { fg = colors.black, bg = colors.violet } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'filename', 'branch' },
    lualine_c = {
      '%=', --[[ add your center components here in place of this comment ]]
    },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}

-- Setup metals
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "mill", "sc" },
  callback = function()
    require("metals").initialize_or_attach({
      settings = {
        serverVersion = "2.0.0-M8",
        serverProperties = { "-Xmx4g" },
        inlayHints = {
          byNameParameters = { enable = true },
          hintsInPatternMatch = { enable = true },
          implicitArguments = { enable = true },
          implicitConversions = { enable = true },
          inferredTypes = { enable = true },
          typeParameters = { enable = true },
        }
      },
      init_options = {
        statusBarProvider = "off",
        byNameParameters = { enable = true },
      },
    })
  end,
  group = nvim_metals_group,
})

-- Setup rustacean
vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
  },
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      vim.keymap.set('n', '<leader>a', function()
        vim.cmd.RustLsp('codeAction')
      end, {})

      vim.keymap.set('n', 'K', function()
        vim.cmd.RustLsp({'hover', 'actions'})
      end, {})
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}

-- setup LSP stuff
require('rustaceanvim')
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end
})
