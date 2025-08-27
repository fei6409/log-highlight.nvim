---@class log-highlight
local M = {}

local ft = 'log'
local defaults = {
    extension = ft,
    filename = {},
    pattern = {},
    keyword = {
        error = {},
        warning = {},
        info = {},
        debug = {},
        pass = {},
    },
}

local hl_group_map = {
    error = 'LogLvError',
    warning = 'LogLvWarning',
    info = 'LogLvInfo',
    debug = 'LogLvDebug',
    pass = 'LogLvPass',
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

---Generate after/syntax/log.vim to highlight custom keywords
---@param keyword_table table<string, string|string[]>: a table of custom keywords
local function gen_syntax_file(keyword_table)
    local after_dir = vim.fn.stdpath('data') .. '/log-highlight/after'
    local syntax_dir = after_dir .. '/syntax'
    local file_path = syntax_dir .. '/log.vim'
    local content = {}

    validate_type('keyword', keyword_table, 'table')
    for log_level, words in pairs(keyword_table) do
        local str = nil

        validate_type('keyword', words, { 'string', 'table' })
        if type(words) == 'string' then
            str = words
        elseif not vim.tbl_isempty(words) then
            str = table.concat(words, ' ')
        end

        if hl_group_map[log_level] and str then
            table.insert(content, 'syn keyword ' .. hl_group_map[log_level] .. ' ' .. str .. '\n')
        end
    end

    if vim.tbl_isempty(content) then
        if vim.fn.filewritable(file_path) == 1 then
            vim.fn.delete(file_path)
        end
        return
    end

    if vim.fn.mkdir(syntax_dir, 'p') == 0 then
        vim.notify('Failed to mkdir ' .. syntax_dir, vim.log.levels.INFO)
        return
    end

    local file = io.open(file_path, 'w')
    if not file then
        vim.notify('Failed to open ' .. file_path, vim.log.levels.INFO)
        return
    end
    file:write(table.concat(content))
    file:close()

    if not M.rtp_added then
        vim.opt.runtimepath:append(after_dir)
        M.rtp_added = true
    end
end

---Setup the plugin
---@param opts table: a table of options to override the defaults
function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', defaults, opts)

    vim.filetype.add {
        extension = gen_ft_table(M.config.extension, 'extension'),
        filename = gen_ft_table(M.config.filename, 'filename'),
        pattern = gen_ft_table(M.config.pattern, 'pattern'),
    }

    gen_syntax_file(M.config.keyword)
end

return M
