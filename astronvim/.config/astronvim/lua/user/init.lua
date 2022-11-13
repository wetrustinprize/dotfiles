return {
  -- Nord color scheme
  colorscheme = "nord",

  -- Vim options
  options = {
    wo = {
      wrap = true,
    },
    g = {
      copilot_node_command = "/usr/local/n/versions/node/17.9.1/bin/node",
    },
  },

  polish = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
      command = 'silent! EslintFixAll',
    })
  end
}
