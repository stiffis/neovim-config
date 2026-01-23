-- Auto-cambio de colorscheme basado en archivo
-- Este archivo vigila ~/.config/nvim/current-theme.txt
-- y cambia el colorscheme automáticamente cuando detecta cambios

local theme_file = vim.fn.expand("~/.config/nvim/current-theme.txt")

-- Función para leer y aplicar el tema
local function apply_theme_from_file(silent)
  -- Verificar si el archivo existe
  if vim.fn.filereadable(theme_file) == 0 then
    return
  end

  -- Leer el tema del archivo
  local ok, lines = pcall(vim.fn.readfile, theme_file)
  if not ok or #lines == 0 then
    return
  end

  local theme = vim.trim(lines[1])
  
  -- Cambiar colorscheme si es válido
  if theme ~= "" then
    local success = pcall(vim.cmd.colorscheme, theme)
    -- Solo notificar si NO es silencioso y hubo éxito
    if success and not silent then
      vim.notify("Tema cambiado a: " .. theme, vim.log.levels.INFO)
    end
  end
end

-- Aplicar tema al iniciar Neovim (esperar a que lazy.nvim cargue los plugins)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    -- Esperar un poco más para asegurar que los temas estén cargados
    -- Pasar 'true' para que sea silencioso (sin notify al inicio)
    vim.defer_fn(function() apply_theme_from_file(true) end, 50)
  end,
  desc = "Aplicar tema después de que lazy.nvim cargue los plugins"
})

-- Crear autocmd para detectar cambios en el archivo
vim.api.nvim_create_autocmd({"FileChangedShellPost"}, {
  pattern = theme_file,
  callback = apply_theme_from_file,
  desc = "Auto-cambiar colorscheme cuando cambia current-theme.txt"
})

-- También vigilar cambios cada cierto tiempo (fallback)
local timer = vim.loop.new_timer()
local last_theme = ""

timer:start(1000, 2000, vim.schedule_wrap(function()
  if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if #lines > 0 then
      local current = vim.trim(lines[1])
      if current ~= last_theme and current ~= "" then
        last_theme = current
        pcall(vim.cmd.colorscheme, current)
      end
    end
  end
end))

return {}
