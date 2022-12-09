-- GENERAL lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "nord"

-- KEYMAPPINGS
lvim.leader = "space"

-- hop
lvim.lsp.buffer_mappings.normal_mode["H"] = { ":HopWord<CR>", "Hop word" }

-- trouble
lvim.builtin.which_key.mappings["t"] = {
  name = "Trouble",
  t = { ":TroubleToggle<cr>", "Toggle Trouble" },
  r = { ":TroubleToggle lsp_references<cr>", "Trouble references" },
  d = { ":TroubleToggle lsp_definitions<cr>", "Trouble definitions" },
  f = { ":TodoTrouble<cr>", "Trouble fixmes" }
}

-- scribe
lvim.builtin.which_key.mappings["n"] = {
  name = "Notes",
  n = { ":ScribeOpen<cr>", "Default note" },
  N = { ":ScribeNew<cr>", "New note" },
  f = { ":ScribeFind<cr>", "Find note" },
}

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
  { "arcticicestudio/nord-vim" },
  {
    "andweeb/presence.nvim",
    config = function()
      require("presence"):setup({
        main_image = "file",
      })
    end,
  },
  { "christoomey/vim-tmux-navigator" },
  { "nkakouros-original/numbers.nvim",
    config = function()
      require("numbers").setup({
        excluded_filetypes = {
          'alpha'
        }
      })
    end
  },
  {
    "wetrustinprize/scribe.nvim",
    requires = "MunifTanjim/nui.nvim",
    config = function()
      require("scribe").setup({})
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>" },
      })
    end,
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end
  },
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup()
    end
  }
}
