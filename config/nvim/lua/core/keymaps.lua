-- lua/core/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Use jk to escape insert mode
map("i", "jk", "<Esc>", opts)

-- Center cursor when moving up/down or searching
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "J", "mzJ`z", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Keep paste buffer when pasting over selection
map("x", "<leader>p", [["_dP]], opts)

-- Copy to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], opts)
map("n", "<leader>Y", [["+Y]], opts)

-- Quick save
map("n", "<leader>w", ":w<CR>", opts)

-- Clear search highlights
map("n", "<leader>nh", ":nohlsearch<CR>", opts)

-- Search (Telescope)
map("n", "<leader>sf", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>sb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>sr", "<cmd>Telescope oldfiles<CR>", opts)
map("n", "<leader>sp", "<cmd>Telescope projects<CR>", opts)
map("n", "<leader>se", "<cmd>Telescope file_browser<CR>", opts)

-- Neo Tree
map('n', '<leader>er', ':Neotree reveal<CR>', opts)
map('n', '<leader>ec', ':Neotree close<CR>', opts)

-- Terminal
map('n', '<leader>tt', '<cmd>ToggleTerm direction=horizontal<CR>', opts)
map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', opts)
map('t', 'jk', [[<C-\><C-n>]], opts)

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Motion (Hop)
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection

    map('', '<leader>fw', function() hop.hint_words() end, opts)
    map('', '<leader>fc', function() hop.hint_char1() end, opts)
    map('', '<leader>f2', function() hop.hint_char2() end, opts)
    map('', '<leader>fa', function() hop.hint_patterns() end, opts)
    map('', '<leader>ff', function() hop.hint_char1({direction = directions.AFTER_CURSOR}) end, opts)
    map('', '<leader>fF', function() hop.hint_char1({direction = directions.BEFORE_CURSOR}) end, opts)
  end
})

