call plug#begin('~/.vim/plugged')

""" Libs
" The lib everyone needs
Plug 'nvim-lua/plenary.nvim'

""" LSP
" Manage/Install LSPs
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Lsp Config
Plug 'neovim/nvim-lspconfig'
" Global and per Project LSP Settings
Plug 'tamago324/nlsp-settings.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
" Tiny bit smarter text subjects
Plug 'RRethy/nvim-treesitter-textsubjects'
" Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" nvim-cmp stuff
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" Special LSP helpers
Plug 'simrat39/rust-tools.nvim'
Plug 'pmizio/typescript-tools.nvim'

""" Debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

""" UI
" Telescope for all things searching
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'

" Keybinds, setting up and previewing
Plug 'folke/which-key.nvim'

""" Language Support
" Just Files
Plug 'NoahTheDuke/vim-just'
" Crates in Cargo.toml
Plug 'saecki/crates.nvim'

""" Git
" Git Integration for Buffers
Plug 'lewis6991/gitsigns.nvim'

""" Utiltiy
" Detect tabstop and shiftwidth automatically
Plug 'tpope/vim-sleuth'
" Toggle code with comments
Plug 'numToStr/Comment.nvim'
" Smart region expansion
Plug 'terryma/vim-expand-region'
" Buffer Management, delete buffer and keep the window
Plug 'ojroques/nvim-bufdel'
" Fancy Colors
Plug 'norcalli/nvim-colorizer.lua'
" Indent Guides
Plug 'lukas-reineke/indent-blankline.nvim'
" Highlight use of the word under the cursor
Plug 'RRethy/vim-illuminate'
" Show marks
Plug 'chentoast/marks.nvim'
" Autoclose brackets
" Plug 'm4xshen/autoclose.nvim'
" Plug 'altermo/ultimate-autopair.nvim'
Plug 'windwp/nvim-autopairs'
" Code Action Bubble
Plug 'kosayoda/nvim-lightbulb'

""" Design
Plug 'hoob3rt/lualine.nvim'
Plug 'kdheepak/tabline.nvim'
" Show Notifications and LSP progress
Plug 'j-hui/fidget.nvim'
" File Type Icons
Plug 'kyazdani42/nvim-web-devicons'

""" Themes
Plug 'rktjmp/lush.nvim'
Plug 'tanvirtin/monokai.nvim'
Plug 'rafamadriz/neon'
Plug 'marko-cerovac/material.nvim'
Plug 'shaunsingh/moonlight.nvim'
Plug 'adisen99/codeschool.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'Yazeed1s/minimal.nvim'
Plug 'sainnhe/sonokai'
Plug 'folke/tokyonight.nvim'

call plug#end()

syntax on
set termguicolors
filetype plugin indent on

""" Theme
let g:sonokai_disable_terminal_colors = 1
let g:sonokai_style = 'shusia'
let g:sonokai_current_word = 'underline'
colorscheme sonokai

" Manual Overrides
let s:configuration = sonokai#get_configuration()
let s:palette = sonokai#get_palette(s:configuration.style, s:configuration.colors_override)
call sonokai#highlight('LightBulbVirtualText', s:palette.yellow, s:palette.none)
" call sonokai#highlight('TSParameter', s:palette.purple, s:palette.none, 'italic')
" hi TSParameter guifg='#f533d8'
hi TSParameter guifg='#ffb8f4'

""" Lua Configuration
lua require('setup')


""" Vim Config
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

" Yank to clipboard
vmap Y "+y

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
if has('linux')
    map <Esc>[27;5;9~ <C-Tab>
    map <Esc>[27;6;9~ <C-S-Tab>
    imap <Esc>[27;6;9~ <Esc><C-S-Tab>
elseif has('mac')
    map ˜ <A-n>
    map π <A-p>
endif

" Mouse
set mouse=a

" Cleanup trailing whitespaces
nnoremap <silent> <leader><space> :%s/\s\+$//<CR>:let @/=''<CR>:w<CR>:set nohlsearch<CR>

" turn off search indicators
nnoremap <silent> <leader>n :silent :nohlsearch<CR>
vnoremap <silent> <leader>n :silent :nohlsearch<CR>

" nmap <leader>sp :TSHighlightCapturesUnderCursor<CR>
function! HiThere(group) abort
    let out = trim(execute('hi ' .. a:group))
    let splits = split(out, ' \+')
    echon splits[0] .. ' '
    execute 'echohl ' .. splits[0]
    echon splits[1] .. ' '
    echohl None
    echon join(splits[2:])
    echom ''
    if out =~ 'links to'
        let a = split(out, ' ')[-1]
        call HiThere(a)
    endif
endfunction
command! -nargs=1 -complete=highlight HiThere call HiThere(<q-args>)
