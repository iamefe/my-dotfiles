-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "oxocarbon", -- @author: Efe - My fovorite is oxocarbon

  changed_themes = {
    oxocarbon = {
      base_16 = {
        base00 = "#000000",
      },
      base_30 = {
        black = "#000000",
      },
    },
  },

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },

  tabufline = {
    enabled = false,
    --  more opts
    order = { "buffers", "tabs", "btns" },
    -- order = { "treeOffset", "buffers", "tabs", "btns"} -- Default table
  },

  statusline = {
    theme = "vscode", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "default",
    order = nil,
    modules = nil,
  },

  telescope = { style = "bordered" },

  nvdash = {
    load_on_startup = true,

    header = {

      " ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗██╗",
      "██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝██║",
      "██║     ██████╔╝█████╗  ███████║   ██║   █████╗  ██║",
      "██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝  ╚═╝",
      "╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗██╗",
      " ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝",
    },

    buttons = {
      { "⌘  Config Files *", "Spc s c", "OpenNvChadConfig" },

      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },
}
return M
