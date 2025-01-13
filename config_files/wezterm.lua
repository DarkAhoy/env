local wezterm = require("wezterm")
local act = wezterm.action

return {
  -- Set a transparent background with opacity
  window_background_opacity = 0.8,  

  -- Optional: Enable text opacity for additional effects
  text_background_opacity = 0.8,   

  -- Set font and other optional configurations
  font = wezterm.font("JetBrains Mono"), 
  font_size = 12.0,                     
  color_scheme = "OneHalfDark",         

  hide_tab_bar_if_only_one_tab = true,

  keys = {
    -- paste from the clipboard
    { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'p', mods = 'SUPER', action = act.ActivateCommandPalette },

    -- allow cntrl left right to skip words 
    {key="LeftArrow", mods="CTRL", action=wezterm.action{SendString="\x1bb"}},
    -- Make Option-Right equivalent to Alt-f; forward-word
    {key="RightArrow", mods="CTRL", action=wezterm.action{SendString="\x1bf"}},
    -- paste from the primary selection
    -- { key = 'v', mods = 'CTRL', action = act.PasteFrom 'PrimarySelection' },
  },

  window_decorations = "NONE"
}
