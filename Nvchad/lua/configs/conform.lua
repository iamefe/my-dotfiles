local options = {
  require("conform").setup {

    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      bash = { "shfmt" },
      markdown = { "prettier" },
      jsx = { "prettier" },
      graphql = { "prettier" },
      json = { "prettier" },
      sql = { "sqlfmt" },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 50000,
      lsp_format = "fallback",
    },
    formatters = {
      rustfmt = {
        command = "rustfmt",
        args = { "--edition", "2021" }, -- adjust the edition as needed
      },
      prettier = {
        -- Prettier-specific options
        tab_width = "auto",
        use_tabs = "auto",
      },
    },
  },
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format { bufnr = args.buf }
    end,
  }),
}

return options
