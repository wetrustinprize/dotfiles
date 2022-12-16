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
