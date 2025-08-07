# log-highlight.nvim

A simple and lightweight Neovim plugin that brings syntax highlighting to
generic log files and provides straightforward configuration to manage filetype
detection rules for your logs.

![preview-1](./doc/images/kernel-log.png)

![preview-2](./doc/images/patterns-log.png)

## Installation

Use your favorite plugin manager to install the plugin.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'fei6409/log-highlight.nvim',
    opts = {},
},
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'fei6409/log-highlight.nvim'
```

Don't forget to add `syntax on` in your `.vimrc`, `init.vim`, or `init.lua` to
enable syntax highlighting.

## Configuration

### Neovim

This plugin uses Neovim's built-in
[filetype detection](https://neovim.io/doc/user/filetype.html) mechanism.

By default, the `log` filetype is applied to files with a `.log` extension
(e.g., `sys.log`) after setup.

You can customize the filetype detection patterns as follows:

```lua
require('log-highlight').setup {
    ---@type string|string[]
    -- File extensions
    extension = 'log',

    ---@type string|string[]
    -- File names or full file paths
    filename = {
        'syslog',
    },

    ---@type string|string[]
    -- File path glob patterns
    -- Note: In Lua, `%` escapes special characters to match them literally.
    pattern = {
        '%/var%/log%/.*',
        'console%-ramoops.*',
        'log.*%.txt',
        'logcat.*',
    },
}
```

### Vim

By default, the `log` filetype is applied to files matching `*.log` or `*_log`.

To add custom patterns, add autocommands to your `.vimrc` like this:

```vim
" Example:
autocmd BufNewFile,BufRead /var/log/* set filetype=log
```

## Release Notes

- v1.0.1: Support lowercase and [spdlog](https://github.com/gabime/spdlog)-style
  log levels
- v1.0.0: Minor cleanup and official release
- v0.0.2: More supports for HDL
- v0.0.1: Initial release

## Contributing

Bug reports, feature requests, and pull requests are welcome. When opening an
issue or PR, please consider attaching a snippet of the relevant log pattern.

If you are submitting a pull request, please also consider adding new log
samples to the `samples/` directory:

- For atomic patterns or small snippets, add them to `patterns.log`.
- For longer, real-world log examples, create a new file.

This helps verify that new changes do not break existing syntax highlighting.

## Acknowledgements

- [vim-log-highlighting](https://github.com/MTDL9/vim-log-highlighting) by MTDL9
- [Built-in messages.vim](https://github.com/vim/vim/blob/master/runtime/syntax/messages.vim)

## License

This project is licensed under the [MIT License](LICENSE).
