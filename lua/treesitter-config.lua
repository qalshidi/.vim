require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "c", "cpp", "haskell", "fish", "bash", "lua",
                       "fennel", "ledger" },
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
