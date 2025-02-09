local w = require 'wezterm'

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local keys = {
  -- paste from the clipboard
  {
	  key = 'v',
	  mods = 'CTRL',
	  action = w.action.PasteFrom 'Clipboard'
  },
  {
	  key = 'p',
	  mods = 'SUPER',
	  action = w.action.ActivateCommandPalette
  },

    -- allow cntrl left right to skip wordsw
  {
	  key="LeftArrow",
	  mods="CTRL",
	  action=w.action{SendString="\x1bb"}
  },

    -- Make Option-Right equivalent to Alt-f; forward-word
  {
	  key="RightArrow",
	  mods="CTRL",
	  action=w.action{SendString="\x1bf"}
  },

  {
    mods   = "LEADER",
    key    = "\"",
    action = w.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "%",
    action = w.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    mods = 'LEADER',
    key = 'z',
    action = w.action.TogglePaneZoomState
  },
  {
    mods = 'LEADER',
    key = '[',
	action = w.action.ActivateCopyMode
  },
  {
      key = "c",
      mods = "LEADER",
      action = w.action.SpawnTab "CurrentPaneDomain",
  },

  {
      key = ",",
      mods = "LEADER",
      action = w.action.PromptInputLine {
        description = "Rename Tab",
        action = w.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      },
  },

}

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

  DownArrow = 'Down',
  UpArrow = 'Up',
  RightArrow = 'Right',
  LeftArrow = 'Left',
}

local function split_nav(key)
  table.insert(keys, {
    key = key,
    mods = 'LEADER',
    action = w.action_callback(function(win, pane)
        win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
    end),
  })
end

local function resize(key)
	table.insert(keys, {
		key = key,
		mods = 'LEADER' and 'META',
		action = w.action_callback(function(win, pane)
			win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
		end),
	})
end

local function move_tabs()
	for i = 1, 9 do
		table.insert(keys, {
			key = tostring(i),
			mods = 'LEADER',
			action = w.action_callback(function(win, pane)
				win:perform_action(w.action.ActivateTab(i - 1),pane)
			end
			)
		})
	end
end

split_nav('h')
split_nav('j')
split_nav('k')
split_nav( 'l')

split_nav('DownArrow')
split_nav('UpArrow')
split_nav('RightArrow')
split_nav( 'LeftArrow')

resize('h')
resize('j')
resize('k')
resize( 'l')

move_tabs()

return keys
