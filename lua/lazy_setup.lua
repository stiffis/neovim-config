require("lazy").setup({
  {
    "andweeb/presence.nvim",
    event = "VeryLazy",
    opts = {
      debounce_timeout = 10,
      auto_update = true,
    },
    config = function(_, opts) require("presence").setup(opts) end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = {
      "CopilotChat",
      "CopilotChatAgents",
      "CopilotChatClose",
      "CopilotChatLoad",
      "CopilotChatModels",
      "CopilotChatOpen",
      "CopilotChatPrompts",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatStop",
      "CopilotChatToggle",
    },
    keys = {
      {
        "<leader>ac",
        function() vim.cmd "CopilotChat" end,
        desc = "Open Copilot Chat",
      },
    },
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function(_, opts) require("CopilotChat").setup(opts) end,
  },
  {
    "AstroNvim/AstroNvim",
    version = "^5",
    import = "astronvim.plugins",
    opts = {
      mapleader = " ",
      maplocalleader = ",",
      icons_enabled = true,
      pin_plugins = nil,
      update_notifications = true,
    },
  },
  { import = "community" },
  { import = "plugins" },
} --[[@as LazySpec]], {
  install = { colorscheme = { "catppuccin" } },
  ui = { backdrop = 100 },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
} --[[@as LazyConfig]])
