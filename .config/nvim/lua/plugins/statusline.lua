local theme = {
	normal = {
		a = { fg = "#ffffff", bg = "#7aa2f7", gui = "bold" },
		b = { fg = "#cccccc", bg = "#757575" },
		c = { fg = "#ffffff", bg = "#262626", gui = "bold" },
	},

	insert = {
		a = { fg = "#ffffff", bg = "#88bd90", gui = "bold" },
		b = { fg = "#cccccc", bg = "#262626" },
		c = { fg = "#ffffff", bg = "#262626", gui = "bold" },
	},

	visual = {
		a = { fg = "#ffffff", bg = "#a474b8", gui = "bold" },
		b = { fg = "#cccccc", bg = "#262626" },
		c = { fg = "#ffffff", bg = "#262626", gui = "bold" },
	},

	replace = {
		a = { fg = "#ffffff", bg = "#c0392b", gui = "bold" },
		b = { fg = "#cccccc", bg = "#262626" },
		c = { fg = "#ffffff", bg = "#262626", gui = "bold" },
	},

	command = {
		a = { fg = "#ffffff", bg = "#e0af68", gui = "bold" },
		b = { fg = "#cccccc", bg = "#262626" },
		c = { fg = "#ffffff", bg = "#262626", gui = "bold" },
	},

	inactive = {
		a = { fg = "#cccccc", bg = "#262626" },
		b = { fg = "#cccccc", bg = "#262626" },
		c = { fg = "#cccccc", bg = "#262626" },
	},
}
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			theme = theme,
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
