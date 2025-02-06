local w = require 'wezterm'

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav( key)
  return {
    key = key,
    mods = 'LEADER',
    action = w.action_callback(function(win, pane)
        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
    end),
  }
end

return {
    -- move between split panes
    split_nav('h'),
    split_nav('j'),
    split_nav('k'),
    split_nav( 'l'),
}

