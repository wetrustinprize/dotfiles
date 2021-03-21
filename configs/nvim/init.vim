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

	" COC (autocomplete)
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	let g:coc_global_extensions = [
				\ 'coc-json',
				\ 'coc-tsserver',
				\ 'coc-sh',
				\ 'coc-vimlsp',
				\ 'coc-prettier',
				\ 'coc-git'
				\ ]
	
		" key mappings
		" coc-prettier
		command! -nargs=0 Prettier :CocCommand prettier.formatFile
		nmap <leader>f :CocCommand prettier.formatFile<cr>

		" coc-git
		nmap <silent> [g <Plug>(coc-git-prevchunk)
		nmap <silent> ]g <Plug>(coc-git-nextchunk)
		nmap <silent> gs <Plug>(coc-git-chunkinfo)
		nmap gu :CocCommand git.chunkUndo<cr>

		nmap <silent> gd <Plug>(coc-definitions)
		nmap <silent> gy <Plug>(coc-type-definitions)
		nmap <silent> gi <Plug>(coc-implementation)
		nmap <silent> gr <Plug>(coc-references)
		nmap <silent> gh <Plug>(coc-doHover)

		nmap <silent> [c <Plug>(coc-diagnostic-prev)
		nmap <silent> ]c <Plug>(coc-diagnostic-next)

	" Auto pairs
	Plug 'jiangmiao/auto-pairs'

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
