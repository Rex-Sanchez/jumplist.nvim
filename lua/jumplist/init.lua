local telescope = require('telescope.builtin')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')



local function take_input(text)
  local name = ""
  vim.ui.input({
    prompt = text,
  }, function(input)
    name = input;
  end)
  return name;
end


local function get_name(item)
  local name = "";
  if (item.name and string.len(item.name) == 0) then
    name = item.local_file;
  else
    name = item.name;
  end
  return name;
end

local function filter(t, cb)
  local items = {};
  for _, item in ipairs(t) do
    if cb(item) == true then
      table.insert(items, item)
    end
  end
  return items;
end


local M = {}


function M.setup(user_opts)

  local map = user_opts.map or {};

  local opts = {
    auto_rename = user_opts.auto_rename or true,
    map = {
      rename = map.rename or "<C-r>",
      remove = map.remove or "<C-d>",
      clear_all = map.clear_all or "<C-x>",
    }
  }

  local Jump_list = {

    Jumplist = {},
    opts = {
      auto_rename = opts.auto_rename,
      map = opts.map
    },

    picker = function(self)
      pickers.new({}, {
        prompt_title = "Select an option",
        finder = finders.new_table({
          results = self.Jumplist,
          entry_maker = function(entry)
            return {
              value = entry.id,
              display = "[ " .. "Line: " .. entry.row .. ", " .. "Col: " .. entry.col .. " ] => " .. get_name(entry),
              ordinal = entry,
            }
          end,
        }),
        sorter = nil,

        attach_mappings = function(pb, map)
          map({ 'n', 'i' }, '<CR>', function()
            local selected = action_state.get_selected_entry();
            vim.print(selected.ordinal);
            actions.close(pb)
            self.open_from_jumplist_at_index(selected.ordinal);
          end)
          map({ 'n', 'i' }, self.opts.map.remove, function()
            local selected = action_state.get_selected_entry();
            self.Jumplist = filter(self.Jumplist, function(i) return i.id ~= selected.ordinal.id end)
            actions.close(pb)
          end)
          map({ 'n', 'i' }, self.opts.map.rename, function()
            local selected = action_state.get_selected_entry();
            vim.print("rename selected")
            local name = take_input("Enter new name: ");
            for i, _ in ipairs(self.Jumplist) do
              if self.Jumplist[i].id == selected.ordinal.id then
                self.Jumplist[i].name = name;
              end
            end
            actions.close(pb)
          end)
          map({ 'n', 'i' }, self.opts.map.clear_all, function()
            self.Jumplist = {};
            actions.close(pb)
          end)
          return true
        end,
      }):find()
    end,

    add_to_jump_list = function(self)
      local r, c = unpack(vim.api.nvim_win_get_cursor(0));
      local file = vim.fn.expand("%:p");

      math.randomseed(os.time());


      local name = "";
      if self.opts.auto_rename then
        name = take_input("Enter a name");
      end

      local jump_list = {
        id = math.random(1, 99999999),
        row = r,
        col = c,
        file = file,
        local_file = vim.fn.expand("%"),
        name = name,
      };


      table.insert(self.Jumplist, jump_list);
      vim.print("Jumplist Item Added")
    end,


    open_from_jumplist_at_index = function(jump)
      if (jump ~= nil) then
        vim.cmd("edit " .. jump.file);
        vim.api.nvim_win_set_cursor(0, { jump.row, jump.col })
        vim.print("\nOpening File from jumplist @ Line: " .. jump.row .. " | Col: " .. jump.col);
      end
    end,


  }

  return Jump_list
end

return M
