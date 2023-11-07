local mason = require('mason');
local mason_lspconfig = require('mason-lspconfig');

local nvim_lsp = require('lspconfig')
local nlspsettings = require('nlspsettings')

mason.setup()
mason_lspconfig.setup({
    ensure_installed = {
        'cssls',
        'eslint',
        'emmet_ls',
        'html',
        'tailwindcss',
        'pyright',
    },
})

nlspsettings.setup()

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*`
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'g0', '<cmd>lua require"telescope.builtin".lsp_document_symbols{}<CR>', opts)
    buf_set_keymap('n', 'gW', '<cmd>lua require"telescope.builtin".lsp_dynamic_workspace_symbols{}<CR>', opts)


    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    buf_set_keymap('n', '<C-b>', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>b', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>F6', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

local opts = { 
    on_attach = on_attach, 
    debounce_text_changes = 150,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- rust-analyzer is initialized with rust-tools
local lsp_servers = {
    'cssls', 'eslint', 'emmet_ls', 'html', 'tailwindcss', 'pyright'
}

for _, lsp in ipairs(lsp_servers) do
    nvim_lsp[lsp].setup(opts)
end

require('rust-tools').setup({
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
        },
    },
    server = opts,
})

require('typescript-tools').setup({
    on_attach = on_attach,
})
