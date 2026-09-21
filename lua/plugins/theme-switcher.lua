local theme_state = require "theme_state"

local initial = theme_state.read()
local last_theme = initial.theme
local last_bg = initial.bg or vim.o.background

local function apply_if_changed()
  local s = theme_state.read()
  local bg = s.bg or vim.o.background
  if s.theme == "" or (s.theme == last_theme and bg == last_bg) then return end
  last_theme, last_bg = s.theme, bg
  if s.bg then vim.o.background = s.bg end
  pcall(vim.cmd.colorscheme, s.theme)
end

local watched = {
  [vim.fs.basename(theme_state.theme_file)] = true,
  [vim.fs.basename(theme_state.background_file)] = true,
}

local debounce = vim.uv.new_timer()
local watcher = vim.uv.new_fs_event()

if watcher and debounce then
  watcher:start(vim.fs.dirname(theme_state.theme_file), {}, function(err, filename)
    if err or not watched[filename] then return end
    debounce:stop()
    debounce:start(100, 0, vim.schedule_wrap(apply_if_changed))
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      watcher:stop()
      debounce:stop()
    end,
  })
end

return {}
