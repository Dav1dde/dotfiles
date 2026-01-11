local LSP = require('utils.lsp')

vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    before_init = function(_, config)
        local codesettings = require('codesettings')
        codesettings.with_local_settings(config.name, config)
    end,
    debounce_text_changes = 150,
})

local lsp_attach = vim.api.nvim_create_augroup('my.lsp.attach', {
    clear = true
})
vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_attach,
    callback = function(ev)
        local bufnr = ev.buf
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
        end

        -- See `:help vim.lsp.*`
        nmap('gD', LSP.declaration, 'Goto Declaration')
        nmap('gd', LSP.definition, 'Goto Definition')
        nmap('gi', LSP.implementation, 'Goto Implementation')
        nmap('gr', LSP.references, 'Show References / Goto Reference')
        nmap('g0', require('telescope.builtin').lsp_document_symbols, 'Show Document Symbols')
        nmap('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Show Workspace Symbols')

        nmap('<leader>rn', vim.lsp.buf.rename, 'Rename Symbol')
        nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Actions')
        nmap('<A-Cr>', LSP.code_action_quickfix, 'Autofix')

        nmap('<C-k>', vim.lsp.buf.signature_help, 'Show Signature Help')

        nmap('<leader>f', vim.lsp.buf.format, 'Format the current Buffer')

        if LSP.setup_codelens_refresh(client, bufnr) then
            nmap('<leader>cr', vim.lsp.codelens.run, 'Code Lens Run')
        end

        if string.match(client.name, 'rust.analyzer') then
            nmap('god', function() vim.cmd.RustLsp('openDocs') end, 'Open Documentation')
            nmap('goc', function() vim.cmd.RustLsp('openCargo') end, 'Open Cargo.toml')
            nmap('gop', function() vim.cmd.RustLsp('parentModule') end, 'Open Parent Module')
        end
    end,
})
