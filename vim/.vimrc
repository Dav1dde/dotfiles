set encoding=utf-8
set nocompatible              " be iMproved, required
filetype off                  " required

" set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

"Plugin 'VundleVim/Vundle.vim'

" Editor
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

"Plugin 'mkitt/tabline.vim'

" Git
Plugin 'tpope/vim-fugitive'

" Code Completion/Syntax
"Plugin 'valloric/youcompleteme'
Plugin 'scrooloose/syntastic'

" Code Display
Plugin 'flazz/vim-colorschemes'

" Editing
Plugin 'tpope/vim-surround'

" Other
Plugin 'felixhummel/setcolors.vim'

call vundle#end()

" Settings
filetype plugin indent on

let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_server_python_interpreter = '/usr/bin/python2'

syntax on
colorscheme molokai

set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab

" Tab
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'wombat'
let g:airline#extensions#tabline#enabled = 1

