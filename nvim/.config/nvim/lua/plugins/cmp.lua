return {
    {
        'saghen/blink.cmp',
        event = { 'InsertEnter', 'CmdLineEnter' },
        version = '1.*',
        opts = {
            keymap = {
                preset = 'enter',
                ['<A-y>'] = { function(cmp) cmp.show { providers = { 'minuet' } } end }
            },
            completion = {
                menu = {
                    draw = {
                        columns = { { 'kind_icon' }, { 'label', gap = 1 } },
                        components = {
                            label = {
                                width = { fill = true, max = 75 },
                                text = function(ctx)
                                    return require('colorful-menu').blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require('colorful-menu').blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
                ghost_text = { enabled = true },
            },
            fuzzy = {
                sorts = { 'exact', 'score', 'sort_text' },
            },
            cmdline = { enabled = false },
            sources = {
                default = { 'lsp', 'path', 'buffer' },
                providers = {
                    minuet = {
                        name = 'minuet',
                        module = 'minuet.blink',
                        async = true,
                        timeout_ms = 10000,
                        score_offset = 50
                    },
                }
            },
        },
        opts_extend = { 'sources.default' }
    },
    {
        'xzbdmw/colorful-menu.nvim',
        lazy = true,
        opts = {
            max_width = 75,
        },
    },
}
