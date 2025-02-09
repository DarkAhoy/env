local wezterm = require 'wezterm'
local keys = require 'keys'

local config = wezterm.config_builder()

config.leader = { key = 'e', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Set a transparent background with opacity
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

-- Set font and other optional configurations
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.color_scheme = "OneHalfDark"

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- config.window_decorations = "NONE"

-- Merge vim_moves into config.keys
config.keys = {}
for _, keymap in ipairs(keys) do
  table.insert(config.keys, keymap)
end

return config
