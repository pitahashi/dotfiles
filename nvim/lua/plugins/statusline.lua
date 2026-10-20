if not vim.g.vscode then
	vim.opt.laststatus = 3
	vim.opt.showmode = false

	return {
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup()
		end,
	}
end
