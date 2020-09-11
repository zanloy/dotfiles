"set runtimepath^=~/.vim
"let &packpath=&runtimepath
"source ~/.vimrc

" Load plugins and settings from config files
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

" Colors!
set termguicolors " enable true (256 bit) colors
"set background=dark
colorscheme equinusocio_material

" Snippets
nnoremap ,begin :-1read $HOME/.config/nvim/snippets/begin.rb<CR>o

" Spacing
set expandtab
set shiftwidth=2

" Navigation
set number " give us line numbers on left
inoremap <C-d> <ESC>:q<CR> " Close file with ^d
nnoremap <C-d> :q<CR>      " Close file with ^d
nnoremap <C-f> scroll      " Fix ^f to scroll half screen to replace default ^d

" FileTypes!
augroup filetypes
  autocmd!
  autocmd BufNewFile,BufRead .gitignore set filetype=config
augroup END

" Search
set gdefault             " assume /g on :s substitutions
set ignorecase smartcase " ignore case in search if all lowercase
set incsearch            " search incrementally

" Using system clipboard
vnoremap <leader>y "+y
nnoremap <leader>y "+y

""""""""""""""""""""""""""""
" Plugin specific settings "
""""""""""""""""""""""""""""

" lightline
let g:lightline = {
      \ 'colorscheme': 'equinusocio_material',
      \ }

" ctrlp
" Change the default mapping and the default command to invoke CtrlP:
let g:ctrlp_map = '<c-p>'
let g:ctrl_cmd = 'CtrlP'
" When invoked, unless a starting directory is specified, CtrlP will set its
" working directory according to this variable:
" r - nearing accestor with .git
" a - the directory of the current file
let g:ctrlp_working_path_mode = 'ra' 
" Use gnu find for fast searching on linux
let g:ctrlp_user_command = "find %s -type f -not -name '^.*'"
" Exit on last <bs>
let g:ctrlp_brief_prompt = 1
" Exclude files and directories using wildignore and g:ctrlp_custom_ignore:
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" deoplete
let g:deoplete#enable_at_startup = 1
" use ^j and ^k to select autocompletions, disabled because we use those
" keybinds for tmux/split navigation
"inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
"inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" nerdtree
map <C-n> :NERDTreeToggle<CR>
" close nerdtree automatically when I open a file
let g:NERDTreeQuitOnOpen = 1
" close nerdtree if last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabFree()) | q | endif
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browser_split=4 " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" ri.vim: Change default mappings because they clash
nnoremap <Leader>ri :call ri#OpenSearchPrompt(0)<cr> "horizontal split
nnoremap <Leader>RI :call ri#OpenSearchPrompt(1)<cr> "vertical split
nnoremap <Leader>RK :call ri#LookupNameUnderCursor()<cr> " keyword lookup

" vim-rspec: add some shortcuts
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
