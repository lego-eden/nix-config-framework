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
vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "K", ":m '>-2<CR>gv=gv")

vim.cmd.colorscheme('catppuccin')

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
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
  'zig', 'haskell', 'toml', 'python', 'markdown', 'make' }
-- local tslangs = { 'all' }
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
vim.lsp.config("clangd", {})
vim.lsp.enable("clangd")

-- Setup Java LSP
vim.lsp.config("jdtls", {})
vim.lsp.enable("jdtls")

-- Setup metals
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "mill", "sc" },
  callback = function()
    require("metals").initialize_or_attach({
      settings = {
        inlayHints = {
          hintsInPatternMatch = { enable = true },
          implicitArguments = { enable = true },
          implicitConversions = { enable = true },
          inferredTypes = { enable = true },
          typeParameters = { enable = true },
        },
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
        vim.cmd.RustLsp('codeaction')
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
