" ensure vim-plug is installed and then load it
call functions#PlugLoad()
call plug#begin('~/.config/nvim/plugged')

" Apparence
set number
set wrap
set shell=$SHELL

set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

" Plugins
" File Manager
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }

" Tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_theme='minimalist'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Theme
Plug 'joshdick/onedark.vim'

call plug#end()

" Colorscheme
syntax enable
let g:onedark_terminal_italics=1
colorscheme onedark
