" Plugins
let mapleader = ','
call plug#begin('~/.config/nvim/plugged')
Plug 'ctrlpvim/ctrlp.vim'
Plug 'roxma/nvim-yarp'          " Required before deoplete
Plug 'roxma/vim-hug-neovim-rpc' " Required before deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
" Syntax and generic language specific
Plug 'towolf/vim-helm'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-surround'
" Ruby specific
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'danchoi/ri.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'ngmy/vim-rubocop'
" Colorschemes
Plug 'chuling/equinusocio-material.vim'
call plug#end()
