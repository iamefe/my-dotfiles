require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map("n", ";fb", ":Telescope file_browser<CR>")

-- Select mode
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all contents of a file in normal mode" })

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Save in normal, insert and visual modes
-- map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Escape>", opts)

-- Save as untitled.txt.
-- If the file was already saved: Saves as copy without switching the document in the buffer to the copy.
-- map({ "n", "i", "v" }, "<C-n>", ":saveas", opts)

-- Save file (saves existing files normally and saves new files also)
map({ "n", "i", "v" }, "<C-s>", function()
  local current_file = vim.fn.expand "%:p"

  -- Remove trailing whitespace
  vim.cmd ":%s/\\s\\+$//e"
  vim.cmd "nohlsearch" -- Clear search highlight

  if current_file == "" then
    local timestamp = os.date "%Y%m%d_%H%M%S"
    local new_filename = vim.fn.getcwd() .. "/untitled_" .. timestamp .. ".txt"
    vim.cmd("saveas " .. vim.fn.fnameescape(new_filename))
  else
    vim.cmd "w!"
  end

  -- Check if currently in insert mode and exit it
  if vim.fn.mode() == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", false)
  end
end, opts)

-- Quit (prompts you to save)
-- map("n", "<Leader>q", ":quit<Return>", opts)

-- Quit (discards unsaved changes)
-- map("n", "<Leader>Q", ":qa!<Return>", opts)

-- Delete tab (ie. buffer)
map("n", "<Leader>X", ":bd<CR>", opts)

-- Remove trailing white spaces
map("n", "<Leader>ts", ":%s/\\s\\+$//e<CR>", opts)

-- Split window
map("n", "<Leader>ss", ":split<Return>", opts)
map("n", "<Leader>sv", ":vsplit<Return>", opts)

-- Telescope emoji
map("n", "<Leader>e", ":Telescope emoji<Return>", opts)
map("i", "<C-M-e>", "<cmd>Telescope emoji<Return>", opts)

-- Lsp Hover Doc Scrolling
map({ "n", "i", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { silent = true, expr = true })

-- Noice
map("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })
map("n", "<Leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dimiss Noice message" })
map({ "n", "i", "s" }, "<c-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-b>"
  end
end, { silent = true, expr = true })

-- Lazy
map("n", "<Leader>l", ":Lazy<CR>", opts)

-- Telescope keymaps
map("n", "<Leader>km", ":Telescope keymaps<CR>", { noremap = true, silent = true })

-- Open Telescope
map("n", "<Leader>t", ":Telescope<CR>", { noremap = true, silent = true })

-- Duplicate the current line in normal mode
map("n", "<Leader>d", "yyp", opts)

-- @author: Efe Ativie
-- START: Custom command for opening NvChad config directory

local autocmd = vim.api.nvim_create_autocmd

-- Define the custom function to open NvChad config in Telescope
local function open_nvchad_config()
  local telescope = require "telescope"
  local function get_nvim_config_dir()
    return vim.fn.expand "~/.config/nvim"
  end
  telescope.extensions.file_browser.file_browser {
    path = get_nvim_config_dir(),
    cwd = get_nvim_config_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = {
      height = 20,
    },
    prompt_title = "Config Files",
  }
end

-- Create an augroup for the custom command
local augroup = vim.api.nvim_create_augroup("CustomCommands", { clear = true })

-- Create the custom autocmd
autocmd("User", {
  pattern = "OpenNvChadConfig",
  group = augroup,
  callback = open_nvchad_config,
})

-- Create the custom command to call the autocmd
vim.api.nvim_create_user_command("OpenNvChadConfig", function()
  vim.api.nvim_exec_autocmds("User", { pattern = "OpenNvChadConfig" })
end, { nargs = 0 })

-- Set the keymap to call the custom command
vim.api.nvim_set_keymap("n", "<Leader>sc", ":OpenNvChadConfig<CR>", opts)

-- END: Custom command for opening NvChad config directory

-- Print working directory
map("n", ";p", ":pwd<CR>", opts)

-- INSTRUCTIONS
-- Open commandline prepopulated with word for replacement
-- In normal mode: Take the word under the cursor
-- In visual mode: Take the highlighted text (supports both single and multi-line selections)
-- Open the command line with :%s/your_text/ pre-filled, letting you type the replacement and add flags like g and c

-- Replace word under cursor or visual selection
local function replace_text()
  local mode = vim.api.nvim_get_mode().mode
  local text = ""

  if mode == "n" then
    -- Get word under cursor in normal mode
    text = vim.fn.expand "<cword>"
  else
    -- Get visual selection using built-in functionality
    local saved_reg = vim.fn.getreg '"'
    vim.cmd "noau normal! y"
    text = vim.fn.getreg '"'
    vim.fn.setreg('"', saved_reg)
  end

  -- Setup the replacement command - using concatenation instead of string.format
  local cmd = ":%s/" .. text .. "/change_me/c"

  -- Open command line with partial command
  vim.api.nvim_feedkeys(cmd, "n", false)
end

-- Set up the mappings
map("n", "<leader>sr", replace_text, { desc = "Replace word under cursor" })
map("v", "<leader>sr", replace_text, { desc = "Replace visual selection" })
