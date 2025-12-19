return {
  {
    "jbyuki/instant.nvim",
    lazy = true,
    cmd = {
      "InstantStartServer",
      "InstantStopServer",
      "InstantStartSession",
      "InstantJoinSession",
      "InstantStartSingle",
      "InstantJoinSingle",
      "InstantStatus",
    },
  },
  {
    "azratul/live-share.nvim",
    lazy = true,
    cmd = { "LiveShareServer", "LiveShareJoin" },
    dependencies = { "jbyuki/instant.nvim" },
    init = function()
      vim.g.instant_username = vim.env.USER or "ctiff"
    end,
    config = function()
      require("live-share").setup {
        port_internal = 9876,
        max_attempts = 40,
        service_url = "/tmp/service.url",
        service = "nokey@localhost.run",
      }
    end,
  },
}
