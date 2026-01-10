local telescope_builtin = require('telescope.builtin')
local telescope_sorters = require('telescope.sorters')
local rooter = require('utils.rooter')

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
        cwd = rooter.project_directory(),
        find_command = { 'rg', '--files', '--color', 'never', '--hidden', '--iglob', '!.git/*' },
    })
end

function WK.telescope_live_grep()
    telescope_builtin.live_grep({
        cwd = rooter.project_directory()
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
})
