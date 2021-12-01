require 'setup_lsp'
require 'setup_cmp'

require('lualine').setup({ options = { theme = 'onedark' }})
require('tabline').setup()

local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
    }
}

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = {},
    },
    ensure_installed = {
        'rust',
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    }
}

