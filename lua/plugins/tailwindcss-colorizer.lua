return {
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    lazy = true,
    opts = {
      color_square_width = 2,
    },
    config = function(_, opts)
      require("tailwindcss-colorizer-cmp").setup(opts)
    end,
  },
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
        tailwind = true,
        mode = "background",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
}
