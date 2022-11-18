local api = vim.api

api.nvim_create_user_command(
  'MakeTags',
  'ctags -R .',
  { bang = true }
)
