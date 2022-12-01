-- GENERAL
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "nord"

-- KEYMAPPINGS
lvim.leader = "space"

lvim.builtin.which_key.mappings["n"] = {
	name = "Notes",
	n = { ":ScribbleOpen<cr>", "Default note" },
	N = { ":ScribbleNew<cr>", "New note" },
	f = { ":ScribbleFind<cr>", "Find note" },
}

-- LVIM BUILTINS
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- PARSERS
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"tsx",
	"css",
	"scss",
	"rust",
	"yaml",
	"haskell",
	"prisma",
	"graphql",
}

lvim.builtin.treesitter.ignore_install = {}
lvim.builtin.treesitter.highlight.enable = true

-- LSP SETTINGS
lvim.lsp.installer.setup.ensure_installed = {
	"sumneko_lua",
	"jsonls",

	-- Node
	"tsserver",
	"eslint",
	"tailwindcss",

	"prismals",
	"omnisharp",
}

-- FORMATTERS AND LINTERS
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

-- PLUGINS
lvim.plugins = {
	-- {
	--   "folke/trouble.nvim",
	--   cmd = "TroubleToggle",
	-- },
	{ "arcticicestudio/nord-vim" },
	{ "andweeb/presence.nvim" },
	{ "christoomey/vim-tmux-navigator" },
	{ "MunifTanjim/nui.nvim" },
	{
		"wetrustinprize/scribble.nvim",
		config = function()
			require("scribble").setup({})
		end,
	},
}
