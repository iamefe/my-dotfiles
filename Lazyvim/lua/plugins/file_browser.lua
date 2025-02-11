return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },

    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = telescope.extensions.file_browser.actions
      local builtin = require("telescope.builtin")

      -- Common configuration for all pickers
      local base_config = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        layout_config = { height = 24, width = 84, prompt_position = "top" },
        -- layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        winblend = 0,
        path_display = { "tail" },
      }

      -- Additional common config for file browsers
      local file_browser_base = vim.tbl_extend("force", base_config, {
        grouped = true,
        depth = 1,
        display_stat = {},
        quiet = true,
        follow_symlinks = true,
        respect_gitignore = false,
        hidden = true,
      })

      -- File browser specific mappings
      local file_browser_mappings = {
        ["n"] = {
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["<C-u>"] = function(prompt_bufnr)
            for _ = 1, 10 do
              actions.move_selection_previous(prompt_bufnr)
            end
          end,
          ["<C-d>"] = function(prompt_bufnr)
            for _ = 1, 10 do
              actions.move_selection_next(prompt_bufnr)
            end
          end,
        },
      }

      -- Functions to show different pickers
      local function show_file_browser()
        local cwd = vim.fn.expand("%:p:h")
        local config = vim.tbl_extend("force", file_browser_base, {
          path = "%:p:h",
          cwd = cwd,
          mappings = file_browser_mappings,
          results_title = "",
        })
        telescope.extensions.file_browser.file_browser(config)
      end

      local function show_config()
        local config_dir = vim.fn.expand("~/.config/nvim")
        local config = vim.tbl_extend("force", file_browser_base, {
          path = config_dir,
          cwd = config_dir,
          prompt_title = "Config Files",
          results_title = "",
        })
        telescope.extensions.file_browser.file_browser(config)
      end

      local function show_buffers()
        local config = vim.tbl_extend("force", base_config, {
          prompt_title = "Tabs",
          results_title = "",
        })
        builtin.buffers(config)
      end

      -- Commands and keymaps
      local commands_and_maps = {
        { cmd = "FileBrowser", key = ";fb", fn = show_file_browser, desc = "Find contents of the cwd" },
        { cmd = "ConfigBrowser", key = ";sc", fn = show_config, desc = "Show config directory contents" },
        { cmd = "ShowBuffers", key = ";sb", fn = show_buffers, desc = "Show open buffers" },
      }

      -- Set up commands and keymaps
      for _, item in ipairs(commands_and_maps) do
        vim.api.nvim_create_user_command(item.cmd, item.fn, {})
        vim.keymap.set("n", item.key, item.fn, { desc = item.desc })
      end

      -- Set highlights
      local highlights = {
        TelescopePromptTitle = { bg = "NONE", fg = "white" },
        TelescopeResultsTitle = { bg = "NONE", fg = "white" },
        TelescopePreviewTitle = { bg = "NONE", fg = "white" },
        TelescopePromptNormal = { bg = "NONE" },
        TelescopePromptBorder = { bg = "NONE" },
        TelescopeResultsNormal = { bg = "NONE" },
        TelescopeResultsBorder = { bg = "NONE" },
        TelescopePreviewNormal = { bg = "NONE" },
        TelescopePreviewBorder = { bg = "NONE" },
      }

      for hl_group, colors in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl_group, colors)
      end
    end,
  },
}
