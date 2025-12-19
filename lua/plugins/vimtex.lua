--return {
--  {
--    "lervag/vimtex",
--    lazy = false, -- we don't want to lazy load VimTeX
--    -- tag = "v2.15", -- uncomment to pin to a specific release
--    init = function()
--      -- Core VimTeX options
--      vim.g.tex_flavor = "latex"
--
--      -- PDF viewer (Linux)
--      vim.g.vimtex_view_method = "zathura"
--
--      -- Compiler: prefer latexrun if present, otherwise latexmk (more common)
--      if vim.fn.executable "latexrun" == 1 then
--        vim.g.vimtex_compiler_method = "latexrun"
--      else
--        vim.g.vimtex_compiler_method = "latexmk"
--      end
--
--      -- The following is the relevant part for viewen formulas
--      vim.g.vimtex_conceal_enabled = 1
--      vim.opt.conceallevel = 2
--      vim.opt.concealcursor = "nc"
--      vim.g.vimtex_conceal_subscripts = 1
--      vim.g.vimtex_conceal_superscripts = 1
--      vim.g.vimtex_conceal_fracs = 1
--      vim.g.vimtex_conceal_delims = 1
--      vim.g.vimtex_conceal_greek = 1
--      -- Make backslash-based mappings work in TeX buffers
--      -- - Set buffer-local localleader to "\\"
--      -- - Remove the global "\\" split mapping only for TeX buffers to avoid conflicts
--      vim.api.nvim_create_autocmd("FileType", {
--        pattern = { "tex", "plaintex", "latex" },
--        callback = function(ev)
--          -- use "\\ll" etc. inside TeX buffers
--          vim.b[ev.buf].maplocalleader = "\\"
--          -- drop the AstroNvim global "\\" mapping (Horizontal Split) only in this buffer
--          pcall(vim.keymap.del, "n", "\\", { buffer = ev.buf })
--        end,
--      })
--    end,
--  },
--}
--

return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"

      if vim.fn.executable "latexrun" == 1 then
        vim.g.vimtex_compiler_method = "latexrun"
      else
        vim.g.vimtex_compiler_method = "latexmk"
      end

      vim.g.vimtex_conceal_enabled = 1
      vim.opt.conceallevel = 2
      vim.opt.concealcursor = "nc"
      vim.g.vimtex_conceal_subscripts = 1
      vim.g.vimtex_conceal_superscripts = 1
      vim.g.vimtex_conceal_fracs = 1
      vim.g.vimtex_conceal_delims = 1
      vim.g.vimtex_conceal_greek = 1

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "plaintex", "latex" },
        callback = function(ev)
          vim.b[ev.buf].maplocalleader = "\\"
          pcall(vim.keymap.del, "n", "\\", { buffer = ev.buf })
        end,
      })
    end,
  },
}
