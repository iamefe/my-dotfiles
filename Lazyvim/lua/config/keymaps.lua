-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Select mode
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all contents of a file in normal mode" })

-- Save file (saves existing files normally and saves new files also)
map({ "n", "i", "v" }, "<C-s>", function()
  local current_file = vim.fn.expand("%:p")

  -- Remove trailing whitespace
  vim.cmd(":%s/\\s\\+$//e")

  if current_file == "" then
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local new_filename = vim.fn.getcwd() .. "/untitled_" .. timestamp .. ".txt"
    vim.cmd("saveas " .. vim.fn.fnameescape(new_filename))
  else
    vim.cmd("w!")
  end

  -- Check if currently in insert mode and exit it
  if vim.fn.mode() == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", false)
  end
  vim.cmd("nohlsearch") -- Clear search highlight
end, opts)

-- Duplicate the current line in normal mode
map("n", "<Leader>d", "yyp", opts)

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
    text = vim.fn.expand("<cword>")
  else
    -- Get visual selection using built-in functionality
    local saved_reg = vim.fn.getreg('"')
    vim.cmd("noau normal! y")
    text = vim.fn.getreg('"')
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

-- Telescope emoji
map("n", "<Leader>te", ":Telescope emoji<Return>", opts)
map("i", "<C-M-e>", "<cmd>Telescope emoji<Return>", opts)

map("n", ";lg", function()
  Snacks.lazygit()
end, { desc = "Lazygit (cwd)" })

-- Zoxide
map("n", ";z", ":FzfLua zoxide<CR>", opts)

-- Toggle buffer diagnostics --
local diagnostics_bufnr = nil

local function toggle_buffer_diagnostics()
  local bufname = "Diagnostics_" .. vim.api.nvim_get_current_buf()

  -- Check if the diagnostics window is already open. If so, close it.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if diagnostics_bufnr and vim.api.nvim_win_get_buf(win) == diagnostics_bufnr then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  -- Get diagnostics
  local diagnostics = vim.diagnostic.get(0)
  local lines = {}
  local severity_map = {
    [vim.diagnostic.severity.ERROR] = "E",
    [vim.diagnostic.severity.WARN] = "W",
    [vim.diagnostic.severity.INFO] = "I",
    [vim.diagnostic.severity.HINT] = "H",
  }

  for _, d in ipairs(diagnostics) do
    -- Truncate the message to a single line
    local message = d.message:gsub("\n", " ") -- Replace newlines with spaces
    local header = string.format("[%s] Line %d: %s", severity_map[d.severity] or "?", d.lnum + 1, message)
    table.insert(lines, header)
  end

  if #lines == 0 then
    -- Clear the diagnostics buffer if it exists and is visible.
    if diagnostics_bufnr and vim.api.nvim_buf_is_valid(diagnostics_bufnr) then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == diagnostics_bufnr then
          vim.api.nvim_buf_set_lines(diagnostics_bufnr, 0, -1, false, {}) -- Clear lines
          return -- Exit early, no need to create a new split
        end
      end
    end
    return -- No diagnostics and buffer doesn't exist or isn't visible, do nothing.
  end

  -- Create the buffer if it doesn't exist.
  if not diagnostics_bufnr or not vim.api.nvim_buf_is_valid(diagnostics_bufnr) then
    diagnostics_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(diagnostics_bufnr, bufname)
    vim.bo[diagnostics_bufnr].buftype = "nofile"
    vim.bo[diagnostics_bufnr].bufhidden = "wipe"
    vim.bo[diagnostics_bufnr].swapfile = false
  end

  -- Update buffer content
  vim.api.nvim_buf_set_lines(diagnostics_bufnr, 0, -1, false, lines)

  -- Open in a horizontal split at the bottom.
  -- Check if a window displaying the buffer already exists.
  local diagnostics_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == diagnostics_bufnr then
      diagnostics_win = win
      break
    end
  end

  if diagnostics_win then
    vim.api.nvim_win_set_current_win(diagnostics_win) -- Switch to existing window
  else
    vim.cmd("botright split") -- Use split instead of 'new'
    local new_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(new_win, diagnostics_bufnr)
    vim.wo[new_win].number = true
    vim.wo[new_win].wrap = true
    vim.cmd("resize 10")
  end

  -- Key mappings
  local options = { noremap = true, silent = true, buffer = diagnostics_bufnr }
  vim.keymap.set("n", "q", ":q<CR>", options)
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local diagnostic = diagnostics[line]
    if diagnostic then
      -- Jump to the diagnostic location without closing the split
      vim.api.nvim_set_current_win(vim.fn.bufwinid(0)) -- Focus the original window
      vim.api.nvim_win_set_cursor(0, { diagnostic.lnum + 1, diagnostic.col })
    end
  end, options)

  -- Mouse support
  vim.keymap.set("n", "<LeftRelease>", "<CR>", options)
end

-- Create command and keymap
vim.api.nvim_create_user_command("ToggleBufferDiagnostics", toggle_buffer_diagnostics, {})
vim.keymap.set("n", "<Leader>de", toggle_buffer_diagnostics, { desc = "Toggle buffer diagnostics" })
-- END: Toggle buffer diagnostics
