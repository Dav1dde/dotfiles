return {
    {
        'hoob3rt/lualine.nvim',
        opts = { options = { theme = 'onedark' } }
    },
    {
        'kdheepak/tabline.nvim',
        opts = { options = { show_filename_only = true } },
    },
    {
        -- Notifications and LSP Progress
        'j-hui/fidget.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        'kyazdani42/nvim-web-devicons',
        event = 'VeryLazy',
    },
    {
        'echasnovski/mini.icons',
        event = 'VeryLazy',
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            require('config.whichkey')
        end,
    },
    {
        'folke/trouble.nvim',
        cmd = { 'Trouble' }
    },
}
