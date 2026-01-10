return {
    { 'nvim-lua/plenary.nvim', lazy = true },
    {
        'ojroques/nvim-bufdel',
        lazy = true,
        opts = {
            next = 'alternate',
            quit = false,
        },
        cmd = { 'BufDel', 'BufDelAll', 'BufDelOther' }
    },
    {
        -- Small git signs for buffers
        'lewis6991/gitsigns.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        -- Highlight use of the word under the cursor
        'RRethy/vim-illuminate',
        event = 'VeryLazy',
    },
    {
        -- Show marks
        'chentoast/marks.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        -- Indent Guides
        'lukas-reineke/indent-blankline.nvim',
        main = "ibl",
        event = 'VeryLazy',
        opts = {},
    },
    {
        -- Fancy Colors
        'norcalli/nvim-colorizer.lua',
        event = 'VeryLazy',
        opts = {},
    },
    {
        --Toggle code with comments
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        -- Detect tabstop and shiftwidth automatically
        'tpope/vim-sleuth',
        event = 'VeryLazy',
        config = function() end,
    },
    {
        -- Autoclose brackets
        'windwp/nvim-autopairs',
        event = 'VeryLazy',
        opts = {},

    },
    {
        --Code Action Bubble
        'kosayoda/nvim-lightbulb',
        event = 'VeryLazy',
        opts = {
            action_kinds = { 'quickfix', 'source' },
            sign = { enabled = false },
            virtual_text = { enabled = true },
            autocmd = { enabled = true }
        },
    },
    {
        -- Justfiles
        'NoahTheDuke/vim-just',
        ft = { 'just' },
    }
}
