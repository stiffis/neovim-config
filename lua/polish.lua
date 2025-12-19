-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Configuración específica para archivos Go
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = false -- Go usa tabs por defecto
  end,
})

-- Alternativamente, si prefieres espacios en lugar de tabs para Go:
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'go',
--   callback = function()
--     vim.opt_local.tabstop = 4
--     vim.opt_local.shiftwidth = 4
--     vim.opt_local.softtabstop = 4
--     vim.opt_local.expandtab = true  -- Usar espacios
--   end,
-- })
