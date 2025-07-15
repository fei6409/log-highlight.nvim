---@class log-highlight
local M = {}

local ft = 'log'
local defaults = {
    extension = ft,
    filename = {},
    pattern = {},
}

---Generate a filetype table for vim.filetype.add()
---@param items string|table: a list of file extensions, filenames, or patterns
---@param item_name string: the name of what the items represent
---@return table: a table that maps the value to the filetype
local function gen_ft_table(items, item_name)
    local map = {}

    if not items then
        return map
    end

    vim.validate(item_name, items, { 'string', 'table' })
    if type(items) == 'string' then
        map[items] = ft
        return map
    end

    for _, v in ipairs(items) do
        vim.validate(item_name, v, 'string')
        map[v] = ft
    end

    return map
end

---Setup the log-highlight plugin
---@param opts table: a table of options to override the defaults
function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', defaults, opts)

    vim.filetype.add {
        extension = gen_ft_table(M.config.extension, 'extension'),
        filename = gen_ft_table(M.config.filename, 'filename'),
        pattern = gen_ft_table(M.config.pattern, 'pattern'),
    }
end

return M
