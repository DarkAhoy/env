local wezterm = require("wezterm")
local keys = require("keys")
local b  = require("background")

local config = wezterm.config_builder()
local home = os.getenv("HOME")
local file = io.open(home .. "/.config/wezterm/background", "r")
local background_image = file:read("*a")
file:close()


config.leader = { key = "e", mods = "CTRL", timeout_milliseconds = 1000 }

-- Set font and other optional configurations
-- config.font = wezterm.font("Iosevka Term", { weight = "Regular", stretch = "Expanded" })
config.font_size = 13.5
config.color_scheme = "OneHalfDark"
-- config.window_decorations = "RESIZE"

config.background = {
	{
		source = {
			File = background_image,
		},
    },
	{
		source = {
			Color = "#383a42",
		},
		width = "100%",
		height = "100%",
		opacity = 0.9,
	},
}

config.inactive_pane_hsb = {
	brightness = 0.8,
}

config.colors = {
	split = '#ff9e64',
}


config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

config.prefer_egl = true
config.max_fps = 120

config.unix_domains = {
    {
        name = 'unix',
    },
}

-- Merge vim_moves into config.keys
config.keys = {}
for _, keymap in ipairs(keys) do
	table.insert(config.keys, keymap)
end

table.insert(config.keys,   {
      key = "b",
      mods = "LEADER",
      action = wezterm.action_callback(b.choose_background)
  })


return config
