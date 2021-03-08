""""""""""""""""""""""""""""
" Plugin specific settings "
"""""""""""""""""""""""""""

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

" devicons
"let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '

" lightline
let g:lightline = {
      \ 'colorscheme': 'equinusocio_material',
      \ }

" nerdtree
" CTRL+N toggles nerdtree
map <C-n> :NERDTreeToggle<CR>
" close nerdtree automatically when I open a file
let g:NERDTreeQuitOnOpen = 1
" close nerdtree if last buffer
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | quit | endif
let g:NERDTreeShowHidden = 1 " show hidden files
let g:NERDTreeMinimalUI = 1 " hide the helper
let g:NERDTreeStatusLine = '' " set to empty to use lightline

" nerdtree plugins
let g:NERDTreeGitStatusUseNerdFonts = 1 " use NerdFont defaults

" netrw - This may be unnecessary since I prefer NERDTree
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

" vim-go
" Use goimports instead of gofmt
let g:go_fmt_command = 'goimports'
" Only open up local vars and stack trace in debug mode
let g:go_debug_windows = {
      \ 'vars': 'rightbelow 60vnew',
      \ 'stack': 'rightbelow 10new',
      \ }
" Use quickfix window for everything
"let g:go_list_type = "quickfix"
" Run :GoBuild on <leader>b
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
" Run :GoDebugToggle
" Run :GoCoverageToggle on <leader>c
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
" Run :GoRun on <leader>r
autocmd FileType go nmap <leader>r <Plug>(go-run)
" Run :GoTest on <leader>t
autocmd FileType go nmap <leader>t <Plug>(go-test)
" This is some next level shit right here...
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
" Beautify it
let g:go_highlight_type = 1 " color types
let g:go_highlight_fields = 1 " color fields
let g:go_highlight_operators = 1 " color operators
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1 " color build tags

" vim-rspec: add some shortcuts
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
