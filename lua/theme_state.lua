-- Fuente de verdad del tema.
-- Lee current-theme.txt / current-background.txt y los comparte entre:
--   * astroui.lua       -> tema inicial al arrancar (un solo pintado)
--   * theme-switcher.lua -> cambios de tema en vivo
local M = {}

M.theme_file = vim.fn.expand "~/.config/nvim/current-theme.txt"
M.background_file = vim.fn.expand "~/.config/nvim/current-background.txt"
M.default_theme = "kanagawa"

local function read_first_line(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local line = f:read "l"
  f:close()
  if line then line = vim.trim(line) end
  if not line or line == "" then return nil end
  return line
end

--- Lee el estado actual del tema desde disco.
--- @return { theme: string, bg: string|nil }  bg es "light"/"dark" o nil
function M.read()
  local theme = read_first_line(M.theme_file) or M.default_theme
  local bg = read_first_line(M.background_file)
  if bg ~= "light" and bg ~= "dark" then bg = nil end
  return { theme = theme, bg = bg }
end

return M
