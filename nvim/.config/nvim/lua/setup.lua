local Path = require 'plenary.path'
local Job = require 'plenary.job'

require 'setup_lsp'
require 'setup_cmp'

require('lualine').setup({ options = { theme = 'onedark' }})
require('tabline').setup()

require'nvim-treesitter.configs'.setup {
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
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    }
}


function project_directory(cwd)
    local stdout, ret = Job:new({
        command = "git",
        args = {"rev-parse", "--show-toplevel"},
        cwd = cwd or vim.loop.cwd()
    }):sync()

    if ret == 0 then
        return stdout[1]
    else
        return vim.fn.expand("%:p:h")
    end
end

function telescope_path_display(opts, path)
    local p = Path:new(path)
    p = Path:new(p:expand())
    return p:make_relative(project_directory(opts.cwd))
end

local actions = require('telescope.actions')

require('telescope').setup{
    defaults = {
        path_display = telescope_path_display,
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
    }
}

