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

  if current_file == "" then
    local timestamp = os.date "%Y%m%d_%H%M%S"
    local new_filename = vim.fn.getcwd() .. "/untitled_" .. timestamp .. ".txt"
    vim.cmd("saveas " .. vim.fn.fnameescape(new_filename))
  else
    vim.cmd "w"
  end
end, opts)

-- Quit (prompts you to save)
-- map("n", "<Leader>q", ":quit<Return>", opts)

-- Quit (discards unsaved changes)
-- map("n", "<Leader>Q", ":qa!<Return>", opts)

-- Delete tab (ie. buffer)
map("n", "<Leader>X", ":bd<CR>", opts)

-- Split window
map("n", "<Leader>ss", ":split<Return>", opts)
map("n", "<Leader>sv", ":vsplit<Return>", opts)

-- Telescope emoji
map("n", "<Leader>e", ":Telescope emoji<Return>", opts)

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
