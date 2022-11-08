local Path = require('plenary.path')
local Job = require('plenary.job')

local rooter = require('rooter');

require('setup_lsp')
require('setup_cmp')

require('lualine').setup({ options = { theme = 'onedark' }})
require('tabline').setup({ options = { show_filename_only = true }})

require('lsp_lines').setup()
vim.diagnostic.config({ virtual_lines = false })

require('which-key').setup()

require('indent_blankline').setup()

require('bufdel').setup({
    next = 'alternate',
    quit = false,
})


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


function project_directory(path)
    return rooter.get_root(path) or vim.fn.expand('%:p:h')
end

function telescope_path_display(opts, path)
    local p = Path:new(path)
    p = Path:new(p:expand())
    return p:make_relative(project_directory(path))
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

function switch_mru_open_buffer()
    local bufnrs = vim.tbl_filter(function(b)
        local c = 1 ~= vim.fn.buflisted(b)
            or not vim.api.nvim_buf_is_loaded(b)
            or b == vim.api.nvim_get_current_buf()
        return not c
    end, vim.api.nvim_list_bufs())

    table.sort(bufnrs, function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)

    if next(bufnrs) then
        vim.api.nvim_win_set_buf(0, bufnrs[1])
    end
end


local telescope_builtin = require('telescope.builtin')
local telescope_sorters = require('telescope.sorters')

function telescope_find_files()
    telescope_builtin.find_files({
        cwd = project_directory(),
        find_command = { 'rg', '--files', '--color', 'never', '--hidden', '--iglob', '!.git/*' },
    })
end

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
        p = { telescope_find_files, 'Find files in project' },
        l = { '<cmd>lua require("lsp_lines").toggle()<cr>', 'Toggle error lines' },
        w = { '<cmd>BufDel<cr>', 'Delete the current buffer, but keep the window' },
        W = { '<cmd>bd<cr>', 'Delete the current buffer' }
    },
    ['<C-p>'] = { telescope_find_files, 'Find files in project' },
    ['<C-Tab>'] = { switch_mru_open_buffer, 'Switches to the most recently used open buffer' },
})
