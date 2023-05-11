-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("telescope").load_extension("refactoring")

-- remap to open the Telescope refactoring menu in visual mode
vim.keymap.set(
  "v",
  "<leader>ct",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true, silent = true, desc = "Refactor" }
)

vim.keymap.set(
  "n",
  "<leader>nn",
  "<Esc><cmd>lua require('ajmasia.utils.obsidian').new_note()<CR>",
  { noremap = true, silent = true, desc = "New" }
)

vim.keymap.set("n", "<leader>nt", "<Esc><cmd>:ObsidianToday<CR>", { noremap = true, silent = true, desc = "Today" })
vim.keymap.set(
  "n",
  "<leader>nb",
  "<Esc><cmd>:ObsidianBacklinks<CR>",
  { noremap = true, silent = true, desc = "Back Links" }
)
vim.keymap.set(
  "n",
  "<leader>nw",
  "<Esc><cmd>:ObsidianQuickSwitch<CR>",
  { noremap = true, silent = true, desc = "Quick Switch" }
)

vim.keymap.set(
  "n",
  "<leader>nl",
  "<Esc><cmd>:ObsidianLinkNew<CR>",
  { noremap = true, silent = true, desc = "Create link under word" }
)

vim.keymap.set("n", "<leader>np", "<Esc><cmd>:ObsidianOpen<CR>", { noremap = true, silent = true, desc = "Preview" })
