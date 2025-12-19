-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "latex",
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
    },
  },
}
