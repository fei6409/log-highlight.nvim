local lazy_plenary_path = vim.fn.stdpath('data') .. '/lazy/plenary.nvim'
local tmp_plenary_path = '/tmp/plenary.nvim'
local plenary_path

if vim.fn.isdirectory(lazy_plenary_path) ~= 0 then
    print('Found plenary.nvim in lazy.nvim data path\n')
    plenary_path = lazy_plenary_path
elseif vim.fn.isdirectory(tmp_plenary_path) ~= 0 then
    print('Found plenary.nvim in /tmp/\n')
    plenary_path = tmp_plenary_path
else
    print('No plenary.nvim found. Cloning into ' .. tmp_plenary_path .. '\n')
    plenary_path = tmp_plenary_path
    local out =
        vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/nvim-lua/plenary.nvim.git', plenary_path }

    if vim.v.shell_error ~= 0 then
        print('Error cloning plenary.nvim: ' .. out .. '\n')
        os.exit(1)
    end
end

vim.opt.rtp:prepend(plenary_path)
vim.opt.rtp:prepend('.')

vim.cmd('runtime plugin/plenary.vim')

require('log-highlight').setup {
    filename = { 'syslog' },
    pattern = {
        '%/var%/log%/.*',
        'wildcard%..*',
        '.*%.ext',
        '%-%#%$%&%*',
        '.*%.UPPERCASE',
    },
}
