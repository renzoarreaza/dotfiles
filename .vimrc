"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	__      __ _            
" 	\ \    / /(_)           
" 	 \ \  / /  _  _ __ ___  
" 	  \ \/ /  | || '_ ` _ \ 
" 	   \  /   | || | | | | |
" 	    \/    |_||_| |_| |_|
"
"	https://github.com/renzoarreaza/dotfiles
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Usefull links
" http://vimdoc.sourceforge.net/htmldoc/options.html 	" web version of :help documentation
" https://devhints.io/vimscript							" vim scripting cheatsheet
" https://jonasjacek.github.io/colors/					" 256 colors

" if scrolling is slow, it's most likely due to: https://github.com/vim/vim/issues/2584
" -> update your vim installation or disable relative number and cursorline options

"TODO; 
"check for relativenumber support
"vim file.py --startuptime startup.log

let &pythonthreedll = '/opt/python-3/lib/libpython3.6m.so.1.0'
set clipboard=exclude:.*
if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
	if enable_plugins == 'true'
		call plug#begin('~/.vim/plugged')
		"Plug 'davidhalter/jedi-vim'
		"
		"Plug 'dense-analysis/ale'
		"
		Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
		"option below is a list of strings, i.e: let g:pymode_lint_ignore=["E501","W601"]
		"let g:pymode_lint_ignore=["W191"]
		let g:pymode_options_max_line_length = 119
		let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
		let g:pymode_options_colorcolumn = 1

		"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
		"
		Plug 'jpalardy/vim-slime'
		let g:slime_target = "tmux"
		let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}
		let g:slime_python_ipython = 1  "deals with autoindent in ipython
		call plug#end()
	endif 
endif


"""""""""""
" Options "
"""""""""""
set encoding=utf-8
scriptencoding utf-8
syntax on 			" enable syntax highlighting
colorscheme peachpuff	" picking a colorscheme for syntax
set backspace=indent,eol,start
set showmatch			" highlight matching [{()}]
set wildmenu		" visual autocomplete for command menu
set splitright 		" vsplit opens file on the right
set splitbelow 		" split opens file on the bottom
" Use case insensitive search, except when using capital letters
set ignorecase		" use case insensitie search
set smartcase		" case sensitive when using capital letters
set incsearch       " search as characters are entered
set cursorline		" Highlight the screen line of the cursor  # makes scrolling slow 
set autoindent		" yet to try this option. perhaps only for python?
set hidden			" to allow editing multiple buffers without saving
set wrap
"set wrap linebreak nolist
"set colorcolumn=120
" dynamic number settings
"let b:toggle_nums = 1
"autocmd BufRead * let b:toggle_nums = 1 "default/starting value
autocmd BufEnter,FocusGained,InsertLeave * call Numbers("relative")
autocmd BufLeave,FocusLost,InsertEnter * call Numbers("normal")
"autocmd BufRead *.ipy set filetype=python

"""""""""""""
" Functions "
"""""""""""""
" New line number handling
function! Numbers(type) "changes number settings
	let b:toggle_nums = get(b:, 'toggle_nums', 1)
	if b:toggle_nums == 1
		set number
		if a:type ==? "relative"
			set relativenumber
		endif
		if a:type ==? "normal"
			set norelativenumber
		endif
	else
		set nonumber
		set norelativenumber
	endif
endfunction

function! Toggle_nums() 
	let b:toggle_nums = !get(b:, 'toggle_nums', 1)
	call Numbers("relative")
endfunction

" Redraw line at 1/4 way down from top of window " similar to z. and z<Enter>
" see vim/src/testdir/test_number.vim  line 9, ScreenLines()
function Redraw()
	let l:startl = line('.')
	let l:startc = col('.')
    let l:lines = 0
    normal! H
    while (line('.') < line('w$'))
        let l:lines += 1
        normal! j
		if line('.') == l:startl
			let l:topl = l:lines
		endif
    endwhile
	execute "normal " . l:startl . "\G"
	let of = l:lines/4
	execute "normal z\<cr>" . of . "\<c-y>"
	execute "normal 0" . (l:startc-1) . "l"
    "return l:lines
endfunction

" old line number handling
"set number 
"augroup numbertoggle            " auto-toggle between hybrid and absolute line numbers in command and insert modes respectively 
"  autocmd!
"  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END

"""""""""""""""
" Indentation "
"""""""""""""""
set tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype yaml setlocal tabstop=4 softtabstop=0 shiftwidth=2 smarttab expandtab 
"autocmd Filetype tcl setlocal expandtab
autocmd Filetype python setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" Flagging unnecessary whitespace
highlight BadWhitespace ctermbg=red guibg=red
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.tcl match BadWhitespace /\s\+$/

""""""""""""
" Mappings "
""""""""""""
nnoremap <silent> z/ :call Redraw()<cr>

" Use \& to create split view with currently open file and enable scrollbind
if &splitright ==? "splitright" || &splitright
	noremap <silent> <leader>& :vs<cr>2<c-w>w<c-f>:set scb<cr>1<c-w>w:set scb<cr> 
elseif &splitright ==? "nosplitright" || &splitright
	noremap <silent> <leader>& :vs<cr>:set scb<cr>2<c-w>w<c-f>:set scb<cr>1<c-w>w 
