vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Author: Oserefemhen Ativie (alias: Efe)
-- Define a function to initialize and call the file browser
local function setup_file_browser()
  local telescope = require "telescope"

  local function telescope_buffer_dir()
    return vim.fn.expand "%:p:h"
  end

  telescope.extensions.file_browser.file_browser {
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 24 },
  }
end

-- Open Telescope File Browser when Neovim starts without arguments
-- Automatically call the setup function on VimEnter, but only if no files or arguments are provided
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check if no files or arguments are given ie. the if vim.fn.argc() == 0 condition
    -- ensures the file browser is only opened when Neovim starts without arguments
    -- (e.g., no vim .bashrc or vim some_directory).
    if vim.fn.argc() == 0 then
      setup_file_browser()
    end
  end,
  desc = "Open Telescope File Browser when Neovim starts without arguments",
})

vim.opt.clipboard:append "unnamedplus"
