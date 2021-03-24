" ensure vim-plug is installed and then load it
	call functions#PlugLoad()
	call plug#begin('~/.config/nvim/plugged')


" Plugins
	Plug 'ryanoasis/vim-devicons'

	" Defx (file manager)
	Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'kristijanhusak/defx-icons'
	Plug 'kristijanhusak/defx-git'

	" Key Mappgins
		" Open Explorer
		nmap <silent><Leader>e :
					\<C-U>:Defx -resume -buffer_name=explorer -split=vertical -vertical_preview<CR>
		
		autocmd FileType defx call s:defx_my_settings()
		function! s:defx_my_settings() abort
			
			" Open Directory or File
			nmap <silent><buffer><expr> o
						\ defx#is_directory() ? defx#do_action('open') : 
						\ match(bufname('%'), 'explorer') >= 0 ?
						\ (defx#do_action('multi', [['drop', 'vsplit'], ['quit']])) :
						\ (defx#do_action('multi', ['open', 'quit']))
			" Open Tree
			nmap <silent><buffer><expr> l
						\ defx#do_action('open_or_close_tree') 

			" Return folder
			nmap <silent><buffer><expr> h
						\ defx#do_action('cd', ['..'])

			" New Directory
			nmap <silent><buffer><expr> K
						\ defx#do_action('new_directory')

			" New File
			nmap <silent><buffer><expr> N
						\ defx#do_action('new_file')

			" Remove
			nmap <silent><buffer><expr> d
						\ defx#do_action('remove')

			" Rename
			nmap <silent><buffer><expr> r
						\ defx#do_action('rename')

			" Quit
			nmap <silent><buffer><expr> q
						\ defx#do_action('quit')
		endfunction


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
	
		" Key Mappings
		" Coc-Prettier
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

	" Language-Specific
		" TypeScript
		Plug 'leafgarland/typescript-vim', { 'for': 'tsx' }

		" Json
		Plug 'elzr/vim-json', { 'for': 'json' } 

	" Theme
	Plug 'joshdick/onedark.vim'

	call plug#end()

" Apparence
	syntax enable
	let g:onedark_terminal_italics=1
	colorscheme onedark

	set number
	set wrap
	set shell=$SHELL
	set encoding=UTF-8

	set smarttab
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set shiftround

	" Defx Apparence
	call defx#custom#option('_', {
		\ 'ignored_files': '.*,target*',
		\ 'direction': 'topleft',
		\ 'toggle': 1,
		\ 'columns': 'indent:git:icons:filename:mark',
	\ })
