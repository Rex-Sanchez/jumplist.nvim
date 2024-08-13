# this is a jumpllist plugin for neovim;


## configuration

config is easy enough just require jumplist and run the setup function
then bind the methods to the keymap you like.

- add_to_jump_list
    This adds the current file in buffer with line and col num to the jumplist.
    you can name the item directly or just press enter, this will use the filename as a ident.

- clear_from_jumplist
    This removes the selected item from the jumplist.

- clear_jump_list
    This clears all items from the jumplist.

- open_from_jumplist
    Select a item and jump to it.

- rename
    rename a item in the jumplist


```lua
local j = require("jumplist").setup();

vim.keymap.set("n", "<leader>ji", function() j:add_to_jump_list() end)
vim.keymap.set("n", "<leader>jd", function() j:clear_from_jumplist() end)
vim.keymap.set("n", "<leader>jD", function() j:clear_jump_list() end)
vim.keymap.set("n", "<leader>jj", function() j:open_from_jumplist() end)
vim.keymap.set("n", "<leader>jr", function() j:rename() end)

```
