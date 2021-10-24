" We like modelines because a lot of config files do not have the appropriate
" extension (eg: .yml) for n/vim to know how to do syntax/highlighting.
" Note: This can be a security vulnerability if you work on a lot of untrusted
"       files so use with caution.
set modeline

" Uncomment if you want to load legacy vim settings.
"set runtimepath^=~/.vim
"let &packpath=&runtimepath
"source ~/.vimrc

" Load plugins and plugin settings from config files
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/plugin_settings.vim

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmode=longest,list,full
set wildmenu

" Tags
command! MakeTags !ctags -R .

" Tab navigation shortcuts
nnoremap t$ :tabfirst<CR>
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap t^ :tablast<CR>
nnoremap tt :tabedit<Space>
nnoremap tm :tabm<Space>
nnoremap td :tabclose<CR>

" *** Colors and syntax highlighting
syntax on
set termguicolors                " enable true (256 bit) colors
set background=dark              " we fear the light
colorscheme equinusocio_material " set our colorscheme
set cursorline                   " highlight the current line

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

" The above command works fine but some colorschemes don't highlight well
" enough so we use the following to highlight extra whitespace.

" Setup a highlight group
highlight ExtraWhitespace ctermbg=red guibg=red

" Match trailing whitespace except when typing
match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Indentation and Spacing
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

" Code Folding
set foldmethod=indent
set nofoldenable

" Diff
set diffopt+=vertical

" Navigation
set number " give us line numbers on left
set splitright " open splits to the right

" FileTypes!
augroup filetypes
  autocmd!
  autocmd BufNewFile,BufRead .gitignore set filetype=config
augroup END

" Search
set gdefault             " assume /g on :s substitutions
set ignorecase smartcase " ignore case in search if all lowercase
set incsearch            " search incrementally

" Use system clipboard
vnoremap <leader>y "+y
nnoremap <leader>y "+y

" Remember last position in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Do not reindent yaml files on : char (You can force reindent with CTRL+F)
if has("autocmd")
  au FileType yaml setl indentkeys-=<:>
endif

" Use relative line numbers in command mode and absolute in insert mode
if has("autocmd")
  au BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  au BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
endif
