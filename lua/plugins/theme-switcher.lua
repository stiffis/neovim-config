local theme_file = vim.fn.expand("~/.config/nvim/current-theme.txt")
local background_file = vim.fn.expand("~/.config/nvim/current-background.txt")

local function apply_theme_from_file(silent)
  if vim.fn.filereadable(theme_file) == 0 then
    return
  end

  local ok, lines = pcall(vim.fn.readfile, theme_file)
  if not ok or #lines == 0 then
    return
  end

  local theme = vim.trim(lines[1])
  
  if vim.fn.filereadable(background_file) == 1 then
    local bg_lines = vim.fn.readfile(background_file)
    if #bg_lines > 0 then
      local bg = vim.trim(bg_lines[1])
      if bg == "light" or bg == "dark" then
        vim.o.background = bg
      end
    end
  end
  
  if theme ~= "" then
    local success = pcall(vim.cmd.colorscheme, theme)
    if success and not silent then
      vim.notify("Tema cambiado a: " .. theme .. " (" .. vim.o.background .. ")", vim.log.levels.INFO)
    end
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.defer_fn(function() apply_theme_from_file(true) end, 50)
  end,
  desc = "Aplicar tema después de que lazy.nvim cargue los plugins"
})

vim.api.nvim_create_autocmd({"FileChangedShellPost"}, {
  pattern = {theme_file, background_file},
  callback = apply_theme_from_file,
  desc = "Auto-cambiar colorscheme cuando cambia current-theme.txt o current-background.txt"
})

local timer = vim.loop.new_timer()
local last_theme = ""
local last_bg = ""

timer:start(1000, 2000, vim.schedule_wrap(function()
  if vim.fn.filereadable(theme_file) == 1 then
    local lines = vim.fn.readfile(theme_file)
    if #lines > 0 then
      local current = vim.trim(lines[1])
      
      local current_bg = vim.o.background
      if vim.fn.filereadable(background_file) == 1 then
        local bg_lines = vim.fn.readfile(background_file)
        if #bg_lines > 0 then
          current_bg = vim.trim(bg_lines[1])
        end
      end
      
      if (current ~= last_theme or current_bg ~= last_bg) and current ~= "" then
        last_theme = current
        last_bg = current_bg
        if current_bg == "light" or current_bg == "dark" then
          vim.o.background = current_bg
        end
        pcall(vim.cmd.colorscheme, current)
      end
    end
  end
end))

return {}
