local Path = require('plenary.path')

local rooter = require('rooter');

require('setup_lsp')
require('setup_cmp')

require('colorizer').setup()
require('lualine').setup({ options = { theme = 'onedark' } })
require('tabline').setup({ options = { show_filename_only = true } })
require('fidget').setup()
require('gitsigns').setup()
require('which-key').setup()
require('ibl').setup()
require('bufdel').setup({
    next = 'alternate',
    quit = false,
})
require('marks').setup()
require('Comment').setup()
-- require('autoclose').setup()
-- require('ultimate-autopair').setup({})
require('nvim-autopairs').setup {}
require("nvim-lightbulb").setup({
    action_kinds = { 'quickfix', 'source' },
    sign = { enabled = false },
    virtual_text = { enabled = true },
    autocmd = { enabled = true }
})


require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = {},
    },
    ensure_installed = {
        'rust',
        'javascript',
        'typescript',
        'html',
        'tsx',
        'python',
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
    textsubjects = {
        enable = true,
        prev_selection = ',', -- (Optional) keymap to select the previous selection
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<C-n>',
            node_incremental = '<C-n>',
            scope_incremental = '<C-s>',
            node_decremental = '<C-r>',
        },
    },
}


function project_directory(path)
    return rooter.get_root(path) or vim.fn.expand('%:p:h')
end

function telescope_path_display(opts, path)
    local p = Path:new(path)
    p = Path:new(p:expand())
    return p:make_relative(project_directory(path))
end

local actions = require('telescope.actions')

require('telescope').setup {
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {
                -- even more opts
            }
        }
    },
    pickers = {
        live_grep = {
            additional_args = function(opts)
                return { "--hidden" }
            end
        },
    },
    defaults = {
        path_display = telescope_path_display,
        mappings = {
            i = {
                ["<C-e>"] = { "<esc>", type = "command" },
                ['<esc>'] = actions.close
            },
        },
    }
}

require('telescope').load_extension('ui-select')

local telescope_builtin = require('telescope.builtin')
local telescope_sorters = require('telescope.sorters')
local crates = require('crates')

local WK = {}

function WK.switch_mru_open_buffer()
    local bufnrs = vim.tbl_filter(function(b)
        local c = 1 ~= vim.fn.buflisted(b)
            or not vim.api.nvim_buf_is_loaded(b)
            or b == vim.api.nvim_get_current_buf()
        return not c
    end, vim.api.nvim_list_bufs())

    table.sort(bufnrs, function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)

    if next(bufnrs) then
        vim.api.nvim_win_set_buf(0, bufnrs[1])
    end
end

function WK.telescope_find_files()
    telescope_builtin.find_files({
        cwd = project_directory(),
        find_command = { 'rg', '--files', '--color', 'never', '--hidden', '--iglob', '!.git/*' },
    })
end

function WK.telescope_live_grep()
    telescope_builtin.live_grep({
        cwd = project_directory()
    })
end

function WK.telescope_buffers()
    telescope_builtin.buffers({
        sort_lastused = true,
        ignore_current_buffer = true,
        sorter = telescope_sorters.get_substr_matcher()
    })
end

function WK._get_highest_severity()
    for _, severity in pairs({ 'ERROR', 'WARN', 'INFO', 'HINT' }) do
        severity = vim.diagnostic.severity[severity]
        if next(vim.diagnostic.get(0, { severity = severity })) then
            return severity
        end
    end

    return { min = vim.diagnostic.severity.HINT }
end

function WK.diagnostic_goto_next()
    vim.diagnostic.goto_next({
        severity = WK._get_highest_severity()
    })
end

function WK.diagnostic_goto_prev()
    vim.diagnostic.goto_prev({
        severity = WK._get_highest_severity()
    })
end

