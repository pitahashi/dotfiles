local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.automatically_reload_config = true

config.font_size = 15
config.font = wezterm.font_with_fallback({
	{ family = "Firge35Nerd Console" },
	{ family = "Hiragino Maru Gothic ProN" },
})

config.adjust_window_size_when_changing_font_size = false
config.cursor_blink_rate = 0 -- 点滅が気になるなら止める
config.use_ime = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false

config.initial_cols = 120
config.initial_rows = 30
config.color_scheme = "Solarized (dark) (terminal.sexy)"
config.colors = {
	tab_bar = {
		background = "none",
		inactive_tab_edge = "none",
	},
}

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
	border_left_width = "2px",
}

config.window_background_gradient = {
	colors = {
		"#062236",
	},
}

config.show_new_tab_button_in_tab_bar = false

config.window_padding = {
	left = 10,
	right = 10,
	top = 8,
	bottom = 8,
}

config.keys = {
	{ key = "DownArrow", mods = "SHIFT|SUPER", action = wezterm.action.ScrollToBottom },
	{ key = "UpArrow", mods = "SHIFT|SUPER", action = wezterm.action.ScrollToTop },
}

config.keys = {
	{ key = "DownArrow", mods = "SHIFT|SUPER", action = wezterm.action.ScrollToBottom },
	{ key = "UpArrow", mods = "SHIFT|SUPER", action = wezterm.action.ScrollToTop },
}

wezterm.on("format-tab-title", function(tab)
	if tab.is_active then
		return {
			{ Foreground = { Color = "#ffffff" } },
			{ Text = "  " .. tab.active_pane.title .. "  " },
		}
	end

	return {
		{ Foreground = { Color = "#666666" } },
		{ Text = "  " .. tab.active_pane.title .. "  " },
	}
end)

local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

return config
