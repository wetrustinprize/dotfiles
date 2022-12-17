local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  {
    command = "eslint_d",
    filetypes = { "typescript", "typescriptreact" },
  },
  {
    command = "write_good",
  },
})
