return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    cmd = "Copilot",
    init = function()
      -- Deshabilitar Tab para Copilot (dejar que blink.cmp lo maneje)
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
    config = function()
      -- <C-j> para aceptar sugerencia de Copilot
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
    end,
  },
}
