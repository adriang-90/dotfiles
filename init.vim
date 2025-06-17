set number


set mouse=a

set termguicolors

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set relativenumber
set clipboard=unnamedplus

set incsearch
set hlsearch

set wrap


call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'          " Basic sensible defaults
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder
Plug 'junegunn/fzf.vim'            " Fzf integration
Plug 'preservim/nerdtree'          " File explorer
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense engine
Plug 'github/copilot.vim'
Plug 'morhetz/gruvbox'

call plug#end()


set background=dark

nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
colorscheme gruvbox

