return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'mason-org/mason.nvim',           opts = {} },
            { 'mason-org/mason-lspconfig.nvim', config = function() end },
        },
        config = function()
            require('config.lsp')
        end
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false, -- This plugin is already lazy
    },
    {
        'tamago324/nlsp-settings.nvim',
        lazy = true,
        opts = {}
    }
}
