-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- El tema lo manda theme-switcher vía current-theme.txt. Lo leemos aquí para
-- que AstroNvim pinte el tema correcto UNA sola vez al arrancar (sin parpadeo).
local theme = require("theme_state").read()
if theme.bg then vim.o.background = theme.bg end

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- colorscheme inicial leído del archivo (fallback: kanagawa)
    colorscheme = theme.theme,
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = function() -- this function overrides highlights in all themes
        local normal = require("astroui").get_hlgroup "Normal"
        local dark = vim.o.background == "dark"
        local bg = type(normal.bg) == "number" and normal.bg or (dark and 0x1e1e1e or 0xf5f5f5)
        local fg = type(normal.fg) == "number" and normal.fg or (dark and 0xd0d0d0 or 0x303030)
        local function mix(t)
          local out = 0
          for shift = 16, 0, -8 do
            local a, b = bit.band(bit.rshift(bg, shift), 0xff), bit.band(bit.rshift(fg, shift), 0xff)
            out = out + bit.lshift(math.floor(a + (b - a) * t + 0.5), shift)
          end
          return string.format("#%06x", out)
        end
        local get = require("astroui").get_hlgroup
        local tree = get("NeoTreeNormal", get "Normal")
        local fill = get("TabLineFill", get "Normal")
        local tab = get("TabLine", get "Normal")
        local overrides = {
          LineNr = { fg = mix(dark and 0.30 or 0.40) },
          CursorLineNr = { fg = mix(dark and 0.60 or 0.70) },
          LspInlayHint = { fg = mix(0.55), italic = true },
          SignColumn = { bg = "NONE" },
          NeoTreeTabActive = { fg = normal.fg, bg = tree.bg, bold = true },
          NeoTreeTabInactive = { fg = tab.fg, bg = fill.bg },
          NeoTreeTabSeparatorActive = { fg = tree.bg, bg = tree.bg },
          NeoTreeTabSeparatorInactive = { fg = fill.bg, bg = fill.bg },
        }
        local styles = {
          bold = { "Function", "@function", "@function.call", "@function.method", "@function.method.call", "@markup.strong" },
          italic = { "Comment", "@comment", "String", "@string", "@markup.italic" },
        }
        for style, groups in pairs(styles) do
          for _, group in ipairs(groups) do
            local hl = overrides[group] or require("astroui").get_hlgroup(group)
            if next(hl) then
              hl.bold, hl.italic = nil, nil
              hl[style] = true
              overrides[group] = hl
            end
          end
        end
        return overrides
      end,
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
