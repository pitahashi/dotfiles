return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	dependencies = { "nvim-mini/mini.icons" },
	keys = {
		{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
	},
	opts = {
		columns = {
			"icon",
			"size",
		},
		view_options = {
			show_hidden = true,
		},
	},
}
