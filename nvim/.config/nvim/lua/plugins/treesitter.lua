return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate',
        opts = {
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
                'javascript',
                'typescript',
                'html',
                'tsx',
                'python',
            },
            rainbow = {
                enable = true,
                extended_mode = true,
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
        },
    },
    -- Does not support new tree-sitter version.
    -- {
    --     'RRethy/nvim-treesitter-textsubjects',
    --     lazy = true,
    --     event = 'VeryLazy',
    --     config = function()
    --         require('nvim-treesitter.configs').setup({
    --             textsubjects = {
    --                 enable = true,
    --                 prev_selection = ',', -- (Optional) keymap to select the previous selection
    --                 keymaps = {
    --                     ['.'] = 'textsubjects-smart',
    --                     [';'] = 'textsubjects-container-outer',
    --                     ['i;'] = 'textsubjects-container-inner',
    --                 },
    --             }
    --         })
    --     end
    -- }
}
