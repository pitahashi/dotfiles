return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			theme = "auto",
			globalstatus = true,
			section_separators = {
				left = "",
				right = "",
			},
			component_separators = {
				left = "",
				right = "",
			},
		},
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(str)
						return str:sub(1, 1)
					end,
				},
			},
			lualine_b = { "branch", "diff" },
			lualine_c = { "filename" },
			lualine_x = { "diagnostics", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
