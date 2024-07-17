local log_highlight = {}

local ft = 'log'
local conf = {
    -- Type: string or a table of strings
    extension = 'log',
    filename = {},
    pattern = {},
}

local function parse_config(tbl, cfg)
    local t = type(cfg)

    if t == 'table' then
        for _, v in ipairs(cfg) do
            if type(v) == 'string' then
                tbl[v] = ft
            else
                error('Not a string: (' .. type(v) .. ') ' .. vim.inspect(v))
            end
        end
    elseif t == 'string' then
        tbl[cfg] = ft
    else
        error('Not a string or table: (' .. t .. ') ' .. vim.inspect(cfg))
    end
end

local function set_filetype()
    local ext = {}
    local name = {}
    local pat = {}

    parse_config(ext, conf.extension)
    parse_config(name, conf.filename)
    parse_config(pat, conf.pattern)

    vim.filetype.add({
        extension = ext,
        filename = name,
        pattern = pat,
    })
end

function log_highlight.setup(opts)
    opts = opts or {}

    for k, v in pairs(opts) do
        conf[k] = v
    end

    set_filetype()
end

return log_highlight
