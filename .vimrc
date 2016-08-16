set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'majutsushi/tagbar'

let delimitMate_jump_expansion = 1


Bundle 'ncol/vim-better-whitespace'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Don't use arrow keys, common
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" highlight lines with length > x where x depends on file type
function! LineLimit100()
  let &colorcolumn=join(range(101,999),",")
  highlight ColorColumn ctermbg=0
endfunction

function! LineLimit80()
  let &colorcolumn=join(range(81,999),",")
  highlight ColorColumn ctermbg=0
endfunction

autocmd FileType java call LineLimit100()
autocmd FileType python call LineLimit80()


let g:jedi#show_call_signatures="0"

let g:solarized_contrast="high"
let g:pymode_rope=0

" syntastic settings
let g:syntastic_java_checkers = ['glint', 'checkstyle']
let g:syntastic_auto_loc_list=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_async=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_balloons=1
let g:syntastic_ignore_files=['^/usr/lib/']
let g:voom_default_mode='python'

" always yank to system clipboard as well
set clipboard=unnamed
set go+=a
set mouse=a

" not vi compatible, things like filetype work then
set nocompatible
set number
set wrap

" set cindent
" set autoindent
" disable all the annoying bells and whistles
set noerrorbells visualbell t_vb=

syntax enable
set ls=2 " continuously show file name
set formatoptions+=o " continue comment marker in new lines
set scrolloff=3 " context lines around cursor
" set tabstop=2
" set expandtab
" set shiftwidth=2
set incsearch
set ignorecase
" set softtabstop=1
set textwidth=100
set wrapmargin=100
set nohls
set shortmess=Ta
" filetype indent on
set background=dark
colorscheme solarized

set showmatch

" keymap timeouts
set ttimeoutlen=200
set timeoutlen=2000

:command! -range=% -nargs=0 Space2Tab execute "<line1>,<line2>s/^\\( \\{".&ts."\\}\\)\\+/\\=substitute(submatch(0), ' \\{".&ts."\\}', '\\t', 'g')"

" in insert mode, press F12 to paste without
" ugly indentation "
set pastetoggle=<F12>

:filetype plugin indent on

set backupdir=~/.vim/tmp
execute "set directory=". &backupdir
silent execute '!mkdir -p '. &backupdir

:map align Align

" set cmdheight=2
:command! -nargs=1 Here :silent !here <args>
:cabbrev here <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Here' : 'here')<CR>


" be consistent (go to EOL) with capitalized C and D commands
nnoremap Y y$

" set nofoldenable

" insert mode to command mode
 " imap ii <Esc>:

"" command mode to normal mode
"cnoremap ff  <BS> <Esc> <Esc>

" treat wrapped lines like real lines
" nnoremap <Up> gk
" nnoremap <Down> gj

" reload file
:noremap <F3> :set hls!<CR>
:noremap <F4> :set number!<CR>

" fix annoying typos
:com W :w
:com Q :q
:com Wq :wq
" match Todo /\s\+$/ "
iab TODO TODO(alicemaindi):

" shift enter for inserting newlines in command mode
:noremap <S-CR> o<Esc> get to work
:noremap <CR> i<CR><Esc>

:map <Space> i<Space><Esc>l
:map <BS> hx<Esc>


" Indent Python in the Google way.

setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

let pyindent_nested_paren="&sw*2"

" open tagbar with F8
nmap <F8> :TagbarToggle<CR>


" enable  Google Jade - fixes dependencies for imports in Java files
command Jade !/google/data/ro/teams/jade/jade %

source /usr/share/vim/google/google.vim
" Enable locating google's vim plugins
Glug googlestyle
Glug gtimporter
Glug scampi
Glug ft-java
Glug coverage
Glug coverage-google
Glug blazedeps auto_filetypes=`['go', 'java']`
" see help coverage-config

Glug codefmt gofmt_executable="goimports"
Glug codefmt-google
autocmd FileType go AutoFormatBuffer gofmt
" Autoformat BUILD files
autocmd FileType bzl AutoFormatBuffer buildifier
" Autoformat java files
" autocmd FileType java AutoFormatBuffer google-java-format

" Blaze support
Glug blaze plugin[mappings]='<leader>b'

" Use google YCM
Glug youcompleteme-google
" disable youcompleteme C++ support
let g:ycm_filetype_specific_completion_to_disable = {'cpp': 1, 'c': 1}

Glug corpweb plugin[mappings]

" remove unused java imports and sort the remaining ones
" command FixImports ! python /google/src/head/depot/google3/tools/java/remove_unused_imports.py --fix %:t <CR> | ! python /google/src/head/depot/google3/tools/java/sort_java_imports.py %:t:t <CR>

" build all files in dir
" nnoremap ,b  :lcd %:p:s?/google3/.*$?/google3/? \| :!blaze build %:p:h:s?/home/\w*/\(\w*/\)*google3/??/... <CR>
" test all files in dir
" nnoremap ,t  :lcd %:p:s?/google3/.*$?/google3/? \| :!blaze test --test_output=errors %:p:h:s?/home/\w*/\(\w*/\)*google3/??/... <CR>
" remove unused imports
nnoremap ,r    :!/google/src/head/depot/google3/tools/java/remove_unused_imports.py --fix % <CR>

" Nicer Go code.
augroup filetypedetect
au BufNewFile,BufRead *.go set nolist
au BufNewFile,BufRead *.go set softtabstop=2
au BufNewFile,BufRead *.go set shiftwidth=2
au BufNewFile,BufRead *.go set noexpandtab
augroup END

set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=100         " How many undos
set undoreload=1000        " number of lines to save for undo


" Format large numbers with commas.
:command! TidyNumbers %s/\(\..*\)\@<!\d\@<=\(\(\d\{3}\)\+\d\@!\)\@=/,/g
