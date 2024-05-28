local mason = require('mason');
local mason_lspconfig = require('mason-lspconfig');
local lspconfig = require('lspconfig')
local nlspsettings = require('nlspsettings')

-- rust-analyzer is initialized with rust-tools
-- typescript ist initialized with typescript-tools
local servers = {
    cssls = {},
    eslint = {},
    emmet_ls = {},
    html = {},
    tailwindcss = {},
    pyright = {},
    lua_ls = {
        Lua = {
            telemetry = { enable = false },
            diagnostics = {
                globals = {
                    'vim', -- Vim
                    'redis', 'ARGV', 'KEYS', -- Redis
                }
            }
        }
    },
}

mason.setup()
mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })

nlspsettings.setup()

local LSP = {}

function LSP.make_find_into_goto_handler(name)
    local handler = vim.lsp.handlers[name]
    if handler == nil then
        error('no parent handler for: ' .. name)
    end

    local inner = function(a, result, ctx, config)
        if #result >= 1 and #result <= 2 then
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            local pp = ctx.params.position

            -- Find the one item that is not the one we requested
            for _, item in ipairs(result) do
                local rs = item.range['start']
                local re = item.range['end']
                local inLineRange = rs.line >= pp.line and re.line <= pp.line
                local inCharacterRange = rs.line >= pp.line and re.line <= pp.line

                if not inLineRange and not inCharacterRange then
                    vim.lsp.util.show_document(item, client.offset_encoding, { reuse_win = true })
                    return
                end
            end
        end

        handler(a, result, ctx, config)
    end

    return { [name] = inner }
end

function LSP.make_handlers(...)
    return vim.tbl_extend('force', ...)
end

function LSP.setup_codelens_refresh(client, bufnr)
    local status_ok, codelens_supported = pcall(function()
        return client.supports_method("textDocument/codeLens")
    end)

    if not status_ok or not codelens_supported then
        return false
    end

    local group = "lsp_code_lens_refresh"
    local cl_events = { "BufEnter", "InsertLeave" }
    local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
        group = group,
        buffer = bufnr,
        event = cl_events,
    })
    if ok and #cl_autocmds > 0 then
        return false
    end

    vim.api.nvim_create_augroup(group, { clear = false })
    vim.api.nvim_create_autocmd(cl_events, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.codelens.refresh,
    })
    return true
end

function LSP.code_action_quickfix()
    vim.lsp.buf.code_action({
        context = {
            only = { 'quickfix', 'source' },
        },
        apply = true
    })
end

function LSP.on_attach(client, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
    end

    -- See `:help vim.lsp.*`
    nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
    nmap('gi', vim.lsp.buf.implementation, 'Goto Implementation')
    nmap('gr', vim.lsp.buf.references, 'Show References / Goto Reference')
    nmap('g0', require('telescope.builtin').lsp_document_symbols, 'Show Document Symbols')
    nmap('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Show Workspace Symbols')

    nmap('<leader>rn', vim.lsp.buf.rename, 'Rename Symbol')
    nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Actions')
    nmap('<A-Cr>', LSP.code_action_quickfix, 'Autofix')

    nmap('<leader>q', vim.lsp.buf.hover, 'Show Hover / Docs')
    nmap('K', vim.lsp.buf.hover, 'Show Hover / Docs')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Show Signature Help')

    nmap('<leader>f', vim.lsp.buf.format, 'Format the current Buffer')

    -- Some remainders of my Intellij muscle memory
    nmap('<C-b>', vim.lsp.buf.implementation, 'Goto Implementation')
    nmap('<leader>b', vim.lsp.buf.implementation, 'Goto Implementation')
    nmap('<leader>F6', vim.lsp.buf.rename, 'Rename Symbol')

    if LSP.setup_codelens_refresh(client, bufnr) then
        nmap('<leader>cr', vim.lsp.codelens.run, 'Code Lens Run')
    end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local opts = {
    on_attach = LSP.on_attach,
    handlers = LSP.make_handlers(
    -- Declaration, Definition and Implementation already jump to the location if there is only a single choice
        LSP.make_find_into_goto_handler('textDocument/references'),
        {}
    ),
    debounce_text_changes = 150,
    capabilities = capabilities,
    cmd_env = {
        RUSTUP_TOOLCHAIN = "stable"
    }
}

for name, settings in pairs(servers) do
    lspconfig[name].setup(vim.tbl_extend('force', opts, { settings = settings }))
end

require('rust-tools').setup({
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
        },
    },
    server = opts,
})

require('typescript-tools').setup(opts)
