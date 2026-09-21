return {
  {
    "github/copilot.vim",
    -- Se carga al entrar en insert o al invocar el comando/keybind,
    -- pero NO sugiere nada hasta que tú lo actives a mano (ver init).
    event = "InsertEnter",
    cmd = "Copilot",
    keys = {
      {
        "<Leader>ap",
        function()
          -- toggle de las sugerencias de Copilot
          local on = vim.g.copilot_enabled ~= false and vim.g.copilot_enabled ~= 0
          if on then
            vim.g.copilot_enabled = false
            vim.cmd "Copilot disable"
            vim.notify("Copilot: sugerencias DESACTIVADAS", vim.log.levels.WARN, { title = "Copilot" })
          else
            vim.g.copilot_enabled = true
            vim.cmd "Copilot enable"
            vim.notify("Copilot: sugerencias ACTIVADAS", vim.log.levels.INFO, { title = "Copilot" })
          end
        end,
        desc = "Toggle Copilot (sugerencias)",
      },
    },
    init = function()
      vim.g.copilot_enabled = false
      -- Dejar que blink.cmp maneje <Tab> (Copilot acepta con <C-j>)
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
    end,
    config = function()
      -- <C-j> para aceptar sugerencia de Copilot (solo si lo activaste antes)
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
    end,
  },
}
