local M = {}

function M.setup()
  local g = vim.g
  local keymap = vim.api.nvim_set_keymap
  local default_opts = { noremap = true, silent = true }
  local expr_opts = { noremap = true, expr = true, silent = true }

  -- first set leader key
  g.mapleader = ','
  g.maplocalleader = ','

  -- use system clipboard
  keymap('v', '<leader>y', [["+y]], default_opts)
  keymap('n', '<leader>y', [["+y]], default_opts)

  -- tab navigation
  keymap('n', 't$', ':tabfirst<CR>', default_opts)
  keymap('n', 'tl', ':tabnext<CR>', default_opts)
  keymap('n', 'th', ':tabprev<CR>', default_opts)
  keymap('n', 't^', ':tablast<CR>', default_opts)
  keymap('n', 'tt', ':tabedit<Space>', default_opts)
  keymap('n', 'tm', ':tabm<Space>', default_opts)
  keymap('n', 'td', ':tabclose<CR>', default_opts)

  -- center search results
  keymap('n', 'n', 'nzz', default_opts)
  keymap('n', 'N', 'Nzz', default_opts)

  -- visual line wraps
  keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", expr_opts)
  keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", expr_opts)

  -- paste over current selection without yanking
  keymap('v', 'p', '"_dP', default_opts)

  -- better indent
  keymap('v', '<', '<gv', default_opts)
  keymap('v', '>', '>gv', default_opts)

  -- switch buffers
  keymap('n', '<S-h>', ':bprevious<CR>', default_opts)
  keymap('n', '<S-l>', ':bnext<CR>', default_opts)

  -- cancel search highlighting with ESC
  keymap('n', '<ESC>', ':nohlsearch<Bar>:echo<CR>', default_opts)

  -- resize panes with arrow keys
  keymap('x', 'K', ":move '<-2<CR>gv-gv", default_opts)
  keymap('x', 'J', ":move '>+1<CR>gv-gv", default_opts)

  -- insert a blank line
  keymap('n', ']<Space>', 'o<Esc>', default_opts)
  keymap('n', '[<Space>', 'O<Esc>', default_opts)
end

return M
