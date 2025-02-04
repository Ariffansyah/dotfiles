-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "carbonfox"

config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 14

config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

config.enable_tab_bar = false
config.enable_scroll_bar = true

config.window_decorations = "TITLE | RESIZE"
config.window_background_opacity = 0.90

-- and finally, return the configuration to wezterm
return config
