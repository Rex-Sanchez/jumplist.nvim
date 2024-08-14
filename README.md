# This is a jumpllist plugin for neovim;

## deps
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim/tree/master)

## Configuration

Config is easy enough just require jumplist and run the setup function
then bind the methods to the keymap you like.

- `add_to_jump_list`
    This adds the current file in buffer with line and col num to the jumplist.
    you can name the item directly or just press enter, this will use the filename as a ident.

- `picker`
    This opens a telescope picker,

```lua
local j = require("jumplist").setup({});

vim.keymap.set("n", "<leader>ji", function() j:add_to_jump_list() end)
vim.keymap.set("n", "<leader>jj", function() j:picker() end)

```

## Default Options

Options can be passed to the setup function 
the following are the default options. change them to what you like,

```lua
local opts = {
    -- set this to false if you dont want a prompt when adding a new jump to the list
    auto_rename = true,
    map = {
      close = "<C-c>",
      rename = "<C-r>",
      remove = "<C-d>",
      clear_all = "<C-x>",
    }
  }

```
