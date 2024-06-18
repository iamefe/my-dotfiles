require "nvchad.mappings"

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- map("n", ";fb", ":Telescope file_browser<CR>")

-- Select mode
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all contents of a file in normal mode" })

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Save in normal, insert and visual modes
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", opts)

-- Quit
map("n", "<Leader>q", ":quit<Return>", opts)
map("n", "<Leader>Q", ":qa<Return>", opts)

-- Split window
map("n", "<Leader>ss", ":split<Return>", opts)
map("n", "<Leader>sv", ":vsplit<Return>", opts)

-- Telescope emoji
map("n", "<Leader>e", ":Telescope emoji<Return>", opts)

-- NvimTree
map("n", "<Leader>F", ":NvimTreeFindFile<Return>", opts)

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

-- Config
