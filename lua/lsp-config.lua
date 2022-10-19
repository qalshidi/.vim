-- LSP
--

local lspconf = require("lspconfig")
local cmp = require'cmp'

local custom_attach = function(client, bufnr)
    print("LSP Attached.")
end

local servers = {
    "vimls",
    "bashls",
    "hls",
    "pyright",
    "texlab",
    "clangd",
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, server in ipairs(servers) do
    lspconf[server].setup {
        on_attach = custom_attach,
        flags = {
            debounce_text_changes = 150,
        },
        capabilities = capabilities
    }
end

-- INSTALLER
--

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.settings({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})
-- lspconf.sumneko_lua.setup {
-- cmd = { vim.fn.stdpath("cache") .. "/lspconf/sumneko_lua/lua-language-server/bin/Linux/lua-language-server", "-E", vim.fn.stdpath("cache") .. "/lspconf/sumneko_lua/lua-language-server/main.lua" },
-- on_attach = custom_attach,
-- settings = {
--   Lua = {
--     diagnostics = {
--       globals = { "vim" },
--     },
--   },
-- },
-- }

-- lspconf.rust_analyzer.setup{ on_attach = custom_attach }


cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  capabilities = capabilities
}
