"
" Good reads (to be expanded):
"   * https://stackoverflow.com/a/26710166/969534
"   * https://nvie.com/posts/how-i-boosted-my-vim/
"   * http://lucumr.pocoo.org/2010/7/29/sharing-vim-tricks/
"   * http://items.sjbach.com/319/configuring-vim-right
"   * http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"   * https://www.youtube.com/watch?v=XA2WjJbmmoM
"   * https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
"

set encoding=utf-8
set nocompatible
filetype off            " required for vundle

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

"Plugin 'VundleVim/Vundle.vim'

" Editor
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'mbbill/undotree'
Plugin 'jaxbot/semantic-highlight.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'tpope/vim-repeat'
Plugin 'lambdalisue/nerdfont.vim'
Plugin 'lambdalisue/fern.vim'
Plugin 'lambdalisue/fern-renderer-nerdfont.vim'
Plugin 'lambdalisue/fern-hijack.vim'
Plugin 'lambdalisue/fern-git-status.vim'
Plugin 'lambdalisue/fern-mapping-git.vim'
Plugin 't9md/vim-choosewin'
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
" Plugin 'felixhummel/setcolors.vim'
Plugin 'zainin/vim-mikrotik'

call vundle#end()

"" Settings
" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_always_populate_location_list = 1
set completeopt-=preview


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

function ProjectDirectory()
  let l:p = ''
  if system('git status') =~ '^fatal'
     let l:p = expand('%:p:h')
  else
    let l:p = trim(system('git rev-parse --show-toplevel'))
  endif

  return trim(system('realpath --relative-to=' . getcwd() . ' ' . fnameescape(l:p)))
endfunction

" Fzf
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>) . ' ' . ProjectDirectory(),
  \   1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)


" Rainbow
let g:rainbow_active = 1

" Fern
let g:fern#renderer = "nerdfont"

" ChooseWin
let g:choosewin_overlay_enable = 0

" Rust
let g:racer_cmd = "/usr/bin/racer"

" Vim
syntax on
filetype plugin indent on

colorscheme molokai
" Change the awful matching paren highlighting in molokai
highlight MatchParen cterm=underline ctermbg=none ctermfg=none
" Change the Visual highlight color which is really hard to see
highlight Visual cterm=bold ctermbg=Blue ctermfg=NONE
" Change the Comment color, really hard to see on dark background
highlight Comment ctermfg=145

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
" leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

"" Mappings
let mapleader=" "

" Expand and Shrink selection
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Jump to the end of paste
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Beginning of the Line
map H ^
" End of the Line
map L $

" Move by display line not physical line
nnoremap j gj
nnoremap k gk

" alias :W to :w
" https://stackoverflow.com/a/3879737/969534
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

" Make special Tab escapes work in vim
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>
imap <Esc>[27;6;9~ <Esc><C-S-Tab>

" Tab Navigation
nnoremap th :tabfirst<CR>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>

" Open graphical undo browser
nnoremap <leader>u :UndotreeToggle<CR>
" Cleanup trailing whitespaces
nnoremap <silent> <leader><space> :%s/\s\+$//<CR>:let @/=''<CR>:w<CR>:set nohlsearch<CR>
" quick buffer navigation (similar to IntelliJ Ctrl+E)
nnoremap <leader>e :CtrlPBuffer<CR>
" Quick search using ripgrep
nnoremap <leader>s :Rg<CR>

" File Browser
noremap <leader>f :execute printf(':Fern %s -drawer -reveal=%s -toggle', ProjectDirectory(), expand('%:p'))<CR>

" Open Window Chooser
nmap - <Plug>(choosewin)

" Jump to tag/implementation
nnoremap <leader>b :YcmCompleter GoTo<CR>
nnoremap <leader>r :YcmCompleter GoToReferences<CR>
nnoremap <C-b> :YcmCompleter GoTo<CR>
nnoremap <leader>q :YcmCompleter GetDoc<CR>
nnoremap <leader><F6> :YcmCompleter RefactorRename<space>
" Jump to the next error
nnoremap <F2> :lnext<CR>

" Close current buffer with Ctrl+W
nnoremap <leader>w :bd<CR>
" Swap to previous buffer with Ctrl+Tab
nnoremap <C-Tab> :b#<CR>
nnoremap <S-Tab> :CtrlPBuffer<CR>

" turn off search indicators
nnoremap <silent> <leader>n :silent :nohlsearch<CR>
vnoremap <silent> <leader>n :silent :nohlsearch<CR>

augroup rust
    autocmd FileType rust nnoremap <F9> :w<CR>:!cargo run<CR>
    autocmd FileType rust inoremap <F9> <ESC>:w<CR>:!cargo run<CR>

    autocmd FileType rust nnoremap <leader>m :RustFmt<CR>:w<CR>
augroup END
