local lspconf = require("lspconfig")
local nvim_completion = require("completion")

local custom_attach = function()
    nvim_completion.on_attach()
    print("LSP Attached.")
end

if not lspconf.vimls.install_info().is_installed then
    lspconf.vimls.install()
end
lspconf.vimls.setup{ on_attach = custom_attach }

if not lspconf.bashls.install_info().is_installed then
    lspconf.bashls.install()
end
lspconf.bashls.setup{ on_attach = custom_attach }

if vim.fn.executable("haskell-language-server-wrapper") then
    lspconf.hls.setup{ on_attach = custom_attach }
else
    vim.fn.jobstart("ghcup upgrade && ghcup install hls")
end

if vim.fn.executable("pyls") then
    lspconf.pyls.setup{ on_attach = custom_attach }
else
    vim.fn.jobstart("python3 -m pip install --user -U --force python-language-server")
end

if vim.fn.executable("texlab") then
    lspconf.texlab.setup{ on_attach = custom_attach }
else
    vim.fn.jobstart("cargo install texlab")
end

if vim.fn.executable("clangd") then
    lspconf.clangd.setup{ on_attach = custom_attach }
end
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

