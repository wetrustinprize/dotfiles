local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  {
    command = "eslint_d",
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
  {
    command = "prettierd",
    filetypes = { "markdown", "markdown.mdx", "graphql", "css", "scss" },
  },
  {
    command = "stylua",
    filetype = { "lua" },
  },
})
