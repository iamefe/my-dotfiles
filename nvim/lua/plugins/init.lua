-- @author: Efe Ativie
-- If you install a plugin that comes by default with NvChad, note that there's no telling which configuration will
-- not be carried over so be prepared to copy and paste all of the configurations for that plugin from NvChad's official repo
-- https://github.com/NvChad/NvChad/tree/v2.5
-- You should also check for the current version or the version you are using. The example above is for v2.5
return {

  -- NvimTree
  {
    "nvim-tree/nvim-tree.lua",
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
          adaptive_size = false,
          side = "right",
          width = 30,
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
                ignored = "❆",
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
      require "configs.conform"
    end,
  },

  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>ri",
        function()
          return ":IncRename " .. vim.fn.expand "<cword>"
        end,
        desc = "Incremental rename",
        mode = "n",
        noremap = true,
        expr = true,
      },
    },
    config = true,
  },

  -- Refactoring tool
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>rc",
        function()
          require("refactoring").select_refactor {
            show_success_message = true,
          }
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  -- LazyGit integration with Telescope
  {
    "kdheepak/lazygit.nvim",
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
      "nvim-lua/plenary.nvim",
    },
  },

  -- Filename
  {
    "b0o/incline.nvim",
    enabled = false,
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
            end,
          },
        },
      }
      require("telescope").load_extension "emoji"
    end,
  },

  -- Install language servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "typescript-language-server",
        "pyright",
        "clangd",
        "eslint-lsp",
        "rust-analyzer",
        "json-lsp",
      },
    },
  },

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

  {
    "telescope.nvim",
    priority = 1000,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "folke/noice.nvim",
    },
    keys = {
      {
        ";f",
        function()
          local builtin = require "telescope.builtin"
          builtin.find_files {
            no_ignore = false,
            hidden = true,
          }
        end,
        desc = "Lists files in your current working directory, respects .gitignore",
      },
      {
        ";r",
        function()
          local builtin = require "telescope.builtin"
          builtin.live_grep()
        end,
        desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
      },
      {
        "\\\\",
        function()
          local builtin = require "telescope.builtin"
          builtin.buffers()
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
        "sf",
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
            initial_mode = "insert",
            layout_config = { height = 40 },
          }
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
    },
    config = function(_, opts)
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
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
    end,
  },
}
