-- @author: Efe Ativie
-- If you install a plugin that comes by default with NvChad, note that there's no telling which configuration will
-- not be carried over so be prepared to copy and paste all of the configurations for that plugin from NvChad's official repo
-- https://github.com/NvChad/NvChad/tree/v2.5
-- You should also check for the current version or the version you are using. The example above is for v2.5
return {

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  -- Move any selection in any direction with Alt + hjkl
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {},
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {},
  },

  -- Comments
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = true,
  },

  -- NvimTree
  -- Set enabled to true and run LazySync if you want to download and use NvimTree alongside the File browser
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    lazy = false,
    config = function()
      require("nvim-tree").setup {
        on_attach = function(bufnr)
          local api = require "nvim-tree.api"

          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          vim.keymap.set("n", "t", api.node.open.tab, opts "Tab")
          -- vim.cmd [[
          --     :hi NvimTreeNormal guibg=#011627,
          --     :hi NvimTreeNormalFloat guibg=#011627,
          --     :hi NvimTreeNormalNC guibg=#011627
          --   ]]
        end,

        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        filesystem_watchers = {
          enable = true,
        },
        actions = {
          open_file = {
            quit_on_open = true,
            resize_window = true,
          },
        },
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          adaptive_size = true,
          side = "left",
          width = 35,
          relativenumber = false,
          preserve_window_proportions = true,
        },
        git = {
          enable = true,
          ignore = false,
        },
        renderer = {
          group_empty = true,
          root_folder_label = false,
          indent_markers = {
            enable = true,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },

            glyphs = {
              default = "󰈚",
              symlink = "",
              folder = {
                default = "",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
                symlink_open = "",
                arrow_open = "",
                arrow_closed = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "❆", -- Customized by Efe
              },
            },
          },
        },
        filters = {
          custom = {
            "node_modules/.*",
          },
        },
        log = {
          enable = true,
          truncate = true,
          types = {
            diagnostics = true,
            git = true,
            profile = true,
            watcher = true,
          },
        },
      }
    end,
  },

  -- Format on save
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      -- Import the configurations from the conform.lua file in the configs directory
      require "configs.conform"
    end,
  },

  -- Incremental rename
  -- {
  --   "smjonas/inc-rename.nvim",
  --   cmd = "IncRename",
  --   keys = {
  --     {
  --       "<leader>ri",
  --       function()
  --         return ":IncRename " .. vim.fn.expand "<cword>"
  --       end,
  --       desc = "Incremental rename",
  --       mode = "n",
  --       noremap = true,
  --       expr = true,
  --     },
  --   },
  --   config = true,
  -- },

  -- LazyGit integration with Telescope
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      {
        ";c",
        ":LazyGit<Return>",
        silent = true,
        noremap = true,
      },
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension "lazygit"
    end,
  },

  -- Filename
  {
    "b0o/incline.nvim",
    enabled = true,
    lazy = false,
    dependencies = {},
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local helpers = require "incline.helpers"
      require("incline").setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local buffer = {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#363944",
          }
          return buffer
        end,
      }
    end,
  },

  -- Messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        lsp = {
          hover = {
            enabled = false,
            silent = true, -- set to true to not show a message if hover is not available
            view = nil, -- when nil, use defaults from documentation
            opts = {}, -- merged with defaults from documentation
          },
          signature = {
            enabled = false,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },

        opts = function(_, opts)
          table.insert(opts.routes, {
            filter = {
              event = "notify",
              find = "No information available",
            },
            opts = { skip = true },
          })
          local focused = true
          vim.api.nvim_create_autocmd("FocusGained", {
            callback = function()
              focused = true
            end,
          })
          vim.api.nvim_create_autocmd("FocusLost", {
            callback = function()
              focused = false
            end,
          })
          table.insert(opts.routes, 1, {
            filter = {
              cond = function()
                return not focused
              end,
            },
            view = "notify_send",
            opts = { stop = false },
          })

          opts.commands = {
            all = {
              -- options for the message history that you get with `:Noice`
              view = "split",
              opts = { enter = true, format = "details" },
              filter = {},
            },
          }

          opts.presets.lsp_doc_border = true
        end,
      }
    end,
  },

  -- Notify
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
      background_colour = "#000000",
      render = "wrapped-compact",
      top_down = false,
    },
  },

  -- Code completion
  {
    "nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- Language servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- Telescope emojis
  {
    "xiyaowong/telescope-emoji.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local telescope = require "telescope"
      telescope.setup {
        extensions = {
          emoji = {
            action = function(emoji)
              -- argument emoji is a table.
              -- {name="", value="", cagegory="", description=""}

              vim.fn.setreg("+", emoji.value)
              -- print([[Press p or "*p to paste this emoji]] .. emoji.value)

              -- insert emoji when picked
              vim.api.nvim_put({ emoji.value }, "c", false, true)

              -- Return to insert mode after inserting the emoji
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("i", true, false, true), "n", false)
              --Move the cursor one step forward
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
            end,
          },
        },
      }
      require("telescope").load_extension "emoji"
    end,
  },

  -- Install Mason
  {
    "williamboman/mason.nvim",
    opts = {},
  },

  -- -- Zoxide
  -- {
  --   "jvgrootveld/telescope-zoxide",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   config = function()
  --     local telescope = require "telescope"
  --     telescope.setup {
  --       extensions = {
  --         zoxide = {
  --           prompt_title = "[ Recent folders ]",
  --           {
  --             mappings = {
  --               ["<C-b>"] = {
  --                 keepinsert = true,
  --                 action = function(selection)
  --                   require("telescope").extensions.file_browser.file_browser { cwd = selection.path }
  --                 end,
  --               },
  --             },
  --           },
  --         },
  --       },
  --     }
  --     require("telescope").load_extension "zoxide"
  --     vim.keymap.set("n", "<leader>cd", telescope.extensions.zoxide.list)
  --   end,
  -- },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "bash",
        "csv",
        "dart",
        "gitignore",
        "http",
        "python",
        "prisma",
        "rust",
        "scss",
        "solidity",
        "svelte",
        "sql",
        "graphql",
        "regex",
        "markdown",
        "markdown_inline",
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
  },

  -- Telescope
  {
    "telescope.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "folke/noice.nvim",
      "jvgrootveld/telescope-zoxide",
    },
    keys = {
      {
        "ff",
        function()
          local builtin = require "telescope.builtin"
          builtin.find_files {
            no_ignore = false,
            hidden = true,
            previewer = false,
            layout_config = { height = 24, width = 84 },
          }
        end,
        desc = "Lists files in your current working directory, respects .gitignore",
      },
      {
        ";w",
        function()
          local builtin = require "telescope.builtin"
          builtin.spell_suggest {
            layout_config = { height = 24, width = 84 },
          }
        end,
        desc = "Lists spelling suggestions for the current word under the cursor",
      },

      {
        ";r",
        function()
          local builtin = require "telescope.builtin"
          builtin.oldfiles {
            previewer = false,
            layout_config = { height = 24, width = 84 },
            prompt_title = "Recent Files",
          }
        end,
        desc = "List recent files",
      },
      {
        "lg",
        function()
          local builtin = require "telescope.builtin"
          builtin.live_grep()
        end,
        desc = "Search for a string in your current working directory",
      },
      {
        ";f",
        function()
          local builtin = require "telescope.builtin"
          builtin.current_buffer_fuzzy_find()
        end,
        desc = "Search for a string in your current buffer",
      },
      {
        "sb",
        function()
          local builtin = require "telescope.builtin"
          builtin.buffers {
            previewer = false,
            layout_config = { height = 24, width = 84 },
            prompt_title = "Tabs",
          }
        end,
        desc = "Lists open buffers",
      },
      {
        ";;",
        function()
          local builtin = require "telescope.builtin"
          builtin.resume()
        end,
        desc = "Resume the previous telescope picker",
      },
      {
        ";e",
        function()
          local builtin = require "telescope.builtin"
          builtin.diagnostics()
        end,
        desc = "Lists Diagnostics for all open buffers or a specific buffer",
      },
      {
        ";s",
        function()
          local builtin = require "telescope.builtin"
          builtin.treesitter()
        end,
        desc = "Lists Function names, variables, from Treesitter",
      },
      {
        ";z",
        function()
          local telescope = require "telescope"
          local actions = require "telescope.actions"
          local action_state = require "telescope.actions.state"
          local pickers = require "telescope.pickers"
          local finders = require "telescope.finders"
          local conf = require("telescope.config").values

          -- Define an icon for directories
          local dir_icon = "" -- Folder icon (Nerd Font required)

          -- Set custom highlight for folder icon
          vim.api.nvim_set_hl(0, "TelescopeFolderIcon", { fg = "#61afef" }) -- Set color (blue)

          -- Get recent directories from zoxide
          local handle = io.popen "zoxide query -l"
          local result = handle:read "*a"
          handle:close()

          -- Convert output into a table with icons
          local paths = {}
          for path in result:gmatch "[^\r\n]+" do
            table.insert(paths, { icon = dir_icon, path = path })
          end

          if #paths == 0 then
            print "No recent directories found."
            return
          end

          -- Show a Telescope picker for selecting a directory with icons
          pickers
            .new({}, {
              prompt_title = "Recent Directories",
              finder = finders.new_table {
                results = paths,
                entry_maker = function(entry)
                  return {
                    value = entry.path,
                    -- Add icon to display
                    display = entry.icon .. "    " .. entry.path,
                    ordinal = entry.path,
                    -- Highlight the whole entry (icon + path)
                    -- This applies the 'TelescopeFolderIcon' highlight to both the icon and the path
                    highlight = "TelescopeFolderIcon",
                  }
                end,
              },
              sorter = conf.generic_sorter {},
              attach_mappings = function(prompt_bufnr, map)
                local function open_selected()
                  local selection = action_state.get_selected_entry()
                  if selection then
                    actions.close(prompt_bufnr)

                    -- Change the current working directory
                    vim.api.nvim_set_current_dir(selection.value)

                    -- Extract only the directory name
                    local dir_name = vim.fn.fnamemodify(selection.value, ":t")
                    print("Changed workspace to " .. '"' .. dir_name .. '"')

                    -- Open Telescope File Browser with full theming
                    telescope.extensions.file_browser.file_browser {
                      cwd = selection.value,
                      path = selection.value,
                      respect_gitignore = false,
                      hidden = true,
                      grouped = true,
                      previewer = false,
                      initial_mode = "normal",
                      layout_config = { height = 24, width = 84 },
                    }
                  end
                end

                map("i", "<CR>", open_selected)
                map("n", "<CR>", open_selected)

                return true
              end,
              previewer = false,
              initial_mode = "normal",
              layout_config = { height = 24, width = 84 },
            })
            :find()
        end,
        desc = "Browse recent directories with icons and themes",
      },
      {
        "fb",
        function()
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
            layout_config = { height = 24, width = 84 },
          }
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
      {
        "sc",
        function()
          local telescope = require "telescope"

          local function get_nvim_config_dir()
            return vim.fn.expand "~/.config/nvim"
          end

          telescope.extensions.file_browser.file_browser {
            path = get_nvim_config_dir(),
            cwd = get_nvim_config_dir(),
            respect_gitignore = true,
            follow_symlinks = true,
            -- select_buffer = true,
            hidden = false,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 24, width = 84 },
            prompt_title = "Config Files",
          }
        end,

        desc = "NvChad config directory",
      },
    },
    config = function(_, opts)
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        notify = {
          enable = false,
        },
        prompt_prefix = " ⌘    ",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          follow_symlinks = true,
          previewer = false,
          dir_icon = "",
          display_stat = {},
          quiet = true,
          -- hide_parent_dir = true,
          depth = 1,
          mappings = {
            -- your custom insert mode mappings
            ["n"] = {
              -- your custom normal mode mappings
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            },
          },
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension "fzf"
      require("telescope").load_extension "file_browser"
      require("telescope").load_extension "noice"
      require("telescope").load_extension "zoxide"

      -- Remove title background and change title text color to white
      vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "NONE", fg = "white" })
      vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = "NONE", fg = "white" })
      vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "NONE", fg = "white" })
    end,
  },
}
