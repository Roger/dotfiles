" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set expandtab
set tabstop=4
set shiftwidth=4

set expandtab                     " always use spaces instead of tabs
set smarttab                      " <tab>
set list                          " show whitespace
set listchars=tab:»·
set listchars+=trail:·

set wildmode=longest:full,full
set wildmenu

set showmatch

set background=dark
colorscheme wombat256roger

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=1000    " keep 1000 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

let mapleader=","

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  " Hide highlight
  nmap <silent> <leader>n :silent :nohlsearch<CR>

endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  " html 2 espacios
  autocmd FileType html setlocal tabstop=2
  autocmd FileType html setlocal shiftwidth=2

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  " Highlight Warning on 77+ lines and Error on 81+
  au BufWinEnter *.py let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
  au BufWinEnter *.py let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

  au BufEnter * lcd %:p:h " change directory the current file's

  " support for eggs browse
  au BufReadCmd *.egg call zip#Browse(expand("<amatch>"))

  au BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
  au BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
  au BufRead,BufNewFile *.vala            setfiletype vala
  au BufRead,BufNewFile *.vapi            setfiletype vala

  " automatically open and close the popup menu / preview window
  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
else

  set autoindent    " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Command Exists?
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis

" searching options
set ignorecase
set incsearch
set smartcase

" scrolling options
set scrolljump=5 " lines to scroll when cursor leaves screen
set scrolloff=3 " minimum lines to keep above and below cursor

" nice cursor line highlight
set cursorline
hi CursorLine guibg=#000000 ctermbg=235 cterm=NONE

" enter in paste mode pressing <leader>p
set pastetoggle=<leader>p

" Control + n/p to move in tabs
nnoremap <silent> <C-n> :tabnext<CR>
nnoremap <silent> <C-p> :tabprev<CR>

" 256 colors support =)
set t_Co=256

" NERDTree
nmap <silent> <leader>f :silent :NERDTreeToggle<CR>

" Exec something and restore position
function! <SID>ExecAndRestore(cmd)
    " Preparation: save last search, and cursor position.
    let cmd=a:cmd
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    exec cmd
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" Toggle Case
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ ygv"=TwiddleCase(@")<CR>Pgv


" Expand tabs
nnoremap <silent> <leader>e :call <SID>ExecAndRestore("%s/\t/    /g")<CR>
" Strip white spaces
nnoremap <silent> <leader>s :call <SID>ExecAndRestore('%s/\s\+$//e')<CR>
