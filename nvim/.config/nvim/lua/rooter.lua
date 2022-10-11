local Path = require('plenary.path')

local _config = {
    patterns = { '.git', '.hg', '.svn' }
}

local function match(dir, pattern)
    if string.sub(pattern, 1, 1) == '=' then
        return vim.fn.fnamemodify(dir, ':t') == string.sub(pattern, 2, #pattern)
    else
        return vim.fn.globpath(dir, pattern) ~= ''
    end
end

local function get_root(current)
    local current = Path:new(current or vim.api.nvim_buf_get_name(0))

    for _, parent in ipairs(current:parents()) do
        for _, pattern in ipairs(_config.patterns) do
            if match(parent, pattern) then
                return parent
            end
        end
    end
    return nil
end

return {
    get_root = get_root,
}
