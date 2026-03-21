local wezterm = require("wezterm")

local M = {}
local home = os.getenv("HOME")
local background_dir = string.format("%s/.config/wallpapers", home)

local function get_backgrounds()
  local backgrounds = {}
  for line in io.popen('ls "' .. background_dir .. '"'):lines() do
    if line:match("%.png$") or line:match("%.jpg$") or line:match("%.jpeg$") then
      table.insert(backgrounds, line)
    end
  end
  return backgrounds
end

function M.choose_background(window, pane)
  local backgrounds = get_backgrounds()
  if #backgrounds == 0 then
    wezterm.log_error("No backgrounds found in " .. background_dir)
    return
  end

  local with_ids = {}
  for _, name in ipairs(backgrounds) do
    table.insert(with_ids, {
        id = background_dir .. "/" .. name ,
        label = name,
    })
  end

  window:perform_action(
  wezterm.action.InputSelector({
      title = "Choose Background",
      choices = with_ids ,
      action = wezterm.action_callback(function(window, pane, id, label)
          print(id);
          local file_id = home .. "/.config/wezterm/background"
          print("file id: ", file_id)
          local file = io.open(file_id, "w")
          file:write(id)
          file:close()
      end)
    }), pane)
end

return M
