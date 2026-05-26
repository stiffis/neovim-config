return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      tex = { "latexindent" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      python = { "isort", "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      typst = { "typstyle" },
    },
    format_on_save = {
      timeout_ms = 3000, -- 1 segundo de tiempo límite (latexindent puede ser lento a veces)
      lsp_fallback = true,
    },
  },
}
