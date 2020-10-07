
local nvim_lsp = require("nvim_lsp")
local nvim_completion = require("completion")
local nvim_diagnostic = require("diagnostic")

local custom_attach = function()
    nvim_completion.on_attach()
    nvim_diagnostic.on_attach()
    print("LSP Attached.")
end

nvim_lsp.pyls.setup{ on_attach = custom_attach }
nvim_lsp.vimls.setup{ on_attach = custom_attach }

-- nvim_lsp.sumneko_lua.setup {
-- cmd = { vim.fn.stdpath("cache") .. "/nvim_lsp/sumneko_lua/lua-language-server/bin/Linux/lua-language-server", "-E", vim.fn.stdpath("cache") .. "/nvim_lsp/sumneko_lua/lua-language-server/main.lua" },
-- on_attach = custom_attach,
-- settings = {
--   Lua = {
--     diagnostics = {
--       globals = { "vim" },
--     },
--   },
-- },
-- }

-- nvim_lsp.texlab.setup{ on_attach = custom_attach }
-- nvim_lsp.clangd.setup{ on_attach = custom_attach }
-- nvim_lsp.rust_analyzer.setup{ on_attach = custom_attach }

