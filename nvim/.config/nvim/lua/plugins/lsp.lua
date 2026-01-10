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
    },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        event = { 'BufEnter Cargo.toml' },
        opts = {
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
            completion = {
                crates = {
                    enabled = true,
                    max_results = 8,
                    min_chars = 2,
                }
            }
        },
        config = function(_, opts)
            local crates = require('crates');
            crates.setup(opts)

            require('which-key').add({
                {
                    { "<leader>c",  group = "Crates" },
                    { "<leader>cU", crates.upgrade_crate,           desc = "Upgrade Crate" },
                    { "<leader>cd", crates.show_dependencies_popup, desc = "Show Crate Dependencies" },
                    { "<leader>cf", crates.show_features_popup,     desc = "Edit Crate Features" },
                    { "<leader>cu", crates.update_crate,            desc = "Update Crate" },
                    { "<leader>cv", crates.show_versions_popup,     desc = "Show Crate Versions" },
                },
                {
                    mode = { "v" },
                    { "<leader>c",  group = "Crates" },
                    { "<leader>cU", crates.update_crates,  desc = "Upgrade selected Crates" },
                    { "<leader>cu", crates.upgrade_crates, desc = "Update selected Crates" },
                }

            })
        end
    }
}
