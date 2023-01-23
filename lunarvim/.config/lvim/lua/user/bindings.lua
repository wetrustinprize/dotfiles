lvim.leader = "space"

-- replace SPC + f
lvim.builtin.which_key.mappings["f"] = {
  name = "Find",
  f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Files" },
  b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers" }
}

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

-- lsp
-- Replace SPC + l + i
lvim.builtin.which_key.mappings["l"]["i"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Info" }
