"
" Good reads (to be expanded):
"   * https://stackoverflow.com/a/26710166/969534
"   * https://nvie.com/posts/how-i-boosted-my-vim/
"   * http://lucumr.pocoo.org/2010/7/29/sharing-vim-tricks/
"   * http://items.sjbach.com/319/configuring-vim-right
"   * http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"   * https://www.youtube.com/watch?v=XA2WjJbmmoM
"

set encoding=utf-8
set nocompatible
filetype off            " required for vundle

" set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

"Plugin 'VundleVim/Vundle.vim'

" Editor
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'sjl/gundo.vim'
Plugin 'jaxbot/semantic-highlight.vim'
Plugin 'francoiscabrol/ranger.vim'

"Plugin 'mkitt/tabline.vim'

" Git
Plugin 'tpope/vim-fugitive'

" Code Completion/Syntax
" Plugin 'scrooloose/syntastic'
Plugin 'rust-lang/rust.vim'

" Code Display
Plugin 'flazz/vim-colorschemes'
Plugin 'luochen1990/rainbow'

" Editing
Plugin 'tpope/vim-surround'

" Other
Plugin 'felixhummel/setcolors.vim'

call vundle#end()

"" Settings
" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_server_python_interpreter = '/usr/bin/python3'

" Snytastic
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_loc_list_height = 5

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'wombat'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ycm#enabled = 1

" CtrlP
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](\.(git|hg|svn))|(ownCloud|node_modules|target|dist|__pycache__)$',
            \ 'file': '\v\.(pyc|pyo|o|a|so|exe|dll|png|jpeg|jpg|desktop|bin)$'
            \ }

" Rainbow
let g:rainbow_active = 1

" Rust
let g:racer_cmd = "/usr/bin/racer"

" Vim
syntax on
filetype plugin indent on

colorscheme molokai
" Change the awful matching paren highlighting in molokai
highlight MatchParen cterm=underline ctermbg=none ctermfg=none

set title                       " automaticall set title to the file that is open
set hidden                      " allow unsaved buffers
set autochdir                   " change into the directory of the currently opened file
set history=1000                " bigger history
set undolevels=1000             " bigger undo buffer

set relativenumber              " show relative line numbers
set number                      " show the current line number
set colorcolumn=120             " visual indicator when lines get long

set tabstop=4                   " a tab is 4 spaces wide
set shiftwidth=4                " autoindent with 4 spaces
set shiftround                  " indent to a multiple of shiftwidth with < and >
set expandtab

set smartcase                   " ignore case when search string is all lowercase
set hlsearch                    " highlight search terms
set incsearch                   " show search matches while typing
set gdefault                    " /g by default for replacments

set wildmenu                    " Completion menu
set wildmode=longest:full,full  " Completion mode

set scrolloff=3                 " Keep cursor 3 lines away from window border

set tags=./tags;/               " set tags location

" rusty-tags integration, for rust ctags
" autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
" autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

" automatically save when losing focus
autocmd FocusLost * :wa

"" Mappings
let mapleader=" "

" alias :W to :w
" https://stackoverflow.com/a/3879737/969534
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

" Make special Tab escapes work in vim
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>

" Open graphical undo browser
nnoremap <leader>u :GundoToggle<CR>
" Cleanup trailing whitespaces
nnoremap <silent> <leader><space> :%s/\s\+$//<CR>:let @/=''<CR>:w<CR>
" quick buffer navigation (similar to IntelliJ Ctrl+E)
nnoremap <leader><C-e> :CtrlPBuffer<CR>
" Jump to tag/implementation
nnoremap <leader><C-b> :YcmCompleter GoTo<CR>
nnoremap <C-b> :YcmCompleter GoTo<CR>

" Close current buffer with Ctrl+W
nnoremap <leader><C-w> :bd<CR>
" Swap to previous buffer with Shift+Tab
nnoremap <C-Tab> :b#<CR>

" turn off search indicators
nnoremap <silent> <leader>n :silent :nohlsearch<CR>

augroup rust
    autocmd FileType rust nnoremap <F9> :w<CR>:!cargo run<CR>
    autocmd FileType rust inoremap <F9> <ESC>:w<CR>:!cargo run<CR>

    autocmd FileType rust nnoremap <leader>f :RustFmt<CR>
augroup END
