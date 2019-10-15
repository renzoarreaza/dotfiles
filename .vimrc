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

"""""""""""
" Options "
"""""""""""
syntax on 			" enable syntax highlighting
colorscheme peachpuff	" picking a colorscheme for syntax
set showmatch			" highlight matching [{()}]
set wildmenu		" visual autocomplete for command menu
set splitright 		" vsplit opens file on the right
set splitbelow 		" split opens file on the bottom
" Use case insensitive search, except when using capital letters
set ignorecase		" use case insensitie search
set smartcase		" case sensitive when using capital letters
set incsearch       " search as characters are entered
" set hlsearch            " highlight matches
set cursorline		" Highlight the screen line of the cursor
"hi CursorLine term=bold cterm=bold guibg=Grey40 	" change cursorline from underline to highlight
"hi CursorLine   cterm=NONE ctermbg=darkgray
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
    "It is setting of color for terminal: background color - ctermbg, and text color - ctermfg. 
    "For using in graphical window, add parameters guibg=darkred guifg=white
"nnoremap H :set cursorline! cursorcolumn!<CR>

" line numbers
set number relativenumber       " setting hybrid line numbers
augroup numbertoggle            " auto-toggle between hybrid and absolute line numbers in command and insert modes respectively
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" indentation
setlocal tabstop=4 shiftwidth=4 softtabstop=4 " default 
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 " javascript


""""""""""""
" Mappings "
""""""""""""
" use \& to create split view with currently open file and enable scrollbind
nnoremap <leader>& :vs<cr>:set scb<cr>2<c-w>w<c-f>:set scb<cr>1<c-w>w
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
nnoremap <space> za	" space open/closes folds
nnoremap <C-@> zR	" unfold all (Ctrl-<Space>)


""""""""""""""""""""""""""""""""""
" Statusline, Tabline, VertSplit "
""""""""""""""""""""""""""""""""""
set laststatus=2        	" Show _always_ the statusline
" ## Statusline colors
highlight h_white ctermbg=15 ctermfg=0  
highlight h_cyan ctermbg=30 ctermfg=0  
if $TERM ==? 'xterm'
	" Simple colors
	highlight h_color1 ctermbg=15 ctermfg=4
	highlight h_color2 ctermbg=4 ctermfg=15
	highlight h_warning ctermbg=1 ctermfg=0
else " xterm-256color
	" Default 
	highlight h_color1 ctermbg=39 ctermfg=15  
	highlight h_color2 ctermbg=25 ctermfg=15 
	highlight h_warning ctermbg=196 ctermfg=0  
endif

" highlight TabLineSel ctermfg=15 ctermbg=0
highlight! link TabLineSel h_color2
highlight! link TabLine h_color1
highlight! link TabLineFill h_color1

" set color split line
set fillchars=
" set fillchars+=vert:┃ " for vsplits
" set fillchars+=vert:\ 
" hi! link VertSplit h_color2
set fillchars+=vert:│
hi! VertSplit cterm=NONE				 
set fillchars+=fold:· " for folds

" Statusline format
set statusline=
" set statusline+=[%n] 		    " buffer number
set statusline+=%#h_warning#
set statusline+=%m 		        " modified flag
set statusline+=%#h_color2#
set statusline+=\ [%l:%c]\ 	    "line and column number
set statusline+=%#h_warning#
set statusline+=%r		        "read only flag
set statusline+=%#h_color1#\ 
set statusline+=<<\ 		
set statusline+=%-40.40(%F\ >>%)%< 		" F: full path to file in buffer, <: where to truncate if line is too long, 
""set statusline+=%F\ >>		            " F: full path to file in buffer
set statusline+=%= 			    " =: separation between left and right aligned items
set statusline+=%#h_color2#
set statusline+=\ (%3P)\        " Percentage through file of displayed window.
set statusline+=%#h_color1#
set statusline+=%y              " y: type of file in buffer e.g [python], [javascript] or [vim] 
set statusline+=%#h_color2#
set statusline+=[%{&ff}]        " ff: file format e.g [unix] or [dos]
set statusline+=%#h_color1#
set statusline+=[%{&fenc}]      " fenc: file encoding e.g [utf-8]
""set statusline+=%-25.25(%y[%{&ff}][%{&fenc}]%) 	" y: type of file in buffer e.g [vim], ff: file format e.g [unix] or [dos], fenc: file encoding e.g [utf-8]
""http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'


