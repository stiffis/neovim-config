-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- FIX compatibilidad CLI: la branch `master` de nvim-treesitter quedó
    -- archivada y sigue pasando el flag obsoleto `--no-bindings` a
    -- `tree-sitter generate`, que el CLI moderno (>= 0.24.4) ya no acepta.
    -- Pre-definimos los args sin ese flag para que CUALQUIER parser que se
    -- genere desde grammar.js (latex, etc.) compile bien. Ver install.lua:361.
    require("nvim-treesitter.install").ts_generate_args =
      { "generate", "--abi", vim.treesitter.language_version }

    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "go",
      "python",
      "c",
      "cpp",
      "javascript",
      "typescript",
      "tsx",
      "json",
      "yaml",
      "markdown",
      "html",
      "css",
      "java",
      "latex",
      "bash",
      "typst",
      "regex",
    })
  end,
}
