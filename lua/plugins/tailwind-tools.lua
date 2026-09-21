return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    document_color = {
      enabled = true,
      kind = "inline",
      inline_symbol = "󱓻 ",
      debounce = 200,
    },
    conceal = {
      enabled = false, -- Cámbialo a true si quieres ocultar las clases largas de Tailwind
      min_len = 25,
      symbol = "󱏿",
    },
  },
}
