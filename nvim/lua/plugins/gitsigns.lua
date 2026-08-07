return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },

		opts = {
			current_line_blame = true,
		},

		keys = {
			{
				"]h",
				function()
					require("gitsigns").nav_hunk("next")
				end,
				desc = "Git: next hunk",
			},
			{
				"[h",
				function()
					require("gitsigns").nav_hunk("prev")
				end,
				desc = "Git: prev hunk",
			},
			{
				"<leader>hs",
				function()
					require("gitsigns").stage_hunk()
				end,
				desc = "Git: stage hunk",
			},
			{
				"<leader>hr",
				function()
					require("gitsigns").reset_hunk()
				end,
				desc = "Git: reset hunk",
			},
			{
				"<leader>hb",
				function()
					require("gitsigns").toggle_current_line_blame()
				end,
				desc = "Git: toggle blame",
			},
		},
	},
}
