# log-highlight.nvim

A simple and lightweight Neovim plugin that brings syntax highlighting to
generic log patterns and provides straight-forward configuration to manage the
filetype detection rules over your preferred log files.

![preview-1](./doc/images/kernel-log.png)

![preview-2](./doc/images/patterns-log.png)

## Installation

Use your favorite plugin manager to download and configure the plugin:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'fei6409/log-highlight.nvim',
    config = function()
        require('log-highlight').setup {}
    end,
},
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'fei6409/log-highlight.nvim',
    config = function()
        require('log-highlight').setup {}
    end,
},
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```lua
Plug 'fei6409/log-highlight.nvim'
```

Don't forget to add `syntax on` in your `.vimrc`, `init.vim` or `init.lua` to
allow syntax highlighting to work.

## Configuration

### Neovim

This plugin makes use of Neovim's built-in [filetype
detection](https://neovim.io/doc/user/filetype.html) mechanism.  

By default, `log` filetype will apply to files with `log` extension (e.g.
`sys.log`, `my_log` etc.) after setting up.

You can customize the filetype detection patterns like below:

```lua
require('log-highlight').setup {
    -- The following options support either a string or a table of strings.

    -- The file extensions.
    extension = 'log',

    -- The file names or the full file paths.
    filename = {
        'messages',
    },

    -- The file path glob patterns, e.g. `.*%.lg`, `/var/log/.*`.
    -- Note: `%.` is to match a literal dot (`.`) in a pattern in Lua, but most
    -- of the time `.` and `%.` here make no observable difference.
    pattern = {
        '/var/log/.*',
        'messages%..*',
    },
}
```

### Vim

By default, `log` filetype will apply to files if the name matches `*.log` or
`*_log`.  

To allow more customized patterns, add auto commands in your `.vimrc` like below.

```vim
" Example:
autocmd BufNewFile,BufRead  /var/log/*  set filetype=log
```

## Release Notes

- v0.0.1: Initial release
- v0.0.2: More supports for HDL
- v1.0.0: Minor cleanup and official (?) release
- v1.0.1: Support lowercase and [spdlog](https://github.com/gabime/spdlog)-style log levels

## Contributing

Bug reports, feature requests and pull requests are welcome.  
Please also consider attaching a snippet of the log patterns when doing so.

If you're sending pull requests, please also consider adding the new log samples
in `samples/`:
- For atomic patterns or smaller pieces, add them to `patterns.log`.
- For longer snippets of real-world logs, create a new log file.

That would be helpful for me to examine if new changes break any existing syntax
highlighting.

## Acknowledgement

- [vim-log-highlighting](https://github.com/MTDL9/vim-log-highlighting) by MTDL9
- [Built-in messages.vim](https://github.com/vim/vim/blob/master/runtime/syntax/messages.vim)
