return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetypes = {
        "css",
        "scss",
        "sass",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
      },
      user_default_options = {
        tailwind = false,
        mode = "background",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
}
