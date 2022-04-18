-- LSP
--

local lspconf = require("lspconfig")
local nvim_completion = require("completion")

local custom_attach = function(client, bufnr)
    nvim_completion.on_attach()
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

for _, server in ipairs(servers) do
    lspconf[server].setup {
        on_attach = custom_attach,
        flags = {
            debounce_text_changes = 150,
        }
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

