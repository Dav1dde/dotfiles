local mason = require('mason');
local mason_lspconfig = require('mason-lspconfig');
local lspconfig = require('lspconfig')
local nlspsettings = require('nlspsettings')

-- rust-analyzer is initialized with rustaceanvim
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
                    'vim',                   -- Vim
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


--- Jumps to a location and focuses on it in the current window.
---
--- The passed location needs to follow the format as returned by
--- `vim.util.locations_to_items()`.
function LSP.goto_location_item(location)
    local bufnr = vim.fn.bufadd(location.filename)

    -- Save position in jumplist
    vim.cmd("normal! m'")

    -- Push a new item into tagstack
    local from = { vim.fn.bufnr('%'), vim.fn.line('.'), vim.fn.col('.'), 0 }
    local items = { { tagname = vim.fn.expand('<cword>'), from = from } }
    vim.fn.settagstack(vim.fn.win_getid(), { items = items }, 't')

    local win = vim.fn.win_findbuf(bufnr)[1] or vim.api.nvim_get_current_win()

    vim.bo[bufnr].buflisted = true
    vim.api.nvim_win_set_buf(win, bufnr)
    vim.api.nvim_set_current_win(win)

    vim.api.nvim_win_set_cursor(win, { location.lnum, location.col })
    vim._with({ win = win }, function()
        -- Open folds under the cursor
        vim.cmd('normal! zv')
    end)
end

--- Creates an `on_list` callback for LSP handlers which support an `on_list` callback,
--- which auto jumps to the only result.
function LSP.make_autojump_on_list()
    local window = vim.api.nvim_get_current_win()
    local lnum, col = unpack(vim.api.nvim_win_get_cursor(window))

    return function(list)
        if #list.items >= 1 and #list.items <= 2 then
            for _, item in ipairs(list.items) do
                local in_line_range = item.lnum >= lnum and item.end_lnum <= lnum
                local in_character_range = item.col >= col and item.end_col <= col

                if not in_line_range and not in_character_range then
                    LSP.goto_location_item(item)
                    return
                end
            end
        end

        if #list.items > 1 then
            -- Only set the quickfix list when there is more than 1 entry to show,
            -- it is possible that the only entry is the entry where the cursor
            -- is currently on, there is no need to show the quickfix list.
            --
            -- The case where the only entry is not on the cursor is already handled
            -- above.
            vim.fn.setqflist({}, ' ', list)
            vim.cmd('botright copen')
        end
    end
end

function LSP.references()
    vim.lsp.buf.references(nil, {
        on_list = LSP.make_autojump_on_list()
    })
end

function LSP.declaration()
    vim.lsp.buf.declaration({
        on_list = LSP.make_autojump_on_list()
    })
end

function LSP.definition()
    vim.lsp.buf.definition({
        on_list = LSP.make_autojump_on_list()
    })
end

function LSP.implementation()
    vim.lsp.buf.implementation({
        on_list = LSP.make_autojump_on_list()
    })
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
        callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
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

    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

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
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local opts = {
    on_attach = LSP.on_attach,
    debounce_text_changes = 150,
    capabilities = capabilities,
    cmd_env = {
        RUSTUP_TOOLCHAIN = "stable"
    },
}

for name, settings in pairs(servers) do
    lspconfig[name].setup(vim.tbl_extend('force', opts, { settings = settings }))
end

vim.g.rustaceanvim = {
    server = vim.tbl_extend('error', opts, {
        settings = function(project_root)
            return nlspsettings.get_settings(project_root, 'rust_analyzer')
        end,
    })
}

require('typescript-tools').setup(opts)
