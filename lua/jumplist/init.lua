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
    auto_rename = true,
    map = {
      close = map.close or "<C-c>",
      rename = map.rename or "<C-r>",
      remove = map.remove or "<C-d>",
      clear_all = map.clear_all or "<C-x>",
    }
  }

  if user_opts.auto_rename == false then
    opts.auto_rename = false;
  end

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
          map({ 'n', 'i' }, self.opts.map.close, function()
            actions.close(pb)
          end)

          map({ 'n', 'i' }, self.opts.map.rename, function()
            local selected = action_state.get_selected_entry();
            local name = take_input("Enter new name: ");
            if name ~= "" then
              for i, _ in ipairs(self.Jumplist) do
                if self.Jumplist[i].id == selected.ordinal.id then
                  self.Jumplist[i].name = name;
                end
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


      local jump_list = {
        id = math.random(1, 99999999),
        buffer_nr = vim.api.nvim_get_current_buf(),
        row = r,
        col = c,
        file = file,
        local_file = vim.fn.expand("%"),
        name = "",
      };

      if self.opts.auto_rename then
        jump_list.name = take_input("Enter a name: ");
      end

      table.insert(self.Jumplist, jump_list);
      vim.print("[ line: " .. r .. " col: " .. c .. " ]: " .. jump_list.local_file .. " | Added"   )
    end,


    open_from_jumplist_at_index = function(jump)
      if (jump ~= nil) then
        vim.cmd("buffer " .. jump.buffer_nr);
        vim.api.nvim_win_set_cursor(0, { jump.row, jump.col })
      end
    end,


  }

  return Jump_list
end

return M
