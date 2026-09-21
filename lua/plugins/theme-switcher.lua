local theme_state = require "theme_state"

-- Aplica el tema/fondo que estén ahora mismo en los archivos.
local function apply_theme_from_file(silent)
  local s = theme_state.read()
  if s.bg then vim.o.background = s.bg end
  local success = pcall(vim.cmd.colorscheme, s.theme)
  if success and not silent then
    vim.notify("Tema cambiado a: " .. s.theme .. " (" .. vim.o.background .. ")", vim.log.levels.INFO)
  end
end

-- NOTA: el pintado inicial del tema lo hace astroui.lua leyendo el mismo
-- archivo (evita el doble pintado/parpadeo del arranque). Aquí solo
-- gestionamos los cambios EN VIVO.

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = { theme_state.theme_file, theme_state.background_file },
  callback = function() apply_theme_from_file() end,
  desc = "Auto-cambiar colorscheme cuando cambia current-theme.txt o current-background.txt",
})

-- Detección por sondeo (TODO #6: migrar a vim.uv.fs_event).
-- Inicializamos last_* con el estado real para que el primer tick NO repinte
-- el tema que astroui ya aplicó al arrancar.
local initial = theme_state.read()
local last_theme = initial.theme
local last_bg = initial.bg or vim.o.background

local timer = vim.uv.new_timer()
timer:start(
  1000,
  2000,
  vim.schedule_wrap(function()
    local s = theme_state.read()
    local bg = s.bg or vim.o.background
    if (s.theme ~= last_theme or bg ~= last_bg) and s.theme ~= "" then
      last_theme = s.theme
      last_bg = bg
      if s.bg then vim.o.background = s.bg end
      pcall(vim.cmd.colorscheme, s.theme)
    end
  end)
)

return {}
