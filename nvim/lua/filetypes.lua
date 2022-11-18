local M = {}

function M.setup()
  local api = vim.api
  local filetypes = api.nvim_create_augroup('FileTypes', { clear = true })

  -- .gitignore files
  api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead' },
    {
      pattern = '.gitignore',
      command = [[set filetype=config]],
      group = filetypes,
    }
  )

  -- go files
  api.nvim_create_autocmd(
    "FileType",
    {
      pattern = "go",
      callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.expandtab = false
      end,
      group = filetypes,
    }
  )
end

return M
