return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        opts = {
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            folds = {
                enable = true,
            },
            ensure_installed = {
                'bash',
                'c',
                'diff',
                'html',
                'javascript',
                'jsdoc',
                'json',
                'json5',
                'lua',
                'luadoc',
                'luap',
                'markdown',
                'markdown_inline',
                'printf',
                'python',
                'query',
                'regex',
                'rust',
                'toml',
                'tsx',
                'typescript',
                'vim',
                'vimdoc',
                'xml',
                'yaml',
            }
        },
        config = function(_, opts)
            local TS = require('nvim-treesitter')
            local TSUtil = require('utils.treesitter')

            if vim.fn.executable('tree-sitter') == 1 then
                vim.defer_fn(function() TS.install(opts.ensure_installed) end, 2000)
            else
                local msg = '`tree-sitter-cli` not found. Skipping auto-install of parsers.'
                vim.notify(msg, vim.log.levels.WARN, { title = 'Treesitter' })
            end

            TS.setup(opts)

            vim.api.nvim_create_autocmd('FileType', {
                group = vim.api.nvim_create_augroup('my.treesitter', { clear = true }),
                callback = function(ev)
                    local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)

                    local function enabled(feat, query)
                        local f = opts[feat] or {}
                        return f.enable ~= false
                            and not (type(f.disable) == 'table' and vim.tbl_contains(f.disable, lang))
                            and TSUtil.have_query(ft, query)
                    end

                    if enabled('highlight', 'highlights') then
                        pcall(vim.treesitter.start, ev.buf)
                    end

                    if enabled('indent', 'indents') then
                        vim.bo[ev.buf].indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
                    end

                    if enabled('folds', 'folds') then
                        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                        vim.wo[0][0].foldmethod = 'expr'
                    end
                end,
            })
        end
    },
    {
        'windwp/nvim-ts-autotag',
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
    },
}
