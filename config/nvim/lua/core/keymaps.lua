-- local map = vim.keymap.set
local map = require("me.util").map
local opts = { noremap = true, silent = true }

-- Use jk to escape insert mode
map("i", "jk", "<Esc>", opts)

-- Keep paste buffer when pasting over selection
map("x", "<leader>p", [["_dP]], opts)

-- Copy to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], opts)
map("n", "<leader>Y", [["+Y]], opts)

-- Quick save
map("n", "<leader>w", ":w<CR>", opts)

-- Clear search highlights
map("n", "<leader>nh", ":nohlsearch<CR>", opts)

-- Snacks Pickers and UI
map("n", "<leader><space>", function() Snacks.picker.smart() end, opts, "Smart Find Files")
map("n", "<leader>,", function() Snacks.picker.buffers() end, opts, "Buffers")
map("n", "<leader>/", function() Snacks.picker.grep() end, opts, "Grep")
map("n", "<leader>:", function() Snacks.picker.command_history() end, opts, "Command History")
map("n", "<leader>n", function() Snacks.picker.notifications() end, opts, "Notification History")
map("n", "<leader>e", function() Snacks.explorer({
  auto_close = true

}) end, opts, "File Explorer")

-- Snacks Find
map("n", "<leader>fb", function() Snacks.picker.buffers() end, opts, "Buffers")
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, opts, "Find Config File")
map("n", "<leader>ff", function() Snacks.picker.files() end, opts, "Find Files")
map("n", "<leader>fg", function() Snacks.picker.git_files() end, opts, "Find Git Files")
map("n", "<leader>fp", function() Snacks.picker.projects() end, opts, "Projects")
map("n", "<leader>fr", function() Snacks.picker.recent() end, opts, "Recent")

-- Git
map("n", "<leader>gb", function() Snacks.picker.git_branches() end, opts, "Git Branches")
map("n", "<leader>gl", function() Snacks.picker.git_log() end, opts, "Git Log")
map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, opts, "Git Log Line")
map("n", "<leader>gs", function() Snacks.picker.git_status() end, opts, "Git Status")
map("n", "<leader>gS", function() Snacks.picker.git_stash() end, opts, "Git Stash")
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, opts, "Git Diff (Hunks)")
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, opts, "Git Log File")

-- Grep/Search
map("n", "<leader>sb", function() Snacks.picker.lines() end, opts, "Buffer Lines")
map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, opts, "Grep Open Buffers")
map("n", "<leader>sg", function() Snacks.picker.grep() end, opts, "Grep")
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, opts, "Grep Word")

map("n", '<leader>s"', function() Snacks.picker.registers() end, opts, "Registers")
map("n", '<leader>s/', function() Snacks.picker.search_history() end, opts, "Search History")
map("n", "<leader>sa", function() Snacks.picker.autocmds() end, opts, "Autocmds")
map("n", "<leader>sc", function() Snacks.picker.command_history() end, opts, "Command History")
map("n", "<leader>sC", function() Snacks.picker.commands() end, opts, "Commands")
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, opts, "Diagnostics")
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, opts, "Buffer Diagnostics")
map("n", "<leader>sh", function() Snacks.picker.help() end, opts, "Help Pages")
map("n", "<leader>sH", function() Snacks.picker.highlights() end, opts, "Highlights")
map("n", "<leader>si", function() Snacks.picker.icons() end, opts, "Icons")
map("n", "<leader>sj", function() Snacks.picker.jumps() end, opts, "Jumps")
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, opts, "Keymaps")
map("n", "<leader>sl", function() Snacks.picker.loclist() end, opts, "Location List")
map("n", "<leader>sm", function() Snacks.picker.marks() end, opts, "Marks")
map("n", "<leader>sM", function() Snacks.picker.man() end, opts, "Man Pages")
map("n", "<leader>sp", function() Snacks.picker.lazy() end, opts, "Search for Plugin Spec")
map("n", "<leader>sq", function() Snacks.picker.qflist() end, opts, "Quickfix List")
map("n", "<leader>sR", function() Snacks.picker.resume() end, opts, "Resume")
map("n", "<leader>su", function() Snacks.picker.undo() end, opts, "Undo History")
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, opts, "Colorschemes")

-- LSP
map("n", "gd", function() Snacks.picker.lsp_definitions() end, opts, "Goto Definition")
map("n", "gD", function() Snacks.picker.lsp_declarations() end, opts, "Goto Declaration")
map("n", "gr", function() Snacks.picker.lsp_references() end, opts, "References")
map("n", "gI", function() Snacks.picker.lsp_implementations() end, opts, "Goto Implementation")
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, opts, "Goto Type Definition")
map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, opts, "LSP Symbols")
map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, opts, "LSP Workspace Symbols")

-- Misc
map("n", "<leader>z", function() Snacks.zen() end, opts, "Toggle Zen Mode")
map("n", "<leader>Z", function() Snacks.zen.zoom() end, opts, "Toggle Zoom")
map("n", "<leader>.", function() Snacks.scratch() end, opts, "Toggle Scratch Buffer")
map("n", "<leader>S", function() Snacks.scratch.select() end, opts, "Select Scratch Buffer")
map("n", "<leader>bd", function() Snacks.bufdelete() end, opts, "Delete Buffer")
map("n", "<leader>cR", function() Snacks.rename.rename_file() end, opts, "Rename File")
map("n", "<leader>gB", function() Snacks.gitbrowse() end, opts, "Git Browse")
map("n", "<leader>un", function() Snacks.notifier.hide() end, opts, "Dismiss Notifications")

map("n", "<leader>gg", function() Snacks.lazygit() end, opts, "Lazygit")
map("n", "<leader>ta", function() Snacks.terminal("aider", {
  win = {
    style = "terminal",
    position = "bottom"
  }
}) end, opts, "aider")

-- Terminal
map("t", "JK", [[<C-\><C-n>]], nil, "Exit terminal mode")
map("n", "<leader>tt", function() Snacks.terminal() end, opts, "Toggle Terminal")
map("n", "<leader>tl", function() Snacks.terminal.list() end, opts, "List Terminals")
map("n", "<C-_>", function() Snacks.terminal() end, opts, "which_key_ignore")

  -- Close terminal (must be in normal mode)
map("n", "<leader>tx", ":bd!<CR>", opts, "Close Terminal Buffer")

  -- Navigate splits (while in terminal, use jk to escape first)
map("n", "<C-h>", "<C-w>h", opts, "Window Left")
map("n", "<C-j>", "<C-w>j", opts, "Window Down")
map("n", "<C-k>", "<C-w>k", opts, "Window Up")
map("n", "<C-l>", "<C-w>l", opts, "Window Right")

-- LSP References Jumping
map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, opts, "Next Reference")
map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, opts, "Previous Reference")

-- Jump List Navigation
map("n", "<leader>]]", "<C-i>", opts, "Jump to Next Location")
map("n", "<leader>[[", "<C-o>", opts, "Jump to Previous Location")


vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Motion (Hop)
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection

    map('', '<leader>hw', function() hop.hint_words() end, opts)
    map('', '<leader>hc', function() hop.hint_char1() end, opts)
    map('', '<leader>h2', function() hop.hint_char2() end, opts)
    map('', '<leader>ha', function() hop.hint_patterns() end, opts)
    map('', '<leader>hf', function() hop.hint_char1({direction = directions.AFTER_CURSOR}) end, opts)
    map('', '<leader>hF', function() hop.hint_char1({direction = directions.BEFORE_CURSOR}) end, opts)
  end
})

