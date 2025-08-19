---@class log-highlight
local M = {}

local ft = 'log'
local defaults = {
    extension = ft,
    filename = {},
    pattern = {},
}

local function validate_type(name, value, validator)
    if vim.fn.has('nvim-0.11') ~= 1 then
        vim.validate { [name] = { value, validator } }
    else
        vim.validate(name, value, validator)
    end
end

---Generate a filetype table for vim.filetype.add()
---@param values string|string[]: string(s) of extensions, filenames, or patterns
---@param category string: the category that the values belong to
---@return table: the generated filetype table
local function gen_ft_table(values, category)
    local ft_table = {}

    if not values then
        return ft_table
    end

    validate_type(category, values, { 'string', 'table' })

    if type(values) == 'string' then
        ft_table[values] = ft
        return ft_table
    end

    for _, val in ipairs(values) do
        validate_type(category, val, 'string')
        ft_table[val] = ft
    end

    return ft_table
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
