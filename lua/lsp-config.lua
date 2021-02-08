local lspconf = require("lspconfig")
local nvim_completion = require("completion")

local custom_attach = function()
    nvim_completion.on_attach()
    print("LSP Attached.")
end

lspconf.vimls.setup{ on_attach = custom_attach }
lspconf.bashls.setup{ on_attach = custom_attach }
lspconf.hls.setup{ on_attach = custom_attach }
lspconf.pyright.setup{ on_attach = custom_attach }
lspconf.texlab.setup{ on_attach = custom_attach }
lspconf.clangd.setup{ on_attach = custom_attach }
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

