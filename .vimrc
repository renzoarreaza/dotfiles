" http://vimdoc.sourceforge.net/htmldoc/options.html
" https://devhints.io/vimscript
" https://jonasjacek.github.io/colors/
"##########
" Visuals
"##########
set showmatch			" highlight matching [{()}]
syntax on 			" enable syntax highlighting
set number relativenumber       " setting hybrid line numbers
augroup numbertoggle            " auto-toggle between hybrid and absolute line numbers in command and insert modes respectively
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" use \& to create split view with currently open file and enable scrollbind
nnoremap <leader>& :vs<cr>:set scb<cr>2<c-w>w<c-f>:set scb<cr>1<c-w>w
" use \* to close split on the right and disable scrollbind 
nnoremap <leader>* 2<c-w>w:set noscb<cr>:q<cr>:set noscb<cr>
" achieves the same as the above mapping. 
" nnoremap :q :windo set noscb<cr>:q

colorscheme peachpuff	" picking a colorscheme for syntax
set cursorline		" Highlight the screen line of the cursor
"hi CursorLine term=bold cterm=bold guibg=Grey40 	" change cursorline from underline to highlight
"hi CursorLine   cterm=NONE ctermbg=darkgray
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
    "It is setting of color for terminal: background color - ctermbg, and text color - ctermfg. 
    "For using in graphical window, add parameters guibg=darkred guifg=white
"nnoremap H :set cursorline! cursorcolumn!<CR>

set tabstop=4 shiftwidth=4 softtabstop=4  " number of visual spaces per TABs
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2

imap jj <Esc>		" use jj to exit insert mode
nmap :W :w
nmap :Q :q
nmap :WQ :wq
set wildmenu            " visual autocomplete for command menu

"#############
" Statusline
"#############
set laststatus=2        	" Show _always_ the statusline
" Creating colorschemes
highlight h_white ctermbg=15 ctermfg=0  
highlight h_cyan ctermbg=30 ctermfg=0  


if $TERM ==? 'xterm'
	" Simple colors
	highlight h_blue cterm=reverse ctermbg=4 ctermfg=15
	highlight h_d_blue ctermbg=4 ctermfg=15
	highlight h_red ctermbg=1 ctermfg=0
else " xterm-256color
	" Default 
	highlight h_blue ctermbg=39 ctermfg=15  
	highlight h_d_blue ctermbg=25 ctermfg=15 
	highlight h_red ctermbg=196 ctermfg=0  
endif

" :hi TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
" :hi TabLine ctermfg=Blue ctermbg=Yellow
" :hi TabLineSel ctermfg=Red ctermbg=Yellow
" TabLineSel - is the current (so to say) active tab label.
" TabLine - are the labels which are not currently active.
" TabLineFill - is the remaining of the tabline where there is no labels (background).


" Statusline format
set statusline=
"" set statusline+=[%n] 		    " buffer number
set statusline+=%#h_red#
set statusline+=%m 		        " modified flag
set statusline+=%#h_d_blue#
set statusline+=\ [%l:%c]\ 	    "line and column number
set statusline+=%#h_red#
set statusline+=%r		        "read only flag
set statusline+=%#h_blue#\ 
set statusline+=<<\ 		
set statusline+=%-40.40(%F\ >>%)%< 		" F: full path to file in buffer, <: where to truncate if line is too long, 
""set statusline+=%F\ >>		            " F: full path to file in buffer
""set statusline+=%#h_cyan#		
set statusline+=%= 			    " =: separation between left and right aligned items
set statusline+=%#h_d_blue#
set statusline+=\ (%3P)\        " Percentage through file of displayed window.
set statusline+=%#h_blue#
set statusline+=%y              " y: type of file in buffer e.g [python], [javascript] or [vim] 
set statusline+=%#h_d_blue#
set statusline+=[%{&ff}]        " ff: file format e.g [unix] or [dos]
set statusline+=%#h_blue#
set statusline+=[%{&fenc}]      " fenc: file encoding e.g [utf-8]
""set statusline+=%-25.25(%y[%{&ff}][%{&fenc}]%) 	" y: type of file in buffer e.g [vim], ff: file format e.g [unix] or [dos], fenc: file encoding e.g [utf-8]
""http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
set incsearch           " search as characters are entered
" set hlsearch            " highlight matches
" turn off search highlight
" nnoremap <leader><space> :nohlsearch<CR>
 
" move vertically by visual line (usefull for wrapped lines)
nnoremap j gj
nnoremap k gk

"##########
" Folding
"##########
setlocal foldmethod=indent   
autocmd Filetype c setlocal foldmethod=syntax " syntax folding for C files 
set foldnestmax=10 
set nofoldenable
set foldlevel=2
nnoremap <space> za	" space open/closes folds
nnoremap <C-@> zR	" unfold all (Ctrl-<Space>)
