return {
  -- Nord color scheme
  colorscheme = "nord",

  -- Vim options
  options = {
    wo = {
      wrap = true,
    }
  },

  polish = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
      command = 'silent! EslintFixAll',
    })
  end
}
