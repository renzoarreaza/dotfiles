""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
" https://devhints.io/vimscript 			" vim scripting cheatsheet
" https://jonasjacek.github.io/colors/ 			" 256 colors
" if scrolling is slow, it's most likely due to: https://github.com/vim/vim/issues/2584
" update your vim installation or disable relative number and cursorline options

if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
	if enable_plugins == 'true'
		call plug#begin('~/.vim/plugged')

		"Plug 'davidhalter/jedi-vim'
		"
		
		Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
		"option below is a list of strings, i.e: let g:pymode_lint_ignore=["E501","W601"]
		let g:pymode_lint_ignore=["W191"]

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
"set hlsearch       " highlight matches
"hi CursorLine term=bold cterm=bold guibg=Grey40 	" change cursorline from underline to highlight
"hi CursorLine   cterm=NONE ctermbg=darkgray
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
    "It is setting of color for terminal: background color - ctermbg, and text color - ctermfg. 
    "For using in graphical window, add parameters guibg=darkred guifg=white
"nnoremap H :set cursorline! cursorcolumn!<CR>

" line numbers
set number 
" relativenumber makes scrolling slow in certain versions
augroup numbertoggle            " auto-toggle between hybrid and absolute line numbers in command and insert modes respectively 
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" indentation
setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd Filetype yaml setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab

" flagging unnecessary whitespace
highlight BadWhitespace ctermbg=red guibg=red
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

""""""""""""
" Mappings "
""""""""""""
nnoremap z/ :call Redraw()<cr>
" redraw line at 1/4 way down from top of window " similar to z. and z<Enter>
function! Redraw()
	let of = ((line('w$')-line('w0'))/4)
	execute "normal z\<cr>" . of . "\<c-y>"
endfunction

" use \& to create split view with currently open file and enable scrollbind
if &splitright ==? "splitright" || &splitright
	nnoremap <leader>& :vs<cr>2<c-w>w<c-f>:set scb<cr>1<c-w>w:set scb<cr> 
elseif &splitright ==? "nosplitright" || &splitright
	nnoremap <leader>& :vs<cr>:set scb<cr>2<c-w>w<c-f>:set scb<cr>1<c-w>w 
endif

" use \* to close split on the right and disable scrollbind 
nnoremap <leader>* 2<c-w>w:set noscb<cr>:q<cr>:set noscb<cr> 

" use \m to toggle mouse between all and disabled
map <leader>m <ESC>:exec &mouse!=""? "set mouse=" : "set mouse=a"<CR>

" use jj to exit insert mode
imap jj <Esc>		
nmap :W :w
nmap :Q :q
nmap :WQ :wq
" move vertically by visual line (usefull for wrapped lines)
nnoremap j gj
nnoremap k gk
" turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>
 

"""""""""""
" Folding "
"""""""""""
setlocal foldmethod=indent   
autocmd Filetype c setlocal foldmethod=syntax " syntax folding for C files 
set foldnestmax=10 
set nofoldenable
set foldlevel=2
" space open/closes folds
nnoremap <space> za	
" unfold all (Ctrl-<Space>)
nnoremap <C-@> zR	


""""""""""""""""""""""""""""""""""
" Statusline, Tabline, VertSplit "
""""""""""""""""""""""""""""""""""
" colors used in status- and tabline
if $TERM ==? 'xterm'
	" Simple colors
	highlight h_color1 ctermbg=15 ctermfg=4
	highlight h_color2 ctermbg=4 ctermfg=15
	highlight h_warning ctermbg=1 ctermfg=0
else " xterm-256color
	" Default 
"	Blues
	highlight h_color1 ctermbg=39 ctermfg=16	"cterm=bold		" light blue
	highlight h_color2 ctermbg=25 ctermfg=15			" dark blue 
	highlight h_warning ctermbg=196 ctermfg=15			" red 
	" Grays
"	highlight h_color1 ctermbg=243 ctermfg=15	" light gray 
"	highlight h_color2 ctermbg=238 ctermfg=15 	" dark gray
"	highlight h_warning ctermbg=160 ctermfg=0 	" softer red 
	" 
"	highlight h_color1 ctermbg=184 ctermfg=15  
"	highlight h_color2 ctermbg=107 ctermfg=15 
"	highlight h_warning ctermbg=160 ctermfg=0  
endif

" highlight TabLineSel ctermfg=15 ctermbg=0
highlight! link TabLineSel h_color2
highlight! link TabLine h_color1
highlight! link TabLineFill h_color1

" set color split line
highlight! VertSplit cterm=NONE				 
set fillchars=
set fillchars+=vert:│ " for vertical split
set fillchars+=fold:· " for folds

" statusline
set laststatus=2        	" always show statusline
set statusline=
" set statusline+=[%n] 		    " buffer number
set statusline+=%#h_warning#
set statusline+=%m 		        " modified flag
set statusline+=%#h_color2#
set statusline+=%{StatuslineGit()}		"u+2387   # slows down scrolling and introduces weird characters. The statusline is reloaded every time the cursor moves. that's why it's slow.  
set statusline+=%#h_warning#
set statusline+=%r		        "read only flag
set statusline+=%#h_color1#\ 
set statusline+=<<\ 		
set statusline+=%-40.40(%F\ >>%)%< 		" F: full path to file in buffer, <: where to truncate if line is too long, 
""set statusline+=%F\ >>		            " F: full path to file in buffer
set statusline+=%= 			    " =: separation between left and right aligned items
set statusline+=%#h_color2#
set statusline+=\ \☰\ %l:%c
set statusline+=\ %p%%\ 
set statusline+=%#h_color1#
set statusline+=%y              " y: type of file in buffer e.g [python], [javascript] or [vim] 
set statusline+=[%{&ff}]        " ff: file format e.g [unix] or [dos]
set statusline+=[%{&fenc}]      " fenc: file encoding e.g [utf-8]
""http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'

function! GitBranch()
	let b:branchname = system("cd " . expand("%:p:h") . " ; " . "git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  return strlen(b:branchname) > 0?' '.'⎇  '.b:branchname.' ':''
" u2387 (branch symbol)
endfunction

autocmd TabEnter,BufEnter,FocusGained * call GitBranch()

