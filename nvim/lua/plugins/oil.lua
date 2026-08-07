return {
	"stevearc/oil.nvim",
	---@module 'oil'
	cond = not vim.g.vscode,
	opts = {},
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
		vim.keymap.set("n", "<leader>t", "<cmd>Oil<cr>", { desc = "Open file explorer" })
	end,
}
