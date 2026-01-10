return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function()
            local actions = require('telescope.actions')

            local Path = require('plenary.path')
            local rooter = require('utils.rooter')

            require('telescope').setup({
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown({})
                    }
                },
                pickers = {
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end
                    },
                },
                defaults = {
                    path_display = function(_, path)
                        local p = Path:new(path)
                        p = Path:new(p:expand())
                        return p:make_relative(rooter.project_directory(path))
                    end,
                    mappings = {
                        i = {
                            ["<C-e>"] = { "<esc>", type = "command" },
                            ['<esc>'] = actions.close
                        },
                    },
                }
            })

            require('telescope').load_extension('ui-select')
        end,
    },
}
