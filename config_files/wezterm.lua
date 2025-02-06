local wezterm = require 'wezterm'
local act = wezterm.action
local vim_moves = require 'keys'

local config = wezterm.config_builder()
config.leader = { key = 'e', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    -- paste from the clipboard
    { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'p', mods = 'SUPER', action = act.ActivateCommandPalette },

    -- allow cntrl left right to skip words 
    {key="LeftArrow", mods="CTRL", action=wezterm.action{SendString="\x1bb"}},
    -- Make Option-Right equivalent to Alt-f; forward-word
    {key="RightArrow", mods="CTRL", action=wezterm.action{SendString="\x1bf"}},

  {
    mods   = "LEADER",
    key    = "\"",
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "%",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    mods = 'LEADER',
    key = 'z',
    action = wezterm.action.TogglePaneZoomState
  },
  {
    mods = 'LEADER',
    key = '[',
    action = wezterm.action.ActivateCopyMode
  },
}

-- Set a transparent background with opacity
config.window_background_opacity = 0.8

-- Optional: Enable text opacity for additional effects
config.text_background_opacity = 0.8

-- Set font and other optional configurations
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.color_scheme = "OneHalfDark"

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "NONE"

-- Merge vim_moves into config.keys
for _, keymap in ipairs(vim_moves) do
  table.insert(config.keys, keymap)
end

return config
