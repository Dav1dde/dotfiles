return {
    {
        'milanglacier/minuet-ai.nvim',
        opts = {
            context_window = 32768,
            provider = 'claude',
            n_completions = 5,
            request_timeout = 10,
            virtualtext = {
                keymap = {
                    -- accept whole completion
                    accept = '<A-A>',
                    -- accept one line
                    accept_line = '<A-a>',
                    -- accept n lines (prompts for number)
                    -- e.g. 'A-z 2 CR' will accept 2 lines
                    accept_n_lines = '<A-z>',
                    -- Cycle to prev completion item, or manually invoke completion
                    prev = '<A-[>',
                    -- Cycle to next completion item, or manually invoke completion
                    next = '<A-]>',
                    dismiss = '<A-e>',
                },
            },
            provider_options = {
                claude = {
                    max_tokens = 512,
                    model = 'claude-opus-4-5',
                    stream = true,
                },
            },
        },
        config = function(_, opts)
            require('minuet').setup(opts)
            require('utils.minuet-fidget'):init()
        end,
        keys = {
            { '<A-[>', mode = 'i' },
            { '<A-]>', mode = 'i' },
            { '<A-y>', mode = 'i' },
        },
    },
}
