" Plugins
let mapleader = ','
call plug#begin('~/.config/nvim/plugged')
Plug 'qpkorr/vim-bufkill'
" I am very interested in this plugin but can not impliment
" with current version of nvim and fzf so commenting this
" out for now until later I can revisit it.
"Plug 'kevinhwang91/nvim-bqf'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'roxma/nvim-yarp'          " Required before deoplete
Plug 'roxma/vim-hug-neovim-rpc' " Required before deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'SirVer/ultisnips'
" Development plugins
Plug 'michaelb/sniprun', {'do': 'bash install.sh'} " Allows running blocks of code in neovim
" NerdTree and plugins
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
" Syntax and generic language specific
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'towolf/vim-helm'
Plug 'tpope/vim-surround'
Plug 'ollykel/v-vim'
" Ruby specific
Plug 'vim-ruby/vim-ruby'      " Ruby
Plug 'tpope/vim-rails'        " Rails
Plug 'tpope/vim-rake'         " Rake
Plug 'danchoi/ri.vim'         " ri
Plug 'thoughtbot/vim-rspec'   " rspec
Plug 'ngmy/vim-rubocop'       " rubocop
Plug 'slim-template/vim-slim' " slim
" Colorschemes
Plug 'dracula/vim', { 'as': 'dracula' } " Dracula
Plug 'chuling/equinusocio-material.vim' " Equinusocio Material
Plug 'morhetz/gruvbox'                  " Gruvbox
Plug 'cocopon/iceberg.vim'              " Iceberg
Plug 'joshdick/onedark.vim'             " OneDark
Plug 'altercation/vim-colors-solarized' " Solarized
Plug 'jacoborus/tender.vim'             " Tender
call plug#end()
