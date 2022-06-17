call plug#begin('~/.vim/plugged')

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
" Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/vim-vsnip'
Plug 'simrat39/rust-tools.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Language Support
Plug 'posva/vim-vue'

" Utiltiy
Plug 'terryma/vim-expand-region'
Plug 'ojroques/nvim-bufdel'
" Plug 'ap/vim-css-color'
Plug 'norcalli/nvim-colorizer.lua'

" Design
Plug 'hoob3rt/lualine.nvim'
Plug 'kdheepak/tabline.nvim'

" Style
Plug 'kyazdani42/nvim-web-devicons'

" Themes
Plug 'rktjmp/lush.nvim'
Plug 'tanvirtin/monokai.nvim'
Plug 'rafamadriz/neon'
Plug 'marko-cerovac/material.nvim'
Plug 'shaunsingh/moonlight.nvim'
Plug 'adisen99/codeschool.nvim'
Plug 'EdenEast/nightfox.nvim'

Plug 'tjdevries/colorbuddy.nvim'

Plug '~/workspaces/vim/davkai'
Plug '~/workspaces/vim/onebuddy'

call plug#end()

syntax on
set termguicolors
filetype plugin indent on

" Lua Configuration
lua require 'setup'

lua require'colorizer'.setup()

" Vim Config

" colorscheme monokai
" colorscheme onebuddy
colorscheme davkai
" lua require('colorbuddy').colorscheme('onebuddy')


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

" automatically save when losing focus
autocmd FocusLost * :wa
" leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q

" Reselect previous selection after indent
vmap < <gv
vmap > >gv

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

" Cleanup trailing whitespaces
nnoremap <silent> <leader><space> :%s/\s\+$//<CR>:let @/=''<CR>:w<CR>:set nohlsearch<CR>

" Quick buffer navigation (similar to IntelliJ Ctrl+E)
" nnoremap <leader>e <cmd>Telescope buffers<CR>
nnoremap <leader>e <cmd>lua require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true, sorter = require'telescope.sorters'.get_substr_matcher() })<CR>
" Quick search
nnoremap <leader>s <cmd>Telescope live_grep<CR>
nnoremap <leader>p <cmd>Telescope git_files<CR>
nnoremap <C-p> <cmd>Telescope git_files<CR>

" Close current buffer with Ctrl+W
nnoremap <leader>w :BufDel<CR>
nnoremap <leader>W :bd<CR>
" Swap to previous buffer with Ctrl+Tab
nnoremap <C-Tab> :b#<CR>

" turn off search indicators
nnoremap <silent> <leader>n :silent :nohlsearch<CR>
vnoremap <silent> <leader>n :silent :nohlsearch<CR>

nnoremap <silent> <leader>d :lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <F2> :lua vim.diagnostic.goto_next()<CR>
inoremap <silent> <F2> :lua vim.diagnostic.goto_next()<CR>

nmap <leader>sp :TSHighlightCapturesUnderCursor<CR>
