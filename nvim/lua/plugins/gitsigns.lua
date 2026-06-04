return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
			})

			local gs = require("gitsigns")
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { desc = desc })
			end

			map("n", "]h", function()
				gs.nav_hunk("next")
			end, "Git: next hunk")
			map("n", "[h", function()
				gs.nav_hunk("prev")
			end, "Git: prev hunk")
			map("n", "<leader>hs", gs.stage_hunk, "Git: stage hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Git: reset hunk")
			map("n", "<leader>hb", gs.toggle_current_line_blame, "Git: toggle blame")
		end,
	},
}
