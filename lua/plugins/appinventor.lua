return {
  {
    dir = "/home/stiff/appinventor.nvim",
    name = "appinventor.nvim",
    lazy = false,
    opts = {},
  },
  {
    "Saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.appinventor = {
        name = "App Inventor",
        module = "blink.cmp.sources.appinventor",
        score_offset = 100,
      }
      opts.sources.per_filetype = opts.sources.per_filetype or {}
      opts.sources.per_filetype.appinventor = { inherit_defaults = true, "appinventor" }
      opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
        enabled = true,
        trigger = {
          show_on_accept = true,
        },
        window = {
          border = "rounded",
          show_documentation = true,
        },
      })
    end,
  },
}
