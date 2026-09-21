-- timelimit (plugin propio) — barra de "cuánto tiempo me queda" por línea.
--
-- Sintaxis en CUALQUIER línea de CUALQUIER archivo:
--   TIMELIMIT [2026-06-01] [2026-06-30]
--   TIMELIMIT [2026-06-01 09:00] [2026-06-16 18:00]   <- la hora es opcional
--
-- Al final de esa línea se dibuja: tiempo restante + barra de progreso, con
-- color que cambia según se acerca la fecha límite (verde → ámbar → rojo).

local ns = vim.api.nvim_create_namespace "timelimit"

-- ── Config ───────────────────────────────────────────────────────────────
local INNER_LEN = 26 -- ancho interno de la barra
local FILL_CHAR = "━"
local EMPTY_CHAR = " "
local LEFT_MARK = '"'
local RIGHT_MARK = '"'
local TICK_MS = 60 * 1000 -- refresco por reloj (la barra avanza sola con el tiempo)
local DEBOUNCE_MS = 150 -- antirebote por defecto al editar
local MAX_LINES = 100000 -- no escanear archivos gigantes

-- Grupos de resaltado propios. El color NO es fijo: se copia de los grupos
-- de diagnóstico del tema actual, así combina con cualquier colorscheme.
local HL_OK = "TimelimitOk"
local HL_WARN = "TimelimitWarn"
local HL_CRIT = "TimelimitCrit"

-- Devuelve el fg (resuelto) de un grupo del tema, o un fallback si no existe.
local function fg_of(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and hl and hl.fg then return hl.fg end
  return fallback
end

local function set_hl()
  -- DiagnosticOk a veces no está definido → caemos a Hint/String.
  local ok = fg_of("DiagnosticOk", fg_of("DiagnosticHint", fg_of("String", "#7CFF7C")))
  local warn = fg_of("DiagnosticWarn", fg_of("WarningMsg", "#FFD75F"))
  local crit = fg_of("DiagnosticError", fg_of("ErrorMsg", "#FF6B6B"))
  vim.api.nvim_set_hl(0, HL_OK, { fg = ok, bold = true })
  vim.api.nvim_set_hl(0, HL_WARN, { fg = warn, bold = true })
  vim.api.nvim_set_hl(0, HL_CRIT, { fg = crit, bold = true })
end
-- aplicar ya, y reaplicar tras cargar plugins (por si el tema llega tarde)
set_hl()
vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", once = true, callback = set_hl })

-- ── Utilidades ───────────────────────────────────────────────────────────
local function parse_date(s)
  s = vim.trim(s)
  local y, mo, d, h, mi = s:match "(%d+)%-(%d+)%-(%d+)%s+(%d+):(%d+)"
  if not y then y, mo, d = s:match "(%d+)%-(%d+)%-(%d+)" end
  if not (y and mo and d) then return nil end
  return os.time {
    year = tonumber(y),
    month = tonumber(mo),
    day = tonumber(d),
    hour = tonumber(h) or 0,
    min = tonumber(mi) or 0,
  }
end

local function clamp(p)
  if p < 0 then
    return 0
  elseif p > 1 then
    return 1
  else
    return p
  end
end

local function make_bar(p)
  p = clamp(p)
  local fill = math.floor(p * INNER_LEN + 0.5)
  return LEFT_MARK .. string.rep(FILL_CHAR, fill) .. string.rep(EMPTY_CHAR, INNER_LEN - fill) .. RIGHT_MARK
end

local function fmt_remaining(sec)
  if sec <= 0 then return "vencido" end
  local d = math.floor(sec / 86400)
  local h = math.floor((sec % 86400) / 3600)
  local m = math.floor((sec % 3600) / 60)
  if d > 0 then return string.format("%dd %dh", d, h) end
  if h > 0 then return string.format("%dh %dm", h, m) end
  return string.format("%dm", m)
end

local function hl_for(p)
  if p >= 0.9 then return HL_CRIT end
  if p >= 0.75 then return HL_WARN end
  return HL_OK
end

-- ── Render ───────────────────────────────────────────────────────────────
local function refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if vim.bo[bufnr].buftype ~= "" then return end -- solo buffers de archivo real
  if vim.api.nvim_buf_line_count(bufnr) > MAX_LINES then return end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local now = os.time()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    local a, b = line:match "TIMELIMIT%s*%[([^%]]+)%]%s*%[([^%]]+)%]"
    if a and b then
      local ts, te = parse_date(a), parse_date(b)
      if ts and te and te > ts then
        local pct = (now - ts) / (te - ts)
        local hl = hl_for(pct)
        vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
          virt_text = { { fmt_remaining(te - now) .. " ", hl }, { make_bar(pct), hl } },
          virt_text_pos = "right_align",
          hl_mode = "combine",
        })
      end
    end
  end
end

-- ── Antirebote por buffer (evita escanear en cada tecla) ──────────────────
local debounce = {}
local function schedule(bufnr, delay)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local t = debounce[bufnr]
  if not t then
    t = vim.uv.new_timer()
    debounce[bufnr] = t
  end
  t:stop()
  t:start(delay or DEBOUNCE_MS, 0, vim.schedule_wrap(function() refresh(bufnr) end))
end

-- ── Autocmds ──────────────────────────────────────────────────────────────
local group = vim.api.nvim_create_augroup("timelimit", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "BufEnter" }, {
  group = group,
  callback = function(a) schedule(a.buf, 30) end,
})
vim.api.nvim_create_autocmd("TextChanged", {
  group = group,
  callback = function(a) schedule(a.buf, 200) end,
})
vim.api.nvim_create_autocmd("TextChangedI", {
  group = group,
  callback = function(a) schedule(a.buf, 600) end, -- mientras escribes: rebote más largo
})
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = group,
  callback = function(a)
    local t = debounce[a.buf]
    if t then
      t:stop()
      t:close()
      debounce[a.buf] = nil
    end
  end,
})
-- reaplicar colores tras cambiar de tema (tienes theme-switcher)
vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_hl })

-- ── Reloj: solo refresca los buffers visibles en una ventana ──────────────
local timer = vim.uv.new_timer()
if timer then
  timer:start(
    TICK_MS,
    TICK_MS,
    vim.schedule_wrap(function()
      local seen = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local b = vim.api.nvim_win_get_buf(win)
        if not seen[b] then
          seen[b] = true
          refresh(b)
        end
      end
    end)
  )
end

return {}
