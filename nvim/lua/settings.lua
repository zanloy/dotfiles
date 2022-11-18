local M = {}

function M.setup()
  local api = vim.api
  local o = vim.o
  local opt = vim.opt
  local wo = vim.wo
  local bo = vim.bo

  -- set modeline
  if vim.fn.has('patch-8.1.1366') then
    o.modelines = 5
    o.modelineexpr = false
    o.modeline = true
  else
    o.modeline = false
  end

  -- global options
  o.scrolloff = 12 -- number of lines to show above and below cursor
  o.number = true -- show line numbers
  opt.splitright = true -- open splits to the right

  -- indentation and spacing
  o.expandtab = true
  o.shiftwidth = 2
  o.tabstop = 2
  o.softtabstop = 2

  -- colors and syntax highlighting settings
  o.termguicolors = true
  o.cursorline = true
  opt.listchars = { eol = "↵", tab = "▷-", trail = "·", extends = "◣", precedes = "◢", nbsp = "␣" }
  o.list = true
  --vim.cmd[[colorscheme equinusocio_material]]

  -- diff
  opt.diffopt = opt.diffopt + 'vertical'

  -- search settings
  o.gdefault = true -- replace all instances by default
  o.ignorecase = true -- search without case sensitivity
  o.smartcase = true -- ignore case in search if all lowercase
  o.path = '**'
  o.wildmode = 'longest,list,full'

  -- folding
  o.foldmethod = 'indent'
  o.foldenable = true
  o.foldlevel = 9999

  -- remember last position in file
  api.nvim_create_autocmd(
    'BufReadPost',
    { command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]] }
  )

  -- check if we need to reload the file when changed
  api.nvim_create_autocmd('FocusGained', { command = [[:checktime]] })

  -- show cursor line only in active window
  local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
  api.nvim_create_autocmd(
    { 'InsertLeave', 'WinEnter' },
    { pattern = '*', command = 'set cursorline', group = cursorGrp }
  )
  api.nvim_create_autocmd(
    { 'InsertEnter', 'WinLeave' },
    { pattern = '*', command = 'set nocursorline', group = cursorGrp }
  )

  -- use absolute numbering in command mode and relative otherwise
  local numberingGrp = api.nvim_create_augroup('Numbering', { clear = true })
  api.nvim_create_autocmd(
    { 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' },
    {
      command = [[if &nu && mode() != 'i' | set rnu | endif]],
      group = numberingGrp
    }
  )
  api.nvim_create_autocmd(
    { 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' },
    {
      command = [[if &nu | set nornu | endif]],
      group = numberingGrp
    }
  )

  -- do not auto comment new line
  api.nvim_create_autocmd('BufEnter', { command = 'set formatoptions-=cro' })

  -- do not reindent yaml files on : character (force with <C-F>)
  api.nvim_create_autocmd(
    'FileType',
    {
      pattern = 'yaml',
      command = [[setl indentkeys-=<:>]]
    }
  )
end

return M