function WK.show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim', 'help' }, filetype) then
        vim.cmd('h ' .. vim.fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man ' .. vim.fn.expand('<cword>'))
    elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
end

require('which-key').add({
    {
        { "<C-Tab>",    WK.switch_mru_open_buffer,                 desc = "Switches to the most recently used open buffer" },
        { "<C-p>",      WK.telescope_find_files,                   desc = "Search Files" },
        { "<leader>W",  "<CMD>bd<CR>",                             desc = "Delete the current buffer" },
        -- Crates
        { "<leader>c",  group = "Crates" },
        { "<leader>cU", crates.upgrade_crate,                      desc = "Upgrade Crate" },
        { "<leader>cd", crates.show_dependencies_popup,            desc = "Show Crate Dependencies" },
        { "<leader>cf", crates.show_features_popup,                desc = "Edit Crate Features" },
        { "<leader>cu", crates.update_crate,                       desc = "Update Crate" },
        { "<leader>cv", crates.show_versions_popup,                desc = "Show Crate Versions" },
        -- Telescope
        { "<leader>e",  WK.telescope_buffers,                      desc = "Search Buffers" },
        { "<leader>p",  WK.telescope_find_files,                   desc = "Search Files" },
        { "<leader>q",  WK.show_documentation,                     desc = "Show Documentation" },
        { "<leader>r",  telescope_builtin.resume,                  desc = "Search Resume" },
        -- Search
        { "<leader>s",  group = "Search" },
        { "<leader>sb", WK.telescope_buffers,                      desc = "Search Buffers" },
        { "<leader>sd", telescope_builtin.diagnostics,             desc = "Search Diagnostics" },
        { "<leader>sf", WK.telescope_find_files,                   desc = "Search Files" },
        { "<leader>sg", WK.telescope_live_grep,                    desc = "Search Grep" },
        { "<leader>sr", telescope_builtin.resume,                  desc = "Search Resume" },
        { "<leader>sw", telescope_builtin.grep_string,             desc = "Search current Word" },
        { "<leader>w",  "<CMD>BufDel<CR>",                         desc = "Delete the current buffer, but keep the window" },
        { "K",          WK.show_documentation,                     desc = "Show Documentation" },
        -- Previous/Next Groups
        { "[",          group = "previous" },
        { "]",          group = "next" },
        -- Quick Fix
        { "[q",         "<CMD>cprev<CR>",                          desc = "Previous Quickfix Item" },
        { "]q",         "<CMD>cnext<CR>",                          desc = "Next Quickfix Item" },
        { "[Q",         "<CMD>cfirst<CR>",                         desc = "First Quickfix Item" },
        { "]Q",         "<CMD>clast<CR>",                          desc = "Last Quickfix Item" },
        -- Location list
        { "[l",         "<CMD>lprev<CR>",                          desc = "Previous Location Item" },
        { "]l",         "<CMD>lnext<CR>",                          desc = "Next Location Item" },
        { "[U",         "<CMD>lfirst<CR>",                         desc = "First Location Item" },
        { "]U",         "<CMD>llast<CR>",                          desc = "Last Location Item" },
        -- Diagnostics
        { "[d",         WK.diagnostic_goto_prev,                   desc = "Goto previous diagnostic" },
        { "]d",         WK.diagnostic_goto_next,                   desc = "Goto next diagnostic" },
        -- Illuminate
        { "[r",         require('illuminate').goto_prev_reference, desc = "Goto previous reference" },
        { "]r",         require('illuminate').goto_next_reference, desc = "Goto next reference" },
        -- Tabs
        { "[t",         "<CMD>tprev<CR>",                          desc = "Previous Tab Item" },
        { "]t",         "<CMD>tnext<CR>",                          desc = "Next Tab Item" },
        { "[T",         "<CMD>tfirst<CR>",                         desc = "First Tab Item" },
        { "]T",         "<CMD>tlast<CR>",                          desc = "Last Tab Item" },
    },
    {
        mode = { "v" },
        { "<leader>c",  group = "Crates" },
        { "<leader>cU", crates.update_crates,  desc = "Upgrade selected Crates" },
        { "<leader>cu", crates.upgrade_crates, desc = "Update selected Crates" },
    }
})
