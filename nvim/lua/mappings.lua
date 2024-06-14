require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map("n", ";fb", ":Telescope file_browser<CR>")
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- map("n", ";fb", ":Telescope file_browser<CR>")
--
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all contents of a file in normal mode" })

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Save in insert mode
map("i", "<C-s>", "<ESC>:update<Return>", opts)

-- Quit
map("n", "<Leader>q", ":quit<Return>", opts)
map("n", "<Leader>Q", ":qa<Return>", opts)

-- Split window
map("n", "<Leader>ss", ":split<Return>", opts)
map("n", "<Leader>sv", ":vsplit<Return>", opts)

-- Telescope emoji
map("n", "<Leader>e", ":Telescope emoji<Return>", opts)

map("n", "<Leader>F", ":NvimTreeFindFile<Return>", opts)

map("n", "<Leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dimiss Noice message" })

map("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

-- Lsp Hover Doc Scrolling
map({ "n", "i", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { silent = true, expr = true })

map({ "n", "i", "s" }, "<c-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-b>"
  end
end, { silent = true, expr = true })

map("n", "<Leader>l", ":Lazy<CR>", opts)
