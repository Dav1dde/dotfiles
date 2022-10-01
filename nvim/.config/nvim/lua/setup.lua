local Path = require('plenary.path')
local Job = require('plenary.job')

require('setup_lsp')
require('setup_cmp')

require('lualine').setup({ options = { theme = 'onedark' }})
require('tabline').setup()

require("lsp_lines").setup()
vim.diagnostic.config({ virtual_lines = false })

require('which-key').setup()

require('indent_blankline').setup()


require('nvim-treesitter.configs').setup {
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
    },
    textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<C-n>',
            node_incremental = '<C-n>',
            scope_incremental = '<C-s>',
            node_decremental = '<C-r>',
        },
    },
}


function project_directory(cwd)
    local root = require('nvim-rooter').get_root()
    if root then
        return root
    end

    return vim.fn.expand('%:p:h')
end

function telescope_path_display(opts, path)
    local p = Path:new(path)
    p = Path:new(p:expand())
    return p:make_relative(project_directory(opts.cwd))
end

local actions = require('telescope.actions')

require('telescope').setup{
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {
                -- even more opts
            }
        }
    },
    defaults = {
        path_display = telescope_path_display,
        mappings = {
            i = {
                ['<esc>'] = actions.close
            },
        },
    }
}

require('telescope').load_extension('ui-select')

require('nvim-rooter').setup({
    manual = true
})

local telescope_builtin = require('telescope.builtin')
local telescope_sorters = require('telescope.sorters')

require('which-key').register({
    ['<leader>'] = {
        s = {
            function() telescope_builtin.live_grep({ cwd = project_directory() }) end,
            'Live Grep in all files of the current project'
        },
        e = {
            function()
                telescope_builtin.buffers({
                    sort_lastused = true,
                    ignore_current_buffer = true,
                    sorter = telescope_sorters.get_substr_matcher()
                })
            end,
            'Quick access to all recently accessed/open buffers'
        },
        p = {
            function() telescope_builtin.find_files({ cwd = project_directory() }) end,
            'Find files in project'
        },
        l = { '<cmd>lua require("lsp_lines").toggle()<cr>', 'Toggle error lines' },
    },
    ['<C-p>'] = { '<leader>p<cr>', 'Alias for <leader>p', noremap = false }
})
