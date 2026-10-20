local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 15.5
config.use_ime = true
config.color_scheme = "Solarized (dark) (terminal.sexy)"

config.font = wezterm.font_with_fallback({
	{ family = "HackGen Console NF", weight = "Medium" },
})
config.initial_cols = 100
config.initial_rows = 40

config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
