local function take_input(text)
  local name = ""
  vim.ui.input({
    prompt = text,
    -- default = "",
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



function Setup()
  local Jump_list = {

    Jumplist = {},

    add_to_jump_list = function(self)
      local r, c = unpack(vim.api.nvim_win_get_cursor(0));
      local file = vim.fn.expand("%:p");

      math.randomseed(os.time());


      local jump_list = {
        id = math.random(1, 99999999),
        row = r,
        col = c,
        file = file,
        local_file = vim.fn.expand("%"),
        name = take_input("Enter a name: "),
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


    clear_jump_list = function(self)
      self.Jumplist = {};
    end,

    open_from_jumplist = function(self)
      vim.print(self.Jumplist);
      if #self.Jumplist == 0 then
        vim.print("No items in jumplist.");
        return
      end
      vim.ui.select(self.Jumplist, {
        prompt = "Open in buffer:",
        format_item = function(item)
          return "[ " .. "Line: " .. item.row .. ", " .. "Col: " .. item.col .. " ] => " .. get_name(item)
        end
      }, function(choice)
        if (choice) then
          self.open_from_jumplist_at_index(choice);
        else
          vim.print("No selection made");
        end
      end)
    end,

    rename = function(self)
      vim.ui.select(self.Jumplist, {
        prompt = "Rename item:",
        on_confirm = function(item)
          vim.print(item);
        end,
        format_item = function(item)
          return "[ " .. "Line: " .. item.row .. ", " .. "Col: " .. item.col .. " ] => " .. get_name(item)
        end
      }, function(choice)
        if (choice) then
          local name = take_input("Enter new name: ");
          for i, _ in ipairs(self.Jumplist) do
            if self.Jumplist[i].id == choice.id then
              self.Jumplist[i].name = name;
            end
          end
        else
          vim.print("No selection made");
        end
      end
      )
    end,
    clear_from_jumplist = function(self)
      vim.ui.select(self.Jumplist, {
        prompt = "Remove Item from list:",
        format_item = function(item)
          return "[ " .. "Line: " .. item.row .. ", " .. "Col: " .. item.col .. " ] => " .. get_name(item)
        end
      }, function(choice)
        if (choice) then
          self.Jumplist = filter(self.Jumplist, function(jump) return jump.id ~= choice.id end);
        else
          vim.print("No selection made");
        end
      end
      )
    end,

  }

  return Jump_list
end



