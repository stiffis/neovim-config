-- Typst support for Neovim
-- Plugin: typst.vim (syntax, conceal, basic commands)
-- LSP: tinymist (already installed via Mason)

return {
  {
    "kaarmu/typst.vim",
    ft = "typst",
    lazy = false, -- Load immediately like vimtex
    init = function()
      -- ============================================================================
      -- BASIC CONFIGURATION
      -- ============================================================================
      
      -- Typst executable location
      vim.g.typst_cmd = "typst"
      
      -- PDF viewer for :TypstWatch command
      vim.g.typst_pdf_viewer = "zathura"
      
      -- ============================================================================
      -- CONCEAL CONFIGURATION
      -- ============================================================================
      
      -- Enable basic concealing (hides *bold*, _italic_ markers)
      vim.g.typst_conceal = 1
      
      -- Enable math symbol concealing (alpha → α, sum → ∑, etc.)
      -- WARNING: This can affect performance on large documents
      vim.g.typst_conceal_math = 1
      
      -- Enable emoji concealing (#emoji.rocket → 🚀)
      vim.g.typst_conceal_emoji = 1
      
      -- ============================================================================
      -- CODE BLOCKS SYNTAX HIGHLIGHTING
      -- ============================================================================
      
      -- List of languages to highlight inside code blocks
      vim.g.typst_embedded_languages = {
        "python",
        "rust",
        "c",
        "cpp",
        "bash",
        "sh",
        "go",
        "sql",
        "java",
      }
      
      -- ============================================================================
      -- FOLDING CONFIGURATION
      -- ============================================================================
      
      -- Enable folding for typst headings
      vim.g.typst_folding = 1
      
      -- Enable nested foldings
      vim.g.typst_foldnested = 1
      
      -- ============================================================================
      -- ERROR HANDLING
      -- ============================================================================
      
      -- Automatically open quickfix list when there are compilation errors
      vim.g.typst_auto_open_quickfix = 1
      
      -- ============================================================================
      -- OUTPUT CONFIGURATION
      -- ============================================================================
      
      -- Save PDFs in the same directory as .typ file (not /tmp)
      vim.g.typst_output_to_tmp = 0
      
      -- ============================================================================
      -- TABLE OF CONTENTS
      -- ============================================================================
      
      -- Do not auto-close TOC after selection
      vim.g.typst_auto_close_toc = 0
      
      -- ============================================================================
      -- SYNTAX HIGHLIGHTING
      -- ============================================================================
      
      -- Enable syntax highlighting (should be 1, this is default)
      vim.g.typst_syntax_highlight = 1
      
      -- ============================================================================
      -- FILETYPE-SPECIFIC CONFIGURATION
      -- ============================================================================
      
      -- Create augroup to prevent duplicate autocmds
      local typst_augroup = vim.api.nvim_create_augroup("typst_config", { clear = true })
      
      vim.api.nvim_create_autocmd("FileType", {
        group = typst_augroup,
        pattern = "typst",
        callback = function(ev)
          -- Use comma (,) as localleader in Typst files
          -- This is consistent with your global config
          -- (Unlike vimtex which overrides to backslash)
          
          -- Set conceallevel for typst files
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
          
          -- ========================================================================
          -- KEYBINDS FOR TYPST FILES
          -- ========================================================================
          -- All keybinds use <localleader>l prefix (similar to vimtex)
          -- Since localleader is ',' your bindings will be: ,ll, ,lv, ,lt, etc.
          
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
          end
          
          -- ========================================================================
          -- COMPILATION & VIEWING
          -- ========================================================================
          
          -- Watch & Compile (like vimtex's \ll)
          map('n', '<localleader>ll', ':TypstWatch<CR>', 'Typst Watch & Compile')
          
          -- Compile once with :make
          map('n', '<localleader>lc', ':make<CR>', 'Typst Compile')
          
          -- View PDF in Zathura
          -- Opens the compiled PDF (assumes same name as .typ file)
          map('n', '<localleader>lv', function()
            local file = vim.fn.expand('%:p')
            local pdf = vim.fn.fnamemodify(file, ':r') .. '.pdf'
            if vim.fn.filereadable(pdf) == 1 then
              vim.fn.jobstart({'zathura', pdf}, { detach = true })
            else
              vim.notify('PDF not found: ' .. pdf, vim.log.levels.WARN)
            end
          end, 'View PDF')
          
          -- ========================================================================
          -- LSP FEATURES
          -- ========================================================================
          
          -- Rename symbol (LSP)
          map('n', '<localleader>lr', vim.lsp.buf.rename, 'Rename Symbol')
          
          -- Code actions (LSP)
          map('n', '<localleader>la', vim.lsp.buf.code_action, 'Code Actions')
          
          -- Format document (LSP)
          map('n', '<localleader>lf', function()
            vim.lsp.buf.format({ async = true })
          end, 'Format Document')
          
          -- LSP Info
          map('n', '<localleader>li', '<cmd>LspInfo<CR>', 'LSP Info')
          
          -- ========================================================================
          -- ERRORS & DIAGNOSTICS
          -- ========================================================================
          
          -- Open quickfix list (errors)
          map('n', '<localleader>le', '<cmd>copen<CR>', 'Open Error List')
          
          -- Close quickfix list
          map('n', '<localleader>lE', '<cmd>cclose<CR>', 'Close Error List')
          
          -- ========================================================================
          -- WHICH-KEY INTEGRATION (NEW SPEC)
          -- ========================================================================
          -- Register the <localleader>l group with which-key for better UX
          
          -- Check if which-key is available
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              { "<localleader>l", group = "Typst", buffer = ev.buf },
              { "<localleader>ll", desc = "Watch & Compile", buffer = ev.buf },
              { "<localleader>lc", desc = "Compile", buffer = ev.buf },
              { "<localleader>lv", desc = "View PDF", buffer = ev.buf },
              { "<localleader>lr", desc = "Rename", buffer = ev.buf },
              { "<localleader>la", desc = "Code Actions", buffer = ev.buf },
              { "<localleader>lf", desc = "Format", buffer = ev.buf },
              { "<localleader>li", desc = "LSP Info", buffer = ev.buf },
              { "<localleader>le", desc = "Error List", buffer = ev.buf },
              { "<localleader>lE", desc = "Close Errors", buffer = ev.buf },
            })
          end
        end,
      })
    end,
  },
}
