require "user.bindings"
require "user.plugins"

require "user.formatters"
require "user.linters"
require "user.lsp"

-- GENERAL lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "nord"

-- True colors
vim.o.termguicolors = true
vim.cmd'colorscheme nord'
