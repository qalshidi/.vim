
local nvim_lsp = require("nvim_lsp")
local nvim_completion = require("completion")
local nvim_diagnostic = require("diagnostic")

local custom_attach = function()
    nvim_completion.on_attach()
    nvim_diagnostic.on_attach()
    print("LSP Attached.")
end

nvim_lsp.vimls.setup{ on_attach = custom_attach }
nvim_lsp.bashls.setup{ on_attach = custom_attach }

if vim.fn.executable("haskell-language-server-wrapper") then
    nvim_lsp.hls.setup{ on_attach = custom_attach }
else
    vim.fn.jobstart("ghcup upgrad && ghcup install hls")
end

if vim.fn.executable("pyls") then
    nvim_lsp.pyls.setup{ on_attach = custom_attach }
else
    vim.fn.jobstart("python3 -m pip install --user -U --force python-language-server")
end

if vim.fn.executable("texlab") then
    nvim_lsp.texlab.setup{ on_attach = custom_attach }
else
    vim.fn.jobstart("cargo install texlab")
end

if vim.fn.executable("clangd") then
    nvim_lsp.clangd.setup{ on_attach = custom_attach }
end
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

-- nvim_lsp.rust_analyzer.setup{ on_attach = custom_attach }