endif
" Use \* to close split on the right and disable scrollbind 
noremap <leader>* 2<c-w>w:set noscb<cr>:q<cr>:set noscb<cr> 
" Use \m to toggle mouse between all and disabled
map <silent> <leader>m <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=a"<CR>
" use \n to toggle numbers
map <silent> <leader>n :call Toggle_nums()<cr>
"use \<tab> to go to most recent buffer 
map <leader><Tab> :b#<cr>
"use \ to go to previous error/warning
map <leader>k :lprevious<cr>
"use \ to go to next error/warning
map <leader>j :lnext<cr>
"use ;b to list buffers and select
nnoremap ;b :ls<cr>:b<space>


" Use jj to exit insert mode
imap jj <Esc>		
"nmap :W :w
"nmap :Q :q
"nmap :WQ :wq
" Move vertically by visual line (usefull for wrapped lines)
nnoremap j gj
nnoremap k gk
" Turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>
"
" Yank to end of line
map Y y$

"easier window movement
map <silent> ,h :wincmd h<CR>
map <silent> ,j :wincmd j<CR>
map <silent> ,k :wincmd k<CR>
map <silent> ,l :wincmd l<CR>

" easier autocomplete
imap <S-tab> <c-n>

"""""""""""
" Folding "
"""""""""""
set foldmethod=indent  "default folding method 
autocmd Filetype c setlocal foldmethod=syntax " syntax folding for C (and tcl files; not working)
set foldnestmax=10 
set nofoldenable
set foldlevel=2
" Space open/closes folds
nnoremap <space> za	
" Unfold all (Ctrl-<Space>)
" nnoremap <C-@> zR	
nnoremap <leader><space> zR

""""""""""""""""""""""""""""""""""
" Statusline, Tabline, VertSplit "
""""""""""""""""""""""""""""""""""
" Colors used in status- and tabline
if $TERM ==? 'xterm'
	" Simple colors
	highlight hl1 ctermbg=15 ctermfg=4
	highlight hl2 ctermbg=4 ctermfg=15
	highlight hl3 ctermbg=1 ctermfg=0
else " xterm-256color
	" Default 
"	Blues
	highlight hl1 ctermbg=39 ctermfg=16	"cterm=bold		" light blue
	highlight hl2 ctermbg=25 ctermfg=231			" dark blue 
	highlight hl12 ctermbg=39 ctermfg=25	
	highlight hl21 ctermbg=25 ctermfg=39		
	highlight hl3 ctermbg=196 ctermfg=231			" red 
	" Grays
"	highlight hl1 ctermbg=243 ctermfg=15	" light gray 
"	highlight hl2 ctermbg=238 ctermfg=15 	" dark gray
"	highlight hl3 ctermbg=160 ctermfg=0 	" softer red 
	" 
"	highlight hl1 ctermbg=184 ctermfg=15  
"	highlight hl2 ctermbg=107 ctermfg=15 
"	highlight hl3 ctermbg=160 ctermfg=0  
endif

" Highlight TabLineSel ctermfg=15 ctermbg=0
highlight! link TabLineSel hl2
highlight! link TabLine hl1
highlight! link TabLineFill hl1

" Set color split line
highlight! VertSplit cterm=NONE
set fillchars=
set fillchars+=vert:│ " for vertical split
set fillchars+=fold:· " for folds

" color of max_line
"highlight ColorColumn ctermbg=1  "red
highlight ColorColumn ctermbg=8  "gray


" Statusline
set laststatus=2        	" always show statusline
set statusline=
set statusline+=%#hl3#
set statusline+=%m 		        " modified flag
set statusline+=%#hl2#
set statusline+=%{StatuslineGit()}
set statusline+=%#hl3#
set statusline+=%r		        "read only flag
set statusline+=%#hl1#\ 
set statusline+=<<\ 
set statusline+=%-40.40(%F\ [%n]>>%)%< 		" F: full path to file in buffer, <: where to truncate if line is too long, n: buffer number 
""set statusline+=%F\ >>		            " F: full path to file in buffer
set statusline+=%= 			    " =: separation between left and right aligned items
"set statusline+=%#hl12#
"set statusline+=
set statusline+=%#hl2#
set statusline+=\ %p%%\ 
set statusline+=\☰\ %l:
set statusline+=%c\ 
"set statusline+=%#hl21#
"set statusline+=
set statusline+=%#hl1#
set statusline+=%y              " y: type of file in buffer e.g [python], [javascript] or [vim] 
set statusline+=[%{&ff}]        " ff: file format e.g [unix] or [dos]
set statusline+=[%{&fenc}]      " fenc: file encoding e.g [utf-8]
""http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'

function! GitBranch()
	"let b:toggle_nums = get(b:, 'toggle_nums', 1)
	let b:branchname = system("cd " . expand("%:p:h") . " ; " . "git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  return strlen(b:branchname) > 0?' '.'  '.b:branchname.' ':''
" u2387 ⎇ ,  ue0a0  (branch symbols)
endfunction

autocmd TabEnter,BufEnter,FocusGained * call GitBranch()
call GitBranch()
" uE0B0 
" uE0B1 
" uE0B2 
" uE0B3 
"
